"""
Toolpath Generation Templates for the Vectric environment.

This module provides templates for generating Lua code to create and
manage toolpaths in the Vectric environment.
"""

class ToolpathTemplates:
    """Templates for toolpath generation operations."""

    @staticmethod
    def create_profile_toolpath(vector_ids: list, tool_id: int, name: str = "Profile Toolpath",
                              cut_depth: float = None, cut_inside: bool = True,
                              allowance: float = 0.0, reverse: bool = False) -> str:
        """
        Generate code to create a profile toolpath.
        
        Args:
            vector_ids: List of vector IDs to create the toolpath from
            tool_id: ID of the tool to use
            name: Name of the toolpath
            cut_depth: Depth of the cut (if None, will use material thickness)
            cut_inside: Whether to cut on the inside of the vectors
            allowance: Additional material to leave (positive value)
            reverse: Whether to reverse the cutting direction
            
        Returns:
            Lua code for creating a profile toolpath
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, vid in enumerate(vector_ids):
            ids_str += f"{vid}"
            if i < len(vector_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        # Handle 'None' value for cut_depth
        depth_code = "GetMaterialThickness()"
        if cut_depth is not None:
            depth_code = f"{cut_depth}"
        
        # Determine side to cut on
        side_code = "ProfileToolpathSide.INSIDE"
        if not cut_inside:
            side_code = "ProfileToolpathSide.OUTSIDE"
        
        return f"""
-- Get vectors by their IDs
local vectors = {{}}
local vector_ids = {ids_str}
for i, id in ipairs(vector_ids) do
    local vector = GetVectorById(id)
    if not vector then
        return {{
            status = "error",
            result = {{
                message = "Vector with ID " .. id .. " not found",
                type = "not_found_error"
            }}
        }}
    end
    table.insert(vectors, vector)
end

-- Check if we have vectors
if #vectors == 0 then
    return {{
        status = "error",
        result = {{
            message = "No valid vectors found",
            type = "validation_error"
        }}
    }}
end

-- Get the tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Create the profile toolpath
local toolpath_options = {{
    name = "{name}",
    cut_depth = {depth_code},
    side = {side_code},
    allowance = {allowance},
    reverse = {str(reverse).lower()},
}}

