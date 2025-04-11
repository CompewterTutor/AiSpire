"""
Command Generator for AiSpire.

This module generates Lua commands to be sent to the Lua Gadget.
It provides templates for common operations and ensures commands are valid.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import logging
from typing import Dict, Any, List, Optional, Union

logger = logging.getLogger(__name__)

class CommandGenerator:
    """
    Generator for creating Lua commands to send to the Vectric Lua Gadget.
    
    This class provides templates and validation for generating commands
    that can be executed by the Lua Gadget.
    """
    
    def __init__(self):
        """Initialize the command generator."""
        self.templates = {
            # Common operation templates
            "create_circle": self._template_create_circle,
            "create_rectangle": self._template_create_rectangle,
            "create_profile_toolpath": self._template_create_profile_toolpath,
            "create_pocket_toolpath": self._template_create_pocket_toolpath,
            "create_layer": self._template_create_layer,
        }
    
    def generate_command(self, request: Dict[str, Any]) -> str:
        """
        Generate a Lua command based on the request.
        
        Args:
            request: Request dictionary containing command details
            
        Returns:
            String containing the Lua command to execute
            
        Raises:
            ValueError: If the request is invalid
        """
        command_type = request.get("command_type")
        payload = request.get("payload", {})
        command_id = request.get("id", "unknown")
        
        if command_type == "execute_code":
            # Direct code execution - just pass through the code
            code = payload.get("code")
            if not code:
                raise ValueError("No code provided for execute_code command")
            return self._format_command("execute_code", {"code": code}, command_id)
            
        elif command_type == "execute_function":
            # Function execution with parameters
            function_name = payload.get("function")
            parameters = payload.get("parameters", {})
            
            if not function_name:
                raise ValueError("No function name provided for execute_function command")
                
            # Check if we have a template for this function
            if function_name in self.templates:
                # Generate code from template
                template_func = self.templates[function_name]
                code = template_func(parameters)
                return self._format_command("execute_code", {"code": code}, command_id)
            else:
                # No template - pass function and parameters directly
                return self._format_command("execute_function", {
                    "function": function_name,
                    "parameters": parameters
                }, command_id)
                
        elif command_type == "query_state":
            # State query command
            return self._format_command("query_state", {}, command_id)
            
        else:
            raise ValueError(f"Unknown command type: {command_type}")
    
    def _format_command(self, command_type: str, payload: Dict[str, Any], command_id: str) -> str:
        """
        Format a command as JSON.
        
        Args:
            command_type: Type of command
            payload: Command payload
            command_id: Command identifier
            
        Returns:
            JSON string with the formatted command
        """
        import json
        
        command = {
            "command_type": command_type,
            "payload": payload,
            "id": command_id
        }
        
        return json.dumps(command)
    
    # Template methods for common operations
    
    def _template_create_circle(self, params: Dict[str, Any]) -> str:
        """
        Generate code for creating a circle.
        
        Args:
            params: Parameters for the circle
            
        Returns:
            Lua code string
        """
        center_x = params.get("center_x", 0)
        center_y = params.get("center_y", 0)
        radius = params.get("radius", 10)
        layer = params.get("layer", "")
        
        code = f"""
            local circle = Circle:new({center_x}, {center_y}, {radius})
            if "{layer}" ~= "" then
                circle:SetLayer("{layer}")
            end
            return circle
        """
        
        return code
    
    def _template_create_rectangle(self, params: Dict[str, Any]) -> str:
        """
        Generate code for creating a rectangle.
        
        Args:
            params: Parameters for the rectangle
            
        Returns:
            Lua code string
        """
        x1 = params.get("x1", 0)
        y1 = params.get("y1", 0)
        x2 = params.get("x2", 100)
        y2 = params.get("y2", 100)
        corner_radius = params.get("corner_radius", 0)
        layer = params.get("layer", "")
        
        code = f"""
            local rect = Contour:new()
            rect:AppendPoint({x1}, {y1})
            rect:AppendPoint({x2}, {y1})
            rect:AppendPoint({x2}, {y2})
            rect:AppendPoint({x1}, {y2})
            rect:Close()
            
            if {corner_radius} > 0 then
                rect = rect:FilletCorners({corner_radius})
            end
            
            if "{layer}" ~= "" then
                rect:SetLayer("{layer}")
            end
            
            return rect
        """
        
        return code
    
    def _template_create_profile_toolpath(self, params: Dict[str, Any]) -> str:
        """
        Generate code for creating a profile toolpath.
        
        Args:
            params: Parameters for the toolpath
            
        Returns:
            Lua code string
        """
        name = params.get("name", "Profile Toolpath")
        tool_id = params.get("tool_id", "1")
        cut_depth = params.get("cut_depth", 5)
        object_ids = params.get("object_ids", [])
        inside = params.get("inside", True)
        
        # Convert object IDs to a Lua table string
        object_ids_str = "{"
        for obj_id in object_ids:
            object_ids_str += f'"{obj_id}", '
        object_ids_str += "}"
        
        code = f"""
            local toolpath = Toolpath:new("Profile")
            toolpath:SetName("{name}")
            toolpath:SetTool("{tool_id}")
            toolpath:SetCutDepth({cut_depth})
            
            -- Add objects to toolpath
            local objects = {object_ids_str}
            for _, obj_id in ipairs(objects) do
                local obj = Job:GetObjectById(obj_id)
                if obj then
                    toolpath:AddObject(obj)
                end
            end
            
            -- Set inside/outside
            toolpath:SetDirection({'true' if inside else 'false'})
            
            -- Calculate the toolpath
            local success, message = toolpath:Calculate()
            
            return {{
                success = success,
                message = message,
                toolpath_id = toolpath:GetId()
            }}
        """
        
        return code
    
    def _template_create_pocket_toolpath(self, params: Dict[str, Any]) -> str:
        """
        Generate code for creating a pocket toolpath.
        
        Args:
            params: Parameters for the toolpath
            
        Returns:
            Lua code string
        """
        name = params.get("name", "Pocket Toolpath")
        tool_id = params.get("tool_id", "1")
        cut_depth = params.get("cut_depth", 5)
        object_ids = params.get("object_ids", [])
        stepover = params.get("stepover", 0.4)
        
        # Convert object IDs to a Lua table string
        object_ids_str = "{"
        for obj_id in object_ids:
            object_ids_str += f'"{obj_id}", '
        object_ids_str += "}"
        
        code = f"""
            local toolpath = Toolpath:new("Pocket")
            toolpath:SetName("{name}")
            toolpath:SetTool("{tool_id}")
            toolpath:SetCutDepth({cut_depth})
            toolpath:SetStepover({stepover})
            
            -- Add objects to toolpath
            local objects = {object_ids_str}
            for _, obj_id in ipairs(objects) do
                local obj = Job:GetObjectById(obj_id)
                if obj then
                    toolpath:AddObject(obj)
                end
            end
            
            -- Calculate the toolpath
            local success, message = toolpath:Calculate()
            
            return {{
                success = success,
                message = message,
                toolpath_id = toolpath:GetId()
            }}
        """
        
        return code
    
    def _template_create_layer(self, params: Dict[str, Any]) -> str:
        """
        Generate code for creating a layer.
        
        Args:
            params: Parameters for the layer
            
        Returns:
            Lua code string
        """
        name = params.get("name", f"Layer {params.get('index', 1)}")
        color = params.get("color", "#0000FF")
        visible = params.get("visible", True)
        
        code = f"""
            local layerManager = Job:GetLayerManager()
            local success, message = layerManager:AddNewLayer(
                "{name}",
                "{color}",
                {str(visible).lower()}
            )
            
            return {{
                success = success,
                message = message,
                layer_name = "{name}"
            }}
        """
        
        return code
