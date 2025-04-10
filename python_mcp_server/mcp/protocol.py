"""
MCP Protocol handling library for AiSpire

This module implements the Model Context Protocol (MCP) for communication with LLMs.
It provides classes and functions for parsing, validating, and generating MCP messages.
"""
import json
import uuid
import logging
from enum import Enum
from typing import Dict, Any, Optional, List, Union

logger = logging.getLogger(__name__)

class MCPMessageType(Enum):
    """MCP message types as defined in the protocol specification."""
    START_SESSION = "start_session"
    END_SESSION = "end_session"
    REQUEST = "request"
    RESPONSE = "response"
    ERROR = "error"
    PING = "ping"
    PONG = "pong"
    STREAM_START = "stream_start"
    STREAM_CONTENT = "stream_content"
    STREAM_END = "stream_end"
    COMMAND = "command"
    RESULT = "result"

class MCPContentType(Enum):
    """Content types for MCP messages."""
    TEXT = "text/plain"
    JSON = "application/json"
    IMAGE = "image/png"
    SVG = "image/svg+xml"
    HTML = "text/html"
    MARKDOWN = "text/markdown"
    VECTRIC_COMMAND = "application/vectric-command+json"
    VECTRIC_RESULT = "application/vectric-result+json"

class MCPProtocolError(Exception):
    """Exception raised for MCP protocol errors."""
    def __init__(self, message: str, error_code: str = "protocol_error"):
        self.message = message
        self.error_code = error_code
        super().__init__(self.message)

class MCPMessage:
    """Base class for MCP messages."""
    
    def __init__(self, 
                 message_type: MCPMessageType,
                 content: Any = None,
                 content_type: MCPContentType = MCPContentType.TEXT,
                 message_id: Optional[str] = None,
                 session_id: Optional[str] = None,
                 in_reply_to: Optional[str] = None,
                 metadata: Optional[Dict[str, Any]] = None):
        """
        Initialize a new MCP message.
        
        Args:
            message_type: Type of the message
            content: Message content
            content_type: Type of the content
            message_id: Unique message identifier (generated if None)
            session_id: Session identifier
            in_reply_to: ID of the message this is a reply to
            metadata: Additional metadata
        """
        self.message_type = message_type
        self.content = content
        self.content_type = content_type
        self.message_id = message_id or str(uuid.uuid4())
        self.session_id = session_id
        self.in_reply_to = in_reply_to
        self.metadata = metadata or {}
        
    def to_dict(self) -> Dict[str, Any]:
        """Convert the message to a dictionary."""
        result = {
            "type": self.message_type.value,
            "id": self.message_id,
            "content_type": self.content_type.value,
            "content": self.content,
        }
        
        if self.session_id:
            result["session_id"] = self.session_id
        if self.in_reply_to:
            result["in_reply_to"] = self.in_reply_to
        if self.metadata:
            result["metadata"] = self.metadata
            
        return result
    
    def to_json(self) -> str:
        """Convert the message to JSON string."""
        return json.dumps(self.to_dict())
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'MCPMessage':
        """Create an MCP message from a dictionary."""
        if "type" not in data:
            raise MCPProtocolError("Missing 'type' field in MCP message")
        if "id" not in data:
            raise MCPProtocolError("Missing 'id' field in MCP message")
        
        try:
            message_type = MCPMessageType(data["type"])
        except ValueError:
            raise MCPProtocolError(f"Invalid message type: {data['type']}")
        
        content_type = MCPContentType.TEXT
        if "content_type" in data:
            try:
                content_type = MCPContentType(data["content_type"])
            except ValueError:
                logger.warning(f"Unknown content type: {data['content_type']}, using TEXT")
        
        return cls(
            message_type=message_type,
            content=data.get("content"),
            content_type=content_type,
            message_id=data["id"],
            session_id=data.get("session_id"),
            in_reply_to=data.get("in_reply_to"),
            metadata=data.get("metadata", {})
        )
    
    @classmethod
    def from_json(cls, json_str: str) -> 'MCPMessage':
        """Create an MCP message from a JSON string."""
        try:
            data = json.loads(json_str)
            return cls.from_dict(data)
        except json.JSONDecodeError as e:
            raise MCPProtocolError(f"Invalid JSON: {e}")


