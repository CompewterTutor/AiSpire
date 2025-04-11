--[[
    AiSpire Server Standalone Runner
    
    This script allows running the AiSpire server outside of Vectric for testing purposes.
    It creates mock Vectric SDK objects and functions to simulate the Vectric environment.
    
    Usage: lua run_standalone_server.lua
    
    Author: Michael Morrissey
    Version: 0.1.0 (Development)
    Date: April 11, 2025
--]]

local socket = require("socket")

print("Starting AiSpire standalone server environment...")
print("Setting up mock Vectric SDK objects...")

-- Create mock Vectric SDK globals
Global = {}
function Global.MessageBox(message)
    print("[MessageBox] " .. message)
end
function Global.IsAspire()
    return true
end
function Global.GetAppVersion()
    return 10.5
end
function Global.GetBuildVersion()
    return 4200
end
function Global.GetDataLocation()
    return "/mock/data"
end
function Global.GetPostProcessorLocation()
    return "/mock/postprocessors"
end
function Global.GetToolDatabaseLocation()
    return "/mock/tooldb"
end
function Global.GetGadgetsLocation()
    return "/mock/gadgets"
end
function Global.CreateCircle(x, y, radius, tolerance, z_value)
    print(string.format("Creating circle at (%s, %s) with radius %s", x, y, radius))
    return {}  -- Return empty object representing circle
end

-- MaterialBlock mock object
MaterialBlock = {}
function MaterialBlock:GetWidth() return 500 end
function MaterialBlock:GetHeight() return 300 end
function MaterialBlock:GetThickness() return 25 end
function MaterialBlock:IsDoubleSided() return false end
function MaterialBlock:SetWidth(width) print("Setting material width to " .. width) end
function MaterialBlock:SetHeight(height) print("Setting material height to " .. height) end
function MaterialBlock:SetThickness(thickness) print("Setting material thickness to " .. thickness) end
function MaterialBlock:Update() print("Updating material block") end

-- Job mock object
Job = {}
function Job:GetJobWidth() return 500 end
function Job:GetJobHeight() return 300 end
function Job:GetMaterialBlock() return MaterialBlock end
function Job:GetName() return "Test Job" end
function Job:Save(pathname)
    print("Saving job to: " .. pathname)
    return true
end

-- VectricJob mock object
VectricJob = {}
function VectricJob.CreateNewJob(name, bounds, thickness, in_mm, origin_on_surface)
    print(string.format("Creating new job: %s, thickness: %s, in_mm: %s", name, thickness, in_mm))
    return true
end
function VectricJob.SaveCurrentJob()
    print("Saving current job")
    return true
end
function VectricJob.OpenExistingJob(pathname)
    print("Opening job from: " .. pathname)
    return true
end
function VectricJob.CloseCurrentJob()
    print("Closing current job")
    return true
end
VectricJob.Exists = true

-- Box2D mock object
function Box2D(x1, y1, x2, y2)
    return {
        minX = math.min(x1, x2),
        minY = math.min(y1, y2),
        maxX = math.max(x1, x2),
        maxY = math.max(y1, y2),
        GetWidth = function() return math.abs(x2 - x1) end,
        GetHeight = function() return math.abs(y2 - y1) end
    }
end

-- Contour mock object
function Contour()
    local points = {}
    local closed = false
    
    return {
        AppendPoint = function(self, x, y)
            table.insert(points, {x = x, y = y})
            print(string.format("Added point (%s, %s) to contour", x, y))
        end,
        AppendLineTo = function(self, x, y)
            table.insert(points, {x = x, y = y, type = "line"})
            print(string.format("Added line to (%s, %s)", x, y))
        end,
        AppendArcTo = function(self, x, y, bulge)
            table.insert(points, {x = x, y = y, type = "arc", bulge = bulge})
            print(string.format("Added arc to (%s, %s) with bulge %s", x, y, bulge))
        end,
        AppendBezierTo = function(self, x, y, cx1, cy1, cx2, cy2)
            table.insert(points, {x = x, y = y, type = "bezier", cx1 = cx1, cy1 = cy1, cx2 = cx2, cy2 = cy2})
            print(string.format("Added bezier to (%s, %s)", x, y))
        end,
        Close = function(self)
            closed = true
            print("Closed contour")
        end,
        IsClosed = function(self)
            return closed
        end,
        GetPoints = function(self)
            return points
        end
    }
end

