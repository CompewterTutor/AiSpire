"""
Command queue system for handling Lua commands.
"""
import asyncio
import uuid
from typing import Dict, Any, List, Optional, Callable, Awaitable, Tuple
from enum import Enum
import time


class CommandStatus(Enum):
    """Status of a command in the queue."""
    PENDING = 0
    IN_PROGRESS = 1
    COMPLETED = 2
    FAILED = 3
    CANCELLED = 4


class CommandPriority(Enum):
    """Priority levels for commands."""
    LOW = 0
    NORMAL = 1
    HIGH = 2
    CRITICAL = 3


class QueuedCommand:
    """Represents a command in the queue."""
    
    def __init__(self, command: str, priority: CommandPriority = CommandPriority.NORMAL,
                metadata: Dict[str, Any] = None):
        """Initialize a queued command."""
        self.id = str(uuid.uuid4())
        self.command = command
        self.priority = priority
        self.status = CommandStatus.PENDING
        self.created_at = time.time()
        self.started_at: Optional[float] = None
        self.completed_at: Optional[float] = None
        self.result: Optional[Dict[str, Any]] = None
        self.error: Optional[str] = None
        self.metadata = metadata or {}
    
    def mark_started(self) -> None:
        """Mark the command as started."""
        self.status = CommandStatus.IN_PROGRESS
        self.started_at = time.time()
    
    def mark_completed(self, result: Dict[str, Any]) -> None:
        """Mark the command as completed with a result."""
        self.status = CommandStatus.COMPLETED
        self.completed_at = time.time()
        self.result = result
    
    def mark_failed(self, error: str) -> None:
        """Mark the command as failed with an error message."""
        self.status = CommandStatus.FAILED
        self.completed_at = time.time()
        self.error = error
    
    def mark_cancelled(self) -> None:
        """Mark the command as cancelled."""
        self.status = CommandStatus.CANCELLED
        self.completed_at = time.time()
    
    @property
    def execution_time(self) -> Optional[float]:
        """Calculate the execution time if available."""
        if self.started_at is not None and self.completed_at is not None:
            return self.completed_at - self.started_at
        return None
    
    @property
    def waiting_time(self) -> Optional[float]:
        """Calculate the waiting time if available."""
        if self.started_at is not None:
            return self.started_at - self.created_at
        return None
    
    @property
    def total_time(self) -> Optional[float]:
        """Calculate the total time if available."""
        if self.completed_at is not None:
            return self.completed_at - self.created_at
        return None
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert the command to a dictionary."""
        return {
            "id": self.id,
            "status": self.status.name,
            "created_at": self.created_at,
            "started_at": self.started_at,
            "completed_at": self.completed_at,
            "execution_time": self.execution_time,
            "waiting_time": self.waiting_time,
            "total_time": self.total_time,
            "priority": self.priority.name,
            "result": self.result,
            "error": self.error,
            "metadata": self.metadata
        }


class CommandQueue:
    """Queue for handling Lua commands with priority and status tracking."""
    
    def __init__(self, max_size: int = 100):
        """Initialize the command queue."""
        self._queue: Dict[CommandPriority, List[QueuedCommand]] = {
            priority: [] for priority in CommandPriority
        }
        self._results: Dict[str, QueuedCommand] = {}
        self._max_size = max_size
        self._lock = asyncio.Lock()
        self._result_retention = 100  # Number of results to keep
    
    async def enqueue(self, command: str, 
                     priority: CommandPriority = CommandPriority.NORMAL,
                     metadata: Dict[str, Any] = None) -> str:
        """
        Add a command to the queue with the specified priority.
        Returns the command ID.
        """
        async with self._lock:
            # Check if queue is full
            total_size = sum(len(q) for q in self._queue.values())
            if total_size >= self._max_size:
                raise ValueError(f"Command queue is full (max size: {self._max_size})")
            
            # Create and add the command
            queued_cmd = QueuedCommand(command, priority, metadata)
            self._queue[priority].append(queued_cmd)
            return queued_cmd.id
    
    async def dequeue(self) -> Optional[QueuedCommand]:
        """Get the next command from the queue based on priority."""
        async with self._lock:
            for priority in reversed(list(CommandPriority)):
                if self._queue[priority]:
                    command = self._queue[priority].pop(0)
                    command.mark_started()
                    self._results[command.id] = command
                    
                    # Trim results if needed
                    if len(self._results) > self._result_retention:
                        # Remove oldest completed results
                        completed_ids = sorted(
                            [cmd_id for cmd_id, cmd in self._results.items() 
                             if cmd.status in (CommandStatus.COMPLETED, CommandStatus.FAILED, CommandStatus.CANCELLED)],
                            key=lambda cmd_id: self._results[cmd_id].completed_at or 0
                        )
                        
                        # Keep only the most recent ones
                        for cmd_id in completed_ids[:-self._result_retention]:
                            del self._results[cmd_id]
                    
                    return command
            
            return None
    
    async def get_command_status(self, command_id: str) -> Optional[QueuedCommand]:
        """Get the status of a command by its ID."""
        async with self._lock:
            # Check in results first
            if command_id in self._results:
                return self._results[command_id]
            
            # Check in pending queues
            for priority in CommandPriority:
                for cmd in self._queue[priority]:
                    if cmd.id == command_id:
                        return cmd
            
            return None
    
    async def mark_completed(self, command_id: str, result: Dict[str, Any]) -> bool:
        """Mark a command as completed with its result."""
        async with self._lock:
            command = await self.get_command_status(command_id)
            if command:
                command.mark_completed(result)
                return True
            return False
    
    async def mark_failed(self, command_id: str, error: str) -> bool:
        """Mark a command as failed with an error message."""
        async with self._lock:
            command = await self.get_command_status(command_id)
            if command:
                command.mark_failed(error)
                return True
            return False
    
    async def cancel_command(self, command_id: str) -> bool:
        """Cancel a pending command by its ID."""
        async with self._lock:
            # Check in pending queues
            for priority in CommandPriority:
                for i, cmd in enumerate(self._queue[priority]):
                    if cmd.id == command_id:
                        cmd.mark_cancelled()
                        self._results[cmd.id] = cmd
                        del self._queue[priority][i]
                        return True
            
            # Check if it's already being processed
            if command_id in self._results and self._results[command_id].status == CommandStatus.IN_PROGRESS:
                self._results[command_id].mark_cancelled()
                return True
                
            return False
    
    async def get_queue_status(self) -> Dict[str, Any]:
        """Get the current status of the queue."""
        async with self._lock:
            return {
                "queue_size": {priority.name: len(self._queue[priority]) for priority in CommandPriority},
                "total_pending": sum(len(q) for q in self._queue.values()),
                "total_results": len(self._results),
                "in_progress_count": sum(1 for cmd in self._results.values() if cmd.status == CommandStatus.IN_PROGRESS),
                "completed_count": sum(1 for cmd in self._results.values() if cmd.status == CommandStatus.COMPLETED),
                "failed_count": sum(1 for cmd in self._results.values() if cmd.status == CommandStatus.FAILED),
                "cancelled_count": sum(1 for cmd in self._results.values() if cmd.status == CommandStatus.CANCELLED),
            }
    
    async def clear_queue(self) -> int:
        """Clear all pending commands and return the number of cleared commands."""
        async with self._lock:
            total_cleared = 0
            for priority in CommandPriority:
                total_cleared += len(self._queue[priority])
                
                # Mark all as cancelled and add to results
                for cmd in self._queue[priority]:
                    cmd.mark_cancelled()
                    self._results[cmd.id] = cmd
                
                # Clear the queue
                self._queue[priority] = []
                
            return total_cleared
    
    async def process_queue(self, process_func: Callable[[str], Awaitable[Tuple[bool, Dict[str, Any], Optional[str]]]],
                          max_concurrent: int = 1) -> None:
        """
        Process the queue with the provided function.
        process_func should take a command string and return (success, result, error)
        """
        tasks = []
        semaphore = asyncio.Semaphore(max_concurrent)
        
        async def process_command() -> None:
            async with semaphore:
                command = await self.dequeue()
                if not command:
                    return
                
                try:
                    success, result, error = await process_func(command.command)
                    if success:
                        await self.mark_completed(command.id, result)
                    else:
                        await self.mark_failed(command.id, error or "Unknown error")
                except Exception as e:
                    await self.mark_failed(command.id, f"Processing exception: {str(e)}")
        
        while True:
            # Check if there are commands to process
            has_commands = False
            for priority in CommandPriority:
                async with self._lock:
                    if self._queue[priority]:
                        has_commands = True
                        break
            
            if not has_commands:
                await asyncio.sleep(0.1)
                continue
            
            # Start a new task to process the next command
            task = asyncio.create_task(process_command())
            tasks.append(task)
            
            # Clean up completed tasks
            tasks = [t for t in tasks if not t.done()]