class MCPCommandMessage(MCPMessage):
    """MCP message for sending commands to Vectric via MCP."""
    
    def __init__(self,
                 command_type: str,
                 payload: Dict[str, Any],
                 message_id: Optional[str] = None,
                 session_id: Optional[str] = None,
                 in_reply_to: Optional[str] = None):
        """
        Initialize a new command message.
        
        Args:
            command_type: Type of command (execute_code, execute_function, query_state)
            payload: Command payload
            message_id: Unique message identifier
            session_id: Session identifier
            in_reply_to: ID of the message this is a reply to
        """
        content = {
            "command_type": command_type,
            "payload": payload
        }
        
        super().__init__(
            message_type=MCPMessageType.COMMAND,
            content=content,
            content_type=MCPContentType.VECTRIC_COMMAND,
            message_id=message_id,
            session_id=session_id,
            in_reply_to=in_reply_to
        )
        
    @classmethod
    def execute_code(cls, 
                     code: str, 
                     options: Optional[Dict[str, Any]] = None,
                     message_id: Optional[str] = None,
                     session_id: Optional[str] = None) -> 'MCPCommandMessage':
        """Create a command message for executing Lua code."""
        payload = {
            "code": code,
            "options": options or {}
        }
        return cls("execute_code", payload, message_id, session_id)
    
    @classmethod
    def execute_function(cls,
                         function_name: str,
                         parameters: Optional[Dict[str, Any]] = None,
                         options: Optional[Dict[str, Any]] = None,
                         message_id: Optional[str] = None,
                         session_id: Optional[str] = None) -> 'MCPCommandMessage':
        """Create a command message for executing a predefined function."""
        payload = {
            "function": function_name,
            "parameters": parameters or {},
            "options": options or {}
        }
        return cls("execute_function", payload, message_id, session_id)
    
    @classmethod
    def query_state(cls,
                    query: str,
                    options: Optional[Dict[str, Any]] = None,
                    message_id: Optional[str] = None,
                    session_id: Optional[str] = None) -> 'MCPCommandMessage':
        """Create a command message for querying the state."""
        payload = {
            "query": query,
            "options": options or {}
        }
        return cls("query_state", payload, message_id, session_id)


class MCPResultMessage(MCPMessage):
    """MCP message for returning results from Vectric operations."""
    
    def __init__(self,
                 status: str,
                 result_data: Any = None,
                 message: Optional[str] = None,
                 result_type: Optional[str] = None,
                 execution_time: Optional[int] = None,
                 message_id: Optional[str] = None,
                 in_reply_to: Optional[str] = None,
                 session_id: Optional[str] = None):
        """
        Initialize a new result message.
        
        Args:
            status: Result status (success, error, in_progress)
            result_data: Result data
            message: Human-readable message
            result_type: Type of result
            execution_time: Execution time in milliseconds
            message_id: Unique message identifier
            in_reply_to: ID of the command message this is responding to
            session_id: Session identifier
        """
        content = {
            "status": status,
            "result": {
                "data": result_data,
                "message": message or "",
                "type": result_type or "generic"
            }
        }
        
        if execution_time is not None:
            content["execution_time"] = execution_time
            
        super().__init__(
            message_type=MCPMessageType.RESULT,
            content=content,
            content_type=MCPContentType.VECTRIC_RESULT,
            message_id=message_id,
            session_id=session_id,
            in_reply_to=in_reply_to
        )
    
    @classmethod
    def success(cls,
               result_data: Any = None,
               message: str = "Operation completed successfully",
               result_type: Optional[str] = None,
               execution_time: Optional[int] = None,
               message_id: Optional[str] = None,
               in_reply_to: Optional[str] = None,
               session_id: Optional[str] = None) -> 'MCPResultMessage':
        """Create a success result message."""
        return cls(
            status="success",
            result_data=result_data,
            message=message,
            result_type=result_type,
            execution_time=execution_time,
            message_id=message_id,
            in_reply_to=in_reply_to,
            session_id=session_id
        )
    
    @classmethod
    def error(cls,
             error_message: str,
             error_data: Any = None,
             error_type: str = "error",
             execution_time: Optional[int] = None,
             message_id: Optional[str] = None,
             in_reply_to: Optional[str] = None,
             session_id: Optional[str] = None) -> 'MCPResultMessage':
        """Create an error result message."""
        return cls(
            status="error",
            result_data=error_data,
            message=error_message,
            result_type=error_type,
            execution_time=execution_time,
            message_id=message_id,
            in_reply_to=in_reply_to,
            session_id=session_id
        )
    
    @classmethod
    def in_progress(cls,
                  progress_data: Any = None,
                  message: str = "Operation in progress",
                  progress_type: str = "in_progress",
                  execution_time: Optional[int] = None,
                  message_id: Optional[str] = None,
                  in_reply_to: Optional[str] = None,
                  session_id: Optional[str] = None) -> 'MCPResultMessage':
        """Create an in-progress result message."""
        return cls(
            status="in_progress",
            result_data=progress_data,
            message=message,
            result_type=progress_type,
            execution_time=execution_time,
            message_id=message_id,
            in_reply_to=in_reply_to,
            session_id=session_id
        )


