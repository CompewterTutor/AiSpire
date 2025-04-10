"""
End-to-End tests for error handling and recovery.

These tests verify that errors in the communication between the MCP Server
and Lua Gadget are properly handled and the system can recover from them.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import unittest
import asyncio
import json
import sys
import os
import time
import socket

# Add project root to Python path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from python_mcp_server.socket_client import LuaSocketClient
from python_mcp_server.result_handler import ResultHandler


class ErrorHandlingTests(unittest.TestCase):
    """Test error handling and recovery in the communication flow."""
    
    def setUp(self):
        """Set up test fixtures."""
        # Create a socket client
        self.lua_client = LuaSocketClient(host="localhost", port=9876)
        
        # Test auth token (same as in mock_lua_server.py)
        self.auth_token = "test_auth_token"
    
    def tearDown(self):
        """Tear down test fixtures."""
        # Disconnect the socket client
        if hasattr(self, 'lua_client') and self.lua_client:
            self.lua_client.disconnect_sync()
    
    async def test_syntax_error_in_code(self):
        """Test handling of syntax errors in Lua code."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Generate a command with an error
        lua_code = "this will cause an error"
        command_id = "test_error_1"
        
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": lua_code
            },
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "error")
        self.assertEqual(response["command_id"], command_id)
    
    async def test_unknown_function_error(self):
        """Test handling of unknown function errors."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Try to execute a function that doesn't exist
        function_name = "non_existent_function"
        command_id = "test_error_2"
        
        command = {
            "command_type": "execute_function",
            "payload": {
                "function": function_name,
                "parameters": {}
            },
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "error")
        self.assertEqual(response["result"]["type"], "validation_error")
        self.assertEqual(response["command_id"], command_id)
    
    async def test_invalid_command_type(self):
        """Test handling of invalid command types."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Send a command with an invalid type
        command_id = "test_error_3"
        command = {
            "command_type": "invalid_command_type",
            "payload": {},
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "error")
        self.assertEqual(response["result"]["type"], "validation_error")
        self.assertEqual(response["command_id"], command_id)
    
    async def test_invalid_json(self):
        """Test handling of invalid JSON in commands."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Send invalid JSON
        invalid_json = "{ this is not valid JSON }"
        
        # Send the command (this should be handled by the client)
        with self.assertRaises(Exception):
            await self.lua_client.send_command(invalid_json)
    
    async def test_runtime_error_in_code(self):
        """Test handling of runtime errors in Lua code."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Generate a command that will cause a runtime error
        # (In the mock, any code containing 'error' will fail)
        lua_code = "local x = 10; error('Test error'); return x"
        command_id = "test_error_4"
        
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": lua_code
            },
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "error")
        self.assertEqual(response["result"]["type"], "runtime_error")
        self.assertEqual(response["command_id"], command_id)
    
    async def test_recovery_after_error(self):
        """Test that the system recovers after an error."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Send a command that will cause an error
        error_code = "error('Test error')"
        error_command = {
            "command_type": "execute_code",
            "payload": {
                "code": error_code
            },
            "id": "error_cmd"
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(error_command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, "error_cmd")
        
        # Check the response
        self.assertEqual(response["status"], "error")
        
        # Now send a valid command to check recovery
        valid_code = "return 'Recovery test'"
        valid_command = {
            "command_type": "execute_code",
            "payload": {
                "code": valid_code
            },
            "id": "recovery_cmd"
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(valid_command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, "recovery_cmd")
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], "recovery_cmd")
    
    async def test_connection_loss_recovery(self):
        """Test recovery from a lost connection."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Send a valid command to verify the connection works
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": "return 'Before disconnect'"
            },
            "id": "before_disconnect"
        }
        
        response_str = await self.lua_client.send_command(json.dumps(command))
        raw_response = json.loads(response_str)
        self.assertEqual(raw_response["status"], "success")
        
        # Force disconnect
        self.lua_client._socket.close()
        self.lua_client._is_connected = False
        
        # Allow time for the client to detect the disconnect
        time.sleep(0.5)
        
        # Try to send another command (should auto-reconnect)
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": "return 'After disconnect'"
            },
            "id": "after_disconnect"
        }
        
        response_str = await self.lua_client.send_command(json.dumps(command))
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, "after_disconnect")
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], "after_disconnect")


if __name__ == '__main__':
    unittest.main()
