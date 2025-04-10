"""
Tests for the MCP protocol library.
"""
import pytest
import json
import uuid
from mcp.protocol import (
    MCPMessage,
    MCPMessageType,
    MCPContentType,
    MCPProtocolError,
    MCPCommandMessage,
    MCPResultMessage,
    MCPSession,
    MCPProcessor
)

class TestMCPMessage:
    """Tests for the MCPMessage class."""
    
    def test_create_message(self):
        """Test creating an MCP message."""
        msg = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Hello, world!",
            content_type=MCPContentType.TEXT
        )
        
        assert msg.message_type == MCPMessageType.REQUEST
        assert msg.content == "Hello, world!"
        assert msg.content_type == MCPContentType.TEXT
        assert msg.message_id is not None
        assert msg.session_id is None
        assert msg.in_reply_to is None
        
    def test_to_dict(self):
        """Test converting an MCP message to a dictionary."""
        msg_id = str(uuid.uuid4())
        session_id = str(uuid.uuid4())
        in_reply_to = str(uuid.uuid4())
        
        msg = MCPMessage(
            message_type=MCPMessageType.RESPONSE,
            content={"result": "success"},
            content_type=MCPContentType.JSON,
            message_id=msg_id,
            session_id=session_id,
            in_reply_to=in_reply_to,
            metadata={"key": "value"}
        )
        
        data = msg.to_dict()
        
        assert data["type"] == MCPMessageType.RESPONSE.value
        assert data["content"] == {"result": "success"}
        assert data["content_type"] == MCPContentType.JSON.value
        assert data["id"] == msg_id
        assert data["session_id"] == session_id
        assert data["in_reply_to"] == in_reply_to
        assert data["metadata"] == {"key": "value"}
        
    def test_from_dict(self):
        """Test creating an MCP message from a dictionary."""
        msg_id = str(uuid.uuid4())
        session_id = str(uuid.uuid4())
        in_reply_to = str(uuid.uuid4())
        
        data = {
            "type": "response",
            "content": {"result": "success"},
            "content_type": "application/json",
            "id": msg_id,
            "session_id": session_id,
            "in_reply_to": in_reply_to,
            "metadata": {"key": "value"}
        }
        
        msg = MCPMessage.from_dict(data)
        
        assert msg.message_type == MCPMessageType.RESPONSE
        assert msg.content == {"result": "success"}
        assert msg.content_type == MCPContentType.JSON
        assert msg.message_id == msg_id
        assert msg.session_id == session_id
        assert msg.in_reply_to == in_reply_to
        assert msg.metadata == {"key": "value"}
        
    def test_to_from_json(self):
        """Test round-trip JSON conversion."""
        original = MCPMessage(
            message_type=MCPMessageType.COMMAND,
            content={"action": "run"},
            content_type=MCPContentType.JSON
        )
        
        json_str = original.to_json()
        recreated = MCPMessage.from_json(json_str)
        
        assert recreated.message_type == original.message_type
        assert recreated.content == original.content
        assert recreated.content_type == original.content_type
        assert recreated.message_id == original.message_id
        
    def test_from_dict_missing_fields(self):
        """Test error handling for missing fields."""
        with pytest.raises(MCPProtocolError):
            MCPMessage.from_dict({})
            
        with pytest.raises(MCPProtocolError):
            MCPMessage.from_dict({"type": "request"})
            
    def test_from_dict_invalid_type(self):
        """Test error handling for invalid message type."""
        with pytest.raises(MCPProtocolError):
            MCPMessage.from_dict({"type": "invalid", "id": "123"})
            
    def test_from_json_invalid(self):
        """Test error handling for invalid JSON."""
        with pytest.raises(MCPProtocolError):
            MCPMessage.from_json("{invalid json")


class TestMCPCommandMessage:
    """Tests for the MCPCommandMessage class."""
    
    def test_create_execute_code(self):
        """Test creating an execute_code command message."""
        msg = MCPCommandMessage.execute_code(
            code="print('hello')",
            options={"timeout": 5000}
        )
        
        assert msg.message_type == MCPMessageType.COMMAND
        assert msg.content_type == MCPContentType.VECTRIC_COMMAND
        assert msg.content["command_type"] == "execute_code"
        assert msg.content["payload"]["code"] == "print('hello')"
        assert msg.content["payload"]["options"]["timeout"] == 5000
        
    def test_create_execute_function(self):
        """Test creating an execute_function command message."""
        msg = MCPCommandMessage.execute_function(
            function_name="create_circle",
            parameters={"x": 100, "y": 100, "radius": 50},
            options={"layer": "Layer 1"}
        )
        
        assert msg.message_type == MCPMessageType.COMMAND
        assert msg.content_type == MCPContentType.VECTRIC_COMMAND
        assert msg.content["command_type"] == "execute_function"
        assert msg.content["payload"]["function"] == "create_circle"
        assert msg.content["payload"]["parameters"] == {"x": 100, "y": 100, "radius": 50}
        assert msg.content["payload"]["options"] == {"layer": "Layer 1"}
        
    def test_create_query_state(self):
        """Test creating a query_state command message."""
        msg = MCPCommandMessage.query_state(
            query="job_info",
            options={"include_layers": True}
        )
        
        assert msg.message_type == MCPMessageType.COMMAND
        assert msg.content_type == MCPContentType.VECTRIC_COMMAND
        assert msg.content["command_type"] == "query_state"
        assert msg.content["payload"]["query"] == "job_info"
        assert msg.content["payload"]["options"] == {"include_layers": True}


