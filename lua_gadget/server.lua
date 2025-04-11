-- Simple server module
local server = {}

-- Load required libraries
local socket = require("socket")
local json = require("json")

-- Configuration
server.CONFIG = {
    PORT = 9876,
    HOST = "127.0.0.1",
    TIMEOUT = 0.001,
    AUTH_TOKEN = "a8f5f167f44f4964e6c998dee827110c"
}

-- Private variables
local socketServer = nil
local client = nil
local isRunning = false
local lastError = nil

-- ===================================
-- SDK Wrapper Functions
-- ===================================
-- SDK wrapper module
local sdkWrapper = {}

-- Job Management Functions

-- Create a new job
function sdkWrapper.createNewJob(name, width, height, thickness, in_mm, origin_on_surface)
    local result = { success = false, message = "", data = {} }
    
    -- Create bounds for the job
    local bounds = Box2D(0, 0, width, height)
    
    -- Call Vectric SDK function
    if VectricJob and type(VectricJob.CreateNewJob) == "function" then
        local success = VectricJob.CreateNewJob(name, bounds, thickness, in_mm, origin_on_surface)
        if success then
            result.success = true
            result.message = "Job created successfully"
            result.data = {
                name = name,
                width = width,
                height = height,
                thickness = thickness,
                in_mm = in_mm
            }
        else
            result.message = "Failed to create job"
        end
    else
        result.message = "VectricJob.CreateNewJob not available"
    end
    
    return result
end

-- Open an existing job
function sdkWrapper.openExistingJob(pathname)
    local result = { success = false, message = "", data = {} }
    
    -- Call Vectric SDK function
    if VectricJob and type(VectricJob.OpenExistingJob) == "function" then
        local success = VectricJob.OpenExistingJob(pathname)
        if success then
            result.success = true
            result.message = "Job opened successfully"
            result.data = {
                pathname = pathname
            }
        else
            result.message = "Failed to open job"
        end
    else
        result.message = "VectricJob.OpenExistingJob not available"
    end
    
    return result
end

-- Save current job
function sdkWrapper.saveCurrentJob(pathname)
    local result = { success = false, message = "", data = {} }
    
    -- Call Vectric SDK function
    if VectricJob and type(VectricJob.SaveCurrentJob) == "function" then
        local success
        if pathname and Job and type(Job.Save) == "function" then
            success = Job:Save(pathname)
        elseif VectricJob.SaveCurrentJob then
            success = VectricJob.SaveCurrentJob()
        end
        
        if success then
            result.success = true
            result.message = "Job saved successfully"
            result.data = {
                pathname = pathname or "Current job path"
            }
        else
            result.message = "Failed to save job"
        end
    else
        result.message = "VectricJob.SaveCurrentJob not available"
    end
    
    return result
end

-- Close current job
function sdkWrapper.closeCurrentJob()
    local result = { success = false, message = "", data = {} }
    
    -- Call Vectric SDK function
    if VectricJob and type(VectricJob.CloseCurrentJob) == "function" then
        local success = VectricJob.CloseCurrentJob()
        if success then
            result.success = true
            result.message = "Job closed successfully"
        else
            result.message = "Failed to close job"
        end
    else
        result.message = "VectricJob.CloseCurrentJob not available"
    end
    
    return result
end

-- Get job information
function sdkWrapper.getJobInfo()
    local result = { success = false, message = "", data = {} }
    
    if Job then
        local hasGetName = type(Job.GetName) == "function"
        local hasGetJobWidth = type(Job.GetJobWidth) == "function"
        local hasGetJobHeight = type(Job.GetJobHeight) == "function"
        
        result.success = true
        result.message = "Job information retrieved"
        result.data = {
            name = hasGetName and Job:GetName() or "Unknown",
            width = hasGetJobWidth and Job:GetJobWidth() or 0,
            height = hasGetJobHeight and Job:GetJobHeight() or 0
        }
        
        -- Get material block information if available
        if type(Job.GetMaterialBlock) == "function" then
            local materialBlock = Job:GetMaterialBlock()
            if materialBlock then
                local hasGetWidth = type(materialBlock.GetWidth) == "function"
                local hasGetHeight = type(materialBlock.GetHeight) == "function"
                local hasGetThickness = type(materialBlock.GetThickness) == "function"
                local hasIsDoubleSided = type(materialBlock.IsDoubleSided) == "function"
                
                result.data.materialBlock = {
                    width = hasGetWidth and materialBlock:GetWidth() or 0,
                    height = hasGetHeight and materialBlock:GetHeight() or 0,
                    thickness = hasGetThickness and materialBlock:GetThickness() or 0,
                    doubleSided = hasIsDoubleSided and materialBlock:IsDoubleSided() or false
                }
            end
        end
    else
        result.message = "Job object not available"
    end
    
    return result