local toolpath = CreateProfileToolpath(vectors, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create profile toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate profile toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Profile toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            vector_count = #vector_ids,
            cut_depth = toolpath_options.cut_depth,
            side = "{('Inside' if cut_inside else 'Outside')}",
            allowance = {allowance},
            reverse = {str(reverse).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def create_pocket_toolpath(vector_ids: list, tool_id: int, name: str = "Pocket Toolpath",
                             cut_depth: float = None, stepover: float = None,
                             clearing_strategy: str = "Offset", profile_pass: bool = True,
                             allowance: float = 0.0) -> str:
        """
        Generate code to create a pocket toolpath.
        
        Args:
            vector_ids: List of vector IDs to create the toolpath from
            tool_id: ID of the tool to use
            name: Name of the toolpath
            cut_depth: Depth of the cut (if None, will use material thickness)
            stepover: Distance between tool paths (if None, will use 40% of tool diameter)
            clearing_strategy: Strategy for clearing material ('Offset', 'Raster', or 'Spiral')
            profile_pass: Whether to include a profile pass
            allowance: Additional material to leave (positive value)
            
        Returns:
            Lua code for creating a pocket toolpath
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, vid in enumerate(vector_ids):
            ids_str += f"{vid}"
            if i < len(vector_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        # Handle 'None' values
        depth_code = "GetMaterialThickness()"
        if cut_depth is not None:
            depth_code = f"{cut_depth}"
        
        # Convert clearing strategy to Vectric enum
        strategy_map = {
            "Offset": "PocketStrategy.OFFSET",
            "Raster": "PocketStrategy.RASTER",
            "Spiral": "PocketStrategy.SPIRAL"
        }
        strategy_code = strategy_map.get(clearing_strategy, "PocketStrategy.OFFSET")
        
        # Handle stepover calculation
        stepover_code = "nil"  # nil will use the default value in Lua
        if stepover is not None:
            stepover_code = f"{stepover}"
        
        return f"""
-- Get vectors by their IDs
local vectors = {{}}
local vector_ids = {ids_str}
for i, id in ipairs(vector_ids) do
    local vector = GetVectorById(id)
    if not vector then
        return {{
            status = "error",
            result = {{
                message = "Vector with ID " .. id .. " not found",
                type = "not_found_error"
            }}
        }}
    end
    table.insert(vectors, vector)
end

-- Check if we have vectors
if #vectors == 0 then
    return {{
        status = "error",
        result = {{
            message = "No valid vectors found",
            type = "validation_error"
        }}
    }}
end

-- Get the tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Calculate stepover if not provided (40% of tool diameter is a common default)
local tool_stepover = {stepover_code}
if tool_stepover == nil then
    tool_stepover = tool:GetDiameter() * 0.4
end

-- Create the pocket toolpath
local toolpath_options = {{
    name = "{name}",
    cut_depth = {depth_code},
    strategy = {strategy_code},
    stepover = tool_stepover,
    profile_pass = {str(profile_pass).lower()},
    allowance = {allowance}
}}

local toolpath = CreatePocketToolpath(vectors, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create pocket toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate pocket toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Pocket toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            vector_count = #vector_ids,
            cut_depth = toolpath_options.cut_depth,
            strategy = "{clearing_strategy}",
            stepover = tool_stepover,
            profile_pass = {str(profile_pass).lower()},
            allowance = {allowance}
        }}
    }}
}}
"""

    @staticmethod
    def create_drilling_toolpath(point_ids: list, tool_id: int, name: str = "Drilling Toolpath",
                               cut_depth: float = None, dwell: float = 0.0,
                               peck_depth: float = 0.0) -> str:
        """
        Generate code to create a drilling toolpath.
        
        Args:
            point_ids: List of point vector IDs to drill
            tool_id: ID of the tool to use
            name: Name of the toolpath
            cut_depth: Depth of the drill (if None, will use material thickness)
            dwell: Time to dwell at the bottom of the hole (seconds)
            peck_depth: Depth for each peck (0 for no pecking)
            
        Returns:
            Lua code for creating a drilling toolpath
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, pid in enumerate(point_ids):
            ids_str += f"{pid}"
            if i < len(point_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        # Handle 'None' value for cut_depth
        depth_code = "GetMaterialThickness()"
        if cut_depth is not None:
            depth_code = f"{cut_depth}"
        
        return f"""
-- Get points by their IDs
local points = {{}}
local point_ids = {ids_str}
for i, id in ipairs(point_ids) do
    local point = GetVectorById(id)
    -- Validate that it's a point (or could convert to one)
    if not point or (not IsPoint(point) and not CanConvertToPoint(point)) then
        return {{
            status = "error",
            result = {{
                message = "Vector with ID " .. id .. " is not a valid point for drilling",
                type = "validation_error"
            }}
        }}
    end
    
    -- Convert to point if needed
    if not IsPoint(point) then
        point = ConvertToPoint(point)
    end
    
    table.insert(points, point)
end

-- Check if we have points
if #points == 0 then
    return {{
        status = "error",
        result = {{
            message = "No valid points found",
            type = "validation_error"
        }}
    }}
end

-- Get the tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Create the drilling toolpath
local toolpath_options = {{
    name = "{name}",
    cut_depth = {depth_code},
    dwell = {dwell},
    peck_depth = {peck_depth}
}}

local toolpath = CreateDrillingToolpath(points, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create drilling toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate drilling toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Drilling toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            point_count = #point_ids,
            cut_depth = toolpath_options.cut_depth,
            dwell = {dwell},
            peck_depth = {peck_depth}
        }}
    }}
}}
"""

    @staticmethod
    def create_vcarve_toolpath(vector_ids: list, tool_id: int, name: str = "VCarve Toolpath",
                             flat_depth: float = 0.0, flat_width: float = 0.0, 
                             allowance: float = 0.0, calculate_flat_areas: bool = True) -> str:
        """
        Generate code to create a V-carving toolpath.
        
        Args:
            vector_ids: List of vector IDs to create the toolpath from
            tool_id: ID of the v-bit tool to use
            name: Name of the toolpath
            flat_depth: Depth for flat areas
            flat_width: Width for identifying flat areas
            allowance: Additional material to leave (positive value)
            calculate_flat_areas: Whether to calculate flat areas
            
        Returns:
            Lua code for creating a V-carving toolpath
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, vid in enumerate(vector_ids):
            ids_str += f"{vid}"
            if i < len(vector_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        return f"""
-- Get vectors by their IDs
local vectors = {{}}
local vector_ids = {ids_str}
for i, id in ipairs(vector_ids) do
    local vector = GetVectorById(id)
    if not vector then
        return {{
            status = "error",
            result = {{
                message = "Vector with ID " .. id .. " not found",
                type = "not_found_error"
            }}
        }}
    end
    table.insert(vectors, vector)
end

-- Check if we have vectors
if #vectors == 0 then
    return {{
        status = "error",
        result = {{
            message = "No valid vectors found",
            type = "validation_error"
        }}
    }}
end

-- Get the v-bit tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Check if it's a v-bit
if not IsVBitTool(tool) then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} is not a v-bit",
            type = "validation_error"
        }}
    }}
