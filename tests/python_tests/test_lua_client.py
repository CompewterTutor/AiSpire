"""
Test file for the LuaGadgetClient class in the Python MCP Server.

This file contains unit tests for the LuaGadgetClient class which handles
communication with the Lua Gadget component.

Author: AiSpire Team
Version: 0.1.0 (Development)
Date: April 9, 2025
"""

import asyncio
import json
import pytest
import sys
import os
from unittest.mock import AsyncMock, MagicMock, patch

# Add the python_mcp_server directory to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../../python_mcp_server')))

# Import the module to test
from server import LuaGadgetClient


@pytest.fixture
def mock_socket():
    """Create a mock StreamReader and StreamWriter for socket testing."""
    reader = AsyncMock()
    writer = AsyncMock()
    
    return reader, writer


@pytest.fixture
def lua_client_config():
    """Create a test config for the LuaGadgetClient."""
    return {
        "host": "127.0.0.1",
        "port": 9876,
        "auth_token": "test_token",
        "connection_timeout": 1.0,
        "reconnect_attempts": 2,
        "reconnect_delay": 0.1
    }


class TestLuaGadgetClient:
    """Test the LuaGadgetClient class."""
    
    def test_init(self, lua_client_config):
        """Test client initialization."""
        client = LuaGadgetClient(lua_client_config)
        
        assert client.host == lua_client_config["host"]
        assert client.port == lua_client_config["port"]
        assert client.auth_token == lua_client_config["auth_token"]
        assert client.timeout == lua_client_config["connection_timeout"]
        assert client.reconnect_attempts == lua_client_config["reconnect_attempts"]
        assert client.reconnect_delay == lua_client_config["reconnect_delay"]
        assert client.connected is False
        assert client.reader is None
        assert client.writer is None
    
    @pytest.mark.asyncio
    async def test_connect_success(self, lua_client_config, mock_socket):
        """Test successful connection to Lua Gadget."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))) as mock_connect:
            result = await client.connect()
            
            mock_connect.assert_called_once_with(
                lua_client_config["host"],
                lua_client_config["port"]
            )
            assert result is True
            assert client.connected is True
            assert client.reader is reader
            assert client.writer is writer
    
    @pytest.mark.asyncio
    async def test_connect_failure_retry(self, lua_client_config):
        """Test connection failure with retries."""
        client = LuaGadgetClient(lua_client_config)
        
        # Make the connection fail with a ConnectionRefusedError
        with patch('asyncio.open_connection', AsyncMock(side_effect=ConnectionRefusedError())) as mock_connect:
            result = await client.connect()
            
            # Should attempt to connect 'reconnect_attempts' times
            assert mock_connect.call_count == lua_client_config["reconnect_attempts"]
            assert result is False
            assert client.connected is False
            assert client.reader is None
            assert client.writer is None
    
    @pytest.mark.asyncio
    async def test_disconnect(self, lua_client_config, mock_socket):
        """Test disconnection from Lua Gadget."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        # Connect first
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))):
            await client.connect()
        
        await client.disconnect()
        
        writer.close.assert_called_once()
        writer.wait_closed.assert_called_once()
        assert client.connected is False
        assert client.reader is None
        assert client.writer is None
    
    @pytest.mark.asyncio
    async def test_execute_code(self, lua_client_config, mock_socket):
        """Test executing Lua code."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        # Set up mock response
        mock_response = {
            "status": "success",
            "result": {
                "message": "Code executed successfully",
                "data": {"value": 42},
                "type": "code_result"
            },
            "command_id": "test_id",
            "execution_time": 0.001
        }
        reader.readline.return_value = json.dumps(mock_response).encode() + b'\n'
        
        # Connect first
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))):
            await client.connect()
        
        # Execute test code
        test_code = "return {value = 42}"
        result = await client.execute_code(test_code, "test_id")
        
        # Check that the correct command was sent
        expected_command = {
            "command_type": "execute_code",
            "payload": {"code": test_code},
            "id": "test_id",
            "auth": "test_token"
        }
        
        # Get the first call to writer.write and extract the argument
        call_args = writer.write.call_args_list[0][0][0]
        actual_command = json.loads(call_args.decode().strip())
        
        assert actual_command == expected_command
        assert result == mock_response
    
    @pytest.mark.asyncio
    async def test_execute_function(self, lua_client_config, mock_socket):
        """Test executing a Lua function with parameters."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        # Set up mock response
        mock_response = {
            "status": "success",
            "result": {
                "message": "Function executed successfully",
                "data": {"circle": {"center": {"x": 0, "y": 0}, "radius": 10}},
                "type": "function_result"
            },
            "command_id": "test_id",
            "execution_time": 0.002
        }
        reader.readline.return_value = json.dumps(mock_response).encode() + b'\n'
        
        # Connect first
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))):
            await client.connect()
        
        # Execute test function
        test_function = "createCircle"
        test_params = {"x": 0, "y": 0, "radius": 10}
        result = await client.execute_function(test_function, test_params, "test_id")
        
        # Check that the correct command was sent
        expected_command = {
            "command_type": "execute_function",
            "payload": {
                "function": test_function,
                "parameters": test_params
            },
            "id": "test_id",
            "auth": "test_token"
        }
        
        # Get the first call to writer.write and extract the argument
        call_args = writer.write.call_args_list[0][0][0]
        actual_command = json.loads(call_args.decode().strip())
        
        assert actual_command == expected_command
        assert result == mock_response
    
    @pytest.mark.asyncio
    async def test_not_connected(self, lua_client_config):
        """Test behaviour when not connected."""
        client = LuaGadgetClient(lua_client_config)
        
        # Try to execute code without connecting
        with patch('server.LuaGadgetClient.connect', AsyncMock(return_value=False)):
            result = await client.execute_code("return 42", "test_id")
        
        # Should return an error
        assert result["status"] == "error"
        assert "Not connected to Lua Gadget" in result["result"]["message"]
        assert result["result"]["type"] == "connection_error"
    
    @pytest.mark.asyncio
    async def test_connection_closed(self, lua_client_config, mock_socket):
        """Test handling of closed connections."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        # Make readline return empty (signifying closed connection)
        reader.readline.return_value = b''
        
        # Connect first
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))):
            await client.connect()
        
        # Try to execute code
        result = await client.execute_code("return 42", "test_id")
        
        # Should return an error and set connected to False
        assert result["status"] == "error"
        assert "Connection closed" in result["result"]["message"]
        assert result["result"]["type"] == "connection_error"
        assert not client.connected
    
    @pytest.mark.asyncio
    async def test_invalid_json_response(self, lua_client_config, mock_socket):
        """Test handling of invalid JSON responses."""
        reader, writer = mock_socket
        client = LuaGadgetClient(lua_client_config)
        
        # Make readline return invalid JSON
        reader.readline.return_value = b'not valid json\n'
        
        # Connect first
        with patch('asyncio.open_connection', AsyncMock(return_value=(reader, writer))):
            await client.connect()
        
        # Try to execute code
        result = await client.execute_code("return 42", "test_id")
        
        # Should return a parsing error
        assert result["status"] == "error"
        assert "Invalid JSON response" in result["result"]["message"]
        assert result["result"]["type"] == "parsing_error"