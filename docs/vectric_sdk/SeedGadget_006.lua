-- VECTRIC LUA SCRIPT
-- ===================================================]]
-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
-- 2. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 3. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 4. This notice may not be removed or altered from any source distribution.

-- Easy Seed Gadget Master is written by Jim Anderson of Houston Texas 2020
-- ===================================================]]
-- Global Variables --
-- require("mobdebug").start()
local Ver = "6.0"  -- Version 6: Jan 2020 - Clean Up and added Ver to Dialog  
-- ===================================================]]
function DisplayTest(words)
  -- test a sub fuction
    DisplayMessageBox(words)
	return true
end -- function end

-- ===================================================]]
function main(script_path)
--[[
	Gadget Notes: Dec 2019 - My New Gadget
  
  ]]
-- Localized Variables --

-- Job Validation --
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: No job loaded")
    return false ; 
  end

-- Get Data --

-- Calculation --

-- Do Something --
  
  DisplayTest("Great: The Gadget Seed is working" .. " Version: " .. Ver )
  
  return true

end  -- function end
-- ===================================================]]