end

-- Create the v-carve toolpath
local toolpath_options = {{
    name = "{name}",
    flat_depth = {flat_depth},
    flat_width = {flat_width},
    allowance = {allowance},
    calculate_flat_areas = {str(calculate_flat_areas).lower()}
}}

local toolpath = CreateVCarveToolpath(vectors, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create v-carve toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate v-carve toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "V-carve toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            vector_count = #vector_ids,
            flat_depth = {flat_depth},
            flat_width = {flat_width},
            allowance = {allowance},
            calculate_flat_areas = {str(calculate_flat_areas).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def create_3d_roughing_toolpath(model_id: int, tool_id: int, name: str = "3D Roughing",
                                  stepover: float = None, cut_depth: float = None, 
                                  strategy: str = "Offset", boundary_id: int = None) -> str:
        """
        Generate code to create a 3D roughing toolpath.
        
        Args:
            model_id: ID of the 3D model to create the toolpath from
            tool_id: ID of the tool to use
            name: Name of the toolpath
            stepover: Distance between tool paths (if None, will use 40% of tool diameter)
            cut_depth: Maximum cut depth per pass (if None, will use 50% of tool diameter)
            strategy: Roughing strategy ('Offset', 'Raster', or 'Spiral')
            boundary_id: Optional ID of a vector to use as boundary
            
        Returns:
            Lua code for creating a 3D roughing toolpath
        """
        # Convert strategy to Vectric enum
        strategy_map = {
            "Offset": "RoughingStrategy.OFFSET",
            "Raster": "RoughingStrategy.RASTER",
            "Spiral": "RoughingStrategy.SPIRAL"
        }
        strategy_code = strategy_map.get(strategy, "RoughingStrategy.OFFSET")
        
        # Handle optional boundary
        boundary_code = "nil"
        if boundary_id is not None:
            boundary_code = f"GetVectorById({boundary_id})"
        
        # Handle stepover and cut_depth defaults
        stepover_code = "nil"  # will be calculated in Lua
        cut_depth_code = "nil"  # will be calculated in Lua
        
        return f"""
-- Get the 3D model
local model = GetComponentById({model_id})
if not model then
    return {{
        status = "error",
        result = {{
            message = "Component (3D model) with ID {model_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Get the tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Get boundary if specified
local boundary = {boundary_code}
if {boundary_id} ~= nil and boundary == nil then
    return {{
        status = "error",
        result = {{
            message = "Boundary vector with ID {boundary_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Calculate stepover if not provided (40% of tool diameter is a common default)
local tool_stepover = {stepover_code}
if tool_stepover == nil then
    tool_stepover = tool:GetDiameter() * 0.4
end

-- Calculate cut depth if not provided (50% of tool diameter is a common default)
local tool_cut_depth = {cut_depth_code}
if tool_cut_depth == nil then
    tool_cut_depth = tool:GetDiameter() * 0.5
end

-- Create the 3D roughing toolpath
local toolpath_options = {{
    name = "{name}",
    strategy = {strategy_code},
    stepover = tool_stepover,
    cut_depth = tool_cut_depth,
    boundary = boundary
}}

local toolpath = Create3DRoughingToolpath(model, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create 3D roughing toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate 3D roughing toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "3D roughing toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            model_id = {model_id},
            strategy = "{strategy}",
            stepover = tool_stepover,
            cut_depth = tool_cut_depth,
            boundary_id = {str(boundary_id) if boundary_id is not None else "nil"}
        }}
    }}
}}
"""

    @staticmethod
    def create_3d_finishing_toolpath(model_id: int, tool_id: int, name: str = "3D Finishing",
                                   stepover: float = None, strategy: str = "Raster",
                                   direction: float = 0.0, boundary_id: int = None) -> str:
        """
        Generate code to create a 3D finishing toolpath.
        
        Args:
            model_id: ID of the 3D model to create the toolpath from
            tool_id: ID of the tool to use
            name: Name of the toolpath
            stepover: Distance between tool paths (if None, will use 10% of tool diameter)
            strategy: Finishing strategy ('Raster', 'Offset', 'Spiral', 'Radial', 'Flowline', etc.)
            direction: Direction angle for raster toolpaths in degrees
            boundary_id: Optional ID of a vector to use as boundary
            
        Returns:
            Lua code for creating a 3D finishing toolpath
        """
        # Convert strategy to Vectric enum
        strategy_map = {
            "Raster": "FinishingStrategy.RASTER",
            "Offset": "FinishingStrategy.OFFSET",
            "Spiral": "FinishingStrategy.SPIRAL",
            "Radial": "FinishingStrategy.RADIAL",
            "Flowline": "FinishingStrategy.FLOWLINE"
        }
        strategy_code = strategy_map.get(strategy, "FinishingStrategy.RASTER")
        
        # Handle optional boundary
        boundary_code = "nil"
        if boundary_id is not None:
            boundary_code = f"GetVectorById({boundary_id})"
        
        # Handle stepover defaults
        stepover_code = "nil"  # will be calculated in Lua
        
        return f"""
-- Get the 3D model
local model = GetComponentById({model_id})
if not model then
    return {{
        status = "error",
        result = {{
            message = "Component (3D model) with ID {model_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Get the tool
local tool = GetToolById({tool_id})
if not tool then
    return {{
        status = "error",
        result = {{
            message = "Tool with ID {tool_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Get boundary if specified
local boundary = {boundary_code}
if {boundary_id} ~= nil and boundary == nil then
    return {{
        status = "error",
        result = {{
            message = "Boundary vector with ID {boundary_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Calculate stepover if not provided (10% of tool diameter is common for finishing)
local tool_stepover = {stepover_code}
if tool_stepover == nil then
    tool_stepover = tool:GetDiameter() * 0.1
end

-- Create the 3D finishing toolpath
local toolpath_options = {{
    name = "{name}",
    strategy = {strategy_code},
    stepover = tool_stepover,
    direction = {direction},
    boundary = boundary
}}

local toolpath = Create3DFinishingToolpath(model, tool, toolpath_options)
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Failed to create 3D finishing toolpath",
            type = "runtime_error"
        }}
    }}
end

-- Calculate the toolpath
local success = CalculateToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to calculate 3D finishing toolpath",
            type = "calculation_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "3D finishing toolpath created and calculated successfully",
        data = {{
            name = "{name}",
            tool_id = {tool_id},
            model_id = {model_id},
            strategy = "{strategy}",
            stepover = tool_stepover,
            direction = {direction},
            boundary_id = {str(boundary_id) if boundary_id is not None else "nil"}
        }}
    }}
}}
"""

    @staticmethod
    def delete_toolpath(toolpath_id: int) -> str:
        """
        Generate code to delete a toolpath.
        
        Args:
            toolpath_id: ID of the toolpath to delete
            
        Returns:
            Lua code for deleting a toolpath
        """
        return f"""
-- Get the toolpath
local toolpath = GetToolpathById({toolpath_id})
if not toolpath then
    return {{
        status = "error",
        result = {{
            message = "Toolpath with ID {toolpath_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Delete the toolpath
local success = DeleteToolpath(toolpath)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to delete toolpath with ID {toolpath_id}",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Toolpath deleted successfully",
        data = {{
            toolpath_id = {toolpath_id}
        }}
    }}
}}
"""