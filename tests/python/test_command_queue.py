"""
Tests for the command queue module.
"""
import pytest
import asyncio
from python_mcp_server.command_generation import CommandQueue, CommandPriority, CommandStatus


class TestCommandQueue:
    """Tests for the CommandQueue class."""
    
    @pytest.fixture
    def queue(self):
        """Create a command queue for testing."""
        return CommandQueue(max_size=10)
    
    @pytest.mark.asyncio
    async def test_enqueue_and_dequeue(self, queue):
        """Test basic enqueue and dequeue functionality."""
        # Enqueue a command
        cmd_id = await queue.enqueue("test command")
        
        # Dequeue the command
        cmd = await queue.dequeue()
        
        assert cmd is not None
        assert cmd.id == cmd_id
        assert cmd.command == "test command"
        assert cmd.status == CommandStatus.IN_PROGRESS
        assert cmd.started_at is not None
    
    @pytest.mark.asyncio
    async def test_priority_ordering(self, queue):
        """Test that commands are dequeued in priority order."""
        # Enqueue commands with different priorities
        low_id = await queue.enqueue("low priority", CommandPriority.LOW)
        normal_id = await queue.enqueue("normal priority", CommandPriority.NORMAL)
        high_id = await queue.enqueue("high priority", CommandPriority.HIGH)
        critical_id = await queue.enqueue("critical priority", CommandPriority.CRITICAL)
        
        # Dequeue commands and check order
        cmd1 = await queue.dequeue()
        cmd2 = await queue.dequeue()
        cmd3 = await queue.dequeue()
        cmd4 = await queue.dequeue()
        
        assert cmd1.id == critical_id
        assert cmd2.id == high_id
        assert cmd3.id == normal_id
        assert cmd4.id == low_id
    
    @pytest.mark.asyncio
    async def test_get_command_status(self, queue):
        """Test getting command status."""
        # Enqueue a command
        cmd_id = await queue.enqueue("test command")
        
        # Check status while in queue
        status = await queue.get_command_status(cmd_id)
        assert status is not None
        assert status.id == cmd_id
        assert status.status == CommandStatus.PENDING
        
        # Dequeue and check status again
        await queue.dequeue()
        status = await queue.get_command_status(cmd_id)
        assert status is not None
        assert status.status == CommandStatus.IN_PROGRESS
    
    @pytest.mark.asyncio
    async def test_mark_completed(self, queue):
        """Test marking a command as completed."""
        cmd_id = await queue.enqueue("test command")
        await queue.dequeue()  # Move to in-progress
        
        # Mark as completed
        success = await queue.mark_completed(cmd_id, {"result": "success"})
        assert success is True
        
        # Check status
        status = await queue.get_command_status(cmd_id)
        assert status is not None
        assert status.status == CommandStatus.COMPLETED
        assert status.result == {"result": "success"}
        assert status.completed_at is not None
        assert status.execution_time is not None
    
    @pytest.mark.asyncio
    async def test_mark_failed(self, queue):
        """Test marking a command as failed."""
        cmd_id = await queue.enqueue("test command")
        await queue.dequeue()  # Move to in-progress
        
        # Mark as failed
        success = await queue.mark_failed(cmd_id, "Error message")
        assert success is True
        
        # Check status
        status = await queue.get_command_status(cmd_id)
        assert status is not None
        assert status.status == CommandStatus.FAILED
        assert status.error == "Error message"
    
    @pytest.mark.asyncio
    async def test_cancel_command(self, queue):
        """Test cancelling a command."""
        cmd_id = await queue.enqueue("test command")
        
        # Cancel the command
        success = await queue.cancel_command(cmd_id)
        assert success is True
        
        # Check status
        status = await queue.get_command_status(cmd_id)
        assert status is not None
        assert status.status == CommandStatus.CANCELLED
        
        # Try to dequeue and ensure it's not returned
        cmd = await queue.dequeue()
        assert cmd is None
    
    @pytest.mark.asyncio
    async def test_queue_full(self, queue):
        """Test behavior when queue is full."""
        # Fill the queue
        for i in range(10):
            await queue.enqueue(f"command {i}")
        
        # Try to add one more
        with pytest.raises(ValueError, match="full"):
            await queue.enqueue("one too many")
    
    @pytest.mark.asyncio
    async def test_clear_queue(self, queue):
        """Test clearing the queue."""
        # Add some commands
        for i in range(5):
            await queue.enqueue(f"command {i}")
        
        # Clear the queue
        cleared = await queue.clear_queue()
        assert cleared == 5
        
        # Verify queue is empty
        cmd = await queue.dequeue()
        assert cmd is None
        
        # Check status of a command
        status = await queue.get_queue_status()
        assert status["total_pending"] == 0
        assert status["cancelled_count"] == 5
    
    @pytest.mark.asyncio
    async def test_process_queue(self, queue):
        """Test processing the queue."""
        # Mock process function
        async def process_func(cmd: str):
            if cmd == "fail":
                return False, {}, "Error processing command"
            return True, {"processed": cmd}, None
        
        # Add commands
        cmd1_id = await queue.enqueue("test1")
        cmd2_id = await queue.enqueue("fail")
        
        # Process one command
        await queue.process_queue(process_func, max_concurrent=1)
        await asyncio.sleep(0.1)  # Allow time for processing
        
        # Check status of first command
        status1 = await queue.get_command_status(cmd1_id)
        assert status1 is not None
        assert status1.status == CommandStatus.COMPLETED
        assert status1.result == {"processed": "test1"}
        
        # Process second command
        await queue.process_queue(process_func, max_concurrent=1)
        await asyncio.sleep(0.1)  # Allow time for processing
        
        # Check status of second command
        status2 = await queue.get_command_status(cmd2_id)
        assert status2 is not None
        assert status2.status == CommandStatus.FAILED
        assert status2.error == "Error processing command"
