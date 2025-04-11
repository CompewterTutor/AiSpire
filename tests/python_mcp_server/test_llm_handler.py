"""
Tests for the LLM Handler module.
"""
import json
import unittest
from unittest.mock import AsyncMock, MagicMock, patch
import asyncio

from python_mcp_server.llm.handler import LLMHandler
from python_mcp_server.mcp.protocol import (
    MCPMessage,
    MCPMessageType,
    MCPContentType,
    MCPCommandMessage,
    MCPResultMessage
)
from python_mcp_server.result_handler import ResultType


class TestLLMHandler(unittest.IsolatedAsyncioTestCase):
    """Test cases for the LLM Handler."""

    def setUp(self):
        """Set up test fixtures."""
        self.lua_client = AsyncMock()
        self.command_generator = MagicMock()
        self.handler = LLMHandler(self.lua_client, self.command_generator)

    async def test_handle_command_invalid_format(self):
        """Test handling a command with invalid format."""
        # Create a command message without a command_type
        message = MCPMessage(
            message_type=MCPMessageType.COMMAND,
            content={},  # Missing command_type
            message_id="test-id"
        )
        
        response = await self.handler.handle_command(message)
        
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "error")
        self.assertIn("missing command_type", response.content["result"]["message"])
        self.assertEqual(response.in_reply_to, "test-id")

    async def test_handle_command_unknown_type(self):
        """Test handling a command with unknown type."""
        message = MCPMessage(
            message_type=MCPMessageType.COMMAND,
            content={"command_type": "unknown_command"},
            message_id="test-id"
        )
        
        response = await self.handler.handle_command(message)
        
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "error")
        self.assertIn("Unknown command type", response.content["result"]["message"])
        self.assertEqual(response.in_reply_to, "test-id")

    async def test_handle_execute_code_success(self):
        """Test handling an execute_code command with success response."""
        # Mock the Lua client to return a success response
        success_response = json.dumps({
            "status": "success",
            "result": {
                "message": "Code executed successfully",
                "data": {"output": "test result"}
            },
            "execution_time": 150
        })
        self.lua_client.execute_code.return_value = success_response
        
        # Create a command message for execute_code
        message = MCPCommandMessage.execute_code(
            code="print('hello')",
            message_id="code-cmd-id"
        )
        
        # Handle the message
        response = await self.handler.handle_command(message)
        
        # Verify the Lua client was called correctly
        self.lua_client.execute_code.assert_called_once_with("print('hello')", "code-cmd-id")
        
        # Check the response format
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "success")
        self.assertEqual(response.content["result"]["message"], "Code executed successfully")
        self.assertEqual(response.content["result"]["data"], {"output": "test result"})
        self.assertEqual(response.content["execution_time"], 150)
        self.assertEqual(response.in_reply_to, "code-cmd-id")

    async def test_handle_execute_code_error(self):
        """Test handling an execute_code command with error response."""
        # Mock the Lua client to return an error response
        error_response = json.dumps({
            "status": "error",
            "result": {
                "message": "Error in Lua code",
                "type": "syntax_error",
                "data": {"line": 10}
            },
            "execution_time": 50
        })
        self.lua_client.execute_code.return_value = error_response
        
        # Create a command message for execute_code
        message = MCPCommandMessage.execute_code(
            code="invalid code",
            message_id="error-cmd-id"
        )
        
        # Handle the message
        response = await self.handler.handle_command(message)
        
        # Verify the Lua client was called correctly
        self.lua_client.execute_code.assert_called_once_with("invalid code", "error-cmd-id")
        
        # Check the response format
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "error")
        self.assertEqual(response.content["result"]["message"], "Error in Lua code")
        self.assertEqual(response.content["result"]["type"], "syntax_error")
        self.assertEqual(response.content["result"]["data"], {"line": 10})
        self.assertEqual(response.content["execution_time"], 50)
        self.assertEqual(response.in_reply_to, "error-cmd-id")

    async def test_handle_execute_function_success(self):
        """Test handling an execute_function command with success response."""
        # Mock the command generator
        self.command_generator.generate_function_command.return_value = "generated_lua_code"
        
        # Mock the Lua client to return a success response
        success_response = json.dumps({
            "status": "success",
            "result": {
                "message": "Function executed successfully",
                "data": {"id": 42}
            }
        })
        self.lua_client.execute_function.return_value = success_response
        
        # Create a command message for execute_function
        message = MCPCommandMessage.execute_function(
            function_name="create_circle",
            parameters={"x": 100, "y": 100, "radius": 50},
            message_id="func-cmd-id"
        )
        
        # Handle the message
        response = await self.handler.handle_command(message)
        
        # Verify the function was called correctly
        self.lua_client.execute_function.assert_called_once_with(
            "create_circle", {"x": 100, "y": 100, "radius": 50}, "func-cmd-id"
        )
        
        # Check the response format
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "success")
        self.assertEqual(response.content["result"]["message"], "Function executed successfully")
        self.assertEqual(response.content["result"]["data"], {"id": 42})
        self.assertEqual(response.in_reply_to, "func-cmd-id")

    async def test_handle_query_state(self):
        """Test handling a query_state command."""
        # Mock the Lua client
        success_response = json.dumps({
            "status": "success",
            "result": {
                "message": "State retrieved",
                "data": {"job_name": "Test Job", "dimensions": [100, 200]}
            }
        })
        self.lua_client.query_state.return_value = success_response
        
        # Create a command message for query_state
        message = MCPCommandMessage.query_state(
            query="job_info",
            message_id="query-cmd-id"
        )
        
        # Handle the message
        response = await self.handler.handle_command(message)
        
        # Verify the query was called correctly
        self.lua_client.query_state.assert_called_once_with("query-cmd-id")
        
        # Check the response format
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "success")
        self.assertEqual(response.content["result"]["message"], "State retrieved")
        self.assertEqual(response.content["result"]["data"], {"job_name": "Test Job", "dimensions": [100, 200]})
        self.assertEqual(response.in_reply_to, "query-cmd-id")

    async def test_handle_natural_language_request(self):
        """Test handling a natural language request."""
        # Create a request message
        message = MCPMessage(
            message_type=MCPMessageType.REQUEST,
            content="Create a circle with radius 50 at position 100,100",
            message_id="nl-req-id"
        )
        
        # Handle the message
        response = await self.handler.handle_request(message)
        
        # Check the response format
        self.assertEqual(response.message_type, MCPMessageType.RESULT)
        self.assertEqual(response.content["status"], "success")
        self.assertIn("natural language", response.content["result"]["message"])
        self.assertEqual(response.in_reply_to, "nl-req-id")


if __name__ == '__main__':
    unittest.main()