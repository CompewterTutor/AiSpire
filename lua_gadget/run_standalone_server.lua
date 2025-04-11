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

-- More mock objects
MaterialBlock = {}
function MaterialBlock:GetWidth() return 500 end
function MaterialBlock:GetHeight() return 300 end
function MaterialBlock:GetThickness() return 25 end
function MaterialBlock:SetWidth(width) print("Setting material width to " .. width) end
function MaterialBlock:SetHeight(height) print("Setting material height to " .. height) end
function MaterialBlock:SetThickness(thickness) print("Setting material thickness to " .. thickness) end

-- Job mock object
Job = {}
function Job:GetJobWidth() return 500 end
function Job:GetJobHeight() return 300 end
function Job:GetMaterialBlock() return MaterialBlock end
function Job:GetName() return "Test Job" end

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
VectricJob.Exists = true

-- Load the server module
local server = require("server")

-- Create a basic vector helper to demonstrate SDK functionality
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
    
    return sandbox
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
    print("Press Ctrl+C to exit")
    
    -- Main loop
    while true do
        server.runServer()
        socket.sleep(0.01)  -- Small delay to prevent hogging CPU
    end
end

-- Run the server
main()