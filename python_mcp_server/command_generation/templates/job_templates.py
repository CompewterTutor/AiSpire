"""
Job Management Templates for the Vectric environment.

This module provides templates for generating Lua code to create, open,
save, and manage jobs in the Vectric environment.
"""

class JobTemplates:
    """Templates for job management operations."""

    @staticmethod
    def create_new_job(name: str, width: float, height: float, thickness: float, 
                       in_mm: bool = True, origin_on_surface: bool = True) -> str:
        """
        Generate code to create a new job.
        
        Args:
            name: Name of the job
            width: Width of the job
            height: Height of the job
            thickness: Thickness of the material
            in_mm: Whether dimensions are in mm (True) or inches (False)
            origin_on_surface: Whether origin is on surface (True) or on bottom (False)
            
        Returns:
            Lua code for creating a new job
        """
        return f"""
-- Create a new job with specified dimensions
local bounds = Box2D(0, 0, {width}, {height})
local success = CreateNewJob("{name}", bounds, {thickness}, {str(in_mm).lower()}, {str(origin_on_surface).lower()})
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to create new job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "New job created successfully",
        data = {{
            name = "{name}",
            width = {width},
            height = {height},
            thickness = {thickness},
            in_mm = {str(in_mm).lower()},
            origin_on_surface = {str(origin_on_surface).lower()}
        }}
    }}
}}
"""

    @staticmethod
    def create_new_2sided_job(name: str, width: float, height: float, thickness: float, 
                              in_mm: bool = True, origin_on_surface: bool = True, 
                              flip_direction: str = "LeftToRight") -> str:
        """
        Generate code to create a new two-sided job.
        
        Args:
            name: Name of the job
            width: Width of the job
            height: Height of the job
            thickness: Thickness of the material
            in_mm: Whether dimensions are in mm (True) or inches (False)
            origin_on_surface: Whether origin is on surface (True) or on bottom (False)
            flip_direction: Direction to flip for second side ('LeftToRight', 'RightToLeft', 
                           'TopToBottom', or 'BottomToTop')
            
        Returns:
            Lua code for creating a new two-sided job
        """
        # Map Python string to Vectric enum value
        flip_map = {
            "LeftToRight": "SideFlipDirection.LEFT_TO_RIGHT",
            "RightToLeft": "SideFlipDirection.RIGHT_TO_LEFT",
            "TopToBottom": "SideFlipDirection.TOP_TO_BOTTOM",
            "BottomToTop": "SideFlipDirection.BOTTOM_TO_TOP"
        }
        
        flip_value = flip_map.get(flip_direction, "SideFlipDirection.LEFT_TO_RIGHT")
        
        return f"""
-- Create a new two-sided job with specified dimensions
local bounds = Box2D(0, 0, {width}, {height})
local success = CreateNew2SidedJob("{name}", bounds, {thickness}, {str(in_mm).lower()}, {str(origin_on_surface).lower()}, {flip_value})
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to create new two-sided job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "New two-sided job created successfully",
        data = {{
            name = "{name}",
            width = {width},
            height = {height},
            thickness = {thickness},
            in_mm = {str(in_mm).lower()},
            origin_on_surface = {str(origin_on_surface).lower()},
            flip_direction = "{flip_direction}"
        }}
    }}
}}
"""

    @staticmethod
    def create_new_rotary_job(name: str, length: float, diameter: float, 
                              in_mm: bool = True, origin_on_surface: bool = True,
                              wrapped_along_x_axis: bool = True, 
                              xy_origin: str = "Center") -> str:
        """
        Generate code to create a new rotary job.
        
        Args:
            name: Name of the job
            length: Length of the workpiece
            diameter: Diameter of the workpiece
            in_mm: Whether dimensions are in mm (True) or inches (False)
            origin_on_surface: Whether origin is on surface (True) or on bottom (False)
            wrapped_along_x_axis: Whether to wrap along X axis (True) or Y axis (False)
            xy_origin: Position of the origin ('Center', 'BottomLeft', 'TopLeft', 'TopRight', 'BottomRight')
            
        Returns:
            Lua code for creating a new rotary job
        """
        # Map Python string to Vectric enum value
        origin_map = {
            "Center": "MaterialBlock.XYOrigin.CENTER",
            "BottomLeft": "MaterialBlock.XYOrigin.BOTTOM_LEFT",
            "TopLeft": "MaterialBlock.XYOrigin.TOP_LEFT",
            "TopRight": "MaterialBlock.XYOrigin.TOP_RIGHT",
            "BottomRight": "MaterialBlock.XYOrigin.BOTTOM_RIGHT"
        }
        
        origin_value = origin_map.get(xy_origin, "MaterialBlock.XYOrigin.CENTER")
        
        return f"""
-- Create a new rotary job with specified dimensions
local success = CreateNewRotaryJob("{name}", {length}, {diameter}, {origin_value}, {str(in_mm).lower()}, {str(origin_on_surface).lower()}, {str(wrapped_along_x_axis).lower()})
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to create new rotary job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "New rotary job created successfully",
        data = {{
            name = "{name}",
            length = {length},
            diameter = {diameter},
            in_mm = {str(in_mm).lower()},
            origin_on_surface = {str(origin_on_surface).lower()},
            wrapped_along_x_axis = {str(wrapped_along_x_axis).lower()},
            xy_origin = "{xy_origin}"
        }}
    }}
}}
"""

    @staticmethod
    def open_job(file_path: str) -> str:
        """
        Generate code to open an existing job file.
        
        Args:
            file_path: Path to the job file (.crv or .crv3d)
            
        Returns:
            Lua code for opening a job
        """
        # Escape backslashes for Lua
        escaped_path = file_path.replace("\\", "\\\\")
        
        return f"""
-- Open an existing job file
local success = OpenExistingJob("{escaped_path}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to open job file: {escaped_path}",
            type = "file_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Job opened successfully",
        data = {{
            file_path = "{escaped_path}"
        }}
    }}
}}
"""

    @staticmethod
    def save_job() -> str:
        """
        Generate code to save the current job.
        
        Returns:
            Lua code for saving the current job
        """
        return """
-- Save the current job
local success = SaveCurrentJob()
if not success then
    return {
        status = "error",
        result = {
            message = "Failed to save job",
            type = "file_error"
        }
    }
end

return {
    status = "success",
    result = {
        message = "Job saved successfully"
    }
}
"""

    @staticmethod
    def save_job_as(file_path: str) -> str:
        """
        Generate code to save the current job to a specified path.
        
        Args:
            file_path: Path where the job should be saved
            
        Returns:
            Lua code for saving the job to a specific path
        """
        # Escape backslashes for Lua
        escaped_path = file_path.replace("\\", "\\\\")
        
        return f"""
-- Save the current job to a specified path
-- Note: This operation requires custom implementation as SaveCurrentJob() doesn't accept a path parameter

-- First check if the job exists
if not JobExists() then
    return {{
        status = "error",
        result = {{
            message = "No job is currently open",
            type = "state_error"
        }}
    }}
end

-- Custom implementation to save job as
local success = SaveJobAs("{escaped_path}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to save job as: {escaped_path}",
            type = "file_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Job saved successfully as: {escaped_path}",
        data = {{
            file_path = "{escaped_path}"
        }}
    }}
}}
"""

    @staticmethod
    def close_job() -> str:
        """
        Generate code to close the current job.
        
        Returns:
            Lua code for closing the current job
        """
        return """
-- Close the current job
local success = CloseCurrentJob()
if not success then
    return {
        status = "error",
        result = {
            message = "Failed to close job or no job was open",
            type = "state_error"
        }
    }
end

return {
    status = "success",
    result = {
        message = "Job closed successfully"
    }
}
"""

    @staticmethod
    def get_job_properties() -> str:
        """
        Generate code to get properties of the current job.
        
        Returns:
            Lua code for retrieving job properties
        """
        return """
-- Check if a job exists
if not JobExists() then
    return {
        status = "error",
        result = {
            message = "No job is currently open",
            type = "state_error"
        }
    }
end

-- Get job properties
local properties = {}
properties.name = GetJobName()
properties.file_path = GetJobFilePath()
properties.width = GetJobWidth()
properties.height = GetJobHeight()
properties.thickness = GetMaterialThickness()
properties.units = GetJobUnits()
properties.is_rotary = IsRotaryJob()
properties.is_two_sided = IsTwoSidedJob()

-- Get material block information
local material_block = GetMaterialBlock()
if material_block then
    properties.material = {
        thickness = material_block:GetThickness(),
        x_min = material_block:GetXMin(),
        y_min = material_block:GetYMin(),
        z_min = material_block:GetZMin(),
        x_max = material_block:GetXMax(),
        y_max = material_block:GetYMax(),
        z_max = material_block:GetZMax()
    }
end

-- Get number of objects
properties.num_vectors = GetNumVectors()
properties.num_components = GetNumComponents()
properties.num_toolpaths = GetNumToolpaths()

return {
    status = "success",
    result = {
        message = "Job properties retrieved successfully",
        data = properties
    }
}
"""

    @staticmethod
    def import_vectors(file_path: str, merge_vectors: bool = True, 
                       center_design: bool = False) -> str:
        """
        Generate code to import vectors from a file.
        
        Args:
            file_path: Path to the vector file (.dxf, .svg, etc.)
            merge_vectors: Whether to merge vectors when possible
            center_design: Whether to center the imported design
            
        Returns:
            Lua code for importing vectors
        """
        # Escape backslashes for Lua
        escaped_path = file_path.replace("\\", "\\\\")
        
        return f"""
-- Import vectors from a file
local import_options = {{
    merge_vectors = {str(merge_vectors).lower()},
    center_design = {str(center_design).lower()}
}}

local success, vectors = ImportVectorsFromFile("{escaped_path}", import_options)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to import vectors from: {escaped_path}",
            type = "file_error"
        }}
    }}
end

-- Get information about imported vectors
local vector_info = {{
    count = #vectors,
    bounds = GetVectorsBoundingBox(vectors)
}}

return {{
    status = "success",
    result = {{
        message = "Vectors imported successfully",
        data = {{
            file_path = "{escaped_path}",
            vector_info = vector_info
        }}
    }}
}}
"""

    @staticmethod
    def export_vectors(file_path: str, format: str = "dxf", 
                       selected_only: bool = False) -> str:
        """
        Generate code to export vectors to a file.
        
        Args:
            file_path: Path where to export the vectors
            format: Export format ('dxf', 'svg', 'eps', etc.)
            selected_only: Whether to export only selected vectors
            
        Returns:
            Lua code for exporting vectors
        """
        # Escape backslashes for Lua
        escaped_path = file_path.replace("\\", "\\\\")
        
        return f"""
-- Export vectors to a file
local export_options = {{
    format = "{format}",
    selected_only = {str(selected_only).lower()}
}}

local success = ExportVectorsToFile("{escaped_path}", export_options)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to export vectors to: {escaped_path}",
            type = "file_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Vectors exported successfully",
        data = {{
            file_path = "{escaped_path}",
            format = "{format}"
        }}
    }}
}}
"""

    @staticmethod
    def export_toolpaths(file_path: str, format: str = "nc", 
                         post_processor: str = "Default", 
                         selected_only: bool = False) -> str:
        """
        Generate code to export toolpaths.
        
        Args:
            file_path: Path where to export the toolpaths
            format: Export format ('nc', 'tap', 'gcode', etc.)
            post_processor: Name of the post processor to use
            selected_only: Whether to export only selected toolpaths
            
        Returns:
            Lua code for exporting toolpaths
        """
        # Escape backslashes for Lua
        escaped_path = file_path.replace("\\", "\\\\")
        
        return f"""
-- Export toolpaths to a file
local export_options = {{
    format = "{format}",
    post_processor = "{post_processor}",
    selected_only = {str(selected_only).lower()}
}}

local success = ExportToolpaths("{escaped_path}", export_options)
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to export toolpaths to: {escaped_path}",
            type = "file_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Toolpaths exported successfully",
        data = {{
            file_path = "{escaped_path}",
            format = "{format}",
            post_processor = "{post_processor}"
        }}
    }}
}}
"""