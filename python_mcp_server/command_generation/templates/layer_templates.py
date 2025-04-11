"""
Layer Management Templates for the Vectric environment.

This module provides templates for generating Lua code to create and
manage layers in the Vectric environment.
"""

class LayerTemplates:
    """Templates for layer management operations."""
    
    @staticmethod
    def create_layer(name: str, visible: bool = True, locked: bool = False) -> str:
        """
        Generate code to create a new layer.
        
        Args:
            name: Name of the layer
            visible: Whether the layer is visible
            locked: Whether the layer is locked
            
        Returns:
            Lua code for creating a layer
        """
        return f"""
-- Create a new layer
local layer = CreateLayer("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Failed to create layer '{name}'",
            type = "runtime_error"
        }}
    }}
end

-- Set visibility and lock state
layer:SetVisible({str(visible).lower()})
layer:SetLocked({str(locked).lower()})

return {{
    status = "success",
    result = {{
        message = "Layer created successfully",
        data = {{
            name = "{name}",
            visible = {str(visible).lower()},
            locked = {str(locked).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def get_layer(name: str) -> str:
        """
        Generate code to get a layer by name.
        
        Args:
            name: Name of the layer
            
        Returns:
            Lua code for getting a layer
        """
        return f"""
-- Get layer by name
local layer = GetLayerByName("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Get layer properties
local properties = {{}}
properties.name = layer:GetName()
properties.id = layer:GetID()
properties.visible = layer:IsVisible()
properties.locked = layer:IsLocked()

-- Count items in layer
local items = {{
    vectors = 0,
    components = 0,
    toolpaths = 0
}}

-- Count vectors
local vectors = GetAllVectors()
for i, vector in ipairs(vectors) do
    if vector:GetLayer():GetName() == "{name}" then
        items.vectors = items.vectors + 1
    end
end

-- Count components (3D models)
local components = GetAllComponents()
for i, component in ipairs(components) do
    if component:GetLayer():GetName() == "{name}" then
        items.components = items.components + 1
    end
end

-- Count toolpaths
local toolpaths = GetAllToolpaths()
for i, toolpath in ipairs(toolpaths) do
    if toolpath:GetLayer():GetName() == "{name}" then
        items.toolpaths = items.toolpaths + 1
    end
end

properties.item_count = items

return {{
    status = "success",
    result = {{
        message = "Layer information retrieved successfully",
        data = properties
    }}
}}
"""

    @staticmethod
    def set_layer_visibility(name: str, visible: bool) -> str:
        """
        Generate code to set a layer's visibility.
        
        Args:
            name: Name of the layer
            visible: Whether the layer should be visible
            
        Returns:
            Lua code for setting layer visibility
        """
        return f"""
-- Get layer by name
local layer = GetLayerByName("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Set visibility
layer:SetVisible({str(visible).lower()})

return {{
    status = "success",
    result = {{
        message = "Layer visibility set successfully",
        data = {{
            name = "{name}",
            visible = {str(visible).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def set_layer_lock(name: str, locked: bool) -> str:
        """
        Generate code to lock or unlock a layer.
        
        Args:
            name: Name of the layer
            locked: Whether the layer should be locked
            
        Returns:
            Lua code for setting layer lock state
        """
        return f"""
-- Get layer by name
local layer = GetLayerByName("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Set lock state
layer:SetLocked({str(locked).lower()})

return {{
    status = "success",
    result = {{
        message = "Layer lock state set successfully",
        data = {{
            name = "{name}",
            locked = {str(locked).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def rename_layer(old_name: str, new_name: str) -> str:
        """
        Generate code to rename a layer.
        
        Args:
            old_name: Current name of the layer
            new_name: New name for the layer
            
        Returns:
            Lua code for renaming a layer
        """
        return f"""
-- Get layer by current name
local layer = GetLayerByName("{old_name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{old_name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Check if the new name already exists
local existing = GetLayerByName("{new_name}")
if existing then
    return {{
        status = "error",
        result = {{
            message = "A layer with the name '{new_name}' already exists",
            type = "validation_error"
        }}
    }}
end

-- Rename layer
layer:SetName("{new_name}")

return {{
    status = "success",
    result = {{
        message = "Layer renamed successfully",
        data = {{
            old_name = "{old_name}",
            new_name = "{new_name}"
        }}
    }}
}}
"""

    @staticmethod
    def delete_layer(name: str, transfer_to: str = "Default Layer") -> str:
        """
        Generate code to delete a layer.
        
        Args:
            name: Name of the layer to delete
            transfer_to: Name of the layer to transfer contents to
            
        Returns:
            Lua code for deleting a layer
        """
        return f"""
-- Get layer by name
local layer = GetLayerByName("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Cannot delete Default Layer
if layer:GetName() == "Default Layer" then
    return {{
        status = "error",
        result = {{
            message = "Cannot delete the Default Layer",
            type = "validation_error"
        }}
    }}
end

-- Get target layer for transferring contents
local target_layer
if "{transfer_to}" ~= "{name}" then
    target_layer = GetLayerByName("{transfer_to}")
    if not target_layer then
        return {{
            status = "error",
            result = {{
                message = "Transfer layer '{transfer_to}' not found",
                type = "not_found_error"
            }}
        }}
    end
end

-- Transfer contents if target layer exists
if target_layer then
    -- Get all vectors from the layer to delete
    local vectors = GetAllVectors()
    for i, vector in ipairs(vectors) do
        if vector:GetLayer():GetID() == layer:GetID() then
            vector:SetLayer(target_layer)
        end
    end
    
    -- Transfer components (3D models)
    local components = GetAllComponents()
    for i, component in ipairs(components) do
        if component:GetLayer():GetID() == layer:GetID() then
            component:SetLayer(target_layer)
        end
    end
    
    -- Transfer toolpaths
    local toolpaths = GetAllToolpaths()
    for i, toolpath in ipairs(toolpaths) do
        if toolpath:GetLayer():GetID() == layer:GetID() then
            toolpath:SetLayer(target_layer)
        end
    end
end

-- Delete the layer
local success = DeleteLayer(layer)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to delete layer '{name}'",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Layer deleted successfully",
        data = {{
            name = "{name}",
            transfer_to = "{transfer_to}"
        }}
    }}
}}
"""

    @staticmethod
    def list_all_layers() -> str:
        """
        Generate code to list all layers in the job.
        
        Returns:
            Lua code for listing all layers
        """
        return """
-- Get all layers
local layers = GetAllLayers()
local layer_info = {}

-- Create an info table for each layer
for i, layer in ipairs(layers) do
    -- Get layer properties
    local properties = {}
    properties.name = layer:GetName()
    properties.id = layer:GetID()
    properties.visible = layer:IsVisible()
    properties.locked = layer:IsLocked()
    properties.index = i
    
    -- Count items in layer
    local vectors = 0
    local components = 0
    local toolpaths = 0
    
    -- Get all objects
    local all_vectors = GetAllVectors()
    local all_components = GetAllComponents()
    local all_toolpaths = GetAllToolpaths()
    
    -- Count objects in layer
    for _, vector in ipairs(all_vectors) do
        if vector:GetLayer():GetID() == layer:GetID() then
            vectors = vectors + 1
        end
    end
    
    for _, component in ipairs(all_components) do
        if component:GetLayer():GetID() == layer:GetID() then
            components = components + 1
        end
    end
    
    for _, toolpath in ipairs(all_toolpaths) do
        if toolpath:GetLayer():GetID() == layer:GetID() then
            toolpaths = toolpaths + 1
        end
    end
    
    -- Add counts to properties
    properties.vectors = vectors
    properties.components = components
    properties.toolpaths = toolpaths
    properties.total_items = vectors + components + toolpaths
    
    -- Add to list
    table.insert(layer_info, properties)
end

return {
    status = "success",
    result = {
        message = #layer_info .. " layers found",
        data = {
            layers = layer_info
        }
    }
}
"""

    @staticmethod
    def move_objects_to_layer(object_ids: list, layer_name: str, object_type: str = "vectors") -> str:
        """
        Generate code to move objects to a different layer.
        
        Args:
            object_ids: List of object IDs to move
            layer_name: Name of the destination layer
            object_type: Type of objects ('vectors', 'components', or 'toolpaths')
            
        Returns:
            Lua code for moving objects to a layer
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, oid in enumerate(object_ids):
            ids_str += f"{oid}"
            if i < len(object_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        # Function to use based on object type
        get_function = {
            "vectors": "GetVectorById",
            "components": "GetComponentById",
            "toolpaths": "GetToolpathById"
        }.get(object_type.lower(), "GetVectorById")
        
        object_label = {
            "vectors": "Vector",
            "components": "Component",
            "toolpaths": "Toolpath"
        }.get(object_type.lower(), "Vector")
        
        return f"""
-- Get target layer
local layer = GetLayerByName("{layer_name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{layer_name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Get objects and move them to the layer
local object_ids = {ids_str}
local moved_count = 0
local failed = {{}}

for i, id in ipairs(object_ids) do
    local object = {get_function}(id)
    if object then
        object:SetLayer(layer)
        moved_count = moved_count + 1
    else
        table.insert(failed, id)
    end
end

-- Report results
if #failed > 0 then
    local failed_str = ""
    for i, id in ipairs(failed) do
        failed_str = failed_str .. id
        if i < #failed then
            failed_str = failed_str .. ", "
        end
    end
    
    return {{
        status = "warning",
        result = {{
            message = moved_count .. " {object_label}" .. (moved_count ~= 1 and "s" or "") .. " moved, " .. #failed .. " not found",
            data = {{
                moved_count = moved_count,
                failed_ids = failed,
                layer = "{layer_name}"
            }}
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = moved_count .. " {object_label}" .. (moved_count ~= 1 and "s" or "") .. " moved to layer '{layer_name}'",
        data = {{
            moved_count = moved_count,
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def set_active_layer(name: str) -> str:
        """
        Generate code to set the active layer.
        
        Args:
            name: Name of the layer to make active
            
        Returns:
            Lua code for setting the active layer
        """
        return f"""
-- Get layer by name
local layer = GetLayerByName("{name}")
if not layer then
    return {{
        status = "error",
        result = {{
            message = "Layer '{name}' not found",
            type = "not_found_error"
        }}
    }}
end

-- Set as active layer
SetActiveLayer(layer)

return {{
    status = "success",
    result = {{
        message = "Active layer set to '{name}'",
        data = {{
            name = "{name}"
        }}
    }}
}}
"""