-- Text mock object
function Text()
    local properties = {
        text = "",
        font = "Arial",
        size = 12,
        bold = false,
        italic = false,
        x = 0,
        y = 0
    }
    
    return {
        SetFont = function(self, font, size, bold, italic)
            properties.font = font
            properties.size = size
            properties.bold = bold
            properties.italic = italic
            print(string.format("Set font to %s, size %s, bold=%s, italic=%s", 
                font, size, tostring(bold), tostring(italic)))
        end,
        SetText = function(self, text)
            properties.text = text
            print("Set text to: " .. text)
        end,
        DrawAtPosition = function(self, x, y)
            properties.x = x
            properties.y = y
            print(string.format("Drawing text at position (%s, %s): %s", x, y, properties.text))
        end
    }
end

-- Transformation2D mock object
function Transformation2D()
    return {
        Translate = function(self, x, y)
            print(string.format("Translating by (%s, %s)", x, y))
        end,
        Rotate = function(self, angle)
            print(string.format("Rotating by %s degrees", angle))
        end,
        Scale = function(self, xScale, yScale)
            print(string.format("Scaling by (%s, %s)", xScale, yScale))
        end,
        ReflectX = function(self)
            print("Reflecting across X axis")
        end,
        ReflectY = function(self)
            print("Reflecting across Y axis")
        end
    }
end

-- Selection mock object
Selection = {
    items = {}
}

function Selection:Clear()
    self.items = {}
    print("Selection cleared")
end

function Selection:Add(item)
    table.insert(self.items, item)
    print("Item added to selection")
end

function Selection:Count()
    return #self.items
end

-- LayerManager mock object
LayerManager = {
    layers = {
        {name = "Layer 1", color = 0xFF0000, visible = true, active = true},
        {name = "Layer 2", color = 0x00FF00, visible = true, active = false}
    }
}

function LayerManager:GetNumLayers()
    return #self.layers
end

function LayerManager:GetLayerName(index)
    if index >= 0 and index < #self.layers then
        return self.layers[index + 1].name
    end
    return nil
end

function LayerManager:FindLayer(name)
    for i, layer in ipairs(self.layers) do
        if layer.name == name then
            return i - 1
        end
    end
    return -1
end

function LayerManager:AddNewLayer(name, color, isVisible, isActive)
    table.insert(self.layers, {
        name = name,
        color = color,
        visible = isVisible,
        active = isActive
    })
    print(string.format("Added new layer: %s", name))
    return true
end

function LayerManager:SetLayerVisibility(name, isVisible)
    local index = self:FindLayer(name)
    if index >= 0 then
        self.layers[index + 1].visible = isVisible
        print(string.format("Set layer %s visibility to %s", name, tostring(isVisible)))
        return true
    end
    return false
end

function LayerManager:SetActiveLayer(name)
    local index = self:FindLayer(name)
    if index >= 0 then
        -- Set all layers inactive
        for i, layer in ipairs(self.layers) do
            layer.active = false
        end
        -- Set requested layer active
        self.layers[index + 1].active = true
        print(string.format("Set layer %s as active", name))
        return true
    end
    return false
end

-- Tool mock object
function Tool()
    local properties = {
        diameter = 6.35,
        stepover = 50,
        feedRate = 1000,
        plungeRate = 500,
        spindleSpeed = 18000
    }
    
    return {
        GetToolDiameter = function(self) return properties.diameter end,
        GetToolStepover = function(self) return properties.stepover end,
        GetToolFeedRate = function(self) return properties.feedRate end,
        GetToolPlungeRate = function(self) return properties.plungeRate end,
        GetToolSpindleSpeed = function(self) return properties.spindleSpeed end,
        
        SetToolDiameter = function(self, value) 
            properties.diameter = value 
            print("Set tool diameter to " .. value)
        end,
        SetToolStepover = function(self, value) 
            properties.stepover = value
            print("Set tool stepover to " .. value)
        end,
        SetToolFeedRate = function(self, value) 
            properties.feedRate = value
            print("Set tool feed rate to " .. value)
        end,
        SetToolPlungeRate = function(self, value) 
            properties.plungeRate = value
            print("Set tool plunge rate to " .. value)
        end,
        SetToolSpindleSpeed = function(self, value) 
            properties.spindleSpeed = value
            print("Set tool spindle speed to " .. value)
        end
    }
end

-- ToolpathManager mock object
ToolpathManager = {
    toolpaths = {}
}

function ToolpathManager:GetToolpathNames()
    local names = {}
    for name, _ in pairs(self.toolpaths) do
        table.insert(names, name)
    end
    return names
