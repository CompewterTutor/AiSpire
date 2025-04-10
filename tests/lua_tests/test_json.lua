--[[
    test_json.lua - Test cases for the JSON module
    
    This file contains unit tests for the json.lua module.
    
    To run these tests, use the Busted framework:
    busted test_json.lua
    
    Author: AiSpire Team
    Version: 0.1.0 (Development)
    Date: April 9, 2025
--]]

-- Set up path to find our module
package.path = package.path .. ";../../lua_gadget/?.lua"

-- Import the JSON module
local json = require("json")

-- Define tests
describe("JSON Module", function()
    describe("json.encode", function()
        it("should encode nil correctly", function()
            assert.are.equal("null", json.encode(nil))
        end)
        
        it("should encode booleans correctly", function()
            assert.are.equal("true", json.encode(true))
            assert.are.equal("false", json.encode(false))
        end)
        
        it("should encode numbers correctly", function()
            assert.are.equal("42", json.encode(42))
            assert.are.equal("3.14", json.encode(3.14))
            assert.are.equal("-10", json.encode(-10))
        end)
        
        it("should handle special numbers", function()
            assert.are.equal("null", json.encode(0/0))       -- NaN
            assert.are.equal("null", json.encode(1/0))       -- Infinity
            assert.are.equal("null", json.encode(-1/0))      -- -Infinity
        end)
        
        it("should encode strings correctly", function()
            assert.are.equal("\"hello\"", json.encode("hello"))
            assert.are.equal("\"quoted \\\"text\\\"\"", json.encode("quoted \"text\""))
        end)
        
        it("should encode arrays correctly", function()
            assert.are.equal("[1,2,3]", json.encode({1, 2, 3}))
            assert.are.equal("[\"a\",\"b\",\"c\"]", json.encode({"a", "b", "c"}))
        end)
        
        it("should encode objects correctly", function()
            local obj = {name = "test", value = 123}
            local encoded = json.encode(obj)
            -- Order of keys isn't guaranteed, so we need to check both possibilities
            assert.is_true(encoded == "{\"name\":\"test\",\"value\":123}" or 
                           encoded == "{\"value\":123,\"name\":\"test\"}")
        end)
        
        it("should encode nested structures correctly", function()
            local nested = {
                name = "parent",
                children = {
                    {name = "child1", age = 10},
                    {name = "child2", age = 12}
                }
            }
            local encoded = json.encode(nested)
            assert.is_true(encoded:find("\"name\":\"parent\"") ~= nil)
            assert.is_true(encoded:find("\"children\":%[") ~= nil)
            assert.is_true(encoded:find("\"name\":\"child1\"") ~= nil)
            assert.is_true(encoded:find("\"name\":\"child2\"") ~= nil)
        end)
        
        it("should handle empty tables properly", function()
            assert.are.equal("{}", json.encode({}))
        end)
    end)
    
    describe("json.decode", function()
        it("should decode null correctly", function()
            assert.are.equal(nil, json.decode("null"))
        end)
        
        it("should decode booleans correctly", function()
            assert.are.equal(true, json.decode("true"))
            assert.are.equal(false, json.decode("false"))
        end)
        
        it("should decode numbers correctly", function()
            assert.are.equal(42, json.decode("42"))
            assert.are.equal(3.14, json.decode("3.14"))
            assert.are.equal(-10, json.decode("-10"))
        end)
        
        it("should decode strings correctly", function()
            assert.are.equal("hello", json.decode("\"hello\""))
            assert.are.equal("quoted \"text\"", json.decode("\"quoted \\\"text\\\"\""))
        end)
        
        it("should handle escape sequences", function()
            assert.are.equal("line1\nline2", json.decode("\"line1\\nline2\""))
            assert.are.equal("tab\tcharacter", json.decode("\"tab\\tcharacter\""))
            assert.are.equal("backslash\\character", json.decode("\"backslash\\\\character\""))
        end)
        
        it("should decode arrays correctly", function()
            local array = json.decode("[1, 2, 3]")
            assert.are.equal(1, array[1])
            assert.are.equal(2, array[2])
            assert.are.equal(3, array[3])
        end)
        
        it("should decode objects correctly", function()
            local obj = json.decode("{\"name\": \"test\", \"value\": 123}")
            assert.are.equal("test", obj.name)
            assert.are.equal(123, obj.value)
        end)
        
        it("should decode nested structures correctly", function()
            local nested = json.decode([[
                {
                    "name": "parent",
                    "children": [
                        {"name": "child1", "age": 10},
                        {"name": "child2", "age": 12}
                    ]
                }
            ]])
            assert.are.equal("parent", nested.name)
            assert.are.equal(2, #nested.children)
            assert.are.equal("child1", nested.children[1].name)
            assert.are.equal(10, nested.children[1].age)
            assert.are.equal("child2", nested.children[2].name)
            assert.are.equal(12, nested.children[2].age)
        end)
        
        it("should handle empty objects and arrays", function()
            local emptyObj = json.decode("{}")
            local emptyArray = json.decode("[]")
            assert.are.same({}, emptyObj)
            assert.are.same({}, emptyArray)
        end)
        
        it("should handle whitespace correctly", function()
            local obj = json.decode(" { \"name\" : \"test\" , \"value\" : 123 } ")
            assert.are.equal("test", obj.name)
            assert.are.equal(123, obj.value)
        end)
        
        it("should reject invalid JSON", function()
            local result, error = json.decode("{unclosed")
            assert.is_nil(result)
            assert.is_string(error)
            
            result, error = json.decode("{\"missing\":\"comma\"} {}")
            assert.is_nil(result)
            assert.is_string(error)
        end)
    end)
    
    describe("Round-trip conversion", function()
        it("should preserve data in encode-decode roundtrip", function()
            local structures = {
                42,
                "hello world",
                true,
                {1, 2, 3, 4},
                {name = "test", nested = {a = 1, b = 2}},
                {mixed = {1, 2, key = "value"}}
            }
            
            for _, value in ipairs(structures) do
                local encoded = json.encode(value)
                local decoded = json.decode(encoded)
                assert.are.same(value, decoded)
            end
        end)
    end)
end)