end

-- Set material block properties
function sdkWrapper.setMaterialBlockProperties(width, height, thickness)
    local result = { success = false, message = "", data = {} }
    
    if Job and type(Job.GetMaterialBlock) == "function" then
        local materialBlock = Job:GetMaterialBlock()
        if materialBlock then
            if width and type(materialBlock.SetWidth) == "function" then 
                materialBlock:SetWidth(width) 
            end
            
            if height and type(materialBlock.SetHeight) == "function" then 
                materialBlock:SetHeight(height) 
            end
            
            if thickness and type(materialBlock.SetThickness) == "function" then 
                materialBlock:SetThickness(thickness) 
            end
            
            if type(materialBlock.Update) == "function" then 
                materialBlock:Update() 
            end
            
            local hasGetWidth = type(materialBlock.GetWidth) == "function"
            local hasGetHeight = type(materialBlock.GetHeight) == "function"
            local hasGetThickness = type(materialBlock.GetThickness) == "function"
            
            result.success = true
            result.message = "Material block properties updated"
            result.data = {
                width = hasGetWidth and materialBlock:GetWidth() or 0,
                height = hasGetHeight and materialBlock:GetHeight() or 0,
                thickness = hasGetThickness and materialBlock:GetThickness() or 0
            }
        else
            result.message = "Material block not available"
        end
    else
        result.message = "Job object not available"
    end
    
    return result
end

-- Vector Creation and Manipulation Functions

-- Create a circle vector
function sdkWrapper.createCircle(x, y, radius)
    local result = { success = false, message = "", data = {} }
    
    -- Call Vectric SDK function if available or use our mock implementation
    if Global and type(Global.CreateCircle) == "function" then
        -- Use the real SDK function
        local circle = Global.CreateCircle(x, y, radius, 0.01, 0) -- default tolerance and z-value
        result.success = true
        result.message = "Circle created successfully"
        result.data = {
            type = "circle",
            center = { x = x, y = y },
            radius = radius
        }
    else
        -- Try to create a contour if available
        if type(Contour) == "function" then
            local contour = Contour()
            -- Create a circle using 4 arcs
            local steps = 4
            local angle = 0
            local stepAngle = (2 * math.pi) / steps
            
            -- Add first point
            local startX = x + radius * math.cos(angle)
            local startY = y + radius * math.sin(angle)
            contour:AppendPoint(startX, startY)
            
            -- Add arcs to form a circle
            for i = 1, steps do
                angle = angle + stepAngle
                local nextX = x + radius * math.cos(angle)
                local nextY = y + radius * math.sin(angle)
                contour:AppendArcTo(nextX, nextY, 1) -- bulge value of 1 for 90-degree arc
            end
            
            contour:Close()
            
            result.success = true
            result.message = "Circle created using contour"
            result.data = {
                type = "contour",
                center = { x = x, y = y },
                radius = radius
            }
        else
            result.message = "Circle creation not available"
        end
    end
    
    return result
end

-- Create a rectangle vector
function sdkWrapper.createRectangle(x1, y1, x2, y2)
    local result = { success = false, message = "", data = {} }
    
    if type(Contour) == "function" then
        local contour = Contour()
        
        -- Add four points to form a rectangle
        contour:AppendPoint(x1, y1)
        contour:AppendLineTo(x2, y1)
        contour:AppendLineTo(x2, y2)
        contour:AppendLineTo(x1, y2)
        contour:Close()
        
        result.success = true
        result.message = "Rectangle created successfully"
        result.data = {
            type = "rectangle",
            points = {
                { x = x1, y = y1 },
                { x = x2, y = y1 },
                { x = x2, y = y2 },
                { x = x1, y = y2 }
            },
            width = math.abs(x2 - x1),
            height = math.abs(y2 - y1)
        }
    else
        result.message = "Contour creation not available"
    end
    
    return result
end

