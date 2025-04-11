"""
Vector Creation and Manipulation Templates for the Vectric environment.

This module provides templates for generating Lua code to create and
manipulate vector objects in the Vectric environment.
"""

class VectorTemplates:
    """Templates for vector creation and manipulation operations."""
    
    @staticmethod
    def create_circle(center_x: float, center_y: float, radius: float, 
                      layer_name: str = "Default Layer") -> str:
        """
        Generate code to create a circle.
        
        Args:
            center_x: X-coordinate of the circle center
            center_y: Y-coordinate of the circle center
            radius: Radius of the circle
            layer_name: Name of the layer to add the circle to
            
        Returns:
            Lua code for creating a circle
        """
        return f"""
-- Create a circle at the specified position
local circle = Circle({center_x}, {center_y}, {radius})
local success = AddVectorToJob(circle, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add circle to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Circle created successfully",
        data = {{
            center_x = {center_x},
            center_y = {center_y},
            radius = {radius},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_rectangle(x: float, y: float, width: float, height: float, 
                        corner_radius: float = 0.0, layer_name: str = "Default Layer") -> str:
        """
        Generate code to create a rectangle.
        
        Args:
            x: X-coordinate of the bottom-left corner
            y: Y-coordinate of the bottom-left corner
            width: Width of the rectangle
            height: Height of the rectangle
            corner_radius: Radius for rounded corners (0 for sharp corners)
            layer_name: Name of the layer to add the rectangle to
            
        Returns:
            Lua code for creating a rectangle
        """
        return f"""
-- Create a rectangle
local rect
if {corner_radius} > 0 then
    rect = CreateRoundedRectangle({x}, {y}, {width}, {height}, {corner_radius})
else
    rect = CreateRectangle({x}, {y}, {width}, {height})
end

local success = AddVectorToJob(rect, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add rectangle to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Rectangle created successfully",
        data = {{
            x = {x},
            y = {y},
            width = {width},
            height = {height},
            corner_radius = {corner_radius},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_polygon(center_x: float, center_y: float, radius: float, num_sides: int, 
                       rotation: float = 0.0, layer_name: str = "Default Layer") -> str:
        """
        Generate code to create a regular polygon.
        
        Args:
            center_x: X-coordinate of the polygon center
            center_y: Y-coordinate of the polygon center
            radius: Radius of the polygon (distance from center to vertices)
            num_sides: Number of sides of the polygon
            rotation: Rotation angle in degrees
            layer_name: Name of the layer to add the polygon to
            
        Returns:
            Lua code for creating a polygon
        """
        return f"""
-- Create a regular polygon
local polygon = CreatePolygon({center_x}, {center_y}, {radius}, {num_sides}, {rotation})
local success = AddVectorToJob(polygon, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add polygon to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Polygon created successfully",
        data = {{
            center_x = {center_x},
            center_y = {center_y},
            radius = {radius},
            num_sides = {num_sides},
            rotation = {rotation},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_ellipse(center_x: float, center_y: float, radius_x: float, 
                       radius_y: float, rotation: float = 0.0, 
                       layer_name: str = "Default Layer") -> str:
        """
        Generate code to create an ellipse.
        
        Args:
            center_x: X-coordinate of the ellipse center
            center_y: Y-coordinate of the ellipse center
            radius_x: X-axis radius of the ellipse
            radius_y: Y-axis radius of the ellipse
            rotation: Rotation angle in degrees
            layer_name: Name of the layer to add the ellipse to
            
        Returns:
            Lua code for creating an ellipse
        """
        return f"""
-- Create an ellipse
local ellipse = CreateEllipse({center_x}, {center_y}, {radius_x}, {radius_y}, {rotation})
local success = AddVectorToJob(ellipse, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add ellipse to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Ellipse created successfully",
        data = {{
            center_x = {center_x},
            center_y = {center_y},
            radius_x = {radius_x},
            radius_y = {radius_y},
            rotation = {rotation},
            layer = "{layer_name}"
        }}
    }}
}}
"""
    
    @staticmethod
    def create_text(text: str, x: float, y: float, font_name: str = "Arial",
                    font_size: float = 12.0, height: float = 0.0, bold: bool = False,
                    italic: bool = False, alignment: str = "Left",
                    layer_name: str = "Default Layer") -> str:
        """
        Generate code to create text.
        
        Args:
            text: Text content
            x: X-coordinate for the text position
            y: Y-coordinate for the text position
            font_name: Name of the font
            font_size: Size of the font
            height: 3D height for the text (0 for 2D text)
            bold: Whether the text should be bold
            italic: Whether the text should be italic
            alignment: Text alignment ('Left', 'Center', or 'Right')
            layer_name: Name of the layer to add the text to
            
        Returns:
            Lua code for creating text
        """
        # Convert Python alignment to Vectric enum values
        alignment_map = {
            "Left": "TextAlignment.LEFT",
            "Center": "TextAlignment.CENTER",
            "Right": "TextAlignment.RIGHT"
        }
        
        alignment_value = alignment_map.get(alignment, "TextAlignment.LEFT")
        
        return f"""