class TestMCPResultMessage:
    """Tests for the MCPResultMessage class."""
    
    def test_create_success(self):
        """Test creating a success result message."""
        command_id = str(uuid.uuid4())
        msg = MCPResultMessage.success(
            result_data={"created_item_id": 123},
            message="Circle created successfully",
            result_type="create_result",
            execution_time=150,
            in_reply_to=command_id
        )
        
        assert msg.message_type == MCPMessageType.RESULT
        assert msg.content_type == MCPContentType.VECTRIC_RESULT
        assert msg.content["status"] == "success"
        assert msg.content["result"]["data"] == {"created_item_id": 123}
        assert msg.content["result"]["message"] == "Circle created successfully"
        assert msg.content["result"]["type"] == "create_result"
        assert msg.content["execution_time"] == 150
        assert msg.in_reply_to == command_id
        
    def test_create_error(self):
        """Test creating an error result message."""
        command_id = str(uuid.uuid4())
        msg = MCPResultMessage.error(
            error_message="Invalid parameters",
            error_data={"field": "radius", "issue": "must be positive"},
            error_type="validation_error",
            in_reply_to=command_id
        )
        
        assert msg.message_type == MCPMessageType.RESULT
        assert msg.content_type == MCPContentType.VECTRIC_RESULT
        assert msg.content["status"] == "error"
        assert msg.content["result"]["data"] == {"field": "radius", "issue": "must be positive"}
        assert msg.content["result"]["message"] == "Invalid parameters"
        assert msg.content["result"]["type"] == "validation_error"
        assert msg.in_reply_to == command_id
        
    def test_create_in_progress(self):
        """Test creating an in-progress result message."""
        command_id = str(uuid.uuid4())
        msg = MCPResultMessage.in_progress(
            progress_data={"percent_complete": 50},
            message="Operation in progress",
            in_reply_to=command_id
        )
        
        assert msg.message_type == MCPMessageType.RESULT
        assert msg.content_type == MCPContentType.VECTRIC_RESULT
        assert msg.content["status"] == "in_progress"
        assert msg.content["result"]["data"] == {"percent_complete": 50}
        assert msg.content["result"]["message"] == "Operation in progress"
        assert msg.content["result"]["type"] == "in_progress"
        assert msg.in_reply_to == command_id


class TestMCPSession:
    """Tests for the MCPSession class."""
    
    def test_create_session(self):
        """Test creating a session."""
        session = MCPSession()
        assert session.session_id is not None
        assert len(session.messages) == 0
        
        session = MCPSession("custom-id")
        assert session.session_id == "custom-id"
        
    def test_add_message(self):
        """Test adding a message to a session."""
        session = MCPSession("test-session")
        msg = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Hello"
        )
        
        session.add_message(msg)
        
        assert len(session.messages) == 1
        assert session.messages[0] == msg
        assert msg.session_id == "test-session"
        
    def test_get_message_by_id(self):
        """Test retrieving a message by ID."""
        session = MCPSession()
        msg1 = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="First message",
            message_id="msg-1"
        )
        msg2 = MCPMessage(
            message_type=MCPMessageType.RESPONSE,
            content="Second message",
            message_id="msg-2"
        )
        
        session.add_message(msg1)
        session.add_message(msg2)
        
        assert session.get_message_by_id("msg-1") == msg1
        assert session.get_message_by_id("msg-2") == msg2
        assert session.get_message_by_id("non-existent") is None
        
    def test_create_session_messages(self):
        """Test creating session start/end messages."""
        session = MCPSession("test-session")
        
        start_msg = session.create_start_session_message()
        assert start_msg.message_type == MCPMessageType.START_SESSION
        assert start_msg.content["session_id"] == "test-session"
        assert start_msg.session_id == "test-session"
        
        end_msg = session.create_end_session_message()
        assert end_msg.message_type == MCPMessageType.END_SESSION
        assert end_msg.content["session_id"] == "test-session"
        assert end_msg.session_id == "test-session"


