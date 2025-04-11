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

-- Load the server module
local server = require("server")

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

-- Main function for the gadget
local function main()
    -- Enhance the sandbox with Vectric SDK
    enhanceSandbox()
    
    -- Start the server
    if not server.startServer() then
        Global.MessageBox("AiSpire Gadget: Failed to start server: " .. (server.getLastError() or "Unknown error"))
        return
    end
    
    Global.MessageBox("AiSpire Gadget: Server started on port " .. server.CONFIG.PORT)
    
    -- Main loop
    while server.isRunning() do
        server.runServer()
        socket.sleep(0.01)  -- Small delay to prevent hogging CPU
    end
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

function Gadget_Action()
    main()
end

-- Export for testing
return {
    enhanceSandbox = enhanceSandbox,
    main = main
}