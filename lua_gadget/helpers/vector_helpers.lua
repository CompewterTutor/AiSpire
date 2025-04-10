--[[
    Vector Drawing Helpers

    This module provides helper functions for vector drawing in Vectric Aspire/V-Carve.
    Functions include drawing lines, arcs, curves, text, and adding dimensions and measurements.
]]--

local VectorHelpers = {}

-- Creates a straight line between two points
-- @param x1 - X coordinate of the start point
-- @param y1 - Y coordinate of the start point
-- @param x2 - X coordinate of the end point
-- @param y2 - Y coordinate of the end point
-- @return Contour object representing the line
function VectorHelpers.createLine(x1, y1, x2, y2)
    if not x1 or not y1 or not x2 or not y2 then
        error("Missing parameters for line creation: x1, y1, x2, and y2 are required")
    end
    
    local contour = Contour:new()
    contour:AppendPoint(x1, y1)
    contour:AppendLineTo(x2, y2)
    
    return contour
end

-- Creates an arc between two points with specified bulge
-- @param x1 - X coordinate of the start point
-- @param y1 - Y coordinate of the start point
-- @param x2 - X coordinate of the end point
-- @param y2 - Y coordinate of the end point
-- @param bulge - Bulge factor (0 = straight line, 1 = semicircle)
-- @return Contour object representing the arc
function VectorHelpers.createArc(x1, y1, x2, y2, bulge)
    if not x1 or not y1 or not x2 or not y2 or not bulge then
        error("Missing parameters for arc creation: x1, y1, x2, y2, and bulge are required")
    end
    
    local contour = Contour:new()
    contour:AppendPoint(x1, y1)
    contour:AppendArcTo(x2, y2, bulge)
    
    return contour
end

-- Creates a circular arc defined by center, radius, start angle, and end angle
-- @param centerX - X coordinate of the arc center
-- @param centerY - Y coordinate of the arc center
-- @param radius - Radius of the arc
-- @param startAngle - Starting angle in degrees
-- @param endAngle - Ending angle in degrees
-- @param clockwise - Boolean indicating direction (true = clockwise, false = counterclockwise)
-- @return Contour object representing the arc
function VectorHelpers.createArcByCenterRadius(centerX, centerY, radius, startAngle, endAngle, clockwise)
    if not centerX or not centerY or not radius or not startAngle or not endAngle then
        error("Missing parameters for arc creation by center and radius")
    end
    
    if radius <= 0 then
        error("Arc radius must be greater than 0")
    end
    
    -- Convert degrees to radians
    local startRad = math.rad(startAngle)
    local endRad = math.rad(endAngle)
    
    -- Ensure proper arc direction
    if clockwise and startRad < endRad then
        endRad = endRad - 2 * math.pi
    elseif not clockwise and startRad > endRad then
        endRad = endRad + 2 * math.pi
    end
    
    -- Calculate start point
    local x1 = centerX + radius * math.cos(startRad)
    local y1 = centerY + radius * math.sin(startRad)
    
    -- Calculate end point
    local x2 = centerX + radius * math.cos(endRad)
    local y2 = centerY + radius * math.sin(endRad)
    
    -- Calculate bulge
    local arcAngle = endRad - startRad
    if clockwise then arcAngle = -arcAngle end
    local bulge = math.tan(arcAngle / 4)
    
    -- Create the arc contour
    local contour = Contour:new()
    contour:AppendPoint(x1, y1)
    contour:AppendArcTo(x2, y2, bulge)
    
    return contour
end

-- Creates a Bezier curve between two points with control points
-- @param x1 - X coordinate of the start point
-- @param y1 - Y coordinate of the start point
-- @param x2 - X coordinate of the end point
-- @param y2 - Y coordinate of the end point
-- @param ctrl1x - X coordinate of the first control point
-- @param ctrl1y - Y coordinate of the first control point
-- @param ctrl2x - X coordinate of the second control point
-- @param ctrl2y - Y coordinate of the second control point
-- @return Contour object representing the Bezier curve
function VectorHelpers.createBezierCurve(x1, y1, x2, y2, ctrl1x, ctrl1y, ctrl2x, ctrl2y)
    if not x1 or not y1 or not x2 or not y2 or
       not ctrl1x or not ctrl1y or not ctrl2x or not ctrl2y then
        error("Missing parameters for Bezier curve creation")
    end
    
    local contour = Contour:new()
    contour:AppendPoint(x1, y1)
    contour:AppendBezierTo(x2, y2, ctrl1x, ctrl1y, ctrl2x, ctrl2y)
    
    return contour
