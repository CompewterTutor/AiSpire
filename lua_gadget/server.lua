--[[
    AiSpire Server Module
    
    This module provides a socket server interface to the Vectric software,
    allowing control via the AiSpire Python MCP Server.
    
    Author: Michael Morrissey
    Version: 0.1.0 (Development)
    Date: April 11, 2025
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
    AUTH_TOKEN = "a8f5f167f44f4964e6c998dee827110c" -- Example secure token (MD5 hash of a random string)
}

-- Module state
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

-- Function to start the server and listen for connections
local function startServer()
    -- Initialize
    if not setupServer() then
        print("Failed to start server: " .. (lastError or "Unknown error"))
        return false
    end
    
    print("Server started on port " .. CONFIG.PORT)
    isRunning = true
    return true
end

-- Function to stop the server
local function stopServer()
    isRunning = false
    if client then client:close() end
    if server then server:close() end
    client = nil
    server = nil
    return true
end

-- Main server loop function
local function runServer()
    if not isRunning then
        if not startServer() then return false end
    end
    
    -- Accept new connections
    if not client and acceptConnection() then
        -- New client connected
        print("Client connected")
    end
    
    -- Process client requests
    if client then
        local data, err = client:receive()
        if data then
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
local function isServerRunning()
    return isRunning
end

-- Function to get the last error
local function getLastError()
    return lastError
end

-- Return the module functions
return {
    startServer = startServer,
    stopServer = stopServer,
    runServer = runServer,
    isRunning = isServerRunning,
    getLastError = getLastError,
    processCommand = processCommand,  -- Exported for testing
    executeCode = executeCode,        -- Exported for testing
    createSandbox = createSandbox,    -- Exported for testing
    CONFIG = CONFIG                   -- Exported for configuration
}