end

function ToolpathManager:ToolpathExists(name)
    return self.toolpaths[name] ~= nil
end

function ToolpathManager:GetToolpathByName(name)
    return self.toolpaths[name]
end

function ToolpathManager:DeleteToolpathByName(name)
    if self.toolpaths[name] then
        self.toolpaths[name] = nil
        print("Deleted toolpath: " .. name)
        return true
    end
    return false
end

function ToolpathManager:SaveToolpathsToFile(filepath)
    print("Saving toolpaths to: " .. filepath)
    return true
end

-- Vector helper mock object for advanced drawing operations
local VectorHelper = {}
function VectorHelper.CreateCircle(x, y, radius)
    print(string.format("Creating circle at (%s, %s) with radius %s", x, y, radius))
    return {
        x = x,
        y = y,
        radius = radius,
        type = "circle"
    }
end

function VectorHelper.CreateRectangle(x1, y1, x2, y2)
    print(string.format("Creating rectangle from (%s, %s) to (%s, %s)", x1, y1, x2, y2))
    return {
        x1 = x1, 
        y1 = y1,
        x2 = x2,
        y2 = y2,
        type = "rectangle"
    }
end

-- Load the server module
print("Loading server module...")
local server = require("server")

print("Server module loaded successfully")

-- Enhance the sandbox with mock Vectric SDK
local originalCreateSandbox = server.createSandbox
server.createSandbox = function()
    local sandbox = originalCreateSandbox()
    
    -- Add mock Vectric SDK global objects
    sandbox.Global = Global
    sandbox.Job = Job
    sandbox.VectricJob = VectricJob
    sandbox.MaterialBlock = MaterialBlock
    sandbox.VectorHelper = VectorHelper
    sandbox.Contour = Contour
    sandbox.Text = Text
    sandbox.Box2D = Box2D
    sandbox.Transformation2D = Transformation2D
    sandbox.Selection = Selection
    sandbox.LayerManager = LayerManager
    sandbox.Tool = Tool
    sandbox.ToolpathManager = ToolpathManager
    
    return sandbox
end

-- Test function to execute sample commands
local function testSdkWrapperFunctions()
    print("\n=== Testing SDK Wrapper Functions ===\n")
    
    -- Test job management functions
    print("\n-- Job Management --")
    local jobInfo = server.sdkWrapper.getJobInfo()
    print("Current job name: " .. jobInfo.data.name)
    print("Job dimensions: " .. jobInfo.data.width .. " x " .. jobInfo.data.height)
    
    server.sdkWrapper.setMaterialBlockProperties(600, 400, 30)
    
    -- Test vector creation
    print("\n-- Vector Creation --")
    server.sdkWrapper.createCircle(100, 100, 50)
    server.sdkWrapper.createRectangle(200, 200, 300, 300)
    server.sdkWrapper.createText("Hello Vectric!", 50, 50, "Arial", 24, true, false)
    
    -- Test layer management
    print("\n-- Layer Management --")
    local layerInfo = server.sdkWrapper.getLayerInfo()
    print("Number of layers: " .. layerInfo.data.count)
    for i, layer in ipairs(layerInfo.data.layers) do
        print("Layer " .. i .. ": " .. layer.name)
    end
    
    server.sdkWrapper.createLayer("New Layer", 0x0000FF, true, false)
    server.sdkWrapper.setActiveLayer("New Layer")
    
    -- Test application info
    print("\n-- Application Info --")
    local appInfo = server.sdkWrapper.getAppInfo()
    print("App version: " .. appInfo.data.appVersion)
    print("Is Aspire: " .. (appInfo.data.isAspire and "Yes" or "No"))
    
    print("\n=== SDK Wrapper Tests Complete ===\n")
end

-- Main function for standalone server
local function main()
    print("Starting AiSpire server in standalone mode...")
    
    -- Start the server
    if not server.startServer() then
        print("Failed to start server: " .. (server.getLastError() or "Unknown error"))
        return
    end
    
    print("Server started on port " .. server.CONFIG.PORT)
    
    -- Run some tests of the SDK wrapper functions
    testSdkWrapperFunctions()
    
    print("\nServer is running. Press Ctrl+C to exit")
    print("Connect to localhost:" .. server.CONFIG.PORT .. " to send commands")
    
    -- Main loop
    while true do
        server.runServer()
        socket.sleep(0.01)  -- Small delay to prevent hogging CPU
    end
end

-- Run the server
main()