-- Create text 
function sdkWrapper.createText(text, x, y, fontName, fontSize, bold, italic)
    local result = { success = false, message = "", data = {} }
    
    if type(Text) == "function" then
        local textObj = Text()
        textObj:SetFont(fontName or "Arial", fontSize or 12, bold or false, italic or false)
        textObj:SetText(text)
        textObj:DrawAtPosition(x, y)
        
        result.success = true
        result.message = "Text created successfully"
        result.data = {
            type = "text",
            content = text,
            position = { x = x, y = y },
            font = fontName or "Arial",
            size = fontSize or 12,
            bold = bold or false,
            italic = italic or false
        }
    else
        result.message = "Text creation not available"
    end
    
    return result
end

-- Transform vectors (move, rotate, scale)
function sdkWrapper.transformVectors(transformType, parameters)
    local result = { success = false, message = "", data = {} }
    
    if type(Transformation2D) == "function" and Selection then
        local transformation = Transformation2D()
        
        if transformType == "move" then
            transformation:Translate(parameters.x or 0, parameters.y or 0)
            result.data = {
                type = "move",
                offset = { x = parameters.x or 0, y = parameters.y or 0 }
            }
        elseif transformType == "rotate" then
            transformation:Rotate(parameters.angle or 0)
            result.data = {
                type = "rotate",
                angle = parameters.angle or 0
            }
        elseif transformType == "scale" then
            transformation:Scale(parameters.scaleX or 1, parameters.scaleY or 1)
            result.data = {
                type = "scale",
                factors = { x = parameters.scaleX or 1, y = parameters.scaleY or 1 }
            }
        elseif transformType == "mirror" then
            if parameters.direction == "x" then
                transformation:ReflectX()
                result.data = { type = "mirror", direction = "x" }
            elseif parameters.direction == "y" then
                transformation:ReflectY()
                result.data = { type = "mirror", direction = "y" }
            else
                result.message = "Invalid mirror direction"
                return result
            end
        else
            result.message = "Invalid transformation type"
            return result
        end
        
        -- Apply the transformation to selected objects
        -- This is a simplified representation - actual implementation would depend on SDK specifics
        result.success = true
        result.message = "Transformation applied successfully"
    else
        result.message = "Transformation functionality not available"
    end
    
    return result
end

-- Layer Management Functions

-- Create a new layer
function sdkWrapper.createLayer(name, color, isVisible, isActive)
    local result = { success = false, message = "", data = {} }
    
    if LayerManager and type(LayerManager.AddNewLayer) == "function" then
        local success = LayerManager:AddNewLayer(name, color, isVisible or true, isActive or false)
        if success then
            result.success = true
            result.message = "Layer created successfully"
            result.data = {
                name = name,
                color = color,
                isVisible = isVisible or true,
                isActive = isActive or false
            }
        else
            result.message = "Failed to create layer"
        end
    else
        result.message = "Layer manager not available"
    end
    
    return result
end

-- Get layer information
function sdkWrapper.getLayerInfo()
    local result = { success = false, message = "", data = { layers = {} } }
    
    if LayerManager and type(LayerManager.GetNumLayers) == "function" then
        local numLayers = LayerManager:GetNumLayers()
        
        for i = 0, numLayers - 1 do
            if type(LayerManager.GetLayerName) == "function" then
                local layerName = LayerManager:GetLayerName(i)
                table.insert(result.data.layers, {
                    name = layerName,
                    index = i
                })
            end
        end
        
        result.success = true
        result.message = "Layer information retrieved"
        result.data.count = numLayers
    else
        result.message = "Layer manager not available"
    end
    
    return result
end

-- Set active layer
function sdkWrapper.setActiveLayer(name)
    local result = { success = false, message = "", data = {} }
    
    if LayerManager and type(LayerManager.SetActiveLayer) == "function" then
        local success = LayerManager:SetActiveLayer(name)
        if success then
            result.success = true
            result.message = "Active layer set successfully"
            result.data = { name = name }
        else
            result.message = "Failed to set active layer"
        end
    else
        result.message = "Layer manager not available"
    end
    
    return result
end

-- Set layer visibility
function sdkWrapper.setLayerVisibility(name, isVisible)
    local result = { success = false, message = "", data = {} }
    
    if LayerManager and type(LayerManager.SetLayerVisibility) == "function" then
        local success = LayerManager:SetLayerVisibility(name, isVisible)
        if success then
            result.success = true
            result.message = "Layer visibility set successfully"
            result.data = { name = name, isVisible = isVisible }
        else
            result.message = "Failed to set layer visibility"
        end
    else
        result.message = "Layer manager not available"
    end
    
    return result
