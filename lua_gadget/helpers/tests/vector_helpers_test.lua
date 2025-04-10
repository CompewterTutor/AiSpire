local VectorHelpers = require("lua_gadget.helpers.vector_helpers")

-- Mock Vectric SDK objects similar to PathHelpers tests
local MockContour = {
    appendedPoints = {},
    isClosed = false,
    
    new = function(self)
        local o = {
            appendedPoints = {},
            isClosed = false
        }
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    
    AppendPoint = function(self, x, y)
        table.insert(self.appendedPoints, {x = x, y = y, type = "point"})
        return self
    end,
    
    AppendLineTo = function(self, x, y)
        table.insert(self.appendedPoints, {x = x, y = y, type = "line"})
        return self
    end,
    
    AppendArcTo = function(self, x, y, bulge)
        table.insert(self.appendedPoints, {x = x, y = y, type = "arc", bulge = bulge})
        return self
    end,
    
    AppendBezierTo = function(self, x, y, ctrl1x, ctrl1y, ctrl2x, ctrl2y)
        table.insert(self.appendedPoints, {
            x = x, y = y, 
            type = "bezier",
            ctrl1x = ctrl1x, ctrl1y = ctrl1y,
            ctrl2x = ctrl2x, ctrl2y = ctrl2y
        })
        return self
    end,
    
    Close = function(self)
        self.isClosed = true
        return self
    end
}

-- Mock text object
local MockText = {
    properties = {},
    
    new = function(self)
        local o = {
            properties = {
                font = "Arial",
                size = 12,
                bold = false,
                italic = false,
                text = "",
                alignment = 0,
                verticalPosition = 0,
                orientation = 0,
                position = {x = 0, y = 0}
            }
        }
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    
    SetFont = function(self, name, size, bold, italic)
        self.properties.font = name
        self.properties.size = size
        self.properties.bold = bold
        self.properties.italic = italic
        return self
    end,
    
    SetText = function(self, text)
        self.properties.text = text
        return self
    end,
    
    SetAlignment = function(self, alignment)
        self.properties.alignment = alignment
        return self
    end,
    
    SetVerticalPosition = function(self, position)
        self.properties.verticalPosition = position
        return self
    end,
    
    SetOrientation = function(self, angle)
        self.properties.orientation = angle
        return self
    end,
    
    DrawAtPosition = function(self, x, y)
        self.properties.position = {x = x, y = y}
        return self
    end,
    
    GetBoundingBox = function(self)
        -- Return a simple bounding box based on text length
        local width = string.len(self.properties.text) * self.properties.size * 0.6
        local height = self.properties.size * 1.2
        return {
            minX = self.properties.position.x,
            minY = self.properties.position.y,
            maxX = self.properties.position.x + width,
            maxY = self.properties.position.y + height
        }
    end
}

-- Mock VectricJob functions
VectricJob = {
    CreateHorizontalGuide = function(y_value, locked)
        return true
    end,
    CreateVerticalGuide = function(x_value, locked)
        return true
    end
}

-- Replace global objects with our mocks
Contour = MockContour
Text = MockText