-- Create text
local text_obj = CreateText("{text}", {font_size}, "{font_name}", {str(bold).lower()}, {str(italic).lower()}, {alignment_value})
if not text_obj then
    return {{
        status = "error",
        result = {{
            message = "Failed to create text object",
            type = "runtime_error"
        }}
    }}
end

-- Apply 3D height if specified
if {height} > 0 then
    text_obj:SetHeight({height})
end

-- Position the text
text_obj:MoveTo({x}, {y})

-- Add to job
local success = AddVectorToJob(text_obj, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add text to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Text created successfully",
        data = {{
            text = "{text}",
            x = {x},
            y = {y},
            font_name = "{font_name}",
            font_size = {font_size},
            height = {height},
            bold = {str(bold).lower()},
            italic = {str(italic).lower()},
            alignment = "{alignment}",
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_arc(center_x: float, center_y: float, radius: float, 
                  start_angle: float, end_angle: float, 
                  layer_name: str = "Default Layer") -> str:
        """
        Generate code to create an arc.
        
        Args:
            center_x: X-coordinate of the arc center
            center_y: Y-coordinate of the arc center
            radius: Radius of the arc
            start_angle: Start angle in degrees
            end_angle: End angle in degrees
            layer_name: Name of the layer to add the arc to
            
        Returns:
            Lua code for creating an arc
        """
        return f"""
-- Create an arc
local arc = CreateArc({center_x}, {center_y}, {radius}, {start_angle}, {end_angle})
local success = AddVectorToJob(arc, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add arc to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Arc created successfully",
        data = {{
            center_x = {center_x},
            center_y = {center_y},
            radius = {radius},
            start_angle = {start_angle},
            end_angle = {end_angle},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_polyline(points: list, closed: bool = True, 
                      layer_name: str = "Default Layer") -> str:
        """
        Generate code to create a polyline.
        
        Args:
            points: List of points as [[x1, y1], [x2, y2], ...]
            closed: Whether the polyline should be closed
            layer_name: Name of the layer to add the polyline to
            
        Returns:
            Lua code for creating a polyline
        """
        # Convert Python list to Lua table format
        points_str = "{\n"
        for point in points:
            points_str += f"        {{ {point[0]}, {point[1]} }},\n"
        points_str += "    }"
        
        return f"""
-- Create a polyline
local points = {points_str}
local polyline = CreatePolyline(points, {str(closed).lower()})
local success = AddVectorToJob(polyline, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add polyline to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Polyline created successfully",
        data = {{
            num_points = {len(points)},
            closed = {str(closed).lower()},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def create_bezier_curve(points: list, closed: bool = False, 
                          layer_name: str = "Default Layer") -> str:
        """
        Generate code to create a Bezier curve.
        
        Args:
            points: List of points as [[x1, y1], [x2, y2], ...]
                   For Bezier curves, points should include control points
            closed: Whether the curve should be closed
            layer_name: Name of the layer to add the curve to
            
        Returns:
            Lua code for creating a Bezier curve
        """
        # Convert Python list to Lua table format
        points_str = "{\n"
        for point in points:
            points_str += f"        {{ {point[0]}, {point[1]} }},\n"
        points_str += "    }"
        
        return f"""
-- Create a Bezier curve
local points = {points_str}
local bezier = CreateBezierCurve(points, {str(closed).lower()})
local success = AddVectorToJob(bezier, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add Bezier curve to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Bezier curve created successfully",
        data = {{
            num_points = {len(points)},
            closed = {str(closed).lower()},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def boolean_operation(vector_ids: list, operation: str = "Union", 
                         layer_name: str = "Default Layer") -> str:
        """
        Generate code to perform a boolean operation on vectors.
        
        Args:
            vector_ids: List of vector IDs to apply operation to
            operation: Boolean operation ('Union', 'Subtraction', 'Intersection', or 'Weld')
            layer_name: Name of the layer for the resulting vector
            
        Returns:
            Lua code for performing a boolean operation
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, vid in enumerate(vector_ids):
            ids_str += f"{vid}"
            if i < len(vector_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        # Map operation names to Vectric enum values
        operation_map = {
            "Union": "BooleanOperation.UNION",
            "Subtraction": "BooleanOperation.SUBTRACTION",
            "Intersection": "BooleanOperation.INTERSECTION",
            "Weld": "BooleanOperation.WELD"
        }
        
        operation_value = operation_map.get(operation, "BooleanOperation.UNION")
        
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

-- Check if we have enough vectors
if #vectors < 2 then
    return {{
        status = "error",
        result = {{
            message = "At least two vectors are required for a boolean operation",
            type = "validation_error"
        }}
    }}
end

-- Perform the boolean operation
local result = PerformBooleanOperation(vectors, {operation_value})
if not result then
    return {{
        status = "error",
        result = {{
            message = "Boolean operation failed",
            type = "runtime_error"
        }}
    }}
end

-- Add the result to the job
local success = AddVectorToJob(result, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add result to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "{operation} operation completed successfully",
        data = {{
            operation = "{operation}",
            vector_ids = {ids_str},
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def offset_vector(vector_id: int, offset: float, corner_type: str = "Round", 
                     layer_name: str = "Default Layer") -> str:
        """
        Generate code to offset a vector.
        
        Args:
            vector_id: ID of the vector to offset
            offset: Distance to offset (positive for outward, negative for inward)
            corner_type: Type of corners ('Round', 'Square', or 'Miter')
            layer_name: Name of the layer for the resulting vector
            
        Returns:
            Lua code for offsetting a vector
        """
        # Map corner types to Vectric enum values
        corner_map = {
            "Round": "OffsetCornerType.ROUND",
            "Square": "OffsetCornerType.SQUARE",
            "Miter": "OffsetCornerType.MITER"
        }
        
        corner_value = corner_map.get(corner_type, "OffsetCornerType.ROUND")
        
        return f"""
-- Get vector by ID
local vector = GetVectorById({vector_id})
if not vector then
    return {{
        status = "error",
        result = {{
            message = "Vector with ID {vector_id} not found",
            type = "not_found_error"
        }}
    }}
end

-- Offset the vector
local offset_vector = OffsetVector(vector, {offset}, {corner_value})
if not offset_vector then
    return {{
        status = "error",
        result = {{
            message = "Offset operation failed",
            type = "runtime_error"
        }}
    }}
end

-- Add the offset vector to the job
local success = AddVectorToJob(offset_vector, "{layer_name}")
if not success then
    return {{
        status = "error",
        result = {{
            message = "Failed to add offset vector to job",
            type = "runtime_error"
        }}
    }}
end

return {{
    status = "success",
    result = {{
        message = "Vector offset successfully",
        data = {{
            original_vector_id = {vector_id},
            offset = {offset},
            corner_type = "{corner_type}",
            layer = "{layer_name}"
        }}
    }}
}}
"""

    @staticmethod
    def transform_vectors(vector_ids: list, transform_type: str, params: dict,
                        layer_name: str = "Default Layer") -> str:
        """
        Generate code to transform vectors.
        
        Args:
            vector_ids: List of vector IDs to transform
            transform_type: Type of transformation ('Move', 'Rotate', 'Scale', 'Mirror')
            params: Transformation parameters
                   For Move: {'dx': float, 'dy': float}
                   For Rotate: {'angle': float, 'center_x': float, 'center_y': float}
                   For Scale: {'scale_x': float, 'scale_y': float, 'center_x': float, 'center_y': float}
                   For Mirror: {'axis': str (X/Y), 'position': float}
            layer_name: Name of the layer for the resulting vectors
            
        Returns:
            Lua code for transforming vectors
        """
        # Convert Python list to Lua table format
        ids_str = "{"
        for i, vid in enumerate(vector_ids):
            ids_str += f"{vid}"
            if i < len(vector_ids) - 1:
                ids_str += ", "
        ids_str += "}"
        
        transform_code = ""
        result_message = ""
        
        if transform_type == "Move":
            dx = params.get("dx", 0.0)
            dy = params.get("dy", 0.0)
            transform_code = f"""
    -- Move vectors
    local matrix = TranslationMatrix2D({dx}, {dy})
    TransformVectors(vectors, matrix)
"""
            result_message = f"Vectors moved by ({dx}, {dy})"
        
        elif transform_type == "Rotate":
            angle = params.get("angle", 0.0)
            center_x = params.get("center_x", 0.0)
            center_y = params.get("center_y", 0.0)
            transform_code = f"""
    -- Move to origin, rotate, then move back
    local to_origin = TranslationMatrix2D(-{center_x}, -{center_y})
    local rotation = RotationMatrix2D({angle})
    local from_origin = TranslationMatrix2D({center_x}, {center_y})
    
    -- Combine transformations: to_origin * rotation * from_origin
    local matrix = MatrixMultiply(to_origin, rotation)
    matrix = MatrixMultiply(matrix, from_origin)
    
    TransformVectors(vectors, matrix)
"""
            result_message = f"Vectors rotated by {angle} degrees around ({center_x}, {center_y})"
        
        elif transform_type == "Scale":
            scale_x = params.get("scale_x", 1.0)
            scale_y = params.get("scale_y", 1.0)
            center_x = params.get("center_x", 0.0)
            center_y = params.get("center_y", 0.0)
            transform_code = f"""
    -- Move to origin, scale, then move back
    local to_origin = TranslationMatrix2D(-{center_x}, -{center_y})
    local scaling = ScalingMatrix2D({scale_x}, {scale_y})
    local from_origin = TranslationMatrix2D({center_x}, {center_y})
    
    -- Combine transformations: to_origin * scaling * from_origin
    local matrix = MatrixMultiply(to_origin, scaling)
    matrix = MatrixMultiply(matrix, from_origin)
    
    TransformVectors(vectors, matrix)
"""
            result_message = f"Vectors scaled by ({scale_x}, {scale_y}) from ({center_x}, {center_y})"
        
        elif transform_type == "Mirror":
            axis = params.get("axis", "X")
            position = params.get("position", 0.0)
            
            if axis.upper() == "X":
                transform_code = f"""
    -- Mirror across X axis at specified position
    local to_axis = TranslationMatrix2D(0, -{position})
    local mirror = ScalingMatrix2D(1, -1)
    local from_axis = TranslationMatrix2D(0, {position})
    
    -- Combine transformations
    local matrix = MatrixMultiply(to_axis, mirror)
    matrix = MatrixMultiply(matrix, from_axis)
    
    TransformVectors(vectors, matrix)
"""
                result_message = f"Vectors mirrored across X axis at y={position}"
            else:  # Y axis
                transform_code = f"""
    -- Mirror across Y axis at specified position
    local to_axis = TranslationMatrix2D(-{position}, 0)
    local mirror = ScalingMatrix2D(-1, 1)
    local from_axis = TranslationMatrix2D({position}, 0)
    
    -- Combine transformations
    local matrix = MatrixMultiply(to_axis, mirror)
    matrix = MatrixMultiply(matrix, from_axis)
    
    TransformVectors(vectors, matrix)
"""
                result_message = f"Vectors mirrored across Y axis at x={position}"
        
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

-- Create copies of the vectors so we don't modify originals
local transformed_vectors = {{}}
for i, vector in ipairs(vectors) do
    table.insert(transformed_vectors, vector:Clone())
end
{transform_code}
-- Add the transformed vectors to the job
for i, vector in ipairs(transformed_vectors) do
    local success = AddVectorToJob(vector, "{layer_name}")
    if not success then
        return {{
            status = "error",
            result = {{
                message = "Failed to add transformed vector to job",
                type = "runtime_error"
            }}
        }}
    end
end

return {{
    status = "success",
    result = {{
        message = "{result_message}",
        data = {{
            transform_type = "{transform_type}",
            vector_count = #vector_ids,
            layer = "{layer_name}"
        }}
    }}
}}
"""