--[[
                                                    
             .oo  o .oPYo.         o                
            .P 8    8                               
           .P  8 o8 `Yooo. .oPYo. o8 oPYo. .oPYo.   
          oPooo8  8     `8 8    8  8 8  `' 8oooo8   
         .P    8  8      8 8    8  8 8     8.       
        .P     8  8 `YooP' 8YooP'  8 8     `Yooo'   
::::::::..:::::..:..:.....:8 ....::....:::::.....:::
:::::::::::::::::::::::::::8 :::::::::::::::::::::::
:::::::::::::::::::::::::::..:::::::::::::::::::::::
    MCP Gadget for Vectric Aspire/V-Carve
    
    This gadget provides a socket server interface to the Vectric software,
    allowing control via the AiSpire Python MCP Server.
    
    Author: Michael Morrissey
    Version: 0.1.0 (Development)
    Date: April 11, 2025
--]]

-- Load required modules
local server = require("server")
local ui = require("ui_manager")

-- Enhance the sandbox with Vectric SDK
local function enhanceSandbox()
    -- Get the original createSandbox function from the server module
    local originalCreateSandbox = server.createSandbox
    
    -- Override the createSandbox function to add Vectric SDK access
    server.createSandbox = function()
        local sandbox = originalCreateSandbox()
        
        -- Add Vectric SDK global objects
        if Global then sandbox.Global = Global end
        if Job then sandbox.Job = Job end
        if VectricJob then sandbox.VectricJob = VectricJob end
        if MaterialBlock then sandbox.MaterialBlock = MaterialBlock end
        
        -- Add more SDK objects as needed
        
        return sandbox
    end
end

-- Function to show the UI panel
local function showUI()
    server.showUI()
end

-- Main function for the gadget
local function main()
    -- Enhance the sandbox with Vectric SDK
    enhanceSandbox()
    
    -- Set up the UI manager
    server.setUiManager(ui)
    
    -- Log startup information
    ui.log("INFO", "AiSpire Gadget starting...")
    ui.log("INFO", "Version: 0.1.0")
    
    -- Start the server
    if not server.startServer() then
        local errorMsg = server.getLastError() or "Unknown error"
        ui.log("ERROR", "Failed to start server: " .. errorMsg)
        Global.MessageBox("AiSpire Gadget: Failed to start server: " .. errorMsg)
        
        -- Show UI even if server failed to start
        showUI()
        return
    end
    
    ui.log("SUCCESS", "Server started on port " .. server.CONFIG.PORT)
    
    -- Show a notification
    Global.MessageBox("AiSpire Gadget: Server started on port " .. server.CONFIG.PORT)
    
    -- Main loop
    while server.isRunning() do
        server.runServer()
        socket.sleep(0.01)  -- Small delay to prevent hogging CPU
    end
    
    ui.log("INFO", "Server stopped. AiSpire Gadget shutting down.")
end

-- Register with Vectric
function Gadget_Description()
    return {
        Name = "AiSpire",
        Description = "Control Vectric software via the AiSpire Python MCP Server",
        Version = "0.1.0",
        Author = "Michael Morrissey"
    }
end

function Gadget_Category()
    return "AiSpire"
end

-- Main gadget action - just starts the server
function Gadget_Action()
    main()
end

-- Secondary action to show just the UI
function Gadget_SecondaryAction()
    -- Load modules if not already loaded
    if not ui then ui = require("ui_manager") end
    if not server then server = require("server") end
    
    -- Set up UI if needed
    server.setUiManager(ui)
    
    -- Show the UI
    showUI()
end

-- Menu text for secondary action
function Secondary_Menu_Text()
    return "Show AiSpire Control Panel"
end

-- Export for testing
return {
    enhanceSandbox = enhanceSandbox,
    main = main,
    showUI = showUI
}