describe("VectorHelpers", function()
    describe("createLine", function()
        it("creates a line contour with the specified parameters", function()
            local line = VectorHelpers.createLine(10, 20, 30, 40)
            
            -- Check that we have a start point and an end point
            assert.are.equal(2, #line.appendedPoints)
            
            -- Check start point
            assert.are.equal(10, line.appendedPoints[1].x)
            assert.are.equal(20, line.appendedPoints[1].y)
            
            -- Check end point
            assert.are.equal(30, line.appendedPoints[2].x)
            assert.are.equal(40, line.appendedPoints[2].y)
            assert.are.equal("line", line.appendedPoints[2].type)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() VectorHelpers.createLine() end)
        end)
    end)
    
    describe("createArc", function()
        it("creates an arc contour with the specified parameters", function()
            local arc = VectorHelpers.createArc(10, 20, 30, 40, 0.5)
            
            -- Check that we have a start point and an end point
            assert.are.equal(2, #arc.appendedPoints)
            
            -- Check start point
            assert.are.equal(10, arc.appendedPoints[1].x)
            assert.are.equal(20, arc.appendedPoints[1].y)
            
            -- Check end point
            assert.are.equal(30, arc.appendedPoints[2].x)
            assert.are.equal(40, arc.appendedPoints[2].y)
            assert.are.equal("arc", arc.appendedPoints[2].type)
            assert.are.equal(0.5, arc.appendedPoints[2].bulge)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() VectorHelpers.createArc() end)
        end)
    end)
    
    describe("createBezierCurve", function()
        it("creates a bezier curve with the specified parameters", function()
            local curve = VectorHelpers.createBezierCurve(10, 20, 100, 200, 30, 40, 80, 90)
            
            -- Check that we have a start point and an end point
            assert.are.equal(2, #curve.appendedPoints)
            
            -- Check start point
            assert.are.equal(10, curve.appendedPoints[1].x)
            assert.are.equal(20, curve.appendedPoints[1].y)
            
            -- Check end point and control points
            assert.are.equal(100, curve.appendedPoints[2].x)
            assert.are.equal(200, curve.appendedPoints[2].y)
            assert.are.equal("bezier", curve.appendedPoints[2].type)
            assert.are.equal(30, curve.appendedPoints[2].ctrl1x)
            assert.are.equal(40, curve.appendedPoints[2].ctrl1y)
            assert.are.equal(80, curve.appendedPoints[2].ctrl2x)
            assert.are.equal(90, curve.appendedPoints[2].ctrl2y)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() VectorHelpers.createBezierCurve() end)
        end)
    end)
    
    describe("createPolyline", function()
        it("creates a polyline with the specified points", function()
            local points = {
                {x = 10, y = 20},
                {x = 30, y = 40},
                {x = 50, y = 60},
                {x = 70, y = 80}
            }
            
            local polyline = VectorHelpers.createPolyline(points)
            
            -- Check that we have the correct number of points
            assert.are.equal(4, #polyline.appendedPoints)
            
            -- Check first point is a point and others are lines
            assert.are.equal("point", polyline.appendedPoints[1].type)
            assert.are.equal("line", polyline.appendedPoints[2].type)
            assert.are.equal("line", polyline.appendedPoints[3].type)
            assert.are.equal("line", polyline.appendedPoints[4].type)
            
            -- Check that polyline is not closed
            assert.is_false(polyline.isClosed)
            
            -- Create closed polyline
            local closedPolyline = VectorHelpers.createPolyline(points, true)
            assert.is_true(closedPolyline.isClosed)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() VectorHelpers.createPolyline() end)
            assert.has.errors(function() VectorHelpers.createPolyline({}) end)
            assert.has.errors(function() VectorHelpers.createPolyline({{x = 10, y = 20}}) end)
        end)
    end)
    
    describe("createText", function()
        it("creates text with the specified parameters", function()
            local text = VectorHelpers.createText(100, 200, "Hello World")
            
            -- Check basic properties
            assert.are.equal("Hello World", text.properties.text)
            assert.are.equal(100, text.properties.position.x)
            assert.are.equal(200, text.properties.position.y)
            
            -- Test with options
            local textWithOptions = VectorHelpers.createText(100, 200, "Hello World", {
                font = "Times New Roman",
                size = 18,
                bold = true,
                italic = true,
                alignment = "center",
                vAlignment = "middle",
                angle = 45
            })
            
            -- Check that options were applied
            assert.are.equal("Times New Roman", textWithOptions.properties.font)
            assert.are.equal(18, textWithOptions.properties.size)
            assert.is_true(textWithOptions.properties.bold)
            assert.is_true(textWithOptions.properties.italic)
            assert.are.equal(1, textWithOptions.properties.alignment) -- center = 1
            assert.are.equal(1, textWithOptions.properties.verticalPosition) -- middle = 1
            assert.are.equal(45, textWithOptions.properties.orientation)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() VectorHelpers.createText() end)
            assert.has.errors(function() VectorHelpers.createText(100) end)
            assert.has.errors(function() VectorHelpers.createText(100, 200) end)
        end)
    end)
    
    -- Add more tests for other functions
end)