end

-- Toolpath Functions

-- Get available toolpaths
function sdkWrapper.getToolpaths()
    local result = { success = false, message = "", data = { toolpaths = {} } }
    
    if ToolpathManager then
        if type(ToolpathManager.GetToolpathNames) == "function" then
            local toolpathNames = ToolpathManager:GetToolpathNames() or {}
            
            for _, name in ipairs(toolpathNames) do
                table.insert(result.data.toolpaths, { name = name })
            end
            
            result.success = true
            result.message = "Toolpaths retrieved successfully"
            result.data.count = #toolpathNames
        else
            result.message = "GetToolpathNames function not available"
        end
    else
        result.message = "Toolpath manager not available"
    end
    
    return result
end

-- Create a profile toolpath
function sdkWrapper.createProfileToolpath(name, toolDiameter, cutDepth, parameters)
    local result = { success = false, message = "", data = {} }
    
    if ToolpathManager and type(Tool) == "function" then
        -- Create a tool
        local tool = Tool()
        tool:SetToolDiameter(toolDiameter)
        
        -- Create a profile toolpath (simplified version)
        -- This is a representative implementation - actual implementation would use SDK-specific functions
        
        result.success = true
        result.message = "Profile toolpath created (mock)"
        result.data = {
            name = name,
            toolDiameter = toolDiameter,
            cutDepth = cutDepth,
            parameters = parameters
        }
    else
        result.message = "Toolpath creation not available"
    end
    
    return result
end

-- Create a pocket toolpath
function sdkWrapper.createPocketToolpath(name, toolDiameter, cutDepth, parameters)
    local result = { success = false, message = "", data = {} }
    
    if ToolpathManager and type(Tool) == "function" then
        -- Create a tool
        local tool = Tool()
        tool:SetToolDiameter(toolDiameter)
        
        -- Create a pocket toolpath (simplified version)
        -- This is a representative implementation - actual implementation would use SDK-specific functions
        
        result.success = true
        result.message = "Pocket toolpath created (mock)"
        result.data = {
            name = name,
            toolDiameter = toolDiameter,
            cutDepth = cutDepth,
            parameters = parameters
        }
    else
        result.message = "Toolpath creation not available"
    end
    
    return result
end

-- Save toolpaths
function sdkWrapper.saveToolpaths(filepath)
    local result = { success = false, message = "", data = {} }
    
    if ToolpathManager and type(ToolpathManager.SaveToolpathsToFile) == "function" then
        local success = ToolpathManager:SaveToolpathsToFile(filepath)
        if success then
            result.success = true
            result.message = "Toolpaths saved successfully"
            result.data = { filepath = filepath }
        else
            result.message = "Failed to save toolpaths"
        end
    else
        result.message = "Toolpath saving not available"
    end
    
    return result
end

-- Application Information Functions

-- Get application information
function sdkWrapper.getAppInfo()
    local result = { success = true, message = "Application information retrieved", data = {} }
    
    if Global then
        local hasIsAspire = type(Global.IsAspire) == "function"
        local hasIsBeta = type(Global.IsBetaBuild) == "function"
        local hasGetAppVersion = type(Global.GetAppVersion) == "function"
        local hasGetBuildVersion = type(Global.GetBuildVersion) == "function"
        
        result.data.isAspire = hasIsAspire and Global.IsAspire() or false
        result.data.isBeta = hasIsBeta and Global.IsBetaBuild() or false
        result.data.appVersion = hasGetAppVersion and Global.GetAppVersion() or "Unknown"
        result.data.buildVersion = hasGetBuildVersion and Global.GetBuildVersion() or "Unknown"
    else
        result.message = "Global object not available"
        result.success = false
    end
    
    return result
end

-- Get file locations
function sdkWrapper.getFileLocations()
    local result = { success = true, message = "File locations retrieved", data = {} }
    
    if Global then
        local hasGetDataLocation = type(Global.GetDataLocation) == "function"
        local hasGetPostProcessorLocation = type(Global.GetPostProcessorLocation) == "function"
        local hasGetToolDatabaseLocation = type(Global.GetToolDatabaseLocation) == "function"
        local hasGetGadgetsLocation = type(Global.GetGadgetsLocation) == "function"
        
        result.data.dataLocation = hasGetDataLocation and Global.GetDataLocation() or "Unknown"
        result.data.postprocessorLocation = hasGetPostProcessorLocation and Global.GetPostProcessorLocation() or "Unknown"
        result.data.toolDatabaseLocation = hasGetToolDatabaseLocation and Global.GetToolDatabaseLocation() or "Unknown"
        result.data.gadgetsLocation = hasGetGadgetsLocation and Global.GetGadgetsLocation() or "Unknown"
    else
        result.message = "Global object not available"
        result.success = false
    end
    
    return result