end

-- Creates a polyline from a series of points
-- @param points - Array of points, where each point is a table with x,y coordinates
-- @param closed - Boolean indicating whether to close the polyline (optional, default: false)
-- @return Contour object representing the polyline
function VectorHelpers.createPolyline(points, closed)
    if not points or #points < 2 then
        error("At least 2 points are required for polyline creation")
    end
    
    local contour = Contour:new()
    
    -- Add the first point
    contour:AppendPoint(points[1].x, points[1].y)
    
    -- Add the remaining points
    for i = 2, #points do
        contour:AppendLineTo(points[i].x, points[i].y)
    end
    
    -- Close the polyline if requested
    if closed then
        contour:Close()
    end
    
    return contour
end

-- Creates text at a specified position with styling options
-- @param x - X coordinate for text placement
-- @param y - Y coordinate for text placement
-- @param text - The text string to create
-- @param options - Optional table with styling options:
--                  font (string), size (number), bold (boolean), italic (boolean),
--                  alignment (string: "left", "center", "right"),
--                  vAlignment (string: "top", "middle", "bottom"),
--                  angle (number: rotation angle in degrees)
-- @return Text object
function VectorHelpers.createText(x, y, text, options)
    if not x or not y or not text then
        error("Missing parameters for text creation: x, y, and text are required")
    end
    
    options = options or {}
    
    -- Create text object
    local textObj = Text:new()
    
    -- Set font properties
    local fontName = options.font or "Arial"
    local fontSize = options.size or 12
    local bold = options.bold or false
    local italic = options.italic or false
    textObj:SetFont(fontName, fontSize, bold, italic)
    
    -- Set text content
    textObj:SetText(text)
    
    -- Set alignment if specified
    if options.alignment then
        local alignmentMap = {
            left = 0,
            center = 1,
            right = 2
        }
        local alignmentValue = alignmentMap[string.lower(options.alignment)] or 0
        textObj:SetAlignment(alignmentValue)
    end
    
    -- Set vertical alignment if specified
    if options.vAlignment then
        local vAlignmentMap = {
            top = 0,
            middle = 1,
            bottom = 2
        }
        local vAlignmentValue = vAlignmentMap[string.lower(options.vAlignment)] or 0
        textObj:SetVerticalPosition(vAlignmentValue)
    end
    
    -- Set rotation angle if specified
    if options.angle then
        textObj:SetOrientation(options.angle)
    end
    
    -- Draw the text at the specified position
    textObj:DrawAtPosition(x, y)
    
    return textObj
end

