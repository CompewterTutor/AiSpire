"""
Tests for the MCP Server implementation.
"""
import json
import asyncio
import unittest
from unittest.mock import AsyncMock, MagicMock, patch

from python_mcp_server.mcp_server import McpServer
from python_mcp_server.result_handler import ResultHandler, ResultType, ErrorCategory


class TestMcpServer(unittest.IsolatedAsyncioTestCase):
    """Test cases for the MCP Server."""

    def setUp(self):
        """Set up test fixtures."""
        self.server = McpServer(host="localhost", port=8765, lua_host="localhost", lua_port=9876)
        self.server.lua_client = AsyncMock()
        self.server.command_generator = MagicMock()

    async def test_start_server(self):
        """Test starting the MCP server."""
        with patch('asyncio.start_server', new_callable=AsyncMock) as mock_start_server:
            mock_server = AsyncMock()
            mock_start_server.return_value = mock_server
            mock_server.sockets = [MagicMock()]
            mock_server.sockets[0].getsockname.return_value = ('localhost', 8765)
            mock_server.__aenter__ = AsyncMock(return_value=mock_server)
            mock_server.__aexit__ = AsyncMock(return_value=None)
            mock_server.serve_forever = AsyncMock()
            
            # Start the server but don't actually run serve_forever
            task = asyncio.create_task(self.server.start())
            await asyncio.sleep(0.1)
            task.cancel()
            
            try:
                await task
            except asyncio.CancelledError:
                pass
                
            # Check that the server was started correctly
            mock_start_server.assert_called_once_with(
                self.server.handle_client, 'localhost', 8765
            )
            self.assertTrue(self.server.running)
            
    async def test_stop_server(self):
        """Test stopping the MCP server."""
        self.server.running = True
        self.server.server = AsyncMock()
        self.server.server.close = MagicMock()
        self.server.server.wait_closed = AsyncMock()
        
        await self.server.stop()
        
        self.server.server.close.assert_called_once()
        self.server.server.wait_closed.assert_called_once()
        self.server.lua_client.disconnect.assert_called_once()
        self.assertFalse(self.server.running)

    async def test_process_message_success(self):
        """Test successful message processing."""
        # Mock command generator
        self.server.command_generator.generate_command.return_value = "lua_command"
        
        # Mock Lua client response
        success_response = {
            "status": "success",
            "result": {"data": {"value": 42}, "message": "Operation successful"},
            "execution_time": 100
        }
        self.server.lua_client.send_command.return_value = json.dumps(success_response)
        
        # Process a test message
        request = json.dumps({"id": "test123", "command": "test_command"})
        response = await self.server.process_message(request)
        
        # Verify the command was generated and sent
        self.server.command_generator.generate_command.assert_called_once()
        self.server.lua_client.send_command.assert_called_once_with("lua_command")
        
        # Check the response is correctly formatted
        self.assertEqual(response["status"], ResultType.SUCCESS.value)
        self.assertEqual(response["result"]["data"], {"value": 42})
        self.assertEqual(response["result"]["message"], "Operation successful")
        self.assertEqual(response["command_id"], "test123")
        self.assertEqual(response["execution_time"], 100)
    
    async def test_process_message_error(self):
        """Test error handling in message processing."""
        # Mock command generator
        self.server.command_generator.generate_command.return_value = "lua_command"
        
        # Mock Lua client response - error case
        error_response = {
            "status": "error",
            "result": {"message": "Something went wrong", "type": "runtime_error"},
            "execution_time": 50
        }
        self.server.lua_client.send_command.return_value = json.dumps(error_response)
        
        # Process a test message
        request = json.dumps({"id": "test456", "command": "test_command"})
        response = await self.server.process_message(request)
        
        # Check error response
        self.assertEqual(response["status"], ResultType.ERROR.value)
        self.assertEqual(response["result"]["message"], "Something went wrong")
        self.assertEqual(response["result"]["type"], "runtime_error")
        self.assertEqual(response["command_id"], "test456")
        self.assertEqual(response["execution_time"], 50)
        
    async def test_process_message_invalid_json(self):
        """Test handling of invalid JSON in the request."""
        request = "not valid json"
        response = await self.server.process_message(request)
        
        self.assertEqual(response["status"], ResultType.ERROR.value)
        self.assertEqual(response["result"]["type"], ErrorCategory.SYNTAX.value)
        self.assertIn("Invalid JSON", response["result"]["message"])
        
    async def test_process_message_exception(self):
        """Test handling of exceptions during processing."""
        self.server.command_generator.generate_command.side_effect = Exception("Test exception")
        
        request = json.dumps({"id": "test789", "command": "test_command"})
        response = await self.server.process_message(request)
        
        self.assertEqual(response["status"], ResultType.ERROR.value)
        self.assertEqual(response["result"]["type"], ErrorCategory.UNKNOWN.value)
        self.assertIn("Test exception", response["result"]["message"])
        
    async def test_handle_client(self):
        """Test client connection handling."""
        # Mock StreamReader and StreamWriter
        reader = AsyncMock()
        writer = AsyncMock()
        writer.get_extra_info.return_value = ('127.0.0.1', 12345)
        
        # Set up reader to return a message
        message = json.dumps({"id": "client123", "command": "test"})
        reader.read.return_value = message.encode()
        
        # Mock process_message to return a success response
        test_response = ResultHandler.format_success_response(
            data={"result": "test_result"},
            message="Test successful",
            command_id="client123"
        )
        
        self.server.process_message = AsyncMock(return_value=test_response)
        
        # Handle the client
        await self.server.handle_client(reader, writer)
        
        # Verify reader/writer were used correctly
        reader.read.assert_called_once()
        writer.write.assert_called_once()
        writer.drain.assert_called_once()
        writer.close.assert_called_once()
        writer.wait_closed.assert_called_once()
        
        # Check the response was processed and sent correctly
        self.server.process_message.assert_called_once_with(message)
        written_data = writer.write.call_args[0][0].decode()
        written_json = json.loads(written_data)
        self.assertEqual(written_json["status"], ResultType.SUCCESS.value)
        self.assertEqual(written_json["command_id"], "client123")
        
    async def test_handle_client_exception(self):
        """Test exception handling in client connection."""
        # Mock StreamReader and StreamWriter
        reader = AsyncMock()
        writer = AsyncMock()
        writer.get_extra_info.return_value = ('127.0.0.1', 12345)
        
        # Make reader raise an exception
        reader.read.side_effect = Exception("Test connection error")
        
        # Handle the client
        await self.server.handle_client(reader, writer)
        
        # Verify error handling behavior
        writer_data = writer.write.call_args[0][0].decode()
        response = json.loads(writer_data)
        self.assertEqual(response["status"], ResultType.ERROR.value)
        self.assertIn("Internal server error", response["result"]["message"])
        self.assertEqual(response["result"]["type"], ErrorCategory.UNKNOWN.value)
        
        writer.close.assert_called_once()
        writer.wait_closed.assert_called_once()


if __name__ == '__main__':
    unittest.main()
