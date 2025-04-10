--[[
    Path Creation and Manipulation Helpers

    This module provides helper functions for creating and manipulating paths in Vectric Aspire/V-Carve.
    Functions include creating basic shapes like circles, rectangles, and polygons,
    as well as operations for path combining and manipulation.
]]--

local PathHelpers = {}

-- Creates a circle contour at the specified position with the given radius
-- @param centerX - X coordinate of the circle center
-- @param centerY - Y coordinate of the circle center
-- @param radius - Radius of the circle
-- @return Contour object representing the circle
function PathHelpers.createCircle(centerX, centerY, radius)
    if not centerX or not centerY or not radius then
        error("Missing parameters for circle creation: centerX, centerY, and radius are required")
    end
    
    if radius <= 0 then
        error("Circle radius must be greater than 0")
    end
    
    local contour = Contour:new()
    
    -- Start point at right-most point of circle (0 degrees)
    contour:AppendPoint(centerX + radius, centerY)
    
    -- Add arcs to complete the circle
    -- Full circle requires 2 semicircles with appropriate bulge
    -- Bulge = tan(included angle / 4), for a semicircle bulge = 1.0
    contour:AppendArcTo(centerX - radius, centerY, 1.0)
    contour:AppendArcTo(centerX + radius, centerY, 1.0)
    
    -- Close the contour
    contour:Close()
    
    return contour
end

-- Creates a rectangle contour with the specified dimensions
-- @param x1 - X coordinate of first corner
-- @param y1 - Y coordinate of first corner
-- @param x2 - X coordinate of opposite corner
-- @param y2 - Y coordinate of opposite corner
-- @return Contour object representing the rectangle
function PathHelpers.createRectangle(x1, y1, x2, y2)
    if not x1 or not y1 or not x2 or not y2 then
        error("Missing parameters for rectangle creation: x1, y1, x2, and y2 are required")
    end
    
    local contour = Contour:new()
    
    -- Start at first corner
    contour:AppendPoint(x1, y1)
    
    -- Add other corners in clockwise order
    contour:AppendLineTo(x2, y1)
    contour:AppendLineTo(x2, y2)
    contour:AppendLineTo(x1, y2)
    
    -- Close the contour
    contour:Close()
    
    return contour
end

-- Creates a regular polygon contour with the specified number of sides
-- @param centerX - X coordinate of the center
-- @param centerY - Y coordinate of the center
-- @param radius - Distance from center to vertices
-- @param sides - Number of sides (must be >= 3)
-- @param startAngle - Starting angle in degrees (default: 0)
-- @return Contour object representing the polygon
function PathHelpers.createPolygon(centerX, centerY, radius, sides, startAngle)
    if not centerX or not centerY or not radius or not sides then
        error("Missing parameters for polygon creation: centerX, centerY, radius, and sides are required")
    end
    
    if sides < 3 then
        error("Polygon must have at least 3 sides")
    end
    
    if radius <= 0 then
        error("Polygon radius must be greater than 0")
    }
    
    startAngle = startAngle or 0
    startAngle = math.rad(startAngle)
    
    local contour = Contour:new()
    
    -- Calculate angle increment between vertices
    local angleIncrement = 2 * math.pi / sides
    
    -- Calculate first point
    local x = centerX + radius * math.cos(startAngle)
    local y = centerY + radius * math.sin(startAngle)
    contour:AppendPoint(x, y)
    
    -- Add remaining vertices
    for i = 1, sides - 1 do
        local angle = startAngle + i * angleIncrement
        x = centerX + radius * math.cos(angle)
        y = centerY + radius * math.sin(angle)
        contour:AppendLineTo(x, y)
    end
    
    -- Close the contour
    contour:Close()
    
    return contour
end

-- Offsets a contour by a specified amount
-- @param contour - The contour to offset
-- @param offset - Offset distance (positive for outward, negative for inward)
-- @return New offset contour
function PathHelpers.offsetPath(contour, offset)
    if not contour or not offset then
        error("Missing parameters for path offsetting: contour and offset are required")
    end
    
    -- This is a placeholder that would use Vectric SDK's actual offset function
    -- In a real implementation, we would use the SDK's functionality
    
    -- For now, we'll create a simple implementation for demonstration
    local result = contour:Clone()
    -- Actual offset implementation would be here
    
    return result
end

-- Scales a contour by specified factors
-- @param contour - The contour to scale
-- @param scaleX - X scale factor
-- @param scaleY - Y scale factor (optional, defaults to scaleX for uniform scaling)
-- @param centerX - X coordinate of scaling center (optional, defaults to 0)
-- @param centerY - Y coordinate of scaling center (optional, defaults to 0)
-- @return New scaled contour
function PathHelpers.scalePath(contour, scaleX, scaleY, centerX, centerY)
    if not contour or not scaleX then
        error("Missing parameters for path scaling: contour and scaleX are required")
    }
    
    scaleY = scaleY or scaleX
    centerX = centerX or 0
    centerY = centerY or 0
    
    -- Clone the contour
    local result = contour:Clone()
    
    -- Create a transformation
    local transform = Transformation2D:new()
    
    -- Move to origin, scale, then move back
    transform:Translate(-centerX, -centerY)
    transform:Scale(scaleX, scaleY)
    transform:Translate(centerX, centerY)
    
    -- Apply transformation to result
    -- This is a placeholder - in the actual implementation,
    -- we would use the SDK's functionality to apply the transform
    
    return result
end

-- Combines two contours using a boolean operation
-- @param contour1 - First contour
-- @param contour2 - Second contour
-- @param operation - String indicating operation: "union", "intersection", "subtraction", "xor"
-- @return New contour resulting from the boolean operation
function PathHelpers.combineContours(contour1, contour2, operation)
    if not contour1 or not contour2 or not operation then
        error("Missing parameters for path combining: contour1, contour2, and operation are required")
    end
    
    if operation ~= "union" and operation ~= "intersection" and 
       operation ~= "subtraction" and operation ~= "xor" then
        error("Invalid operation: must be 'union', 'intersection', 'subtraction', or 'xor'")
    end
    
    -- This is a placeholder that would use Vectric SDK's actual boolean operations
    -- In a real implementation, we would call the appropriate SDK functions
    
    -- For now, just return a clone of the first contour
    return contour1:Clone()
end

return PathHelpers