-- Creates a linear dimension between two points
-- @param x1 - X coordinate of the first point
-- @param y1 - Y coordinate of the first point
-- @param x2 - X coordinate of the second point
-- @param y2 - Y coordinate of the second point
-- @param offset - Offset distance for the dimension line
-- @param options - Optional table with styling options:
--                  units (string: "mm", "inch"), precision (number),
--                  arrowSize (number), textHeight (number)
-- @return Group object containing the dimension elements
function VectorHelpers.createLinearDimension(x1, y1, x2, y2, offset, options)
    if not x1 or not y1 or not x2 or not y2 or not offset then
        error("Missing parameters for linear dimension creation")
    end
    
    options = options or {}
    
    -- Calculate dimension line perpendicular to the measurement line
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx*dx + dy*dy)
    
    if length < 0.001 then
        error("Points are too close for dimensioning")
    end
    
    -- Calculate normal vector (perpendicular to the line)
    local nx = -dy / length
    local ny = dx / length
    
    -- Calculate dimension line endpoints
    local dim1x = x1 + nx * offset
    local dim1y = y1 + ny * offset
    local dim2x = x2 + nx * offset
    local dim2y = y2 + ny * offset
    
    -- Create extension lines
    local extLine1 = VectorHelpers.createLine(x1, y1, dim1x, dim1y)
    local extLine2 = VectorHelpers.createLine(x2, y2, dim2x, dim2y)
    
    -- Create dimension line
    local dimLine = VectorHelpers.createLine(dim1x, dim1y, dim2x, dim2y)
    
    -- Create measurement text
    local textX = (dim1x + dim2x) / 2
    local textY = (dim1y + dim2y) / 2
    local units = options.units or "mm"
    local precision = options.precision or 1
    local measurement = string.format("%." .. precision .. "f %s", length, units)
    
    local textOptions = {
        size = options.textHeight or 5,
        alignment = "center",
        vAlignment = "middle"
    }
    
    local measurementText = VectorHelpers.createText(textX, textY, measurement, textOptions)
    
    -- In a real implementation, we would create a Group object to hold all elements
    -- For now, we'll return the dimension line as a representative for the whole group
    -- In a real Vectric implementation, this would return a proper Group object
    
    return dimLine  -- This is a placeholder that would actually return a Group
end

-- Creates an angular dimension between three points
-- @param x1 - X coordinate of the first point (start of first line)
-- @param y1 - Y coordinate of the first point
-- @param x2 - X coordinate of the second point (vertex)
-- @param y2 - Y coordinate of the second point
-- @param x3 - X coordinate of the third point (end of second line)
-- @param y3 - Y coordinate of the third point
-- @param radius - Radius for the dimension arc
-- @param options - Optional table with styling options
-- @return Group object containing the dimension elements
function VectorHelpers.createAngularDimension(x1, y1, x2, y2, x3, y3, radius, options)
    if not x1 or not y1 or not x2 or not y2 or not x3 or not y3 or not radius then
        error("Missing parameters for angular dimension creation")
    end
    
    options = options or {}
    
    -- Calculate vectors
    local v1x = x1 - x2
    local v1y = y1 - y2
    local v2x = x3 - x2
    local v2y = y3 - y2
    
    -- Calculate the angle between vectors
    local angle1 = math.atan2(v1y, v1x)
    local angle2 = math.atan2(v2y, v2x)
    
    -- Calculate the included angle
    local includedAngle = angle2 - angle1
    while includedAngle < 0 do includedAngle = includedAngle + 2 * math.pi end
    while includedAngle > 2 * math.pi do includedAngle = includedAngle - 2 * math.pi end
    
    -- Create dimension arc
    local arc = VectorHelpers.createArcByCenterRadius(
        x2, y2, radius, 
        math.deg(angle1), math.deg(angle2), 
        false
    )
    
    -- Calculate text position
    local midAngle = angle1 + includedAngle / 2
    local textX = x2 + radius * 1.2 * math.cos(midAngle)
    local textY = y2 + radius * 1.2 * math.sin(midAngle)
    
    -- Create text
    local degrees = math.deg(includedAngle)
    local measurement = string.format("%.1f°", degrees)
    local textOptions = {
        size = options.textHeight or 5,
        alignment = "center",
        vAlignment = "middle"
    }
    local measurementText = VectorHelpers.createText(textX, textY, measurement, textOptions)
    
    -- In a real implementation, we would create a Group object
    -- For now, return the arc as a representative for the whole group
    
    return arc  -- This is a placeholder that would actually return a Group
end

-- Draws a horizontal or vertical guide line
-- @param position - Position value (x for vertical guide, y for horizontal guide)
-- @param isHorizontal - Boolean indicating guide orientation (true = horizontal, false = vertical)
-- @param locked - Boolean indicating whether the guide should be locked (optional, default: false)
-- @return Boolean indicating success
function VectorHelpers.createGuide(position, isHorizontal, locked)
    if position == nil then
        error("Position is required for guide creation")
    end
    
    locked = locked or false
    
    if isHorizontal then
        return VectricJob.CreateHorizontalGuide(position, locked)
    else
        return VectricJob.CreateVerticalGuide(position, locked)
    end
end

return VectorHelpers