class TestMCPProcessor:
    """Tests for the MCPProcessor class."""
    
    def test_create_processor(self):
        """Test creating a processor."""
        processor = MCPProcessor()
        assert len(processor.sessions) == 0
        assert len(processor.handlers) == 0
        
    def test_session_management(self):
        """Test session management."""
        processor = MCPProcessor()
        
        # Create session
        session = processor.create_session("test-session")
        assert session.session_id == "test-session"
        assert "test-session" in processor.sessions
        
        # Get session
        retrieved = processor.get_session("test-session")
        assert retrieved == session
        assert processor.get_session("non-existent") is None
        
        # End session
        processor.end_session("test-session")
        assert "test-session" not in processor.sessions
        
    def test_register_handler(self):
        """Test registering message handlers."""
        processor = MCPProcessor()
        
        def dummy_handler(msg):
            return MCPMessage(
                message_type=MCPMessageType.RESPONSE,
                content="Handled",
                in_reply_to=msg.message_id
            )
            
        processor.register_handler(MCPMessageType.REQUEST, dummy_handler)
        assert MCPMessageType.REQUEST in processor.handlers
        assert processor.handlers[MCPMessageType.REQUEST] == dummy_handler
        
    def test_process_message_session_management(self):
        """Test processing session management messages."""
        processor = MCPProcessor()
        
        # Process START_SESSION
        start_msg = MCPMessage(
            message_type=MCPMessageType.START_SESSION,
            content={},
            message_id="msg-1",
            session_id="new-session"
        )
        
        response = processor.process_message(start_msg)
        assert response.message_type == MCPMessageType.RESPONSE
        assert response.content["status"] == "active"
        assert response.in_reply_to == "msg-1"
        assert "new-session" in processor.sessions
        
        # Process END_SESSION
        end_msg = MCPMessage(
            message_type=MCPMessageType.END_SESSION,
            content={},
            message_id="msg-2",
            session_id="new-session"
        )
        
        response = processor.process_message(end_msg)
        assert response.message_type == MCPMessageType.RESPONSE
        assert response.content["status"] == "closed"
        assert response.in_reply_to == "msg-2"
        assert "new-session" not in processor.sessions
        
    def test_process_message_with_handler(self):
        """Test processing a message with a registered handler."""
        processor = MCPProcessor()
        session_id = "test-session"
        processor.create_session(session_id)
        
        def echo_handler(msg):
            return MCPMessage(
                message_type=MCPMessageType.RESPONSE,
                content=f"Echo: {msg.content}",
                in_reply_to=msg.message_id,
                session_id=msg.session_id
            )
            
        processor.register_handler(MCPMessageType.REQUEST, echo_handler)
        
        request = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Hello",
            message_id="msg-1",
            session_id=session_id
        )
        
        response = processor.process_message(request)
        assert response.message_type == MCPMessageType.RESPONSE
        assert response.content == "Echo: Hello"
        assert response.in_reply_to == "msg-1"
        assert response.session_id == session_id
        
    def test_process_message_no_handler(self):
        """Test processing a message with no registered handler."""
        processor = MCPProcessor()
        session_id = "test-session"
        processor.create_session(session_id)
        
        request = MCPMessage(
            message_type=MCPMessageType.COMMAND,
            content={"command": "do_something"},
            message_id="msg-1",
            session_id=session_id
        )
        
        response = processor.process_message(request)
        assert response.message_type == MCPMessageType.ERROR
        assert "no_handler" in response.content["code"]
        assert response.in_reply_to == "msg-1"
        
    def test_process_message_handler_error(self):
        """Test processing a message where the handler raises an exception."""
        processor = MCPProcessor()
        session_id = "test-session"
        processor.create_session(session_id)
        
        def failing_handler(msg):
            raise ValueError("Something went wrong")
            
        processor.register_handler(MCPMessageType.REQUEST, failing_handler)
        
        request = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Hello",
            message_id="msg-1",
            session_id=session_id
        )
        
        response = processor.process_message(request)
        assert response.message_type == MCPMessageType.ERROR
        assert "handler_error" in response.content["code"]
        assert "Something went wrong" in response.content["error"]
        assert response.in_reply_to == "msg-1"
        
    def test_process_message_invalid_session(self):
        """Test processing a message with an invalid session ID."""
        processor = MCPProcessor()
        
        request = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Hello",
            message_id="msg-1",
            session_id="non-existent"
        )
        
        response = processor.process_message(request)
        assert response.message_type == MCPMessageType.ERROR
        assert "session_not_found" in response.content["code"]
        assert response.in_reply_to == "msg-1"
        
    def test_process_message_from_json(self):
        """Test processing a message from JSON string."""
        processor = MCPProcessor()
        processor.create_session("test-session")
        
        def echo_handler(msg):
            return MCPMessage(
                message_type=MCPMessageType.RESPONSE,
                content=f"Echo: {msg.content}",
                in_reply_to=msg.message_id,
                session_id=msg.session_id
            )
            
        processor.register_handler(MCPMessageType.REQUEST, echo_handler)
        
        json_str = json.dumps({
            "type": "request",
            "id": "json-msg",
            "content": "JSON Hello",
            "session_id": "test-session"
        })
        
        response = processor.process_message(json_str)
        assert response.message_type == MCPMessageType.RESPONSE
        assert response.content == "Echo: JSON Hello"
        assert response.in_reply_to == "json-msg"
        
    def test_process_message_invalid_json(self):
        """Test processing an invalid JSON string."""
        processor = MCPProcessor()
        
        response = processor.process_message("{invalid json")
        assert response.message_type == MCPMessageType.ERROR
        assert "Invalid JSON" in response.content["error"]
