"""
End-to-End tests for command execution flow.

These tests verify that commands flow correctly from the MCP Server to the
Lua Gadget and responses are properly handled.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import unittest
import asyncio
import json
import sys
import os
import time

# Add project root to Python path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from python_mcp_server.socket_client import LuaSocketClient
from python_mcp_server.command_generator import CommandGenerator
from python_mcp_server.result_handler import ResultHandler


class CommandExecutionTests(unittest.TestCase):
    """Test command execution flow between the MCP Server and Lua Gadget."""
    
    def setUp(self):
        """Set up test fixtures."""
        # Create a socket client
        self.lua_client = LuaSocketClient(host="localhost", port=9876)
        
        # Create a command generator
        self.command_generator = CommandGenerator()
        
        # Test auth token (same as in mock_lua_server.py)
        self.auth_token = "test_auth_token"
    
    def tearDown(self):
        """Tear down test fixtures."""
        # Disconnect the socket client
        if hasattr(self, 'lua_client') and self.lua_client:
            self.lua_client.disconnect_sync()
    
    async def test_execute_code_command(self):
        """Test executing a code command."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Generate a command to create a circle
        lua_code = "local circle = Circle:new(100, 100, 50); return circle"
        command_id = "test_circle_1"
        
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
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], command_id)
    
    async def test_execute_function_command(self):
        """Test executing a function command."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Function to create a circle
        function_name = "create_circle"
        parameters = {
            "center_x": 150,
            "center_y": 150,
            "radius": 75
        }
        command_id = "test_function_1"
        
        command = {
            "command_type": "execute_function",
            "payload": {
                "function": function_name,
                "parameters": parameters
            },
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], command_id)
        self.assertIn("object_id", response["result"]["data"])
    
    async def test_query_state_command(self):
        """Test querying the state of the Lua Gadget."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        command_id = "test_query_1"
        command = {
            "command_type": "query_state",
            "id": command_id
        }
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], command_id)
        self.assertIn("job", response["result"]["data"])
    
    async def test_command_with_delay(self):
        """Test a command that takes some time to execute."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Generate a command that includes a sleep/delay
        lua_code = "-- This will trigger a delay in the mock\nlocal sleep = 1; return 'done'"
        command_id = "test_delay_1"
        
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": lua_code
            },
            "id": command_id
        }
        
        # Record the start time
        start_time = time.time()
        
        # Send the command
        response_str = await self.lua_client.send_command(json.dumps(command))
        
        # Calculate elapsed time
        elapsed_time = time.time() - start_time
        
        # Parse and process the response
        raw_response = json.loads(response_str)
        response = ResultHandler.process_lua_response(raw_response, command_id)
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["command_id"], command_id)
        
        # Verify that the command took at least 1 second to execute
        self.assertGreaterEqual(elapsed_time, 1.0)
    
    async def test_command_sequence(self):
        """Test a sequence of commands executed in order."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Define a sequence of commands
        commands = [
            {
                "command_type": "execute_function",
                "payload": {
                    "function": "create_job",
                    "parameters": {
                        "name": "Test Job",
                        "width": 400,
                        "height": 300,
                        "thickness": 20
                    }
                },
                "id": "seq_cmd_1"
            },
            {
                "command_type": "execute_function",
                "payload": {
                    "function": "create_circle",
                    "parameters": {
                        "center_x": 200,
                        "center_y": 150,
                        "radius": 100
                    }
                },
                "id": "seq_cmd_2"
            },
            {
                "command_type": "execute_function",
                "payload": {
                    "function": "create_profile_toolpath",
                    "parameters": {
                        "name": "Test Toolpath",
                        "tool_id": "1",
                        "cut_depth": 10,
                        "object_ids": ["will_be_replaced"]
                    }
                },
                "id": "seq_cmd_3"
            }
        ]
        
        created_object_id = None
        
        # Execute the commands in sequence
        for i, command in enumerate(commands):
            # If we have an object ID from a previous command, use it
            if i == 2 and created_object_id:
                command["payload"]["parameters"]["object_ids"] = [created_object_id]
            
            # Send the command
            response_str = await self.lua_client.send_command(json.dumps(command))
            
            # Parse and process the response
            raw_response = json.loads(response_str)
            response = ResultHandler.process_lua_response(raw_response, command["id"])
            
            # Check the response
            self.assertEqual(response["status"], "success")
            self.assertEqual(response["command_id"], command["id"])
            
            # Save the object ID from the second command
            if i == 1:
                created_object_id = response["result"]["data"]["object_id"]


if __name__ == '__main__':
    unittest.main()
