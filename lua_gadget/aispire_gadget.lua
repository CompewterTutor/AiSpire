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
    Gadget for Vectric Aspire/V-Carve
    
    This gadget provides a socket server interface to the Vectric software,
    allowing control via the AiSpire Python MCP Server.
    
    Author: Michael Morrissey
    Version: 0.1.0 (Development)
    Date: April 9, 2025
--]]

-- Load required libraries
local socket = require("socket")
local json = require("json")  -- Load our custom JSON module

-- Configuration
local CONFIG = {
    PORT = 9876,
    HOST = "127.0.0.1",  -- localhost only for security
    MAX_CONNECTIONS = 1, -- Only allow one connection at a time
    TIMEOUT = 0.001,     -- Socket timeout in seconds
    AUTH_TOKEN = "change_this_to_a_secure_token"
}

-- Global state
local server = nil
local client = nil
local isRunning = false
local lastError = nil

-- Forward declarations
local setupServer, acceptConnection, processCommand, executeCode, executeSdkFunction
local sendResponse, validateCommand, createSandbox

-- Initialize the socket server
function setupServer()
    local serverSocket, err = socket.bind(CONFIG.HOST, CONFIG.PORT)
    
    if not serverSocket then
        lastError = "Failed to create server: " .. (err or "unknown error")
        return false
    end
    
    serverSocket:settimeout(CONFIG.TIMEOUT)
    server = serverSocket
    isRunning = true
    
    return true
end

-- Accept a client connection
function acceptConnection()
    if not server then return false end
    
    local clientSocket = server:accept()
    if clientSocket then
        clientSocket:settimeout(CONFIG.TIMEOUT)
        client = clientSocket
        return true
    end
    
    return false
end

-- Process a command from the client
function processCommand(commandStr)
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
        result = executeSdkFunction(command.payload.function, command.payload.parameters)
    elseif command.command_type == "query_state" then
        -- Not implemented yet
        result = {
            status = "error",
            result = {
                message = "Query state not implemented yet",
                data = {},
                type = "not_implemented"
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

-- Execute arbitrary Lua code
function executeCode(code)
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
function executeSdkFunction(functionName, params)
    -- This is a placeholder for the SDK function execution logic
    -- In a real implementation, this would call into the Vectric SDK
    return {
        status = "error",
        result = {
            message = "Function execution not implemented yet",
            data = {},
            type = "not_implemented"
        }
    }
end

-- Send a response back to the client
function sendResponse(response)
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

-- Validate a command structure and authentication
function validateCommand(command)
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
    if not command.auth or command.auth ~= CONFIG.AUTH_TOKEN then
        return false, "Authentication failed"
    end
    
    -- Validate payload based on command type
    if command.command_type == "execute_code" and not command.payload.code then
        return false, "Missing code in payload"
    end
    
    if command.command_type == "execute_function" and not command.payload.function then
        return false, "Missing function name in payload"
    end
    
    return true
end

-- Create a sandbox environment for code execution
function createSandbox()
    local sandbox = {}
    
    -- Add safe Lua standard libraries
    sandbox.string = string
    sandbox.math = math
    sandbox.table = table
    
    -- Add Vectric SDK wrappers (to be implemented)
    -- This would provide access to the Vectric SDK functions in a controlled way
    
    return sandbox
end

-- Main function for the gadget
local function main()
    -- Initialize
    if not setupServer() then
        Global.MessageBox("AiSpire Gadget: Failed to start server: " .. (lastError or "Unknown error"))
        return
    end
    
    Global.MessageBox("AiSpire Gadget: Server started on port " .. CONFIG.PORT)
    
    -- Main loop
    while isRunning do
        -- Accept new connections
        if not client and acceptConnection() then
            -- New client connected
        end
        
        -- Process client requests
        if client then
            local data, err = client:receive()
            if data then
                -- Process the command
                local response = processCommand(data)
                sendResponse(response)
            elseif err == "closed" then
                -- Client disconnected
                client = nil
            end
        end
        
        -- Sleep a bit to prevent high CPU usage
        socket.sleep(0.01)
    end
    
    -- Cleanup
    if client then client:close() end
    if server then server:close() end
end

-- Register with Vectric
function Gadget_Description()
    return {
        Name = "AiSpire",
        Description = "AI-powered interface for Vectric software",
        Icon = "aispire_icon.png",  -- Will need to create this icon
        Author = "AiSpire Team",
        Version = "0.1.0"
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
    setupServer = setupServer,
    acceptConnection = acceptConnection,
    processCommand = processCommand,
    executeCode = executeCode
}