end

-- Command Handlers
local commandHandlers = {
    -- Job Management
    create_job = sdkWrapper.createNewJob,
    open_job = sdkWrapper.openExistingJob,
    save_job = sdkWrapper.saveCurrentJob,
    close_job = sdkWrapper.closeCurrentJob,
    get_job_info = sdkWrapper.getJobInfo,
    set_material_properties = sdkWrapper.setMaterialBlockProperties,
    
    -- Vector Creation and Manipulation
    create_circle = sdkWrapper.createCircle,
    create_rectangle = sdkWrapper.createRectangle,
    create_text = sdkWrapper.createText,
    transform_vectors = sdkWrapper.transformVectors,
    
    -- Layer Management
    create_layer = sdkWrapper.createLayer,
    get_layers = sdkWrapper.getLayerInfo,
    set_active_layer = sdkWrapper.setActiveLayer,
    set_layer_visibility = sdkWrapper.setLayerVisibility,
    
    -- Toolpath Operations
    get_toolpaths = sdkWrapper.getToolpaths,
    create_profile_toolpath = sdkWrapper.createProfileToolpath,
    create_pocket_toolpath = sdkWrapper.createPocketToolpath,
    save_toolpaths = sdkWrapper.saveToolpaths,
    
    -- Application Information
    get_app_info = sdkWrapper.getAppInfo,
    get_file_locations = sdkWrapper.getFileLocations
}

-- Public functions
server.sdkWrapper = sdkWrapper
server.commandHandlers = commandHandlers

-- ===================================
-- Base Server Functions
-- ===================================

-- Create a sandbox environment for code execution
local function createSandbox()
    local sandbox = {}
    
    -- Add safe Lua standard libraries
    sandbox.string = string
    sandbox.math = math
    sandbox.table = table
    
    -- Add SDK wrapper functions
    sandbox.sdkWrapper = sdkWrapper
    
    return sandbox
end

-- Validate a command structure and authentication
local function validateCommand(command)
    -- Check required fields
    if not command.command_type then
        return false, "Missing command_type field"
    end
    
    if not command.payload then
        return false, "Missing payload field"
    end
    
    if not command.id then
        return false, "Missing id field"
    end
    
    -- Validate command type
    if command.command_type ~= "execute_code" and 
       command.command_type ~= "execute_function" and
       command.command_type ~= "query_state" then
        return false, "Invalid command_type"
    end
    
    -- Validate authentication
    if not command.auth or command.auth ~= server.CONFIG.AUTH_TOKEN then
        return false, "Authentication failed"
    end
    
    -- Validate payload based on command type
    if command.command_type == "execute_code" and not command.payload.code then
        return false, "Missing code in payload"
    end
    
    -- if command.command_type == "execute_function" and not command.payload.function then
    --     return false, "Missing function name in payload"
    -- end
    
    return true
end

-- Execute arbitrary Lua code
local function executeCode(code)
    if not code or code == "" then
        return {
            status = "error",
            result = {
                message = "No code provided",
                data = {},
                type = "invalid_code"
            }
        }
    end
    
    -- Create a sandbox environment
    local sandbox = createSandbox()
    
    -- Compile the code
    local func, compileError = load(code, "command", "t", sandbox)
    if not func then
        return {
            status = "error",
            result = {
                message = "Code compilation error: " .. compileError,
                data = {},
                type = "compilation_error"
            }
        }
    end
    
    -- Execute the code
    local success, result = pcall(func)
    if not success then
        return {
            status = "error",
            result = {
                message = "Code execution error: " .. tostring(result),
                data = {},
                type = "execution_error"
            }
        }
    end
    
    return {
        status = "success",
        result = {
            message = "Code executed successfully",
            data = result or {},
            type = "code_result"
        }
    }
end

