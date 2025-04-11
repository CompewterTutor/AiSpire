#!/usr/bin/env python3
"""
Example client for the AiSpire Official MCP Server.

This script demonstrates how to connect to the MCP server using the official
MCP client SDK and use the available tools and resources.
"""

import asyncio
import logging
import os
import sys
from pathlib import Path
from typing import Dict, Any, List

# Import the official MCP client SDK
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("aispire_client_example")


class AiSpireMCPClient:
    """Example client for the AiSpire MCP Server."""
    
    def __init__(self, port: int = 8765):
        """
        Initialize the client.
        
        Args:
            port: Port number of the MCP server
        """
        self.port = port
        self.session = None
    
    async def connect(self):
        """Connect to the MCP server."""
        logger.info(f"Connecting to MCP server on port {self.port}...")
        
        # Create a client session
        self.session = ClientSession()
        
        # Connect to the server
        await self.session.connect_to_tcp_server("localhost", self.port)
        
        # Get server capabilities
        capabilities = await self.session.handshake()
        logger.info(f"Connected to server: {capabilities.name}")
        logger.info(f"Server description: {capabilities.description}")
        logger.info(f"Available tools: {[tool.name for tool in capabilities.tools]}")
        logger.info(f"Available resources: {[resource.uri_scheme for resource in capabilities.resources]}")
        
        return capabilities
    
    async def disconnect(self):
        """Disconnect from the MCP server."""
        if self.session:
            await self.session.close()
            logger.info("Disconnected from MCP server")
    
    async def execute_lua_code(self, code: str):
        """
        Execute Lua code on the server.
        
        Args:
            code: Lua code to execute
            
        Returns:
            Result of the execution
        """
        if not self.session:
            raise RuntimeError("Not connected to MCP server")
        
        logger.info(f"Executing Lua code: {code[:50]}...")
        result = await self.session.execute_tool("execute_code", {"code": code})
        return result
    
    async def query_state(self):
        """
        Query the state of the Vectric application.
        
        Returns:
            Current state information
        """
        if not self.session:
            raise RuntimeError("Not connected to MCP server")
        
        logger.info("Querying application state...")
        result = await self.session.execute_tool("query_state", {})
        return result
    
    async def create_vector(self, vector_type: str, params: Dict[str, Any], layer_name: str = None):
        """
        Create a vector in the Vectric application.
        
        Args:
            vector_type: Type of vector (circle, rectangle, polyline, text)
            params: Parameters for the vector
            layer_name: Optional layer name
            
        Returns:
            Result of the vector creation
        """
        if not self.session:
            raise RuntimeError("Not connected to MCP server")
        
        logger.info(f"Creating {vector_type} vector...")
        
        # Build parameters
        tool_params = {
            "vector_type": vector_type,
            "params": params
        }
        
        if layer_name:
            tool_params["layer_name"] = layer_name
        
        # Execute the tool
        result = await self.session.execute_tool("create_vector", tool_params)
        return result
    
    async def create_toolpath(self, toolpath_type: str, vector_ids: List[str], tool_name: str, params: Dict[str, Any] = None):
        """
        Create a toolpath in the Vectric application.
        
        Args:
            toolpath_type: Type of toolpath (profile, pocket, drilling)
            vector_ids: List of vector IDs to use
            tool_name: Name of the tool to use
            params: Optional parameters for the toolpath
            
        Returns:
            Result of the toolpath creation
        """
        if not self.session:
            raise RuntimeError("Not connected to MCP server")
        
        logger.info(f"Creating {toolpath_type} toolpath...")
        
        # Build parameters
        tool_params = {
            "toolpath_type": toolpath_type,
            "vector_ids": vector_ids,
            "tool_name": tool_name
        }
        
        if params:
            tool_params["params"] = params
        
        # Execute the tool
        result = await self.session.execute_tool("create_toolpath", tool_params)
        return result
    
    async def get_job_resources(self):
        """
        Get available job resources.
        
        Returns:
            Dictionary of resource information
        """
        if not self.session:
            raise RuntimeError("Not connected to MCP server")
        
        logger.info("Getting job resources...")
        
        # List available resources
        resources = await self.session.list_resources("vectric://job")
        
        results = {}
        for resource in resources:
            # Get the resource content
            content = await self.session.read_resource(resource.uri)
            results[resource.uri] = content
        
        return results


async def run_example():
    """Run the client example."""
    # Create the client
    port = int(os.environ.get("AISPIRE_MCP_PORT", "8765"))
    client = AiSpireMCPClient(port)
    
    try:
        # Connect to the server
        await client.connect()
        
        # Execute a simple Lua code example
        result = await client.execute_lua_code("""
            -- Get job information
            local job_name = Job.GetName()
            local units = Job.GetUnits()
            
            -- Return the information
            return {
                job_name = job_name,
                units = units
            }
        """)
        logger.info(f"Lua code execution result: {result}")
        
        # Query the application state
        state = await client.query_state()
        logger.info(f"Application state: {state}")
        
        # Create a circle vector
        circle_result = await client.create_vector("circle", {
            "x": 50,
            "y": 50,
            "radius": 25
        }, layer_name="MCP Example")
        logger.info(f"Circle creation result: {circle_result}")
        
        # If we got a valid vector ID, create a toolpath
        if "id" in circle_result:
            vector_id = circle_result["id"]
            toolpath_result = await client.create_toolpath(
                "profile",
                [vector_id],
                "End Mill",
                {
                    "machine_vectors": "outside",
                    "start_depth": 0,
                    "cut_depth": 5
                }
            )
            logger.info(f"Toolpath creation result: {toolpath_result}")
        
        # Get job resources
        job_resources = await client.get_job_resources()
        for uri, content in job_resources.items():
            logger.info(f"Resource {uri}: {content}")
            
        logger.info("Example completed successfully")
        
    finally:
        # Disconnect from the server
        await client.disconnect()


if __name__ == "__main__":
    try:
        asyncio.run(run_example())
    except KeyboardInterrupt:
        logger.info("Example stopped by user")
    except Exception as e:
        logger.error(f"Example error: {str(e)}")
        sys.exit(1)