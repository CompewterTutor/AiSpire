"""
Official MCP Server implementation for AiSpire using the Model Context Protocol Python SDK.

This module implements an MCP server using the official Python SDK that connects
to the Lua Gadget and exposes its functionality through MCP tools.
"""

import asyncio
import logging
import os
import sys
from typing import Dict, Any, Optional, List, Union
import json
from pathlib import Path

# Add parent directory to path to import from python_mcp_server
parent_dir = str(Path(__file__).parent.parent)
if parent_dir not in sys.path:
    sys.path.append(parent_dir)

# Import from the official MCP SDK
from mcp.server.fastmcp import FastMCP
from mcp.server.resources import Resource

# Import from existing AiSpire modules
from python_mcp_server.socket_client import LuaSocketClient
from python_mcp_server.config import load_config
from python_mcp_server.metrics import initialize_metrics, get_metrics

# Import our resources implementation
from resources import VectricJobResource

# Configure logging
logger = logging.getLogger("aispire_official_mcp")
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

class AiSpireMCPServer:
    """
    Official MCP Server implementation for AiSpire using the Model Context Protocol Python SDK.
    
    This class integrates the official MCP SDK with the existing AiSpire Lua Gadget.
    """
    
    def __init__(self, config_path: Optional[str] = None):
        """
        Initialize the AiSpire MCP Server.
        
        Args:
            config_path: Optional path to a configuration file
        """
        # Load configuration
        self.config = load_config(config_path)
        
        # Initialize metrics
        metrics_config = self.config.get("metrics", {})
        if metrics_config.get("enabled", True):
            self.metrics = initialize_metrics(metrics_config)
            logger.info(f"Metrics system initialized (enabled: {self.metrics.enabled})")
        else:
            self.metrics = None
            logger.info("Metrics system disabled")
        
        # Initialize Lua socket client
        lua_config = self.config.get("lua_gadget", {})
        self.lua_client = LuaSocketClient(
            host=lua_config.get("host", "localhost"),
            port=lua_config.get("port", 9876),
            connect_timeout=lua_config.get("connection_timeout", 5.0)
        )
        
        # Initialize FastMCP server
        mcp_config = self.config.get("mcp_server", {})
        self.mcp = FastMCP(
            "aispire",
            description="AiSpire MCP Server for controlling Vectric Aspire/V-Carve via the Lua Gadget",
        )
        
        # Register tools with FastMCP
        self._register_tools()
        
        # Register resources with FastMCP
        self._register_resources()
        
        # Server instance
        self.server = None
        self.running = False
    
    def _register_resources(self) -> None:
        """Register all resources with the FastMCP server."""
        # Register job resource
        job_resource = VectricJobResource(
            self.lua_client, 
            self.config.get("lua_gadget", {}).get("auth_token", "")
        )
        self.mcp.register_resource_handler("vectric://job", job_resource)
        logger.info("Registered Vectric job resources")
    
    def _register_tools(self) -> None:
        """Register all tools with the FastMCP server."""
        # Register the execute_code tool
        @self.mcp.tool("execute_code")
        async def execute_code(code: str) -> Dict[str, Any]:
            """
            Execute raw Lua code in the Vectric environment.
            
            Args:
                code: Lua code to execute
            
            Returns:
                Result of the execution
            """
            command_id = f"execute_code_{id(code)}"
            
            try:
                # Ensure connected to Lua Gadget
                if not self.lua_client.is_connected():
                    await self.lua_client.connect(
                        auth_token=self.config.get("lua_gadget", {}).get("auth_token")
                    )
                
                # Send command to Lua Gadget
                command = {
                    "command_type": "execute_code",
                    "payload": {
                        "code": code
                    },
                    "id": command_id,
                    "auth": self.config.get("lua_gadget", {}).get("auth_token")
                }
                
                start_time = asyncio.get_event_loop().time()
                response_json = await self.lua_client.send_command(command)
                end_time = asyncio.get_event_loop().time()
                
                # Record metrics
                if self.metrics:
                    self.metrics.record_request_latency((end_time - start_time) * 1000)
                
                # Parse response
                response = json.loads(response_json)
                
                # Record execution time and errors if available
                if self.metrics:
                    if "execution_time" in response:
                        self.metrics.record_execution_time(response["execution_time"])
                    if response.get("status") == "error":
                        self.metrics.record_error(
                            response.get("result", {}).get("type", "unknown_error")
                        )
                
                return response["result"]
            except Exception as e:
                logger.error(f"Error executing Lua code: {str(e)}")
                # Record error in metrics
                if self.metrics:
                    self.metrics.record_error("execution_error")
                return {
                    "message": f"Failed to execute code: {str(e)}",
                    "data": {},
                    "type": "execution_error"
                }
        
        # Query state tool - gets the current state of the Vectric environment
        @self.mcp.tool("query_state")
        async def query_state() -> Dict[str, Any]:
            """
            Query the current state of the Vectric environment.
            
            Returns:
                Current state information
            """
            command_id = f"query_state_{id(object())}"
            
            try:
                # Ensure connected to Lua Gadget
                if not self.lua_client.is_connected():
                    await self.lua_client.connect(
                        auth_token=self.config.get("lua_gadget", {}).get("auth_token")
                    )
                
                # Send command to Lua Gadget
                command = {
                    "command_type": "query_state",
                    "payload": {},
                    "id": command_id,
                    "auth": self.config.get("lua_gadget", {}).get("auth_token")
                }
                
                start_time = asyncio.get_event_loop().time()
                response_json = await self.lua_client.send_command(command)
                end_time = asyncio.get_event_loop().time()
                
                # Record metrics
                if self.metrics:
                    self.metrics.record_request_latency((end_time - start_time) * 1000)
                
                # Parse response
                response = json.loads(response_json)
                
                # Record errors if any
                if self.metrics and response.get("status") == "error":
                    self.metrics.record_error(
                        response.get("result", {}).get("type", "unknown_error")
                    )
                
                return response["result"]
            except Exception as e:
                logger.error(f"Error querying state: {str(e)}")
                # Record error in metrics
                if self.metrics:
                    self.metrics.record_error("state_query_error")
                return {
                    "message": f"Failed to query state: {str(e)}",
                    "data": {},
                    "type": "state_query_error"
                }
        
        # Create vector tool
        @self.mcp.tool("create_vector")
        async def create_vector(vector_type: str, params: Dict[str, Any], layer_name: Optional[str] = None) -> Dict[str, Any]:
            """
            Create a vector in the Vectric environment.
            
            Args:
                vector_type: Type of vector to create (circle, rectangle, polyline, text)
                params: Parameters for the vector
                layer_name: Optional name of the layer to add the vector to
            
            Returns:
                Result of the vector creation
            """
            command_id = f"create_vector_{id(object())}"
            
            # Validate vector type
            valid_vector_types = ["circle", "rectangle", "polyline", "text"]
            if vector_type not in valid_vector_types:
                return {
                    "message": f"Invalid vector type: {vector_type}. Must be one of: {', '.join(valid_vector_types)}",
                    "data": {},
                    "type": "invalid_parameter"
                }
            
            # Generate Lua code based on vector type
            lua_code = "local result = {}\n"
            
            # Add layer handling
            if layer_name:
                lua_code += f"""
                -- Find or create the layer
                local layer = nil
                local all_layers = Job.GetAllLayers()
                for i, l in ipairs(all_layers) do
                    if l:GetName() == "{layer_name}" then
                        layer = l
                        break
                    end
                end
                
                if not layer then
                    layer = Job.AddLayer("{layer_name}")
                    if not layer then
                        return {{
                            error = "Failed to create layer '{layer_name}'",
                            success = false
                        }}
                    end
                end
                """
            else:
                lua_code += """
                -- Use active layer
                local layer = Job.GetActiveLayer()
                if not layer then
                    return {
                        error = "No active layer available",
                        success = false
                    }
                end
                """
            
            # Generate vector creation code based on type
            if vector_type == "circle":
                # Expected params: x, y, radius
                x = params.get("x", 0)
                y = params.get("y", 0)
                radius = params.get("radius", 1)
                
                lua_code += f"""
                -- Create circle
                local circle = Object.CreateCircle({x}, {y}, {radius})
                if not circle then
                    return {{
                        error = "Failed to create circle",
                        success = false
                    }}
                end
                
                -- Add to layer
                layer:AddObject(circle)
                
                result = {{
                    success = true,
                    object_type = "circle",
                    id = circle:GetId(),
                    x = {x},
                    y = {y},
                    radius = {radius}
                }}
                """
            
            elif vector_type == "rectangle":
                # Expected params: x, y, width, height
                x = params.get("x", 0)
                y = params.get("y", 0)
                width = params.get("width", 1)
                height = params.get("height", 1)
                
                lua_code += f"""
                -- Create rectangle
                local rect = Object.CreateRectangle({x}, {y}, {width}, {height})
                if not rect then
                    return {{
                        error = "Failed to create rectangle",
                        success = false
                    }}
                end
                
                -- Add to layer
                layer:AddObject(rect)
                
                result = {{
                    success = true,
                    object_type = "rectangle",
                    id = rect:GetId(),
                    x = {x},
                    y = {y},
                    width = {width},
                    height = {height}
                }}
                """
                
            elif vector_type == "polyline":
                # Expected params: points (array of [x,y] coordinates)
                points = params.get("points", [])
                
                if not points or len(points) < 2:
                    return {
                        "message": "Polyline requires at least 2 points",
                        "data": {},
                        "type": "invalid_parameter"
                    }
                
                # Convert points to Lua array initialization
                points_lua = "{\n"
                for point in points:
                    if isinstance(point, list) and len(point) >= 2:
                        points_lua += f"    {{{point[0]}, {point[1]}}},\n"
                points_lua += "}"
                
                lua_code += f"""
                -- Points for polyline
                local points = {points_lua}
                
                -- Create polyline
                local polyline = Object.CreatePolyline(points)
                if not polyline then
                    return {{
                        error = "Failed to create polyline",
                        success = false
                    }}
                end
                
                -- Add to layer
                layer:AddObject(polyline)
                
                result = {{
                    success = true,
                    object_type = "polyline",
                    id = polyline:GetId(),
                    point_count = #{len(points)}
                }}
                """
                
            elif vector_type == "text":
                # Expected params: text, x, y, height, font
                text = params.get("text", "")
                x = params.get("x", 0)
                y = params.get("y", 0)
                height = params.get("height", 1)
                font = params.get("font", "Arial")
                
                # Escape quotes in text
                text = text.replace('"', '\\"')
                
                lua_code += f"""
                -- Create text
                local textObj = Object.CreateText("{text}", {x}, {y}, {height}, "{font}")
                if not textObj then
                    return {{
                        error = "Failed to create text",
                        success = false
                    }}
                end
                
                -- Add to layer
                layer:AddObject(textObj)
                
                result = {{
                    success = true,
                    object_type = "text",
                    id = textObj:GetId(),
                    text = "{text}",
                    x = {x},
                    y = {y},
                    height = {height},
                    font = "{font}"
                }}
                """
            
            # Return result
            lua_code += "\nreturn result"
            
            try:
                # Ensure connected to Lua Gadget
                if not self.lua_client.is_connected():
                    await self.lua_client.connect(
                        auth_token=self.config.get("lua_gadget", {}).get("auth_token")
                    )
                
                # Send command to Lua Gadget
                command = {
                    "command_type": "execute_code",
                    "payload": {
                        "code": lua_code
                    },
                    "id": command_id,
                    "auth": self.config.get("lua_gadget", {}).get("auth_token")
                }
                
                start_time = asyncio.get_event_loop().time()
                response_json = await self.lua_client.send_command(command)
                end_time = asyncio.get_event_loop().time()
                
                # Record metrics
                if self.metrics:
                    self.metrics.record_request_latency((end_time - start_time) * 1000)
                
                # Parse response
                response = json.loads(response_json)
                
                # Record execution time and errors if available
                if self.metrics:
                    if "execution_time" in response:
                        self.metrics.record_execution_time(response["execution_time"])
                    if response.get("status") == "error":
                        self.metrics.record_error(
                            response.get("result", {}).get("type", "unknown_error")
                        )
                
                return response["result"]
            except Exception as e:
                logger.error(f"Error creating vector: {str(e)}")
                # Record error in metrics
                if self.metrics:
                    self.metrics.record_error("vector_creation_error")
                return {
                    "message": f"Failed to create vector: {str(e)}",
                    "data": {},
                    "type": "vector_creation_error"
                }
        
        # Create toolpath tool
        @self.mcp.tool("create_toolpath")
        async def create_toolpath(
            toolpath_type: str, 
            vector_ids: List[str], 
            tool_name: str, 
            params: Dict[str, Any] = None
        ) -> Dict[str, Any]:
            """
            Create a toolpath from vectors in the Vectric environment.
            
            Args:
                toolpath_type: Type of toolpath (profile, pocket, drilling)
                vector_ids: List of vector IDs to use for toolpath
                tool_name: Name of the tool to use
                params: Optional parameters for toolpath creation
            
            Returns:
                Result of the toolpath creation
            """
            command_id = f"create_toolpath_{id(object())}"
            params = params or {}
            
            # Validate toolpath type
            valid_toolpath_types = ["profile", "pocket", "drilling"]
            if toolpath_type not in valid_toolpath_types:
                return {
                    "message": f"Invalid toolpath type: {toolpath_type}. Must be one of: {', '.join(valid_toolpath_types)}",
                    "data": {},
                    "type": "invalid_parameter"
                }
            
            # Generate Lua code for toolpath creation
            lua_code = """
            local result = {}
            
            -- Function to get vector by ID
            local function get_vector_by_id(id)
                local all_layers = Job.GetAllLayers()
                for i, layer in ipairs(all_layers) do
                    local objects = layer:GetAllObjects()
                    for j, obj in ipairs(objects) do
                        if obj:GetId() == id then
                            return obj
                        end
                    end
                end
                return nil
            end
            
            -- Get tools
            local tool = nil
            local all_tools = Job.GetAllTools()
            for i, t in ipairs(all_tools) do
                if t:GetName() == "%s" then
                    tool = t
                    break
                end
            end
            
            if not tool then
                return {
                    error = "Tool not found: %s",
                    success = false
                }
            end
            
            -- Collect all requested vectors
            local vectors = {}
            """ % (tool_name, tool_name)
            
            # Add vector IDs to retrieve
            for vector_id in vector_ids:
                lua_code += f"""
                local v_{vector_id} = get_vector_by_id("{vector_id}")
                if v_{vector_id} then
                    table.insert(vectors, v_{vector_id})
                else
                    table.insert(result, "Vector not found: {vector_id}")
                end
                """
            
            lua_code += """
            -- Validate we have at least one vector
            if #vectors == 0 then
                return {
                    error = "No valid vectors found for toolpath",
                    success = false
                }
            end
            """
            
            # Generate toolpath based on type
            if toolpath_type == "profile":
                # Add profile toolpath parameters
                machine_vectors = params.get("machine_vectors", "outside")
                if machine_vectors not in ["inside", "outside", "on"]:
                    machine_vectors = "outside"
                
                start_depth = params.get("start_depth", 0)
                cut_depth = params.get("cut_depth", 1)
                
                lua_code += f"""
                -- Create profile toolpath
                local toolpath = Job.CreateProfileToolpath("Profile Toolpath", tool)
                if not toolpath then
                    return {{
                        error = "Failed to create profile toolpath",
                        success = false
                    }}
                end
                
                -- Set parameters
                toolpath:SetMachineVectors("{machine_vectors}")
                toolpath:SetStartDepth({start_depth})
                toolpath:SetCutDepth({cut_depth})
                
                -- Add vectors to toolpath
                local valid_vectors = 0
                for i, vector in ipairs(vectors) do
                    if toolpath:AddVector(vector) then
                        valid_vectors = valid_vectors + 1
                    end
                end
                
                if valid_vectors == 0 then
                    return {{
                        error = "Failed to add any vectors to toolpath",
                        success = false
                    }}
                end
                
                -- Calculate toolpath
                if not toolpath:Calculate() then
                    return {{
                        error = "Failed to calculate toolpath",
                        success = false
                    }}
                end
                
                return {{
                    success = true,
                    toolpath_type = "profile",
                    toolpath_id = toolpath:GetId(),
                    tool_name = "{tool_name}",
                    vector_count = valid_vectors
                }}
                """
                
            elif toolpath_type == "pocket":
                # Add pocket toolpath parameters
                start_depth = params.get("start_depth", 0)
                cut_depth = params.get("cut_depth", 1)
                
                lua_code += f"""
                -- Create pocket toolpath
                local toolpath = Job.CreatePocketToolpath("Pocket Toolpath", tool)
                if not toolpath then
                    return {{
                        error = "Failed to create pocket toolpath",
                        success = false
                    }}
                end
                
                -- Set parameters
                toolpath:SetStartDepth({start_depth})
                toolpath:SetCutDepth({cut_depth})
                
                -- Add vectors to toolpath
                local valid_vectors = 0
                for i, vector in ipairs(vectors) do
                    if toolpath:AddVector(vector) then
                        valid_vectors = valid_vectors + 1
                    end
                end
                
                if valid_vectors == 0 then
                    return {{
                        error = "Failed to add any vectors to toolpath",
                        success = false
                    }}
                end
                
                -- Calculate toolpath
                if not toolpath:Calculate() then
                    return {{
                        error = "Failed to calculate toolpath",
                        success = false
                    }}
                end
                
                return {{
                    success = true,
                    toolpath_type = "pocket",
                    toolpath_id = toolpath:GetId(),
                    tool_name = "{tool_name}",
                    vector_count = valid_vectors
                }}
                """
            
            elif toolpath_type == "drilling":
                # Add drilling toolpath parameters
                start_depth = params.get("start_depth", 0)
                cut_depth = params.get("cut_depth", 1)
                
                lua_code += f"""
                -- Create drilling toolpath
                local toolpath = Job.CreateDrillingToolpath("Drilling Toolpath", tool)
                if not toolpath then
                    return {{
                        error = "Failed to create drilling toolpath",
                        success = false
                    }}
                end
                
                -- Set parameters
                toolpath:SetStartDepth({start_depth})
                toolpath:SetCutDepth({cut_depth})
                
                -- Add vectors to toolpath
                local valid_vectors = 0
                for i, vector in ipairs(vectors) do
                    if toolpath:AddVector(vector) then
                        valid_vectors = valid_vectors + 1
                    end
                end
                
                if valid_vectors == 0 then
                    return {{
                        error = "Failed to add any vectors to toolpath",
                        success = false
                    }}
                end
                
                -- Calculate toolpath
                if not toolpath:Calculate() then
                    return {{
                        error = "Failed to calculate toolpath",
                        success = false
                    }}
                end
                
                return {{
                    success = true,
                    toolpath_type = "drilling",
                    toolpath_id = toolpath:GetId(),
                    tool_name = "{tool_name}",
                    vector_count = valid_vectors
                }}
                """
            
            try:
                # Ensure connected to Lua Gadget
                if not self.lua_client.is_connected():
                    await self.lua_client.connect(
                        auth_token=self.config.get("lua_gadget", {}).get("auth_token")
                    )
                
                # Send command to Lua Gadget
                command = {
                    "command_type": "execute_code",
                    "payload": {
                        "code": lua_code
                    },
                    "id": command_id,
                    "auth": self.config.get("lua_gadget", {}).get("auth_token")
                }
                
                start_time = asyncio.get_event_loop().time()
                response_json = await self.lua_client.send_command(command)
                end_time = asyncio.get_event_loop().time()
                
                # Record metrics
                if self.metrics:
                    self.metrics.record_request_latency((end_time - start_time) * 1000)
                
                # Parse response
                response = json.loads(response_json)
                
                # Record execution time and errors if available
                if self.metrics:
                    if "execution_time" in response:
                        self.metrics.record_execution_time(response["execution_time"])
                    if response.get("status") == "error":
                        self.metrics.record_error(
                            response.get("result", {}).get("type", "unknown_error")
                        )
                
                return response["result"]
            except Exception as e:
                logger.error(f"Error creating toolpath: {str(e)}")
                # Record error in metrics
                if self.metrics:
                    self.metrics.record_error("toolpath_creation_error")
                return {
                    "message": f"Failed to create toolpath: {str(e)}",
                    "data": {},
                    "type": "toolpath_creation_error"
                }
    
    async def start(self) -> None:
        """Start the MCP server and connect to the Lua gadget."""
        try:
            # Connect to Lua Gadget
            logger.info("Connecting to Lua Gadget...")
            await self.lua_client.connect(
                host=self.config.get("lua_gadget", {}).get("host"),
                port=self.config.get("lua_gadget", {}).get("port"),
                auth_token=self.config.get("lua_gadget", {}).get("auth_token")
            )
            
            # Set up server parameters
            mcp_config = self.config.get("mcp_server", {})
            host = mcp_config.get("host", "localhost")
            port = mcp_config.get("port", 8765)
            
            # Start the MCP server
            logger.info(f"Starting MCP Server on {host}:{port}")
            self.server = await self.mcp.start_server(host=host, port=port)
            self.running = True
            
            logger.info(f"MCP Server started successfully on {host}:{port}")
            
            # Keep server running until stopped
            while self.running:
                await asyncio.sleep(1)
                
        except Exception as e:
            logger.error(f"Failed to start MCP server: {str(e)}")
            self.running = False
            raise
    
    async def stop(self) -> None:
        """Stop the MCP server and disconnect from the Lua gadget."""
        logger.info("Stopping MCP Server...")
        self.running = False
        
        # Disconnect from Lua Gadget
        await self.lua_client.disconnect()
        
        # Stop MCP server
        if self.server:
            await self.server.shutdown()
            self.server = None
        
        # Shutdown metrics
        if self.metrics:
            self.metrics.shutdown()
        
        logger.info("MCP Server stopped")


async def main() -> None:
    """Main function to start the AiSpire MCP Server."""
    config_path = os.environ.get("AISPIRE_CONFIG_PATH")
    server = AiSpireMCPServer(config_path)
    
    try:
        await server.start()
    except asyncio.CancelledError:
        logger.info("Server shutdown requested")
    except Exception as e:
        logger.error(f"Server error: {str(e)}")
    finally:
        await server.stop()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Server stopped by user")