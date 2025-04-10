local PathHelpers = require("lua_gadget.helpers.path_helpers")

-- Mock Vectric SDK objects
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
    
    Close = function(self)
        self.isClosed = true
        return self
    end,
    
    Clone = function(self)
        local clone = MockContour:new()
        for _, point in ipairs(self.appendedPoints) do
            table.insert(clone.appendedPoints, {
                x = point.x,
                y = point.y,
                type = point.type,
                bulge = point.bulge
            })
        end
        clone.isClosed = self.isClosed
        return clone
    end
}

-- Replace global Contour with our mock
Contour = MockContour

-- Mock transformation
Transformation2D = {
    new = function(self)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    Translate = function(self, x, y) return self end,
    Scale = function(self, x, y) return self end
}

describe("PathHelpers", function()
    describe("createCircle", function()
        it("creates a circle contour with the specified parameters", function()
            local circle = PathHelpers.createCircle(100, 100, 50)
            
            -- Check that the circle starts at the right point (x + r, y)
            assert.are.equal(150, circle.appendedPoints[1].x)
            assert.are.equal(100, circle.appendedPoints[1].y)
            
            -- Check that there are two arcs that make up the circle
            assert.are.equal(3, #circle.appendedPoints)
            assert.are.equal("arc", circle.appendedPoints[2].type)
            assert.are.equal("arc", circle.appendedPoints[3].type)
            
            -- Check that the circle is closed
            assert.is_true(circle.isClosed)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() PathHelpers.createCircle() end)
            assert.has.errors(function() PathHelpers.createCircle(100, 100, 0) end)
            assert.has.errors(function() PathHelpers.createCircle(100, 100, -10) end)
        end)
    end)
    
    describe("createRectangle", function()
        it("creates a rectangle contour with the specified parameters", function()
            local rect = PathHelpers.createRectangle(10, 20, 100, 200)
            
            -- Check that we have 4 points
            assert.are.equal(4, #rect.appendedPoints)
            
            -- Check first point
            assert.are.equal(10, rect.appendedPoints[1].x)
            assert.are.equal(20, rect.appendedPoints[1].y)
            
            -- Check that subsequent points are lines
            assert.are.equal("line", rect.appendedPoints[2].type)
            assert.are.equal("line", rect.appendedPoints[3].type)
            assert.are.equal("line", rect.appendedPoints[4].type)
            
            -- Check that the rectangle is closed
            assert.is_true(rect.isClosed)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() PathHelpers.createRectangle() end)
        end)
    end)
    
    describe("createPolygon", function()
        it("creates a polygon contour with the specified parameters", function()
            local hexagon = PathHelpers.createPolygon(100, 100, 50, 6)
            
            -- Check that we have 6 points (1 initial + 5 lines)
            assert.are.equal(6, #hexagon.appendedPoints)
            
            -- Check that subsequent points are lines
            for i = 2, 6 do
                assert.are.equal("line", hexagon.appendedPoints[i].type)
            end
            
            -- Check that the polygon is closed
            assert.is_true(hexagon.isClosed)
        end)
        
        it("throws an error for invalid parameters", function()
            assert.has.errors(function() PathHelpers.createPolygon() end)
            assert.has.errors(function() PathHelpers.createPolygon(100, 100, 50, 2) end)
            assert.has.errors(function() PathHelpers.createPolygon(100, 100, 0, 6) end)
        end)
    end)
    
    -- Additional tests for other functions would go here
end)
