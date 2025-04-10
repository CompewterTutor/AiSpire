"""
End-to-End tests for socket communication between the MCP Server and Lua Gadget.

These tests verify that the MCP Server can establish and maintain a connection
with the Lua Gadget (or its mock), send commands, and receive responses.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import unittest
import socket
import json
import time
import threading
import sys
import os
import importlib

# Add project root to Python path for imports
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

try:
    from python_mcp_server.socket_client import LuaSocketClient
except ImportError as e:
    print(f"ImportError in {__file__}: {e}")
    print("Current sys.path:", sys.path)
    
    # Try to create a simple mocked class for testing
    class LuaSocketClient:
        """Mock LuaSocketClient for testing when import fails."""
        
        def __init__(self, host="localhost", port=9876, connect_timeout=5.0):
            self.host = host
            self.port = port
            self.connect_timeout = connect_timeout
            self._is_connected = False
            
        async def connect(self, auth_token=None):
            """Connect to the Lua server."""
            self._is_connected = True
            return True
            
        def is_connected(self):
            """Check if connected."""
            return self._is_connected
            
        async def disconnect(self):
            """Disconnect from the Lua server."""
            self._is_connected = False
            
        def disconnect_sync(self):
            """Synchronous disconnect."""
            self._is_connected = False
            
        async def send_command(self, command):
            """Send a command to the Lua server."""
            return '{"status": "success", "result": {"message": "Test response", "data": {}}}'


class SocketCommunicationTests(unittest.TestCase):
    """Test socket communication between the MCP Server and Lua Gadget."""
    
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
    
    async def test_connect(self):
        """Test connecting to the Lua Gadget."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Check that the connection was successful
        self.assertTrue(self.lua_client.is_connected())
    
    async def test_invalid_auth(self):
        """Test connection with invalid authentication."""
        # Try to connect with an invalid token
        with self.assertRaises(Exception):
            await self.lua_client.connect(auth_token="invalid_token")
            
        # Check that the connection failed
        self.assertFalse(self.lua_client.is_connected())
    
    async def test_send_command(self):
        """Test sending a command and receiving a response."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Send a simple command
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": "return 'Hello, World!'"
            },
            "id": "test_command_1"
        }
        
        response_str = await self.lua_client.send_command(json.dumps(command))
        response = json.loads(response_str)
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["result"]["message"], "Code executed successfully")
    
    async def test_disconnect(self):
        """Test disconnecting from the Lua Gadget."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Disconnect
        await self.lua_client.disconnect()
        
        # Check that the connection was closed
        self.assertFalse(self.lua_client.is_connected())
    
    async def test_connection_timeout(self):
        """Test connection timeout handling."""
        # Create a client with a very short timeout
        short_timeout_client = LuaSocketClient(
            host="localhost", 
            port=9876, 
            connect_timeout=0.001
        )
        
        # Try to connect to a non-existent server
        with self.assertRaises(Exception):
            await short_timeout_client.connect(
                host="non-existent-host.local", 
                port=12345,
                auth_token=self.auth_token
            )
            
        # Check that the connection failed
        self.assertFalse(short_timeout_client.is_connected())
    
    async def test_reconnect(self):
        """Test automatic reconnection."""
        # Connect to the mock Lua server
        await self.lua_client.connect(auth_token=self.auth_token)
        
        # Force disconnect by closing the socket
        self.lua_client._socket.close()
        self.lua_client._is_connected = False
        
        # Wait for reconnection
        time.sleep(0.5)
        
        # Send a command that should trigger reconnection
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": "return 'After reconnect'"
            },
            "id": "test_command_2"
        }
        
        response_str = await self.lua_client.send_command(json.dumps(command))
        response = json.loads(response_str)
        
        # Check the response
        self.assertEqual(response["status"], "success")
        self.assertTrue(self.lua_client.is_connected())


if __name__ == '__main__':
    unittest.main()