class MCPSession:
    """Handler for MCP sessions."""
    
    def __init__(self, session_id: Optional[str] = None):
        """Initialize a new MCP session."""
        self.session_id = session_id or str(uuid.uuid4())
        self.messages: List[MCPMessage] = []
        
    def add_message(self, message: MCPMessage) -> None:
        """Add a message to the session."""
        # Update the session_id if not already set
        if not message.session_id:
            message.session_id = self.session_id
        self.messages.append(message)
        
    def get_message_by_id(self, message_id: str) -> Optional[MCPMessage]:
        """Get a message by its ID."""
        for message in self.messages:
            if message.message_id == message_id:
                return message
        return None
    
    def create_start_session_message(self) -> MCPMessage:
        """Create a start session message."""
        return MCPMessage(
            message_type=MCPMessageType.START_SESSION,
            content={"session_id": self.session_id},
            content_type=MCPContentType.JSON,
            message_id=str(uuid.uuid4()),
            session_id=self.session_id
        )
    
    def create_end_session_message(self) -> MCPMessage:
        """Create an end session message."""
        return MCPMessage(
            message_type=MCPMessageType.END_SESSION,
            content={"session_id": self.session_id},
            content_type=MCPContentType.JSON,
            message_id=str(uuid.uuid4()),
            session_id=self.session_id
        )


class MCPProcessor:
    """
    Processor for handling MCP messages and maintaining sessions.
    
    This class handles incoming MCP messages, routes them to the appropriate
    handlers, and manages active sessions.
    """
    
    def __init__(self):
        """Initialize the MCP processor."""
        self.sessions: Dict[str, MCPSession] = {}
        self.handlers: Dict[MCPMessageType, callable] = {}
        
    def register_handler(self, message_type: MCPMessageType, handler: callable) -> None:
        """Register a handler for a specific message type."""
        self.handlers[message_type] = handler
        
    def create_session(self, session_id: Optional[str] = None) -> MCPSession:
        """Create a new session."""
        session = MCPSession(session_id)
        self.sessions[session.session_id] = session
        return session
    
    def get_session(self, session_id: str) -> Optional[MCPSession]:
        """Get a session by its ID."""
        return self.sessions.get(session_id)
    
    def end_session(self, session_id: str) -> None:
        """End a session."""
        if session_id in self.sessions:
            del self.sessions[session_id]
            
    def process_message(self, message: Union[MCPMessage, Dict, str]) -> Optional[MCPMessage]:
        """
        Process an incoming MCP message.
        
        Args:
            message: The message to process (can be an MCPMessage object, dict, or JSON string)
            
        Returns:
            Optional response message
        """
        # Convert message to MCPMessage object if needed
        if isinstance(message, str):
            try:
                message = MCPMessage.from_json(message)
            except MCPProtocolError as e:
                logger.error(f"Error parsing message: {e}")
                return MCPMessage(
                    message_type=MCPMessageType.ERROR,
                    content={"error": str(e), "code": e.error_code},
                    content_type=MCPContentType.JSON
                )
        elif isinstance(message, dict):
            try:
                message = MCPMessage.from_dict(message)
            except MCPProtocolError as e:
                logger.error(f"Error parsing message: {e}")
                return MCPMessage(
                    message_type=MCPMessageType.ERROR,
                    content={"error": str(e), "code": e.error_code},
                    content_type=MCPContentType.JSON
                )
        
        # Handle session management
        if message.session_id:
            session = self.get_session(message.session_id)
            if not session and message.message_type != MCPMessageType.START_SESSION:
                # Session doesn't exist but should
                error_msg = f"Session {message.session_id} does not exist"
                logger.error(error_msg)
                return MCPMessage(
                    message_type=MCPMessageType.ERROR,
                    content={"error": error_msg, "code": "session_not_found"},
                    content_type=MCPContentType.JSON,
                    in_reply_to=message.message_id
                )
                
            if session:
                session.add_message(message)
                
            # Handle start/end session specially
            if message.message_type == MCPMessageType.START_SESSION:
                if not session:
                    session = self.create_session(message.session_id)
                    logger.info(f"Started new session: {session.session_id}")
                else:
                    logger.warning(f"Session {session.session_id} already exists")
                    
                return MCPMessage(
                    message_type=MCPMessageType.RESPONSE,
                    content={"session_id": session.session_id, "status": "active"},
                    content_type=MCPContentType.JSON,
                    in_reply_to=message.message_id,
                    session_id=session.session_id
                )
                
            elif message.message_type == MCPMessageType.END_SESSION:
                if session:
                    self.end_session(session.session_id)
                    logger.info(f"Ended session: {message.session_id}")
                    
                return MCPMessage(
                    message_type=MCPMessageType.RESPONSE,
                    content={"session_id": message.session_id, "status": "closed"},
                    content_type=MCPContentType.JSON,
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
        
        # Route message to appropriate handler
        if message.message_type in self.handlers:
            try:
                return self.handlers[message.message_type](message)
            except Exception as e:
                logger.exception(f"Error in handler for {message.message_type.value}: {e}")
                return MCPMessage(
                    message_type=MCPMessageType.ERROR,
                    content={"error": str(e), "code": "handler_error"},
                    content_type=MCPContentType.JSON,
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
        else:
            logger.warning(f"No handler registered for message type: {message.message_type.value}")
            return MCPMessage(
                message_type=MCPMessageType.ERROR,
                content={
                    "error": f"No handler for message type: {message.message_type.value}",
                    "code": "no_handler"
                },
                content_type=MCPContentType.JSON,
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
