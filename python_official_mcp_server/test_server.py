#!/usr/bin/env python3
"""
Test script for the AiSpire Official MCP Server.

This script provides a way to test the official MCP server implementation
and its tools without requiring a real Lua Gadget connection.
"""

import asyncio
import json
import logging
import os
import sys
from pathlib import Path
from typing import Dict, Any, Optional, List
from unittest.mock import AsyncMock, MagicMock

# Add parent directory to path to import from python_mcp_server
parent_dir = str(Path(__file__).parent.parent)
if parent_dir not in sys.path:
    sys.path.append(parent_dir)

from server import AiSpireMCPServer
from python_mcp_server.socket_client import LuaSocketClient

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("aispire_test_mcp")


class MockLuaSocketClient:
    """Mock implementation of the LuaSocketClient for testing."""
    
    def __init__(self):
        """Initialize the mock client."""
        self.connect_called = False
        self.disconnect_called = False
        self.auth_token = None
        self.commands = []
        self._is_connected = False
        
        # Set up mock responses
        self.responses = {
            "execute_code": {
                "status": "success",
                "result": {
                    "data": {"value": 42},
                    "message": "Code executed successfully"
                },
                "execution_time": 10
            },
            "query_state": {
                "status": "success",
                "result": {
                    "data": {
                        "job_name": "Test Job",
                        "is_saved": False,
                        "job_path": "/path/to/test_job.crv",
                        "units": "mm",
                        "width": 100,
                        "height": 100,
                        "thickness": 10
                    },
                    "message": "State queried successfully"
                },
                "execution_time": 5
            },
            "create_vector": {
                "status": "success",
                "result": {
                    "success": True,
                    "object_type": "circle",
                    "id": "mock-vector-id-123",
                    "x": 50,
                    "y": 50,
                    "radius": 25
                },
                "execution_time": 15
            },
            "create_toolpath": {
                "status": "success",
                "result": {
                    "success": True,
                    "toolpath_type": "profile",
                    "toolpath_id": "mock-toolpath-id-456",
                    "tool_name": "End Mill",
                    "vector_count": 1
                },
                "execution_time": 20
            }
        }
    
    async def connect(self, host: Optional[str] = None, port: Optional[int] = None, auth_token: Optional[str] = None) -> bool:
        """Mock connection to the Lua server."""
        self.connect_called = True
        self._is_connected = True
        self.auth_token = auth_token
        logger.info(f"MockLuaSocketClient: Connected to {host}:{port} with auth token {auth_token}")
        return True
    
    async def disconnect(self) -> None:
        """Mock disconnection from the Lua server."""
        self.disconnect_called = True
        self._is_connected = False
        logger.info("MockLuaSocketClient: Disconnected")
    
    def is_connected(self) -> bool:
        """Mock check if connected to the Lua server."""
        return self._is_connected
    
    async def send_command(self, command: Dict[str, Any]) -> str:
        """Mock sending a command to the Lua server."""
        self.commands.append(command)
        
        # Determine the type of command and return appropriate mock response
        command_type = command.get("command_type")
        
        if command_type == "execute_code":
            code = command.get("payload", {}).get("code", "")
            
            # Check if it's a specific tool command based on the code content
            if "CreateCircle" in code:
                return json.dumps(self.responses["create_vector"])
            elif "CreateProfileToolpath" in code or "CreatePocketToolpath" in code or "CreateDrillingToolpath" in code:
                return json.dumps(self.responses["create_toolpath"])
            else:
                return json.dumps(self.responses["execute_code"])
                
        elif command_type == "query_state":
            return json.dumps(self.responses["query_state"])
            
        else:
            # Default response
            return json.dumps({
                "status": "success",
                "result": {
                    "message": f"Command {command_type} executed successfully",
                    "data": {}
                },
                "execution_time": 5
            })


async def test_official_mcp_server():
    """Test the official MCP server implementation."""
    # Create mock Lua socket client
    mock_client = MockLuaSocketClient()
    
    # Create the MCP server with mocked client
    server = AiSpireMCPServer()
    server.lua_client = mock_client
    
    try:
        # Start the server (this will be non-blocking in test mode)
        server_task = asyncio.create_task(server.start())
        
        # Wait a bit for the server to start
        await asyncio.sleep(1)
        
        logger.info("MCP Server started successfully")
        logger.info("Server capabilities:")
        for tool_name, tool_info in server.mcp.tools.items():
            logger.info(f"  - Tool: {tool_name}")

        logger.info("Resources:")
        for handler_name in server.mcp.resource_handlers.keys():
            logger.info(f"  - Resource: {handler_name}")
        
        # Test is successful if we get here without errors
        logger.info("Test completed successfully")
        
    except Exception as e:
        logger.error(f"Test failed: {str(e)}")
        raise
    finally:
        # Stop the server
        await server.stop()
        
        # Cancel the server task
        if server_task and not server_task.done():
            server_task.cancel()
            try:
                await server_task
            except asyncio.CancelledError:
                pass
        
        logger.info("Server stopped")


if __name__ == "__main__":
    try:
        # Set test environment
        os.environ["AISPIRE_MCP_PORT"] = "8767"  # Use a different port for testing
        
        # Run the test
        asyncio.run(test_official_mcp_server())
    except KeyboardInterrupt:
        logger.info("Test stopped by user")
    except Exception as e:
        logger.error(f"Test error: {str(e)}")
        sys.exit(1)