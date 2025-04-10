--[[
    json.lua - JSON encoding/decoding for AiSpire Lua Gadget
    
    This is a lightweight JSON parser and encoder for Lua,
    based on Lua CJSON and JSON4Lua but simplified for our needs.
    
    Author: AiSpire Team
    Version: 0.1.0
    Date: April 9, 2025
    
    Usage:
        local json = require("json")
        local encoded = json.encode({name = "test", value = 123})
        local decoded = json.decode('{"name":"test","value":123}')
--]]

local json = {}

-- Constants
local ESCAPE_MAP = {
    ["\\"] = "\\\\",
    ["\""] = "\\\"",
    ["\b"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t"
}

local ESCAPE_PATTERN = "[\\\"'%z\1-\31]"

local NUMBER_PATTERN = "^-?%d+%.?%d*[eE]?[+-]?%d*$"

-- Forward declarations
local encode, encodeValue, decode, decodeValue, removeWhitespace
local parseObject, parseArray, parseString, parseNumber, parseBoolean, parseNull

-- Encode a Lua table or value to a JSON string
function json.encode(value)
    local success, result = pcall(encodeValue, value)
    if success then
        return result
    else
        return nil, "JSON encoding error: " .. result
    end
end

-- Decode a JSON string to a Lua table or value
function json.decode(jsonString)
    if type(jsonString) ~= "string" then
        return nil, "Expected string argument, got " .. type(jsonString)
    end
    
    -- Remove whitespace for easier parsing
    local str = removeWhitespace(jsonString)
    
    -- Handle empty JSON objects/arrays
    if str == "{}" then return {} end
    if str == "[]" then return {} end
    
    -- Parse the string
    local success, result, pos = pcall(decodeValue, str, 1)
    if success then
        -- Check if there's remaining content after a valid JSON value
        if pos <= #str then
            return nil, "Unexpected trailing characters at position " .. pos
        end
        return result
    else
        return nil, "JSON decoding error: " .. result
    end
end

-- Encode a value to JSON
function encodeValue(value)
    local valueType = type(value)
    
    if valueType == "nil" then
        return "null"
    elseif valueType == "boolean" then
        return value and "true" or "false"
    elseif valueType == "number" then
        -- Convert nan and inf to null
        if value ~= value or value == math.huge or value == -math.huge then
            return "null"
        end
        return tostring(value)
    elseif valueType == "string" then
        return encodeString(value)
    elseif valueType == "table" then
        return encodeTable(value)
    else
        error("Cannot encode value of type " .. valueType)
    end
end

-- Encode a string with proper escaping
function encodeString(str)
    local escaped = str:gsub(ESCAPE_PATTERN, function(c)
        return ESCAPE_MAP[c] or string.format("\\u%04x", c:byte())
    end)
    return "\"" .. escaped .. "\""
end

-- Encode a table as either an object or array
function encodeTable(t)
    -- Check if the table is an array (only sequential numeric keys)
    local isArray = true
    local maxIndex = 0
    
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
            isArray = false
            break
        end
        maxIndex = math.max(maxIndex, k)
    end
    
    -- If array has holes (non-consecutive indices), treat as object
    if isArray and maxIndex > #t then
        isArray = false
    end
    
    -- Encode as array
    if isArray then
        local result = {}
        for i = 1, #t do
            result[i] = encodeValue(t[i])
        end
        return "[" .. table.concat(result, ",") .. "]"
    else
        -- Encode as object
        local result = {}
        for k, v in pairs(t) do
            if type(k) == "string" or type(k) == "number" then
                table.insert(result, encodeString(tostring(k)) .. ":" .. encodeValue(v))
            end
        end
        return "{" .. table.concat(result, ",") .. "}"
    end
end

-- Remove whitespace from JSON string for easier parsing
function removeWhitespace(s)
    -- Keep spaces inside strings but remove others
    local inString = false
    local escape = false
    local result = {}
    
    for i = 1, #s do
        local c = s:sub(i, i)
        
        if inString then
            table.insert(result, c)
            if escape then
                escape = false
            elseif c == '\\' then
                escape = true
            elseif c == '"' then
                inString = false
            end
        else
            if c == '"' then
                inString = true
                table.insert(result, c)
            elseif c ~= ' ' and c ~= '\t' and c ~= '\n' and c ~= '\r' then
                table.insert(result, c)
            end
        end
    end
    
    return table.concat(result)
end

-- Decode a JSON string starting at position pos
function decodeValue(str, pos)
    local c = str:sub(pos, pos)
    
    if c == '{' then
        return parseObject(str, pos)
    elseif c == '[' then
        return parseArray(str, pos)
    elseif c == '"' then
        return parseString(str, pos)
    elseif c == '-' or (c >= '0' and c <= '9') then
        return parseNumber(str, pos)
    elseif c == 't' or c == 'f' then
        return parseBoolean(str, pos)
    elseif c == 'n' then
        return parseNull(str, pos)
    else
        error("Unexpected character at position " .. pos .. ": " .. c)
    end
end

-- Parse a JSON object (dictionary) starting at position pos
function parseObject(str, pos)
    local result = {}
    
    -- Move past the opening brace
    pos = pos + 1
    
    -- Check for empty object
    if str:sub(pos, pos) == '}' then
        return result, pos + 1
    end
    
    while true do
        -- Parse the key (must be a string)
        if str:sub(pos, pos) ~= '"' then
            error("Expected string key at position " .. pos)
        end
        
        local key, newPos = parseString(str, pos)
        pos = newPos
        
        -- Check for colon
        if str:sub(pos, pos) ~= ':' then
            error("Expected ':' at position " .. pos)
        end
        pos = pos + 1
        
        -- Parse the value
        local value
        value, pos = decodeValue(str, pos)
        result[key] = value
        
        -- Check for end of object or comma
        local c = str:sub(pos, pos)
        if c == '}' then
            return result, pos + 1
        elseif c == ',' then
            pos = pos + 1
        else
            error("Expected ',' or '}' at position " .. pos)
        end
    end
end

-- Parse a JSON array starting at position pos
function parseArray(str, pos)
    local result = {}
    
    -- Move past the opening bracket
    pos = pos + 1
    
    -- Check for empty array
    if str:sub(pos, pos) == ']' then
        return result, pos + 1
    end
    
    local index = 1
    while true do
        -- Parse the value
        local value
        value, pos = decodeValue(str, pos)
        result[index] = value
        index = index + 1
        
        -- Check for end of array or comma
        local c = str:sub(pos, pos)
        if c == ']' then
            return result, pos + 1
        elseif c == ',' then
            pos = pos + 1
        else
            error("Expected ',' or ']' at position " .. pos)
        end
    end
end

-- Parse a JSON string starting at position pos
function parseString(str, pos)
    -- Skip the opening quote
    pos = pos + 1
    
    local startPos = pos
    local escaped = false
    
    while pos <= #str do
        local c = str:sub(pos, pos)
        
        if escaped then
            escaped = false
        elseif c == '\\' then
            escaped = true
        elseif c == '"' then
            -- End of string found
            local value = str:sub(startPos, pos - 1)
            
            -- Process escapes
            value = value:gsub("\\\"", "\"")
                :gsub("\\\\", "\\")
                :gsub("\\b", "\b")
                :gsub("\\f", "\f")
                :gsub("\\n", "\n")
                :gsub("\\r", "\r")
                :gsub("\\t", "\t")
                :gsub("\\u(%x%x%x%x)", function(hex)
                    return string.char(tonumber(hex, 16))
                end)
            
            return value, pos + 1
        end
        
        pos = pos + 1
    end
    
    error("Unterminated string starting at position " .. (startPos - 1))
end

-- Parse a JSON number starting at position pos
function parseNumber(str, pos)
    local endPos = pos
    
    -- Find the end of the number
    while endPos <= #str do
        local c = str:sub(endPos, endPos)
        if (c >= '0' and c <= '9') or c == '-' or c == '+' or c == '.' or c:lower() == 'e' then
            endPos = endPos + 1
        else
            break
        end
    end
    
    local numStr = str:sub(pos, endPos - 1)
    
    -- Validate the number format
    if not numStr:match(NUMBER_PATTERN) then
        error("Invalid number format at position " .. pos .. ": " .. numStr)
    end
    
    return tonumber(numStr), endPos
end

-- Parse a JSON boolean starting at position pos
function parseBoolean(str, pos)
    if str:sub(pos, pos + 3) == "true" then
        return true, pos + 4
    elseif str:sub(pos, pos + 4) == "false" then
        return false, pos + 5
    else
        error("Invalid boolean at position " .. pos)
    end
end

-- Parse a JSON null starting at position pos
function parseNull(str, pos)
    if str:sub(pos, pos + 3) == "null" then
        return nil, pos + 4
    else
        error("Expected 'null' at position " .. pos)
    end
end

return json