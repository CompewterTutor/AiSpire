--[[
    run_tests.lua - Test runner for AiSpire Lua Gadget tests
    
    This script runs all the Lua tests for the AiSpire project.
    It requires the Busted testing framework to be installed:
    https://olivinelabs.com/busted/
    
    Usage:
        busted run_tests.lua
    
    Author: AiSpire Team
    Version: 0.1.0 (Development)
    Date: April 9, 2025
--]]

-- Add project directories to Lua path
package.path = package.path .. ";../../lua_gadget/?.lua"

-- List of test files to run
local test_files = {
    "test_json.lua",
    -- Add more test files as they are created
}

-- Load each test file
for _, file in ipairs(test_files) do
    print("Running tests in " .. file)
    require(file:gsub(".lua$", ""))
end

print("All tests completed.")