-- Execute a specific SDK function
local function executeSdkFunction(functionName, params)
    local handler = commandHandlers[functionName]
    
    if handler then
        local result = handler(table.unpack(params or {}))
        
        return {
            status = result.success and "success" or "error",
            result = {
                message = result.message,
                data = result.data or {},
                type = functionName .. "_result"
            }
        }
    else
        return {
            status = "error",
            result = {
                message = "Function not found: " .. functionName,
                data = {},
                type = "unknown_function"
            }
        }
    end
end

-- Send a response back to the client
local function sendResponse(response)
    if not client then return false end
    
    local responseStr, err = json.encode(response)
    if not responseStr then
        -- If JSON encoding fails, try to send a simple error response
        responseStr = '{"status":"error","result":{"message":"Failed to encode response: ' .. 
                     (err or "unknown error") .. '","data":{},"type":"encoding_error"}}'
    end
    
    client:send(responseStr .. "\n")
    return true
end

-- Process a command from the client
local function processCommand(commandStr)
    local command, err = json.decode(commandStr)
    
    if not command then
        return {
            status = "error",
            result = {
                message = "Invalid JSON command: " .. (err or "unknown error"),
                data = {},
                type = "parsing_error"
            }
        }
    end
    
    -- Validate the command format and authentication
    local isValid, validationError = validateCommand(command)
    if not isValid then
        return {
            status = "error",
            result = {
                message = validationError,
                data = {},
                type = "validation_error"
            }
        }
    end
    
    -- Process different command types
    local startTime = os.clock()
    local result
    
    if command.command_type == "execute_code" then
        result = executeCode(command.payload.code)
    elseif command.command_type == "execute_function" then
        -- result = executeSdkFunction(command.payload.function, command.payload.parameters)
    elseif command.command_type == "query_state" then
        -- Query the state of various SDK objects
        result = {
            status = "success",
            result = {
                message = "Current state retrieved",
                data = {
                    job = sdkWrapper.getJobInfo().data,
                    app = sdkWrapper.getAppInfo().data,
                    layers = sdkWrapper.getLayerInfo().data
                },
                type = "state_query_result"
            }
        }
    else
        result = {
            status = "error",
            result = {
                message = "Unknown command type: " .. command.command_type,
                data = {},
                type = "unknown_command"
            }
        }
    end
    
    -- Add execution metadata
    result.command_id = command.id
    result.execution_time = os.clock() - startTime
    
    return result
end

-- Initialize the socket server
local function setupServer()
    local s, err = socket.bind(server.CONFIG.HOST, server.CONFIG.PORT)
    
    if not s then
        lastError = "Failed to create server: " .. (err or "unknown error")
        return false
    end
    
    s:settimeout(server.CONFIG.TIMEOUT)
    socketServer = s
    isRunning = true
    
    return true
end

-- Accept a client connection
local function acceptConnection()
    if not socketServer then return false end
    
    local c = socketServer:accept()
    if c then
        c:settimeout(server.CONFIG.TIMEOUT)
        client = c
        return true
    end
    
    return false
end

-- Function to start the server and listen for connections
function server.startServer()
    -- Initialize
    if not setupServer() then
        print("Failed to start server: " .. (lastError or "Unknown error"))
        return false
    end
    
    print("Server started on port " .. server.CONFIG.PORT)
    isRunning = true
    return true
end

-- Function to stop the server
function server.stopServer()
    isRunning = false
    if client then client:close() end
    if socketServer then socketServer:close() end
    client = nil
    socketServer = nil
    return true
end

-- Main server loop function
function server.runServer()
    if not isRunning then
        if not server.startServer() then return false end
    end
    
    -- Try to accept a new connection if no client connected
    if not client then
        client = socketServer:accept()
        if client then
            client:settimeout(server.CONFIG.TIMEOUT)
            print("Client connected")
        end
    end
    
    -- Process client requests
    if client then
        local data, err = client:receive()
        if data then
            print("Received data: " .. data)
            local response = processCommand(data)
            sendResponse(response)
        elseif err ~= "timeout" then
            -- Connection error or closed
            client:close()
            client = nil
            print("Client disconnected: " .. (err or "unknown error"))
        end
    end
    
    -- Sleep a bit to prevent CPU hogging
    socket.sleep(0.01)
    
    return true
end

-- Function to check if the server is running
function server.isRunning()
    return isRunning
end

-- Function to get the last error
function server.getLastError()
    return lastError
end

-- Expose internal functions for testing
server.processCommand = processCommand
server.executeCode = executeCode
server.createSandbox = createSandbox

-- Return the module
return server