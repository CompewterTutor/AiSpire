"""
Resource definitions for the AiSpire Official MCP Server.

This module defines MCP resources that expose Vectric data to clients.
"""

import asyncio
import json
import logging
from typing import Dict, Any, List, Optional, Tuple
from pathlib import Path

from mcp.server.resources import Resource, ResourceWithContent, TextContent

# Import from our existing modules
from python_mcp_server.socket_client import LuaSocketClient

logger = logging.getLogger("aispire_official_mcp.resources")

class VectricJobResource(Resource):
    """Resource for accessing Vectric job data."""
    
    def __init__(self, lua_client: LuaSocketClient, auth_token: str):
        """
        Initialize the Vectric job resource.
        
        Args:
            lua_client: Client for communicating with the Lua Gadget
            auth_token: Authentication token for the Lua server
        """
        self.lua_client = lua_client
        self.auth_token = auth_token
        self.job_info = {}
    
    async def list_resources(self) -> List[Dict[str, Any]]:
        """
        List available job resources.
        
        Returns:
            List of resource descriptors
        """
        # Try to get current job information
        await self._update_job_info()
        
        resources = []
        
        # Add job info resource
        resources.append({
            "uri": "vectric://job/info",
            "name": "Job Information",
            "description": "Basic information about the current job",
            "content_type": "text/plain"
        })
        
        # Add layers resource
        resources.append({
            "uri": "vectric://job/layers",
            "name": "Layers",
            "description": "Information about layers in the current job",
            "content_type": "text/plain"
        })
        
        # Add toolpaths resource
        resources.append({
            "uri": "vectric://job/toolpaths",
            "name": "Toolpaths",
            "description": "Information about toolpaths in the current job",
            "content_type": "text/plain"
        })
        
        # Add vectors resource
        resources.append({
            "uri": "vectric://job/vectors",
            "name": "Vectors",
            "description": "Information about vectors in the current job",
            "content_type": "text/plain"
        })
        
        # Add models resource if available
        try:
            if self.job_info.get("has_models", False):
                resources.append({
                    "uri": "vectric://job/models",
                    "name": "Models",
                    "description": "Information about 3D models in the current job",
                    "content_type": "text/plain"
                })
        except (KeyError, AttributeError):
            # No model info available
            pass
        
        return resources
    
    async def read_resource(self, uri: str) -> ResourceWithContent:
        """
        Read the content of a resource.
        
        Args:
            uri: Resource URI
            
        Returns:
            Resource content
            
        Raises:
            ValueError: If the resource is not found
        """
        # Ensure we have up-to-date job info
        await self._update_job_info()
        
        # Handle different resource types
        if uri == "vectric://job/info":
            return ResourceWithContent(
                uri=uri,
                name="Job Information",
                description="Basic information about the current job",
                contents=[TextContent(text=json.dumps(self.job_info, indent=2))]
            )
        elif uri == "vectric://job/layers":
            layers = await self._get_layers()
            return ResourceWithContent(
                uri=uri,
                name="Layers",
                description="Information about layers in the current job",
                contents=[TextContent(text=json.dumps(layers, indent=2))]
            )
        elif uri == "vectric://job/toolpaths":
            toolpaths = await self._get_toolpaths()
            return ResourceWithContent(
                uri=uri,
                name="Toolpaths",
                description="Information about toolpaths in the current job",
                contents=[TextContent(text=json.dumps(toolpaths, indent=2))]
            )
        elif uri == "vectric://job/vectors":
            vectors = await self._get_vectors()
            return ResourceWithContent(
                uri=uri,
                name="Vectors",
                description="Information about vectors in the current job",
                contents=[TextContent(text=json.dumps(vectors, indent=2))]
            )
        elif uri == "vectric://job/models":
            if not self.job_info.get("has_models", False):
                raise ValueError("No 3D models available in the current job")
                
            models = await self._get_models()
            return ResourceWithContent(
                uri=uri,
                name="Models",
                description="Information about 3D models in the current job",
                contents=[TextContent(text=json.dumps(models, indent=2))]
            )
        else:
            raise ValueError(f"Resource not found: {uri}")
    
    async def _update_job_info(self) -> None:
        """Update job information from the Vectric application."""
        try:
            # Ensure we're connected to the Lua Gadget
            if not self.lua_client.is_connected():
                await self.lua_client.connect(auth_token=self.auth_token)
            
            # Execute Lua code to get job information
            lua_code = """
            local info = {}
            
            -- Get basic job information
            info.job_name = Job.GetName()
            info.is_saved = Job.IsSaved()
            info.job_path = Job.GetPath()
            info.units = Job.GetUnits()
            info.width = Job.GetWidth()
            info.height = Job.GetHeight()
            info.thickness = Job.GetThickness()
            info.has_models = true  -- This should be replaced with actual check
            
            -- Return the information
            return info
            """
            
            command = {
                "command_type": "execute_code",
                "payload": {
                    "code": lua_code
                },
                "id": f"get_job_info_{id(object())}",
                "auth": self.auth_token
            }
            
            response_json = await self.lua_client.send_command(command)
            response = json.loads(response_json)
            
            if response.get("status") == "success":
                self.job_info = response.get("result", {}).get("data", {})
            else:
                logger.warning(
                    f"Failed to get job info: {response.get('result', {}).get('message', 'Unknown error')}"
                )
                self.job_info = {
                    "error": "Failed to get job information"
                }
        except Exception as e:
            logger.error(f"Error updating job info: {str(e)}")
            self.job_info = {
                "error": f"Exception occurred: {str(e)}"
            }
    
    async def _get_layers(self) -> Dict[str, Any]:
        """Get information about layers in the job."""
        try:
            # Execute Lua code to get layer information
            lua_code = """
            local layers = {}
            
            -- Get all layers
            local all_layers = Job.GetAllLayers()
            for i, layer in ipairs(all_layers) do
                table.insert(layers, {
                    name = layer:GetName(),
                    visible = layer:IsVisible(),
                    id = layer:GetId(),
                    num_objects = layer:GetNumObjects()
                })
            end
            
            return layers
            """
            
            command = {
                "command_type": "execute_code",
                "payload": {
                    "code": lua_code
                },
                "id": f"get_layers_{id(object())}",
                "auth": self.auth_token
            }
            
            response_json = await self.lua_client.send_command(command)
            response = json.loads(response_json)
            
            if response.get("status") == "success":
                return {
                    "layers": response.get("result", {}).get("data", {})
                }
            else:
                return {
                    "error": response.get("result", {}).get("message", "Unknown error")
                }
        except Exception as e:
            logger.error(f"Error getting layers: {str(e)}")
            return {"error": str(e)}
    
    async def _get_toolpaths(self) -> Dict[str, Any]:
        """Get information about toolpaths in the job."""
        try:
            # Execute Lua code to get toolpath information
            lua_code = """
            local toolpaths = {}
            
            -- Get all toolpaths
            local all_toolpaths = Job.GetAllToolpaths()
            for i, tp in ipairs(all_toolpaths) do
                table.insert(toolpaths, {
                    name = tp:GetName(),
                    tool_name = tp:GetTool():GetName(),
                    strategy = tp:GetStrategy(),
                    calculated = tp:IsCalculated()
                })
            end
            
            return toolpaths
            """
            
            command = {
                "command_type": "execute_code",
                "payload": {
                    "code": lua_code
                },
                "id": f"get_toolpaths_{id(object())}",
                "auth": self.auth_token
            }
            
            response_json = await self.lua_client.send_command(command)
            response = json.loads(response_json)
            
            if response.get("status") == "success":
                return {
                    "toolpaths": response.get("result", {}).get("data", {})
                }
            else:
                return {
                    "error": response.get("result", {}).get("message", "Unknown error")
                }
        except Exception as e:
            logger.error(f"Error getting toolpaths: {str(e)}")
            return {"error": str(e)}
    
    async def _get_vectors(self) -> Dict[str, Any]:
        """Get information about vectors in the job."""
        try:
            # Execute Lua code to get vector information
            lua_code = """
            local vectors = {}
            local vector_counts = {
                contours = 0,
                polylines = 0,
                circles = 0,
                text = 0,
                groups = 0,
                other = 0
            }
            
            -- Get all vectors by iterating through layers
            local all_layers = Job.GetAllLayers()
            for i, layer in ipairs(all_layers) do
                if layer:IsVisible() then
                    local objects = layer:GetAllObjects()
                    for j, obj in ipairs(objects) do
                        if obj:IsA("Contour") then
                            vector_counts.contours = vector_counts.contours + 1
                        elseif obj:IsA("Polyline") then
                            vector_counts.polylines = vector_counts.polylines + 1
                        elseif obj:IsA("Circle") then
                            vector_counts.circles = vector_counts.circles + 1
                        elseif obj:IsA("Text") then
                            vector_counts.text = vector_counts.text + 1
                        elseif obj:IsA("Group") then
                            vector_counts.groups = vector_counts.groups + 1
                        else
                            vector_counts.other = vector_counts.other + 1
                        end
                    end
                end
            end
            
            return vector_counts
            """
            
            command = {
                "command_type": "execute_code",
                "payload": {
                    "code": lua_code
                },
                "id": f"get_vectors_{id(object())}",
                "auth": self.auth_token
            }
            
            response_json = await self.lua_client.send_command(command)
            response = json.loads(response_json)
            
            if response.get("status") == "success":
                return response.get("result", {}).get("data", {})
            else:
                return {
                    "error": response.get("result", {}).get("message", "Unknown error")
                }
        except Exception as e:
            logger.error(f"Error getting vectors: {str(e)}")
            return {"error": str(e)}
    
    async def _get_models(self) -> Dict[str, Any]:
        """Get information about 3D models in the job."""
        try:
            # Execute Lua code to get model information
            lua_code = """
            local models = {}
            local model_count = 0
            
            -- Try to access models (may not be available in all Vectric products)
            local success, result = pcall(function()
                -- Get all components that might contain models
                local components = Job.GetAllComponents()
                for i, comp in ipairs(components) do
                    if comp.GetNumModels then  -- Check if it's a component with models
                        local num_models = comp:GetNumModels()
                        model_count = model_count + num_models
                    end
                end
                
                return {
                    model_count = model_count
                }
            end)
            
            if success then
                return result
            else
                return { error = "Models not supported or error occurred" }
            end
            """
            
            command = {
                "command_type": "execute_code",
                "payload": {
                    "code": lua_code
                },
                "id": f"get_models_{id(object())}",
                "auth": self.auth_token
            }
            
            response_json = await self.lua_client.send_command(command)
            response = json.loads(response_json)
            
            if response.get("status") == "success":
                return response.get("result", {}).get("data", {})
            else:
                return {
                    "error": response.get("result", {}).get("message", "Unknown error")
                }
        except Exception as e:
            logger.error(f"Error getting models: {str(e)}")
            return {"error": str(e)}