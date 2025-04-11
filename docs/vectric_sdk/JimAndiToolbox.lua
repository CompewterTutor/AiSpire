 ╦╦╔╦╗╔═╗╔╗╔╔╦╗╦
 ║║║║║╠═╣║║║ ║║║
╚╝╩╩ ╩╩ ╩╝╚╝═╩╝╩
╔╦╗╔═╗╔═╗╦  ╔╗ ╔═╗═╗ ╦
 ║ ║ ║║ ║║  ╠╩╗║ ║╔╩╦╝
 ╩ ╚═╝╚═╝╩═╝╚═╝╚═╝╩ ╚═
-- Last Update : 10/30/2022
-- =====================================================]]
╔╦╗╔═╗╔╗ ╦  ╔═╗  ╔═╗╔╗╔╔╦╗  ╔═╗╦═╗╦═╗╔═╗╦ ╦  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║ ╠═╣╠╩╗║  ║╣   ╠═╣║║║ ║║  ╠═╣╠╦╝╠╦╝╠═╣╚╦╝   ║ ║ ║║ ║║  ╚═╗
 ╩ ╩ ╩╚═╝╩═╝╚═╝  ╩ ╩╝╚╝═╩╝  ╩ ╩╩╚═╩╚═╩ ╩ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function ArrayTools()
-- =====================================================]]
  function ArrayClear(arrayName)
    for _,v in ipairs(arrayName) do
      table.remove(arrayName, i)
    end -- for end
    return true
  end -- function end
  -- =====================================================]]
  function NameCheck(Name, Defalt, ListName)              -- Checks if Name in in the list of it is default name
    if Name ~= Defalt then
      for i=1, ListName do
        if Name == i then
          return true
        end
      end
      return false
    else
      return  true
    end
  end -- NameCheck function end
  -- =====================================================]]
  function RemoveDuplicates(tab, order)                   -- returns table of unique items in "A" acending or "D" decending
    local hashSet = {}
    local new = {}
    local value
    for i = 1, #tab do
      value = (tab[i])
      if hashSet[value] == nil then
        table.insert(new, value)
        hashSet[value] = true
      end
    end
    if string.upper(order) =="A" then
      table.sort(new)
    else
      table.sort(new, function(a, b) return a > b end)
    end
    return new
  end
  -- =====================================================]]
  function RemoveTableItem(tabName, tabItem)
    for x = 1 in ipairs(tabName) do
      if tabName[x] == tabItem then
         table.remove(tabName, i)
      end
    end -- for end
    return true
  end -- function end
  -- =====================================================]]
  function TableLength(tbl)                               -- tbl returns table count
    -- tbl = {7, 6, 5, 4, 3, 2, 1}
    local count = 0
    for _ in pairs(tbl) do
      count = count + 1
    end
    return count
  end
  -- =====================================================]]
  function FindDups(checktbl, duptbl, cleantbl)           -- Find all duplicate items and returns both dup and clean tables
    function tLength(tbl) -- tLength returns table count
      local count = 0
      for _ in pairs(tbl) do
        count = count + 1
      end
      return count
    end
    -- =================================
    local trip = false
    for i=1, tLength(checktbl) do
      for x=1, tLength(cleantbl) do
        if cleantbl[x] == checktbl[i] then
          trip = true
        end
      end
      if trip then
        table.insert(duptbl,   checktbl[i])
      else
        table.insert(cleantbl, checktbl[i])
      end
      trip = false
    end
    return table.sort(duptbl), table.sort(cleantbl) -- returns both dup and clean table
  end -- function end
  -- =====================================================]]
  function ReverseTable(tbl)                              -- Reverse table order
   --tbl = {7, 6, 7, A, 5, 4, 3, A, 2, 1}
    local n = #tbl
    local i = 1
    while i < n do
      tbl[i],tbl[n] = tbl[n],tbl[i]
      i = i + 1
      n = n - 1
    end
    return tbl
  end
  -- =====================================================]]
end -- ArrayTools function end
-- =====================================================]]
╔═╗╔═╗╔╗╔╦  ╦╔═╗╦═╗╔╦╗╦╔═╗╔╗╔  ╔╦╗╔═╗╔═╗╦  ╔═╗
║  ║ ║║║║╚╗╔╝║╣ ╠╦╝ ║ ║║ ║║║║   ║ ║ ║║ ║║  ╚═╗
╚═╝╚═╝╝╚╝ ╚╝ ╚═╝╩╚═ ╩ ╩╚═╝╝╚╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function ConvertingTools()
-- ====================================================]]
function bool2S(x)                                     -- Converts true or false to text
  if x then
    return "true"
  else
    return "false"
  end
end --function end
-- =====================================================]]
function D2S8(d)                                        --  Converts a Number (Double) to a String with 8 places
  return string.format("%.8f", d)
end -- function end
-- =====================================================]]
function D2S4(d)                                        --  Converts a Number (Double) to a String with 4 places
  return string.format("%.4f", d)
end -- function end
-- =====================================================]]
function toint(number)
  return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end
-- =====================================================]]
function Rounder(num, idp)                              --  Rounds a Number (Double) up or down
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end -- end function
-- =====================================================]]
function RUsame(num, comp)                              --  Rounds a Number (Double) up or down
  local function toint(number)
    return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
  end
  local function Rounder(num, idp)                      --  Rounds a Number (Double) up or down
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
  end -- end function
        num = math.abs(num)
  local idp = #comp
  local Mynum = Rounder(num, idp)
  local Myint = toint(Mynum)
  local Myval = tonumber(tostring(Myint) .. "." .. comp)
  if (Mynum == Myval) then
    return true
  else
    return false
  end -- if end
end -- end function
-- =====================================================]]
function WithIn(Num, Mat, Tol)                          --  Retuns true if number is within tolerance with match
  if ((Num >= (Mat - Tol)) and (Num <= (Mat + Tol))) then
    return true
  end -- if end
  return false
end -- end function
-- =====================================================]]
function Double2Fraction(Num)                           --  Converts a Measurement (Double) to a Fractional String
  local Frac = "Error"
  if Num then
    Frac = tostring(Num)
  end
  if (not Milling.Unit) and Num then
    local AmountValuex = math.floor(math.abs(Num))
    local DicValue    = Num - AmountValuex
    local AmountValue = tostring(AmountValuex)
    Frac              = tostring(DicValue)

    if Project.Fractions == "No Fractions" then
      Frac = tostring(Num)

    elseif Project.Fractions == "1/8" then
      if     DicValue >= 0.9375 then
        AmountValue = tostring(AmountValuex + 1)
        Frac = "0"
      elseif DicValue >= 0.8125 then Frac = "7/8" .. string.char(34)
      elseif DicValue >= 0.6875 then Frac = "3/4" .. string.char(34)
      elseif DicValue >= 0.5625 then Frac = "5/8" .. string.char(34)
      elseif DicValue >= 0.4375 then Frac = "1/2" .. string.char(34)
      elseif DicValue >= 0.3125 then Frac = "3/8" .. string.char(34)
      elseif DicValue >= 0.1875 then Frac = "1/4" .. string.char(34)
      elseif DicValue >= 0.0625 then Frac = "1/8" .. string.char(34)
      else
        Frac = "0"
      end
    elseif Project.Fractions == "1/16" then
      if     DicValue >= 0.96875 then
        AmountValue = tostring(AmountValuex + 1)
        Frac = "0"
      elseif DicValue >= 0.90625 then Frac = "15/16" .. string.char(34)
      elseif DicValue >= 0.84375 then Frac = "7/8"   .. string.char(34)
      elseif DicValue >= 0.78125 then Frac = "13/16" .. string.char(34)
      elseif DicValue >= 0.71875 then Frac = "3/4"   .. string.char(34)
      elseif DicValue >= 0.65625 then Frac = "11/16" .. string.char(34)
      elseif DicValue >= 0.59375 then Frac = "5/8"   .. string.char(34)
      elseif DicValue >= 0.53125 then Frac = "9/16"  .. string.char(34)
      elseif DicValue >= 0.46875 then Frac = "1/2"   .. string.char(34)
      elseif DicValue >= 0.40625 then Frac = "7/16"  .. string.char(34)
      elseif DicValue >= 0.34375 then Frac = "3/8"   .. string.char(34)
      elseif DicValue >= 0.28125 then Frac = "5/16"  .. string.char(34)
      elseif DicValue >= 0.21875 then Frac = "1/4"   .. string.char(34)
      elseif DicValue >= 0.15625 then Frac = "3/16"  .. string.char(34)
      elseif DicValue >= 0.09375 then Frac = "1/8"   .. string.char(34)
      elseif DicValue >= 0.03125 then Frac = "1/16"  .. string.char(34)
      else
        Frac = "0"
      end -- If end
    elseif Project.Fractions == "1/32" then
      if     DicValue >= 0.984375 then
        AmountValue = tostring(AmountValuex + 1)
        Frac = "0"
      elseif DicValue >= 0.953126 then Frac = "31/32" .. string.char(34)
      elseif DicValue >= 0.921876 then Frac = "15/16" .. string.char(34)
      elseif DicValue >= 0.890626 then Frac = "29/32" .. string.char(34)
      elseif DicValue >= 0.859376 then Frac = "7/8"   .. string.char(34)
      elseif DicValue >= 0.828126 then Frac = "27/32" .. string.char(34)
      elseif DicValue >= 0.796876 then Frac = "13/16" .. string.char(34)
      elseif DicValue >= 0.765626 then Frac = "25/32" .. string.char(34)
      elseif DicValue >= 0.737376 then Frac = "3/4"   .. string.char(34)
      elseif DicValue >= 0.703126 then Frac = "23/32" .. string.char(34)
      elseif DicValue >= 0.671876 then Frac = "11/16" .. string.char(34)
      elseif DicValue >= 0.640626 then Frac = "21/32" .. string.char(34)
      elseif DicValue >= 0.609376 then Frac = "5/8"   .. string.char(34)
      elseif DicValue >= 0.578126 then Frac = "19/32" .. string.char(34)
      elseif DicValue >= 0.541260 then Frac = "9/16"  .. string.char(34)
      elseif DicValue >= 0.515626 then Frac = "17/32" .. string.char(34)
      elseif DicValue >= 0.484376 then Frac = "1/2"   .. string.char(34)
      elseif DicValue >= 0.468760 then Frac = "15/32" .. string.char(34)
      elseif DicValue >= 0.421876 then Frac = "7/16"  .. string.char(34)
      elseif DicValue >= 0.390626 then Frac = "13/32" .. string.char(34)
      elseif DicValue >= 0.359376 then Frac = "3/8"   .. string.char(34)
      elseif DicValue >= 0.328126 then Frac = "11/32" .. string.char(34)
      elseif DicValue >= 0.296876 then Frac = "5/16"  .. string.char(34)
      elseif DicValue >= 0.265626 then Frac = "9/32"  .. string.char(34)
      elseif DicValue >= 0.234376 then Frac = "1/4"   .. string.char(34)
      elseif DicValue >= 0.203126 then Frac = "7/32"  .. string.char(34)
      elseif DicValue >= 0.171876 then Frac = "3/16"  .. string.char(34)
      elseif DicValue >= 0.140626 then Frac = "5/32"  .. string.char(34)
      elseif DicValue >= 0.109376 then Frac = "1/8"   .. string.char(34)
      elseif DicValue >= 0.078126 then Frac = "3/32"  .. string.char(34)
      elseif DicValue >= 0.046876 then Frac = "1/16"  .. string.char(34)
      elseif DicValue >= 0.015626 then Frac = "1/32"  .. string.char(34)
      else
        Frac = "0"
      end -- If end
    elseif Project.Fractions == "1/64" then
      if     DicValue >= 0.9921875 then
        AmountValue = tostring(AmountValuex + 1)
        Frac = "0"
        elseif DicValue >= 0.9765625 then Frac = "62/64" .. string.char(34)
        elseif DicValue >= 0.9609375 then Frac = "31/32" .. string.char(34)
        elseif DicValue >= 0.9453125 then Frac = "61/64" .. string.char(34)
        elseif DicValue >= 0.9296875 then Frac = "15/16" .. string.char(34)
        elseif DicValue >= 0.9140625 then Frac = "59/64" .. string.char(34)
        elseif DicValue >= 0.8984375 then Frac = "29/32" .. string.char(34)
        elseif DicValue >= 0.8828125 then Frac = "57/64" .. string.char(34)
        elseif DicValue >= 0.8671875 then Frac = "7/8"   .. string.char(34)
        elseif DicValue >= 0.8515625 then Frac = "55/64" .. string.char(34)
        elseif DicValue >= 0.8359375 then Frac = "27/32" .. string.char(34)
        elseif DicValue >= 0.8203125 then Frac = "53/64" .. string.char(34)
        elseif DicValue >= 0.8046875 then Frac = "13/16" .. string.char(34)
        elseif DicValue >= 0.7890625 then Frac = "51/64" .. string.char(34)
        elseif DicValue >= 0.7734375 then Frac = "25/32" .. string.char(34)
        elseif DicValue >= 0.7578125 then Frac = "49/64" .. string.char(34)
        elseif DicValue >= 0.7421875 then Frac = "3/4"   .. string.char(34)
        elseif DicValue >= 0.7265625 then Frac = "47/64" .. string.char(34)
        elseif DicValue >= 0.7109375 then Frac = "23/32" .. string.char(34)
        elseif DicValue >= 0.6953125 then Frac = "45/64" .. string.char(34)
        elseif DicValue >= 0.6796875 then Frac = "11/16" .. string.char(34)
        elseif DicValue >= 0.6640625 then Frac = "43/64" .. string.char(34)
        elseif DicValue >= 0.6484375 then Frac = "21/32" .. string.char(34)
        elseif DicValue >= 0.6328125 then Frac = "41/64" .. string.char(34)
        elseif DicValue >= 0.6171875 then Frac = "5/8"   .. string.char(34)
        elseif DicValue >= 0.6015625 then Frac = "39/64" .. string.char(34)
        elseif DicValue >= 0.5859375 then Frac = "19/32" .. string.char(34)
        elseif DicValue >= 0.5703125 then Frac = "37/64" .. string.char(34)
        elseif DicValue >= 0.5546875 then Frac = "9/16"  .. string.char(34)
        elseif DicValue >= 0.5390625 then Frac = "35/64" .. string.char(34)
        elseif DicValue >= 0.5234375 then Frac = "17/32" .. string.char(34)
        elseif DicValue >= 0.5078125 then Frac = "33/64" .. string.char(34)
        elseif DicValue >= 0.4921875 then Frac = "1/2"   .. string.char(34)
        elseif DicValue >= 0.4765625 then Frac = "31/64" .. string.char(34)
        elseif DicValue >= 0.4609375 then Frac = "15/32" .. string.char(34)
        elseif DicValue >= 0.4453125 then Frac = "29/32" .. string.char(34)
        elseif DicValue >= 0.4296875 then Frac = "7/16"  .. string.char(34)
        elseif DicValue >= 0.4140625 then Frac = "27/64" .. string.char(34)
        elseif DicValue >= 0.3984375 then Frac = "13/32" .. string.char(34)
        elseif DicValue >= 0.3828125 then Frac = "25/64" .. string.char(34)
        elseif DicValue >= 0.3671875 then Frac = "3/8"   .. string.char(34)
        elseif DicValue >= 0.3515625 then Frac = "23/64" .. string.char(34)
        elseif DicValue >= 0.3359375 then Frac = "11/32" .. string.char(34)
        elseif DicValue >= 0.3203125 then Frac = "21/64" .. string.char(34)
        elseif DicValue >= 0.3046875 then Frac = "5/16"  .. string.char(34)
        elseif DicValue >= 0.2890625 then Frac = "19/64" .. string.char(34)
        elseif DicValue >= 0.2734375 then Frac = "9/32"  .. string.char(34)
        elseif DicValue >= 0.2578125 then Frac = "17/64" .. string.char(34)
        elseif DicValue >= 0.2421875 then Frac = "1/4"   .. string.char(34)
        elseif DicValue >= 0.2265625 then Frac = "15/64" .. string.char(34)
        elseif DicValue >= 0.2109375 then Frac = "7/32"  .. string.char(34)
        elseif DicValue >= 0.1953125 then Frac = "13/64" .. string.char(34)
        elseif DicValue >= 0.1796875 then Frac = "3/16"  .. string.char(34)
        elseif DicValue >= 0.1640625 then Frac = "11/64" .. string.char(34)
        elseif DicValue >= 0.1484375 then Frac = "5/32"  .. string.char(34)
        elseif DicValue >= 0.1328125 then Frac = "9/64"  .. string.char(34)
        elseif DicValue >= 0.1171875 then Frac = "1/8"   .. string.char(34)
        elseif DicValue >= 0.1015625 then Frac = "7/64"  .. string.char(34)
        elseif DicValue >= 0.0859375 then Frac = "3/32"  .. string.char(34)
        elseif DicValue >= 0.0703125 then Frac = "5/64"  .. string.char(34)
        elseif DicValue >= 0.0546875 then Frac = "1/16"  .. string.char(34)
        elseif DicValue >= 0.0390625 then Frac = "3/64"  .. string.char(34)
        elseif DicValue >= 0.0234375 then Frac = "1/32"  .. string.char(34)
        elseif DicValue >= 0.0078125 then Frac = "1/64"  .. string.char(34)
        else
          Frac = "0"
        end -- If end
      end
    if Project.Fractions == "No Fractions" then
      Frac = tostring(Num)
    else
      if Frac == "0" then
        Frac = AmountValue .. string.char(34)
      else
        if AmountValue ~= "0" then
          Frac = AmountValue .. "-" .. Frac
        end
      end
    end
  end
  return Frac
end -- function end
-- =====================================================]]
end -- Convert Tools end
-- =====================================================]]
╔╦╗╦╔╦╗╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║ ║║║║║╣    ║ ║ ║║ ║║  ╚═╗
 ╩ ╩╩ ╩╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function DateTimeTools()
-- =====================================================]]
  function StartDateTime(LongShort)
--[[ Date Value Codes
--  |   %a  abbreviated weekday name (e.g., Wed)
--  |    %A  full weekday name (e.g., Wednesday)
--  |    %b  abbreviated month name (e.g., Sep)
--  |    %B  full month name (e.g., September)
--  |    %c  date and time (e.g., 09/16/98 23:48:10)
--  |    %d  day of the month (16) [01-31]
--  |    %H  hour, using a 24-hour clock (23) [00-23]
--  |    %I  hour, using a 12-hour clock (11) [01-12]
--  |    %M  minute (48) [00-59]
--  |    %m  month (09) [01-12]
--  |    %p  either "am" or "pm" (pm)
--  |    %S  second (10) [00-60]
--  |    %w  weekday (3) [0-6 = Sunday-Saturday]
--  |    %x  date (e.g., 09/16/98)
--  |    %X  time (e.g., 23:48:10)
--  |    %Y  full year (e.g., 1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´ ]]
    if LongShort then
      return os.date("%b %d, %Y") .. " - " .. os.date("%I") .. ":" .. os.date("%m") .. os.date("%p")
    else
      return os.date("%Y%m%d%H%M")
    end
  end
-- =====================================================]]
  function StartDate(LongShort)
--[[ Date Value Codes
--  |   %a  abbreviated weekday name (e.g., Wed)
--  |    %A  full weekday name (e.g., Wednesday)
--  |    %b  abbreviated month name (e.g., Sep)
--  |    %B  full month name (e.g., September)
--  |    %c  date and time (e.g., 09/16/98 23:48:10)
--  |    %d  day of the month (16) [01-31]
--  |    %H  hour, using a 24-hour clock (23) [00-23]
--  |    %I  hour, using a 12-hour clock (11) [01-12]
--  |    %M  minute (48) [00-59]
--  |    %m  month (09) [01-12]
--  |    %p  either "am" or "pm" (pm)
--  |    %S  second (10) [00-60]
--  |    %w  weekday (3) [0-6 = Sunday-Saturday]
--  |    %x  date (e.g., 09/16/98)
--  |    %X  time (e.g., 23:48:10)
--  |    %Y  full year (e.g., 1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´ ]]

    if LongShort then
      return os.date("%b %d, %Y")  -- "Sep 01, 2022"
    else
      return os.date("%Y%m%d")     -- "20220901"
    end
  end
-- ====================================================]]
function Wait(time)
    local duration = os.time() + time
    while os.time() < duration do end
end
-- =====================================================]]
end -- Date Time Tools function end
-- =====================================================]]
╔╦╗╔═╗╔╗ ╦ ╦╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║║╣ ╠╩╗║ ║║ ╦   ║ ║ ║║ ║║  ╚═╗
═╩╝╚═╝╚═╝╚═╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function DebugTools()
-- =====================================================]]
  function DMark(Note, Pt)
  --[[-- ==MarkPoint==
    | Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
    | Draws mark on the drawing
    | call = DebugMarkPoint("Note: Hi", Pt1)
    ]]
    local function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
  --[[ draws a circle based on user inputs
    | job - current validated job unique ID
    | Cpt - (2Dpoint) center of the circle
    | CircleRadius - radius of the circle
    | Layer - layer name to draw circle (make layer if not exist)
    ]]
      local pa   = Polar2D(Cpt, 180.0, CircleRadius)
      local pb   = Polar2D(Cpt,   0.0, CircleRadius)
      local line = Contour(0.0)
      line:AppendPoint(pa); line:ArcTo(pb,1); line:ArcTo(pa,1)
      local layer = job.LayerManager:GetLayerWithName(LayerName)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end
  -- ====]]
    local BubbleSize = 1.25
    if not Project.DebugAngle then
      Project.DebugAngle = 0.0
    end
    Project.DebugAngle = Project.DebugAngle + 2.0
    if Project.DebugAngle >= 90.0 and Project.DebugAngle <= 358.0 then
      Project.DebugAngle = 272.0
    elseif Project.DebugAngle >= 360.0 then
      Project.DebugAngle = 2.0
    end
    if Pt then
      local job = VectricJob()
      local Pt1 = Polar2D(Pt, Project.DebugAngle, BubbleSize)
      local Pt2 = Polar2D(Pt1, 0.0, BubbleSize * 0.25)
      local Pt3 = Polar2D(Pt2, 315.0, BubbleSize * 0.0883883476483188 * 4.0)
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName("Debug")
      line:AppendPoint(Pt)
      line:LineTo(Pt1)
      line:LineTo(Pt2)
      layer:AddObject(CreateCadContour(line), true)
      DrawWriter(Note, Pt3, BubbleSize * 0.5, "Debug", 0.0)
      DrawCircle(job, Pt, BubbleSize * 0.5, "Debug")
    else
      DisplayMessageBox("Issue with Point for - " .. Note)
    end
    return true
  end -- function end
-- =====================================================]]
function StatusMessage(Type, Header, Question, ErrorNumber)
  --[[
  Useage:          type     Header Info              Question or Message                                  Err No.
    StatusMessage("Error", "Base Cabinet Settings", "Face Frame Bottom Rail Width - value cannot be 0.", "(9000)")
    Note: if the debug flag is on (true) a message box shows the message length, dialog size and error number
  ]]
  local dialog
  local X = 460
  local Y = 124
  local step = 35
  Question = WrapString(Question, step)
  local QL = string.len(Question)
  if (QL > step) and (QL < step * 2) then
    Y = Y + 12
  elseif (QL > (step * 2) +1) and (QL < 105) then
    Y = Y + 24
  elseif (QL > (step * 3) +1) and (QL < (step * 4)) then
    Y = Y + 36
  elseif (QL > (step * 4) +1) and (QL < (step * 5)) then
    Y = Y + 48
  elseif (QL > (step * 5) +1) and (QL < (step * 6)) then
    Y = Y + 60
  elseif (QL > (step * 6) +1) and (QL < (step * 7)) then
    Y = Y + 72
  elseif (QL > (step * 7) +1) and (QL < (step * 8)) then
    Y = Y + 84
  elseif (QL > (step * 8) +1) and (QL < (step * 9)) then
    Y = Y + 96
  elseif (QL > (step * 9) +1) and (QL < (step * 10)) then
    Y = Y + 108
  elseif (QL > (step * 10) +1) and (QL < (step * 11)) then
    Y = Y + 120
  else
    Y = Y + 150
  end
  if Project.Debugger then
    Queston = Question .. " - " .. ErrorNumber
  end
  if Type == "Alert" then
    dialog = HTML_Dialog(true, DialogWindow.myHtml16, X, Y, Header)
  else -- "Error"
    dialog = HTML_Dialog(true, DialogWindow.myHtml17, X, Y, Header)
  end -- if end
  if Project.Debugger then
    Question = Question .. " " .. ErrorNumber
  end
  dialog:AddLabelField("Question", Type .. ": " .. Question)
  dialog:ShowDialog()
  if Project.Debugger then
    DisplayMessageBox("Question Len " .. " = " .. tostring(string.len(Question)) .. ": \nWindow = " .. tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight))
  end
  return true
end
-- =====================================================]]
  function DebugMarkPoint(Note, Pt, Size, LayerName)
  --[[-- ==MarkPoint==
  | Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
  | Draws mark on the drawing
  | call = DebugMarkPoint("Note: Hi", Pt1, 0.125, "Jim")
  ]]
    if Size == nil then
      Size = 0.125
    end
    if LayerName == nil then
      LayerName = "Debug"
    end
    local function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- | draws a circle based on user inputs
  -- | job - current validated job unique ID
  -- | Cpt - (2Dpoint) center of the circle
  -- | CircleRadius - radius of the circle
  -- | Layer - layer name to draw circle (make layer if not exist)
      local pa = Polar2D(Cpt, 180.0, CircleRadius)
      local pb = Polar2D(Cpt,   0.0, CircleRadius)
      local line = Contour(0.0)
      line:AppendPoint(pa); line:ArcTo(pb,1);   line:ArcTo(pa,1)
      local layer = job.LayerManager:GetLayerWithName(LayerName)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end
  -- ====]]
    local job = VectricJob()
    local Pt1 = Polar2D(Pt, Project.DebugAngle, Size * 2.0)
    local Pt2 = Polar2D(Pt1, 0.0, 0.500 * Size)
    local Pt3 = Polar2D(Pt2, 315.0, (0.500 * Size) * 1.4142135623731)
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    line:AppendPoint(Pt)
    line:LineTo(Pt1)
    line:LineTo(Pt2)
    layer:AddObject(CreateCadContour(line), true)
    DrawWriter(Note, Pt3, Size, LayerName, 0.0)
    DrawCircle(job, Pt, Size, LayerName)
    return true
  end -- function end
-- =====================================================]]
  function ShowDialogSize()                             -- Returns Dialog X and Y size
    DisplayMessageBox(tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight))
  end -- function end
-- =====================================================]]
end -- End Debug
-- =====================================================]]
╔╦╗╦╔═╗╦  ╔═╗╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║║╠═╣║  ║ ║║ ╦   ║ ║ ║║ ║║  ╚═╗
═╩╝╩╩ ╩╩═╝╚═╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function DialogTools()
-- =====================================================]]
function DialogSize(Str)                     -- returns the X and Y value of the dialogue
  local InText = string.find(string.upper(Str) , "X")
  local DialogX = All_Trim(string.sub(Str, 1, InText - 1))
  local DialogY = All_Trim(string.sub(Str, InText + 1))
  return tonumber(DialogX), tonumber(DialogY)
end -- end function
-- ====================================================]]
function ProgressBarAmount(TotalRecords, Record) -- Calculates the percent amount of progression based on total process
  --[[
  local MyProgressBar
    MyProgressBar = ProgressBar("Working", ProgressBar.LINEAR)                -- Setup Type of progress bar
    MyProgressBar:SetPercentProgress(0)                                       -- Sets progress bar to zero
    MyProgressBar:SetPercentProgress(ProgressAmount(Door.Records, myRecord))  -- sends percent of process progress bar (adds to the bar)
    MyProgressBar:SetPercentProgress(ProgressAmount(12000, 416))              -- sends percent of process progress bar (adds to the bar)
    MyProgressBar:SetText("Compete")                                          -- Sets the label to Complete
    MyProgressBar:Finished()                                                  -- Close Progress Bar
  ]]
  local X1 = (100.0 / TotalRecords)
  local X2 = X1 * Record
  local X3 = math.abs(X2)
  local X4 = (math.floor(X3))
  return (math.floor(math.abs((100.0 / TotalRecords) * Record)))
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryGearCalulate(dialog)
  Gear.Addendum         = dialog:GetDoubleField("Gear.Addendum")
  Gear.Dedendum         = dialog:GetDoubleField("Gear.Dedendum")
  Gear.AddendumDiameter = dialog:GetDoubleField("Gear.AddendumDiameter")
  Gear.DedendumDiameter = dialog:GetDoubleField("Gear.DedendumDiameter")
  Gear.ToothTickness    = dialog:GetDoubleField("Gear.ToothTickness")
  Gear.Slotwidth        = dialog:GetDoubleField("Gear.Slotwidth")
  Gear.PitchAmount      = dialog:GetDoubleField("Gear.PitchAmount")
  Gear.FilletRadius     = dialog:GetDoubleField("Gear.FilletRadius")
  Gear.ToplandAmount    = dialog:GetDoubleField("Gear.ToplandAmount")
  Gear.FaceFlankRadius  = dialog:GetDoubleField("Gear.FaceFlankRadius")
  Gear.ToothCount       = dialog:GetDropDownListValue("Gear.ToothCount")
  Gear.ShowLines        = dialog:GetDropDownListValue("Gear.ShowLines")

  dialog:UpdateDoubleField("Gear.Addendum",                      Gear.Addendum)
  dialog:UpdateDoubleField("Gear.Dedendum",                      Gear.Dedendum)
  dialog:UpdateDoubleField("Gear.AddendumDiameter",              Gear.AddendumDiameter)
  dialog:UpdateDoubleField("Gear.DedendumDiameter",              Gear.DedendumDiameter)
  dialog:UpdateDoubleField("Gear.ToothTickness",                 Gear.ToothTickness)
  dialog:UpdateDoubleField("Gear.Slotwidth",                     Gear.Slotwidth)
  dialog:UpdateDoubleField("Gear.PitchAmount",                   Gear.PitchAmount)
  dialog:UpdateDoubleField("Gear.FilletRadius",                  Gear.FilletRadius)
  dialog:UpdateDoubleField("Gear.ToplandAmount",                 Gear.ToplandAmount)
  dialog:UpdateDoubleField("Gear.FaceFlankRadius",               Gear.FaceFlankRadius)

  return true
end -- function end
-- =====================================================]]
function InquiryDropList(Header, Quest, DX, DY, DList)
--[[
    Drop list foe user input
    Caller: local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Cabinet Maker"
    Quest = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML><html lang="en"><head><title>My List Box</title><style>.FormButton{font-weight:700;width:75px;font-size:12px;white-space:nowrap;font-family:Arial,Helvetica,sans-serif font-size: 12px}.h1-l{font-size:12px;font-weight:700;text-align:left;white-space:nowrap}.h1-c{font-size:12px;font-weight:700;text-align:center;white-space:nowrap}table{width:100%;border:0}body,td,th{background-color:#3a4660;background-position:center;overflow:hidden;font-family:arial,helvetica,sans-serif;font-size:12px;color:#fff;background-image:url(']].. DialogWindow.myBackGround ..[[')}html{overflow:hidden}</style></head><body><table><tr><td class="h1-l" id="Questions"><strong class="h2">Message Here</strong></td></tr><tr><td class="h1-c"><select name="DList" size="10" class="h1-c" id="ListBox"><option>My Default 1</option><option selected="selected">My Default 2</option><option>My Default 3</option><option>My Default 4</option></select></td></tr><tr><th class="h1-l" colspan="3" id="QuestionID"></th></tr></table><table><tr><td class="h1-c"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td><td></td><td class="h1-c"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></body></html>]] ;

    local dialog = HTML_Dialog(true, myHtml, DX, DY, Header)
          dialog:AddLabelField("Questions", Quest)
          dialog:AddDropDownList("ListBox", "DEFAULT")
          dialog:AddDropDownListValue("ListBox", "DEFAULT")
    for index, value in pairs(DList) do
        dialog:AddDropDownListValue("ListBox", value)
    end
    if not dialog:ShowDialog() then
      return "."
    else
      return dialog:GetDropDownListValue("ListBox")
    end
end
-- =====================================================]]
function InquiryFileBox(Header, Quest, DefaltPath)
--[[
    Dialog Box for user to pick a file
    Caller: local X = InquiryFileBox("Select File", "Where is the file location?", "C:\\")
    Dialog Header = "File Name"
    User Question = "Path name?"
    Default Value = "C:\\"
    Returns = String
  ]]
  local myHtml = [[<html> <head> <title>Easy Tools</title> <style type = "text/css">  html {overflow: hidden; } body {
             background-color: #EBEBEB; overflow:hidden; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } body, td,
             th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ;
             width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }
             </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0">
             <tr> <th align = "left" valign = "top" bgcolor = "#EBEBEB" id = "QuestionID"><strong>Message Here</strong></th>
             <th align = "left" valign = "middle" bgcolor = "#EBEBEB">&nbsp;</th> </tr> <tr>
             <th width = "381" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID">
             <input name = "ReadFile" type = "text" id = "ReadFile" size = "60"></th>
             <th width = "83" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <span style="width: 15%">
             <input id = "FilePicker" class = "FilePicker" name = "FilePicker" type = "button" value = "Path">
             </span></th> </tr> <tr> <td colspan = "2" align = "center" valign = "middle" bgcolor = "#EBEBEB">
             <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"> </td>
             <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%">
             <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td>
             <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
             </td> </tr> </table> </td> </tr> </table> </body>  </html>]]
  -- =============================================
  local dialog = HTML_Dialog(true, myHtml, 505, 150, Header)
    dialog:AddLabelField("QuestionID", Quest)
    dialog:AddTextField("ReadFile", DefaltPath )
    dialog:AddFilePicker(true, "FilePickerButton", "ReadFile", true)
    if not dialog:ShowDialog() then
      return ""
    else
      return dialog:GetTextField("ReadFile")
    end -- if end
 end -- function end
-- =====================================================]]
function InquiryPathBox(Header, Quest, DefaltPath)
--[[
    Number Box for user input with default value
    Caller: local X = InquiryPathBox("Select Path", "Where is the file location?", "C:\\")
    Dialog Header = "Tool Name"
    User Question = "Path name?"
    Default Value = "C:\\"
    Returns = String
  ]]
  local myHtml = [[ <html> <head> <title>Easy Tools</title> <style type = "text/css">  html {overflow: hidden; } body {
             background-color: #EBEBEB; overflow:hidden; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } body, td,
             th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ;
             width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }
             </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0">
             <tr> <th align = "left" valign = "top" bgcolor = "#EBEBEB" id = "QuestionID"><strong>Message Here</strong></th>
             <th align = "left" valign = "middle" bgcolor = "#EBEBEB">&nbsp;</th> </tr> <tr>
             <th width = "381" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID">
             <input name = "DInput" type = "text" id = "DInput" size = "60"></th>
             <th width = "83" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <span style="width: 15%">
             <input id = "DirectoryPicker" class = "DirectoryPicker" name = "DirectoryPicker" type = "button" value = "Path">
             </span></th> </tr> <tr> <td colspan = "2" align = "center" valign = "middle" bgcolor = "#EBEBEB">
             <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"> </td>
             <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%">
             <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td>
             <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
             </td> </tr> </table> </td> </tr> </table> </body>  </html>]]
  -- =============================================
  local dialog = HTML_Dialog(true, myHtml, 505, 150, Header)
    dialog:AddLabelField("QuestionID", Quest)
    dialog:AddTextField("DInput", DefaltPath )
    dialog:AddDirectoryPicker("DirectoryPicker",  "DInput",  true)
    if not dialog:ShowDialog() then
      return ""
    else
      return dialog:GetTextField("DInput")
    end -- if end
 end -- function end
-- =====================================================]]
function InquiryAreYouSureYesNo(Header, Question1, Question2)
 --[[
     Drop list for user to input project info
     Caller = local y = InquiryAreYouSureYesNo("Pie Question", "Do you want free pie")
     Dialog Header = "Pie Question"
     User Question1 = "Do you want a Free Pie"
     User Question2 = "You only get one"
     Returns = true / false
   ]]
    local myHtml = [[ <html><head><title>Yes or No Question</title>]] .. DialogWindow.Style ..[[</head><body><table><tr><td colspan="3" class="h2-lw" id="Question1">Question1</td></tr><tr><td colspan="3" class="h2-lw" id="Question2">Question2</td></tr><tr><td class="h2-l">&nbsp;</td></tr><tr><td colspan="3" class="h2-l">Are you sure?</td></tr><tr><td class="h2-l">&nbsp;</td></tr></table><table><tr><td colspan="3"><h2><span></span></h2></td></tr>
   <tr><td class="h1-l"><input id="ButtonOK" class="FormButton FormBut" name="ButtonOK" type="button" value="  Yes  "> </td> <td class="h1-r"> <input id="ButtonCancel" class="FormButton FormBut" name="ButtonCancel" type="button" value="  No  "></td></tr></table></body></html>]]
-- =========================================================
    local dialog = HTML_Dialog(true, myHtml, 440, 218, Header)
    dialog:AddLabelField("Question1", Question1)
    dialog:AddLabelField("Question2", Question2)
    if not dialog:ShowDialog() then
      return false
    else
      return true
    end
 end
-- =====================================================]]
function InquiryDoubleBox(Header, Quest, DefaltN)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
   local myHtml = [[<html><head><title>Get Double Value</title><style type="text/css">html{overflow:hidden}body{background-color:#ebebeb;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px;text:#000}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:700;text-align:left;white-space:nowrap}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:700;text-align:right;white-space:nowrap}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:700;text-align:center;white-space:nowrap}table{width:100%;border:0;cellpadding:0}.FilePicker{font-weight:700;font-family:Arial,Helvetica,sans-serif;font-size:12px;width:50px}.FormButton{font-weight:700;width:65px;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style></head><body><table><tr><td id="QuestionID" class="h1-r"><strong>Message Here</strong></td><td><input type="text" id="NumberInput" size="5"></td></tr><tr><td colspan="2"></td></tr></table><table><tr class="h1-c"><td><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td><td><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></body></html>]]
   local dialog = HTML_Dialog(true, myHtml, 260, 125, Header)
   dialog:AddLabelField("QuestionID", Quest) ;
   dialog:AddDoubleField("NumberInput", DefaltN) ;
  if not dialog:ShowDialog() then
    return -1
  else
    return dialog:GetDoubleField("NumberInput")
  end
end -- function end
-- =====================================================]]
function InquiryIntegerBox(Header, Quest, DefaltI)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryIntegerBox("Cabinet Maker", "Enter the door count", 4)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the door count"
-- Default value = 4
-- Returns = integer
]]
   local myHtml = [[<html><head><title>Get Number</title><style type="text/css">html{overflow:auto}body{background-color:#ebebeb}table{width:100%;border:0}body,td,th{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000}.FormButton{font-weight:700;width:85px;font-family:Arial,Helvetica,sans-serif;font-size:12px}body{background-color:#ebebeb;text:#000}</style></head><body><table><tr><td id="QuestionID"><strong>Message Here</strong></td><td><input type="text" id="IntegerInput" size="10"></td></tr><tr><td colspan="2"></td></tr></table><table><tr><td><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td><td><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></body></html>]]
   local dialog = HTML_Dialog(true, myHtml, 505, 140, Header)
   dialog:AddLabelField("QuestionID", Quest)
   dialog:AddIntegerField("IntegerInput", DefaltI)
  if not dialog:ShowDialog() then
    return -1
  else
    return dialog:GetIntegerField("NumberInput")
  end
end -- function end
-- =====================================================]]
function InquiryTextgBox(Header, Quest, DefaltS)
--[[
-- InquiryStringBox for user input with default number value
-- Caller: local x = InquiryTextgBox("Cabinet Maker", "Enter the cabinet Name", "Jim")
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet Name"
-- Default value = Jim
-- Returns = string
]]
   local myHtml = [[<html><head><title>Get Number</title><style type="text/css">html{overflow:auto}body{background-color:#ebebeb}table{width:100%;border:0}body,td,th{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000}.FormButton{font-weight:700;width:85px;font-family:Arial,Helvetica,sans-serif;font-size:12px}body{background-color:#ebebeb;text:#000}</style></head><body><table><tr><td id="QuestionID"><strong>Message Here</strong></td><td><input type="text" id="StringInput" size="10"></td></tr><tr><td colspan="2"></td></tr></table><table><tr><td><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td><td><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></body></html>]]
   local dialog = HTML_Dialog(true, myHtml, 505, 140, Header)
   dialog:AddLabelField("QuestionID", Quest)
   dialog:AddTextField("StringInput", DefaltS)
  if not dialog:ShowDialog() then
    return -1
  else
    return dialog:GetTextField("NumberInput")
  end
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryError(Message)
    --[[
     Provides user information on an Error
     Caller = local ItWorked = OnLuaButton_InquiryError("No number found")
     Dialog Header = "Something Error"
     User Message = "No Number etc..."
     Returns = True
   ]]
  local myHtml = [[<html><head><title>Error</title><style type = "text/css">.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap}.Error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.ErrorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.ErrorTable{background-color:#FFF white-space:nowrap}html{overflow:hidden}</style></head><body text = "#000000"><table width="100%" border="0" cellpadding="0" class="ErrorTable"><tr><th align="center" nowrap="nowrap" class="Error">Error!</th></tr><tr><td id="ErrorMessage"><label class="ErrorMessage">-</label></tr><tr><td width="30%" align="right" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "Exit"></td></tr></table></body></html>]]
  local dialogWide =  (#Message + 300)
  local dialog = HTML_Dialog(true, myHtml, 250, dialogWide, "Gadget Error")
  dialog:AddLabelField("ErrorMessage",   Message)
  dialog:ShowDialog()
  Dovetail.InquiryErrorX = Dialog.WindowWidth
  Dovetail.InquiryErrorY = Dialog.WindowHeight
  WriteRegistry()
  return  true
end
-- =====================================================]]
function PresentMessage(Header, Type, Line)
    --[[
     Provides user information on an Error
     Caller = local ItWorked = OnLuaButton_InquiryError("No number found")
     Dialog Header = "Something Error"
     User Message = "No Number etc..."
     Returns = True
   ]]
  local myHtml = [[<html><head><title>Error</title>]] .. DialogWindow.Style ..[[</head><body>
  <table><tr><th valign="top" id="MessageType" class="Error">-</th><td id="MessageLine"><label class="ErrorMessage">-</label><td></tr>
<tr><td></td><td align="right"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td></tr>
</table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 500, 150, Header)
  dialog:AddLabelField("MessageType", Type .. ": ")
  dialog:AddLabelField("MessageLine", Line)
  dialog:ShowDialog()
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryAbout()
local myHtml = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" id="Version" class="ver-c">Version</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. Dovetail.AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center"><span class="header2-c">JimAndi</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 720, 468, "About")
  dialog:AddLabelField("SysName", Project.ProgramName)
  dialog:AddLabelField("Version", "Version: " .. Project.ProgramVersion)
  dialog:ShowDialog()
  Project.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  return  true
end
-- =====================================================]]
function Color_HTML ()
  MessageBox(" X = " .. tostring(dialog.WindowWidth) ..
             " Y = " .. tostring(dialog.WindowHeight)
 )
-- =====================================================]]
--[[ -- begin HTML for Layer Color
<table>
  <tr>
    <td width="200" align="right" valign="middle" nowrap class="h1-rp">Layer Name</td>
    <td width="300" align="right" valign="middle" nowrap class="h1-l" id="ValueTable">
      <input name="Panel.PinHole" type="text" class="h1-l" id="Panel.PinHole" size="50" maxlength="50"/>
      </td>
    <td width="150"align="right" valign="middle" nowrap class="h1-l"><label for="Panel.LineColor01">Color</label>
      <select name="Panel.LineColor01" id="Panel.LineColor01">
        <option selected="selected">Black</option>
        <option>Blue</option>
        <option>Brown</option>
        <option>Cyan</option>
        <option>Gray</option>
        <option>Green</option>
        <option>Lime</option>
        <option>Magenta</option>
        <option>Maroon</option>
        <option>Navy</option>
        <option>Olive</option>
        <option>Orange</option>
        <option>Purple</option>
        <option>Red</option>
        <option>Silver</option>
        <option>Teal</option>
        <option>White</option>
        <option>Yellow</option>
    </select></td>
  </tr>
</table>
<table width="101%" border="0" id="ButtonTable">
</table>
]] -- end HTML
end -- HTML Function end
-- =====================================================]]
function Style ()
-- =====================================================]]
DialogWindow.Style = [[ <style>
.DirectoryPicker {
  font-weight: bold;
  font-size: 12px;
  white-space: nowrap;
  background-color: #663300;
  color: #FFFFFF;
}
.FormButton {
	font-weight: bold;
	width: 75px;
	font-size: 12px;
	white-space: nowrap;
	background-color: #663300;
	color: #FFFFFF;
}
.FormButton-Help {
	font-weight: bold;
	width: 75px;
	font-size: 12px;
	white-space: nowrap;
	background-color: #663300;
	color: #FFFFFF;
	padding-left: 10;
	padding-right: 10;
}
.LuaButton {
	font-weight: bold;
	font-size: 12px;
	background-color: #663300;
	color: #FFFFFF;
}
.ToolNameLabel {
	font-weight: bolder;
	font-size: 12px;
	text-align: left;
	color: #000;
	width: 70%;
}
.ToolPicker {
	font-weight: bold;
	text-align: center;
	font-size: 12px;
	text-align: center;
	width: 50px;
	background-color: #663300;
	color: #FFFFFF;
}
.alert-c {
	font-size: 14px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
}
.alert-l {
	font-size: 14px;
	font-weight: bold;
	text-shadow: 5px 5px 10px #FFF;
	text-align: left;
	width: 100%;
	white-space: nowrap;
}
.alert-r {
	font-size: 14px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
}
.error {
	font-size: 18px;
	font-weight: bold;
	color: #FF0000;
	text-align: left;
	white-space: nowrap;
	padding-right: 4px;
	padding-left: 10px;
	padding-top: 4px;
	padding-bottom: 4px;
}
.errorMessage {
	font-size: 12px;
	color: #000;
	font-weight: bold;
	text-align: left;
	white-space: nowrap;
	padding-right: 4px;
	padding-left: 10px;
	padding-top: 4px;
	padding-bottom: 4px;
}
.errorTable {
	background-color: #FFFFFF;
	white-space: nowrap;
}
.p1-l {
	font-size: 12px;
	text-align: left;
}
.h1-c {
	font-size: 12px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
}
.h1-cOk {
	font-size: 12px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
	width: 15%;
}
.h1-l {
	font-size: 12px;
	font-weight: bold;
	text-align: left;
	white-space: nowrap;
}
.h1-r {
	font-size: 12px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
}
.h1-rP {
	font-size: 12px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
	padding-right: 4px;
	padding-left: 4px;
}
.h1-rPx {
	font-size: 12px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
	padding-right: 8px;
	padding-left: 8px;
}
.h2-c {
	font-size: 14px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
	text-shadow: 2px 2px white;
}
.h2-l {
	font-size: 14px;
	font-weight: bold;
	color: #663300;
	text-align: left;
	white-space: nowrap;
	text-shadow: 2px 2px white;
}
.h2-r {
	font-size: 14px;
	font-weight: bold;
	color: #663300;
	text-align: right;
	white-space: nowrap;
	text-shadow: 2px 2px white;
}
.h3-bc {
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
}
.h3-c {
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
}
.h3-l {
	font-size: 16px;
	font-weight: bold;
	text-align: left;
	white-space: nowrap;
}
.h3-r {
	font-size: 16px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
}
.h4-c {
	font-size: 18px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
}
.h4-l {
	font-size: 18px;
	font-weight: bold;
	text-align: left;
	white-space: nowrap;
}
.h4-r {
	font-size: 18px;
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
}
.help_But {
	width: 45px;
}
.MyCenter{
	text-align:center;
	width:10;
}
.MyLeft{
	text-align:left;
	width:10;
}
.MyRight{
	text-align:right;
	width:10;
}
.helplabel-r {
	cursor: pointer;
	white-space: nowrap;
	text-align: right;
}
.helplabel-rp {
	cursor: pointer;
	white-space: nowrap;
	text-align: right;
	padding-right: 8px;
}
.jsTag-no-vis {
	font-size: 10px;
	display: none;
	text-align: center;
	color: #00F;
	visibility: hidden;
}
.jsbutton {
	background-color: #663300;
	border: 2px solid #999;
	border-right-color: #000;
	border-bottom-color: #000;
	border-top-color: #FFF;
	border-left-color: #FFF;
	text-align: center;
	text-decoration: none;
	font-size: 12px;
	margin: 1px 1px;
	color: #FFFFFF;
}
.p1-c {
	font-size: 12px;
	text-align: center;
}
.p1-r {
	font-size: 12px;
	text-align: right;
}
.ver-c {
	font-size: 10px;
	font-weight: bold;
	text-align: center;
	white-space: nowrap;
	color: #ffd9b3;
}
.webLink-c {
	font-size: 16px;
	font-weight: bold;
	background-color: yellow;
	text-align: center;
	white-space: nowrap;
}
body {
	background-color: #3a4660;
	background-position: center;
	overflow: hidden;
	font-family: arial, helvetica, sans-serif;
	font-size: 12px;
	color: #FFFFFF;
	background-image: url(]].. DialogWindow.myBackGround ..[[);
}
html {
	overflow: hidden
}
table {
	width: 100%;
	border: 0;
}
</style>]]
end
-- =====================================================]]
function Orgin ()                                       -- Anchor Point
-- ================================
  DialogWindow.Orgin = [[<table><tr><td colspan="2" class="h2-l">Anchor Point</td></tr><tr class="MyLeft"><td class="MyLeft"><table class="MyCenter"><tr><td><input type="radio" name="DrawingOrigin" checked="checked" value="V1"></td><td><hr></td><td valign="top"><input type="radio" name="DrawingOrigin" checked="checked" value="V2"></td></tr><tr><td class="auto-style9">|</td><td><input type="radio" name="DrawingOrigin" checked="checked" value="V3"></td><td valign="top">|</td></tr><tr><td><input type="radio" name="DrawingOrigin" checked="checked" value="V4"></td><td><hr></td><td valign="top"><input type="radio" name="DrawingOrigin" checked="checked" value="V5"></td></tr></table></td><td width="81%"><table><tr class="MyLeft"><td>X</td><td><input name="OriginX0" type="text" id="OriginX" size="8" maxlength="8"></td></tr><tr class="MyLeft"><td>Y</td><td><input name="OriginY0" type="text" id="OriginY" size="8" maxlength="8"></td></tr></table></td></tr></table>]]
end -- HTML Function end
-- =====================================================]]
function GetColor(str)                                  -- returns the RGB value for the standard color names
-- str = "Purple"
-- returns = 128 0 128
    local Colors = {}
    Colors.Black  = "0,0,0";       Colors.White  = "255,255,255"; Colors.Red    = "255,0,0"
    Colors.Lime   = "0,255,0";     Colors.Blue   = "0,0,255";     Colors.Yellow = "255,255,0"
    Colors.Cyan   = "0,255,255";   Colors.Magenta = "255,0,255";  Colors.Silver = "192,192,192"
    Colors.Gray   = "128,128,128"; Colors.Maroon = "128,0,0";     Colors.Olive  = "128,128,0"
    Colors.Green  = "0,128,0";     Colors.Purple = "128,0,128";   Colors.Teal   = "0,128,128"
    Colors.Navy   = "0,0,128"
    local Red, Green, Blue = 0
    if "" == str then
      DisplayMessageBox("Error: Empty string passed")
    else
      str = Colors[str]
      if "string" == type(str) then
        if string.find(str, ",") then
          Red  = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          str = string.sub(str, assert(string.find(str, ",") + 1))
          Green = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          Blue = tonumber(string.sub(str, assert(string.find(str, ",") + 1)))
        end
      else
        DisplayMessageBox("Error: Color Not Found")
        Red = 0
        Green = 0
        Blue = 0
      end
    end
    return Red, Green, Blue
  end -- function end
-- =====================================================]]
end -- Dialog Tools function end
-- =====================================================]]
╔╦╗╦╦═╗╔═╗╔═╗╔╦╗╔═╗╦═╗╦ ╦  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║║╠╦╝║╣ ║   ║ ║ ║╠╦╝╚╦╝   ║ ║ ║║ ║║  ╚═╗
═╩╝╩╩╚═╚═╝╚═╝ ╩ ╚═╝╩╚═ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function DirectoryTools()
-- =====================================================]]
  function MakeFolder(xPath)
    os.execute( "mkdir  " .. xPath)
    return true
  end
-- =====================================================]]
  function FileExists(name)
-- FileExists(name
-- DisplayMessageBox(name)
    local f=io.open(name,"r")
    if f~=nil then
      io.close(f)
      return true
    else
      return false
    end
  end -- Function end
-- =====================================================]]
  function DirectoryProcessor(job, dir_name, filter, do_sub_dirs, function_ptr)
      local num_files_processed = 0
      local directory_reader = DirectoryReader()
      local cur_dir_reader = DirectoryReader()
      directory_reader:BuildDirectoryList(dir_name, do_sub_dirs)
      directory_reader:SortDirs()
      local number_of_directories = directory_reader:NumberOfDirs()
      for i = 1, number_of_directories do
        local cur_directory = directory_reader:DirAtIndex(i)
         -- get contents of current directory
         -- dont include sub dirs, use passed filter
        cur_dir_reader:BuildDirectoryList(cur_directory.Name, false)
        cur_dir_reader:GetFiles(filter, true, false)
         -- call passed method for each file:
        local num_files_in_dir = cur_dir_reader:NumberOfFiles()
        for j=1, num_files_in_dir  do
          local file_info = cur_dir_reader:FileAtIndex(j)
          if not function_ptr(job, file_info.Name) then
            return true
          end -- if end
           num_files_processed = num_files_processed + 1
        end -- for end
        -- empty out our directory object ready for next go
        cur_dir_reader:ClearDirs()
        cur_dir_reader:ClearFiles()
      end -- for end
      return num_files_processed
  end -- function end
-- =====================================================]]
end -- Directory Tools end
-- =====================================================]]
╔╦╗╦═╗╔═╗╦ ╦╦╔╗╔╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║╠╦╝╠═╣║║║║║║║║ ╦   ║ ║ ║║ ║║  ╚═╗
═╩╝╩╚═╩ ╩╚╩╝╩╝╚╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function DrawTools()
-- =====================================================]]
function LayerClear(LayerName)
  local Mylayer = Milling.job.LayerManager:GetLayerWithName(LayerName)
     if Mylayer.IsEmpty then
        Milling.job.LayerManager:RemoveLayer(Mylayer)
     end -- if end
  return true
end -- function end

-- ====================================================]]
function Scale(Num)
  local mtl_block = MaterialBlock()
  if mtl_block.InMM then
    return Num * 25.4
  else
    return Num
  end
end -- end function

-- =====================================================]]
function AssyHoler(pt1, pt2, PartName)                  -- Draws Assy Holes in a stight line
  local Ang1 = GetPolarDirection(pt1, pt2)
  local Ang2 = GetPolarDirection(pt2, pt1)
  pt1 = Polar2D(pt1, Ang1, Milling.AssemblyHoleStartEnd)
  DrawCircle(pt1, Milling.AssemblyHoleRad, Milling.LNAssemblyHole .. PartName)
  pt2 = Polar2D(pt2, Ang2, Milling.AssemblyHoleStartEnd)
  DrawCircle(pt2, Milling.AssemblyHoleRad, Milling.LNAssemblyHole .. PartName)
  local Dist = GetDistance(pt1, pt2)
  if Project.Debugger then
    DMark("pt1", pt1)
    DMark("pt2", pt2)
  end
  BaseScrew(2)
  Milling.AssemblyHoleSpace = ((Milling.AssemblyHoleMaxSpace + Milling.AssemblyHoleMinSpace) * 0.5)
  HoleCount = Round(math.floor(Dist / Milling.AssemblyHoleSpace))
  HoleSpacing = (Dist / HoleCount)
  HoleCount = (Dist / HoleSpacing)
  if (Dist > (HoleSpacing * 2.0)) then
    for i = HoleCount, 1, -1 do
      pt1 = Polar2D(pt1, Ang1, HoleSpacing)
      DrawCircle(pt1, Milling.AssemblyHoleRad, Milling.LNAssemblyHole .. PartName)
      if Project.Debugger then
        DMark("pt1w", pt1)
      end
      BaseScrew(1)
    end -- for end
  elseif (Dist > HoleSpacing) then
    ptC = Polar2D(pt1, Ang1, Dist / 2.0)
    if Project.Debugger then
      DMark("ptC", ptC)
    end
    DrawCircle(ptC, Milling.AssemblyHoleRad, Milling.LNAssemblyHole .. PartName)
  else
    -- Done No Holes
  end
  return true
end -- end AssyHoler function
  -- =====================================================]]
  function DrawBoneCenter2Pts(pt1, pt2, SlotWidth, BitRadius)
    Local Project = {}
    Project.job   = VectricJob()
    Project.ang   = GetPolarDirection(pt1, pt2)
    Project.dis   = H(SlotWidth)
    Project.bit   = math.sin(math.rad(45.0)) * BitRadius
    Project.ptA   = Polar2D(pt1, Project.ang +  90.0, Project.dis)
    Project.ptAa  = Polar2D(Project.ptA, Project.ang, Project.bit)
    Project.ptAb  = Polar2D(Project.ptA, Project.ang + 270.0, Project.bit)
    Project.ptB   = Polar2D(pt1, Project.ang + 270.0, Project.dis)
    Project.ptBa  = Polar2D(Project.ptB, Project.ang +  90.0, Project.bit)
    Project.ptBb  = Polar2D(Project.ptB, Project.ang, Project.bit)
    Project.ptC   = Polar2D(pt2, Project.ang + 270.0, Project.dis)
    Project.ptCa  = Polar2D(Project.ptC, Project.ang +  90.0, Project.bit)
    Project.ptCb  = Polar2D(Project.ptC, Project.ang - 180.0, Project.bit)
    Project.ptD   = Polar2D(pt2, Project.ang +  90.0, Project.dis)
    Project.ptDa  = Polar2D(Project.ptD, Project.ang - 180.0, Project.bit)
    Project.ptDb  = Polar2D(Project.ptD, Project.ang + 270.0, Project.bit)
    Project.line  = Contour(0.0)
    Project.layer = Project.job.LayerManager:GetLayerWithName("DogBone")
    Project.line:AppendPoint(Project.ptAa)
    Project.line:ArcTo(Project.ptAb, 1.0)
    Project.line:LineTo(Project.ptBa)
    Project.line:ArcTo(Project.ptBb, 1.0)
    Project.line:LineTo(Project.ptCb)
    Project.line:ArcTo(Project.ptCa, 1.0)
    Project.line:LineTo(Project.ptDb)
    Project.line:ArcTo(Project.ptDa, 1.0)
    Project.line:LineTo(Project.ptAa)
    Project.layer:AddObject(CreateCadContour(Project.line), true)
    return true
  end -- function end
  -- =====================================================]]
function InsideCornerNipper(AngPlung, BitRadius, CornerPt)
  local NipLength = math.sin(math.rad(45.0)) * ((BitRadius + 0.04) * 2.0)
  local Pt1, Pt2 = Point2D()
  if Material.Orientation == "V" then
    Pt1 = Polar2D(CornerPt, (AngPlung + 90.0) - 45.0, NipLength)
    Pt2 = Polar2D(CornerPt, (AngPlung + 90.0) + 45.0, NipLength)
  else
    Pt1 = Polar2D(CornerPt, (AngPlung + 180.0) - 45.0, NipLength)
    Pt2 = Polar2D(CornerPt, (AngPlung + 180.0) + 45.0, NipLength)
  end
  return Pt1, Pt2
end
  -- =====================================================]]
  function AddGroupToJob(job, group, layer_name)
     --[[  --------------- AddGroupToJob --------------------------------------------------|
  |  Add passed group to the job - returns object created
  |  Parameters:
  |     job              -- job we are working with
  |     group            -- group of contours to   add to document
  |     layer_name       -- name of layer group will be created on|
  |  Return Values:
  |     object created to represent group in document
  ]]
     --  create a CadObject to represent the  group
    local cad_object = CreateCadGroup(group);
     -- create a layer with passed name if it doesnt already exist
    local layer = job.LayerManager:GetLayerWithName(layer_name)
     -- and add our object to it
    layer:AddObject(cad_object, true)
    return cad_object
  end

  -- =====================================================]]
  function DrawArc(PtS, PtE, ArcRadius, Layer)
  --[[Draw Arc
  function main(script_path)
  local MyPt1 = Point2D(3.5,3.8)
  local MyPt2 = Point2D(3.5,6.8)
  local layer = "My Arc"
  DrawArc(MyPt1, MyPt2, -0.456, Layer)
  return true
  end -- function end
  -- -----------------------------------------------------]]
      local job = VectricJob()
      if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false
      end
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(Layer)
      line:AppendPoint(PtS)
      line:ArcTo(PtE,1);
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end

  -- =====================================================]]
  function DrawEllipse(CenterPt, LongAxe, ShortAxe, Layer)
    local LongAngle = 90.0
    local ValueAB = (LongAxe - ShortAxe) * 0.50
    local ValueAC = ValueAB * math.cos(math.rad(LongAngle))
    local job = VectricJob()
    local LRad = LongAxe * 0.50
    local ptT = Polar2D(CenterPt, LongAngle, LRad)
    local X = 0.0
    local pty = Point2D(0.0,0.0)
    local ptx   = Point2D(0.0,0.0)
    local mylayer = job.LayerManager:GetLayerWithName(Layer)
    local line = Contour(0.0)
          line:AppendPoint(ptT)
    while (X < 360.0) do
      pty = Polar2D(CenterPt, LongAngle + X, LRad)
      ValueAC = ValueAB * math.cos(math.rad(LongAngle + X))
      if ((LongAngle + X) >= 90.0) then
        ptx = Polar2D(pty, 180.0, ValueAC)
      else
        ptx = Polar2D(pty,   0.0, ValueAC)
      end
      line:LineTo(ptx)
      X = X + 1
    end -- while end
      line:LineTo(ptT)
    mylayer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
  -- =====================================================]]
  function DrawEllipse1(DrawEllipse_CenterPt, DrawEllipse_LongAxe, DrawEllipse_ShortAxe, DrawEllipse_LongAxeAngle, DrawEllipse_Layer)
    -- ---------------------------------------------------]]
    function H(x)                                         -- Returns half the value
      return x * 0.5
    end -- function end
    -- ---------------------------------------------------]]
    function Polar2D(pt, ang, dis)
    -- The Polar2D function will calculate a new point in space
    -- based on a Point of reference, Angle of direction, and Projected distance.
    -- Returns a 2Dpoint(x, y)
      return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
    end -- End Function
    -- ---------------------------------------------------]]
    function GetDistance(objA, objB)
      local xDist = objB.x - objA.x
      local yDist = objB.y - objA.y
      return math.sqrt((xDist ^ 2) + (yDist ^ 2))
    end -- function end
    -- ---------------------------------------------------]]
    function Radius2Bulge (p1, p2, Rad)
      local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
      local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
      local bulge = (2 * seg) / chord
      return bulge
    end -- function end
    -- ---------------------------------------------------]]
  function GetPolarAngle(Start, Corner, End)
    local function GetPolarDirection(point1, point2)              --
      local ang = math.abs(math.deg(math.atan((point2.Y - point1.Y) / (point2.X - point1.X))))
      if point1.X < point2.X then
        if point1.Y < point2.Y then
          ang = ang + 0.0
        else
          ang = 360.0 - ang
        end -- if end
      else
        if point1.Y < point2.Y then
          ang = 180.0 - ang
        else
          ang = ang + 180.0
        end -- if end
      end -- if end
      if ang >=360 then
        ang = ang -360.0
      end -- if end
      return ang
    end -- function end
    return  math.abs(GetPolarDirection(Corner, Start) - GetPolarDirection(Corner, End))
  end -- function end
    -- ---------------------------------------------------]]

    -- Call = DrawEllipse(2DPoint(20.0, 20.0), 20.0, 10.0, 0.0, "Jim")
    local job = VectricJob()
    local EndRadius = 0.0
    local TopRadius = 0.0
    local ptT = Polar2D(DrawEllipse_CenterPt,  (90.0 + DrawEllipse_LongAxeAngle), H(DrawEllipse_ShortAxe))
    local ptB = Polar2D(DrawEllipse_CenterPt, (270.0 + DrawEllipse_LongAxeAngle), H(DrawEllipse_ShortAxe))
    local ptR = Polar2D(DrawEllipse_CenterPt,   (0.0 + DrawEllipse_LongAxeAngle), H(DrawEllipse_LongAxe))
    local ptL = Polar2D(DrawEllipse_CenterPt, (180.0 + DrawEllipse_LongAxeAngle), H(DrawEllipse_LongAxe))
    local ptC = DrawEllipse_CenterPt
    --[[
      DMark("ptC", ptC)
      DMark("ptT", ptT)
      DMark("ptB", ptB)
      DMark("ptL", ptL)
      DMark("ptR", ptR)
  ]]
    local C_Offset = H(DrawEllipse_LongAxe - DrawEllipse_ShortAxe)
    local LT_SlopeDist = H(GetDistance(ptL, ptT) - H(DrawEllipse_LongAxe - DrawEllipse_ShortAxe))
    local LT_Dist  = GetDistance(ptL, ptT)
    local LT_Angle = math.abs(90.0 - GetAngle(ptT, ptL, ptC))
    local pt_a = Polar2D(ptL, LT_Angle + DrawEllipse_LongAxeAngle, LT_SlopeDist)
    local aT_Dist  = GetDistance(pt_a, ptT)
    local aC_Dist = aT_Dist / (math.tan(math.rad(LT_Angle)))
    local Tc_Dist = math.sqrt(aT_Dist^2 + aC_Dist^2)
    local pt_c = Polar2D(ptT, (270.0 + DrawEllipse_LongAxeAngle), Tc_Dist)
    local cC_Dist  = GetDistance(pt_c, ptC)
    local b_Dist = math.tan(math.rad(LT_Angle)) * cC_Dist
    local pt_b = Polar2D(ptC, (180.0 + DrawEllipse_LongAxeAngle), b_Dist)
    local pt_d = Polar2D(ptB,  (90.0 + DrawEllipse_LongAxeAngle), Tc_Dist)
    local pt_e = Polar2D(ptC,   (0.0 + DrawEllipse_LongAxeAngle), b_Dist)
    local pt1  = Polar2D(pt_d, (270.0 + DrawEllipse_LongAxeAngle) - LT_Angle, Tc_Dist)
    local pt2  = Polar2D(pt_d, (270.0 + DrawEllipse_LongAxeAngle) + LT_Angle, Tc_Dist)
    local pt3  = Polar2D(pt_c,  (90.0 + DrawEllipse_LongAxeAngle) - LT_Angle, Tc_Dist)
    local pt4  = Polar2D(pt_c,  (90.0 + DrawEllipse_LongAxeAngle) + LT_Angle, Tc_Dist)
    --[[
      DMark("pt1", pt1)
      DMark("pt2", pt2)
      DMark("pt3", pt3)
      DMark("pt4", pt4)
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(DrawEllipse_Layer)
      line:AppendPoint(pt1)
      line:LineTo(pt2)
      line:LineTo(pt3)
      line:LineTo(pt4)
      line:LineTo(pt1)
      layer:AddObject(CreateCadContour(line), true)
  ]]
    local T_Sec   = GetDistance(ptC, ptT) - H(GetDistance(pt1, pt4))
    local R_Sec   = GetDistance(ptC, ptR) - H(GetDistance(pt1, pt2))
    local T_Chor  = GetDistance(pt1, pt2)
    local R_Chor  = GetDistance(pt1, pt4)
    local T_Bulge = Radius2Bulge (pt1, pt2, Tc_Dist)
    local L_Bulge = Radius2Bulge (pt1, pt4, GetDistance(ptL, pt_b))

    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(DrawEllipse_Layer)
    line:AppendPoint(pt1)
    line:ArcTo(pt2, T_Bulge)
    line:ArcTo(pt3, L_Bulge)
    line:ArcTo(pt4, T_Bulge)
    line:ArcTo(pt1, L_Bulge)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true
  end -- Draw Ellipse function end


  -- =====================================================]]
  function DrawBox(p1, p2, p3, p4, Layer)
    --[[ Draw Box
    function main(script_path)
    local MyPt1 = Point2D(1.0,1.0)
    local MyPt2 = Point2D(1.0,3.0)
    local MyPt3 = Point2D(3.0,1.0)
    local MyPt4 = Point2D(3.0,3.0)
    local layer = "My Box"
    DrawBox(MyPt1 ,MyPt2, MyPt3, MyPt4, Layer)
    return true
    end -- function end
  -- -----------------------------------------------------]]
      local job = VectricJob()
      if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false
      end -- if end
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(Layer)
      line:AppendPoint(p1)
      line:LineTo(p2)
      line:LineTo(p3)
      line:LineTo(p4)
      line:LineTo(p1)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end
  -- =====================================================]]
  function DrawCircle(Pt1, CenterRadius, Layer)
    --[[ ==Draw Circle==
    function main(script_path)
    local MyPt1 = Point2D(1.0,1.0)
    local MyRad = 3.0
    local layer = "My Box"
    DrawCircle(MyPt1, MyRad, Layer)
    return true
    end -- function end
  -- -----------------------------------------------------]]
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: No job loaded")
      return false
    end -- if end
    local pa = Polar2D(Pt1,   180.0, CenterRadius)
    local pb = Polar2D(Pt1,     0.0, CenterRadius)
    local Contour = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    Contour:AppendPoint(pa)
    Contour:ArcTo(pb, 1)
    Contour:ArcTo(pa, 1)
    layer:AddObject(CreateCadContour(Contour), true)
    return true
  end -- function end
  -- =====================================================]]
  function DrawLine(Pt1, Pt2, Layer)
  --[[Draws a line from Pt1 to Pt2 on the layer name.
  function main(script_path)
  local MyPt1 = Point2D(3.5,3.8)
  local MyPt2 = Point2D(3.5,6.8)
  local layer = "My Line"
  DrawLine(MyPt1 , MyPt2, MyPt3, Layer)
  return true
  end -- function end
  -- -----------------------------------------------------]]
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: No job loaded")
      return false
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(Pt1)
    line:LineTo(Pt2)
    layer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
  -- =====================================================]]
  function DrawStar(pt1, InRadius ,OutRadius, layer)      --This draw function requires the center point, inter star radius, outer star radius and layer name.
  --[[
    function main(script_path)
      local MyPt = Point2D(3.5,3.8)
      local InRadius = 9.0
      local OutRadius= 20.0
      local layer = "My Star"
      DrawStar(MyPt , InRadius ,OutRadius, layer)
      return true
    end -- function end
  -- -----------------------------------------------------]]
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: No job loaded")
      return false
    end
    local p1 =  Polar2D(pt1,  18.0,  OutRadius)
    local p2 =  Polar2D(pt1,  54.0,  InRadius)
    local p3 =  Polar2D(pt1,  90.0,  OutRadius)
    local p4 =  Polar2D(pt1,  126.0, InRadius)
    local p5 =  Polar2D(pt1,  162.0, OutRadius)
    local p6 =  Polar2D(pt1,  198.0, InRadius)
    local p7 =  Polar2D(pt1,  234.0, OutRadius)
    local p8 =  Polar2D(pt1,  270.0, InRadius)
    local p9 =  Polar2D(pt1,  306.0, OutRadius)
    local p0 =  Polar2D(pt1,  342.0, InRadius)
    local line = Contour(0.0)
   -- local layers = job.LayerManager:GetLayerWithName(layer)
    line:AppendPoint(p1);
    line:LineTo(p2);  line:LineTo(p3)
    line:LineTo(p4);  line:LineTo(p5)
    line:LineTo(p6);  line:LineTo(p7)
    line:LineTo(p8);  line:LineTo(p9)
    line:LineTo(p0);  line:LineTo(p1)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true
  end -- function end

  -- =====================================================]]
  function DrawTriangle(p1, p2, p3, Layer)
  --[[Draw Triangle
    function main(script_path)
      local MyPt1 = Point2D(3.5,3.8)
      local MyPt2 = Point2D(3.5,6.8)
      local MyPt3 = Point2D(9.8,6.8)
      local layer = "My Triangle"
      DrawTriangle(MyPt1 , MyPt2, MyPt3, Layer)
      return true
    end -- function end
  -- -----------------------------------------------------]]
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: No job loaded")
      return false
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1)
    line:LineTo(p2)
    line:LineTo(p3)
    line:LineTo(p1)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true
  end -- function end


  -- =====================================================]]
  function Radius2Bulge (p1, p2, Rad)
    local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
    local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
    local bulge = (2 * seg) / chord
    return bulge
  end

  -- =====================================================]]
  function ChordSeg2Radius (Chr, Seg)
    local rad =  (((Chr * Chr)/(Seg * 4)) + Seg) / 2.0
    return rad
  end  -- end Function

  -- =====================================================]]
  function DrawFontGrid(job)
    local pt = Point2D(0.3,0.3)
    local scl  = 1.0 -- (scl * 0.5)
    local pA0  = pt
    local ang  = 0.0
    local pA1  = Polar2D(pt, ang + 90.0000, (0.2500 * scl))
    local pA2  = Polar2D(pt, ang + 90.0000, (0.5000 * scl))
    local pA3  = Polar2D(pt, ang + 90.0000, (0.7500 * scl))
    local pA4  = Polar2D(pt, ang + 90.0000, (1.0000 * scl))
    local pA5  = Polar2D(pt, ang + 90.0000, (1.2500 * scl))
    local pA6  = Polar2D(pt, ang + 90.0000, (1.5000 * scl))
    local pA7  = Polar2D(pt, ang + 90.0000, (1.7500 * scl))
    local pA8  = Polar2D(pt, ang + 90.0000, (2.0000 * scl))
    local pA9  = Polar2D(pt, ang + 90.0000, (2.2500 * scl))
    local pA10 = Polar2D(pt, ang + 90.0000, (2.5000 * scl))

    PointCircle(pA0)
    PointCircle(pA1)
    PointCircle(pA2)
    PointCircle(pA3)
    PointCircle(pA4)
    PointCircle(pA5)
    PointCircle(pA6)
    PointCircle(pA7)
    PointCircle(pA8)
    PointCircle(pA9)
    PointCircle(pA10)

    local pB0  = Polar2D(pt, ang +  0.0000, (0.2500 * scl))
    local pB1  = Polar2D(pt, ang + 45.0000, (0.3536 * scl))
    local pB2  = Polar2D(pt, ang + 63.4352, (0.5590 * scl))
    local pB3  = Polar2D(pt, ang + 71.5651, (0.7906 * scl))
    local pB4  = Polar2D(pt, ang + 75.9638, (1.0308 * scl))
    local pB5  = Polar2D(pt, ang + 78.6901, (1.2748 * scl))
    local pB6  = Polar2D(pt, ang + 80.5376, (1.5207 * scl))
    local pB7  = Polar2D(pt, ang + 81.8699, (1.7678 * scl))
    local pB8  = Polar2D(pt, ang + 82.8750, (2.0156 * scl))
    local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl))

    PointCircle(pB0)
    PointCircle(pB1)
    PointCircle(pB2)
    PointCircle(pB3)
    PointCircle(pB4)
    PointCircle(pB5)
    PointCircle(pB7)
    PointCircle(pB8)
    PointCircle(pB10)

    local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl))
    local pC1 = Polar2D(pt, ang + 26.5650, (0.5590 * scl))
    local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl))
    local pC3 = Polar2D(pt, ang + 56.3099, (0.9014 * scl))
    local pC4 = Polar2D(pt, ang + 63.4342, (1.1180 * scl))
    local pC5 = Polar2D(pt, ang + 68.1993, (1.3463 * scl))
    local pC6 = Polar2D(pt, ang + 71.5650, (1.5811 * scl))
    local pC7 = Polar2D(pt, ang + 63.4342, (1.1180 * scl))
    local pC8 = Polar2D(pt, ang + 74.0550, (1.8201 * scl))
    local pC10 = Polar2D(pt, ang + 78.6899, (2.5495 * scl))

    PointCircle(pC0)
    PointCircle(pC1)
    PointCircle(pC2)
    PointCircle(pC3)
    PointCircle(pC4)
    PointCircle(pC6)
    PointCircle(pC8)
    PointCircle(pC10)

    local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl))
    local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl))
    local pD2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl))
    local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl))
    local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl))
    local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl))

    PointCircle(pD0)
    PointCircle(pD1)
    PointCircle(pD2)
    PointCircle(pD4)
    PointCircle(pD7)
    PointCircle(pD8)

    local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl))
    local pE1 = Polar2D(pt, ang + 18.4346, (0.7906 * scl))
    local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl))
    local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl))
    local pE5 = Polar2D(pt, ang + 59.0371, (1.4578 * scl))
    local pE6 = Polar2D(pt, ang + 63.4349, (1.6771 * scl))
    local pE7 = Polar2D(pt, ang + 66.4349, (1.9039 * scl))
    local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl))

    PointCircle(pE0)
    PointCircle(pE1)
    PointCircle(pE2)
    PointCircle(pE3)
    PointCircle(pE5)
    PointCircle(pE6)
    PointCircle(pE7)
    PointCircle(pE8)

    local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl))
    local pF1 = Polar2D(pt, ang + 14.0360, (1.0308 * scl))
    local pF2 = Polar2D(pt, ang + 26.5651, (1.1180 * scl))
    local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl))
    local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl))
    local pF5 = Polar2D(pt, ang + 51.3425, (1.6006 * scl))
    local pF6 = Polar2D(pt, ang + 56.3099, (1.8025 * scl))
    local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl))
    local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl))

    PointCircle(pF0)
    PointCircle(pF1)
    PointCircle(pF2)
    PointCircle(pF3)
    PointCircle(pF4)
    PointCircle(pF5)
    PointCircle(pF6)
    PointCircle(pF7)
    PointCircle(pF8)

    local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl))
    local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl))
    local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl))
    local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl))
    local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl))
    local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl))
    local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl))
    local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl))
    local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl))
    local pG10 = Polar2D(pt,59.0362, (2.9155 * scl))

    PointCircle(pG0)
    PointCircle(pG1)
    PointCircle(pG2)
    PointCircle(pG3)
    PointCircle(pG4)
    PointCircle(pG5)
    PointCircle(pG6)
    PointCircle(pG7)
    PointCircle(pG8)
    PointCircle(pG10)

    local pH0  = Polar2D(pt, ang + 0.0000, (1.5000 * scl))
    local pH10 = Polar2D(pt, 63.4349,      (2.7951 * scl))
    PointCircle(pH0)
    PointCircle(pH10)
    job:Refresh2DView()
    return true
  end

  -- =====================================================]]
  function DrawWriterOld(what, where, size, lay, ang)
    local group
  --[[ How to use:
  |    local TextMessage = "Your Text Here"
  |    local TextPt = Point2D(3.5,3.8)
  |    local TextHight = 0.5
  |    local TextLayer = "Jim Anderson"
  |    local TextAng = 20.0
  |    DrawWriter(TextMessage ,local TextPt , TextHight , TextLayer,TextAng )
  |    -- ==Draw Writer==
  |    -- Utilizing a provided string of text, the program walks the string and reproduces each letter (parametrically) on the drawing using vectors.
  function main()
      -- create a layer with passed name if it doesn't already exist
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    local TextMessage = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 ! @ # $ % & * ( ) { } [ ] ? , . : ; '' ' _ - + = ~ ^ < > |"
    local TextPt = Point2D(0.1, 2.0)
    local TextHight = 0.25
    local TextLayer = "Gadget Text"
    local TextAng = 10.0
    DrawWriter(TextMessage, TextPt, TextHight, TextLayer, TextAng)
    job:Refresh2DView()
    return true
  end
  -- -----------------------------------------------------]]
  -- ==============================================================================
  local function Polar2D(pt, ang, dis)
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
  end
  -- ==============================================================================
  local function MonoFont(job, pt, letter, scl, lay, ang)
    scl = (scl * 0.5) ;
    local pA0 = pt ;
    local pA1 = Polar2D(pt, ang + 90.0000, (0.2500 * scl)) ;  local pA2 = Polar2D(pt, ang + 90.0000, (0.5000 * scl)) ;
    local pA3 = Polar2D(pt, ang + 90.0000, (0.7500 * scl)) ;  local pA4 = Polar2D(pt, ang + 90.0000, (1.0000 * scl)) ;
    local pA5 = Polar2D(pt, ang + 90.0000, (1.2500 * scl)) ;  local pA6 = Polar2D(pt, ang + 90.0000, (1.5000 * scl)) ;
    local pA7 = Polar2D(pt, ang + 90.0000, (1.7500 * scl)) ;  local pA8 = Polar2D(pt, ang + 90.0000, (2.0000 * scl)) ;
    local pA9 = Polar2D(pt, ang + 90.0000, (2.2500 * scl)) ;  local pA10 = Polar2D(pt, ang + 90.0000, (2.5000 * scl)) ;
    local pB0 = Polar2D(pt, ang +  0.0000, (0.2500 * scl)) ;  local pB1 = Polar2D(pt, ang + 45.0000, (0.3536 * scl)) ;
    local pB2 = Polar2D(pt, ang + 63.4352, (0.5590 * scl)) ;  local pB3 = Polar2D(pt, ang + 71.5651, (0.7906 * scl)) ;
    local pB4 = Polar2D(pt, ang + 75.9638, (1.0308 * scl)) ;  local pB5 = Polar2D(pt, ang + 78.6901, (1.2748 * scl)) ;
    local pB6 = Polar2D(pt, ang + 80.5376, (1.5207 * scl)) ;  local pB7 = Polar2D(pt, ang + 81.8699, (1.7678 * scl)) ;
    local pB8 = Polar2D(pt, ang + 82.8750, (2.0156 * scl)) ;  local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl)) ;
    local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl)) ;  local pC1 = Polar2D(pt, ang + 26.5650, (0.5590 * scl)) ;
    local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl)) ;  local pC3 = Polar2D(pt, ang + 56.3099, (0.9014 * scl)) ;
    local pC4 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;  local pC5 = Polar2D(pt, ang + 68.1993, (1.3463 * scl)) ;
    local pC6 = Polar2D(pt, ang + 71.5650, (1.5811 * scl)) ;  local pC7 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;
    local pC8 = Polar2D(pt, ang + 75.9640, (2.0616 * scl)) ;  local pC10 = Polar2D(pt, ang + 78.6899, (2.5495 * scl)) ;
    local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl)) ;  local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl)) ;
    local pD2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;  local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl)) ;
    local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl)) ;  local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl)) ;
    local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl)) ;  local pE1 = Polar2D(pt, ang + 18.4346, (0.7906 * scl)) ;
    local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;  local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl)) ;
    local pE5 = Polar2D(pt, ang + 59.0371, (1.4578 * scl)) ;  local pE6 = Polar2D(pt, ang + 63.4349, (1.6771 * scl)) ;
    local pE7 = Polar2D(pt, ang + 66.4349, (1.9039 * scl)) ;  local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl)) ;
    local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl)) ;  local pF1 = Polar2D(pt, ang + 14.0360, (1.0308 * scl)) ;
    local pF2 = Polar2D(pt, ang + 26.5651, (1.1180 * scl)) ;  local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl)) ;
    local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl)) ;  local pF5 = Polar2D(pt, ang + 51.3425, (1.6006 * scl)) ;
    local pF6 = Polar2D(pt, ang + 56.3099, (1.8025 * scl)) ;  local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl)) ;
    local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl)) ;  local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl)) ;
    local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl)) ;  local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl)) ;
    local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl)) ;  local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl)) ;
    local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl)) ;  local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl)) ;
    local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl)) ;  local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl)) ;
    local pG10 = Polar2D(pt,59.0362, (2.9155 * scl))       ;  local pH0 = Polar2D(pt, ang +  0.0000, (1.5000 * scl)) ;
    local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))       ;  local layer = job.LayerManager:GetLayerWithName(lay) ;
    local line = Contour(0.0) ;
   -- ------------------------------------------------------------------
    if letter == 32 then
      pH0 = pH0
    end
    if letter == 33 then
      line:AppendPoint(pB0) ;  line:LineTo(pE0) ;  line:LineTo(pE2) ;  line:LineTo(pB2) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
      line = Contour(0.0) line:AppendPoint(pB3) ;  line:LineTo(pE3) ;  line:LineTo(pE8) ;  line:LineTo(pB8) ;  line:LineTo(pB3) ;  group:AddTail(line) ;
    end
    if letter == 34 then
      line:AppendPoint(pA7) ;  line:LineTo(pB10) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB7) ;  line:LineTo(pC10) ;
      group:AddTail(line) ;  pH0 = pE0
    end
    if letter == 35 then
      line:AppendPoint(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;
      line:LineTo(pG6) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;
      line = Contour(0.0) ;  line:AppendPoint(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;
    end
    if letter == 36 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;
      line:LineTo(pB4) ;  line:LineTo(pA5) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  group:AddTail(line) ;
      line = Contour(0.0) ;  line:AppendPoint(pC0) ;  line:LineTo(pE0) ;  line:LineTo(pE8) ;  line:LineTo(pC8) ;  line:LineTo(pC0) ;  group:AddTail(line) ;
    end
    if letter == 37 then
      line:AppendPoint(pC6) ;  line:LineTo(pC8) ;  line:LineTo(pA8) ;  line:LineTo(pA6) ;  line:LineTo(pE6) ;  line:LineTo(pG8) ;
      line:LineTo(pA0) ;  line:LineTo(pC2) ;  line:LineTo(pG2) ;  line:LineTo(pG0) ;  line:LineTo(pE0) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 38 then
      line:AppendPoint(pG2) ;  line:LineTo(pG1) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  line:LineTo(pA3) ;
      line:LineTo(pE6) ;  line:LineTo(pE7) ;  line:LineTo(pD8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA6) ;  line:LineTo(pG0) ;
      group:AddTail(line) ;
    end
    if letter == 39 then
      line:AppendPoint(pA7) ;  line:LineTo(pB10) ;  group:AddTail(line) ;  pH0 = pC0
    end
    if letter == 40 then
      line:AppendPoint(pB8) ;  line:LineTo(pA5) ;  line:LineTo(pA3) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  pH0 = pD0
    end
    if letter == 41 then
      line:AppendPoint(pA8) ;  line:LineTo(pB5) ;  line:LineTo(pB3) ;  line:LineTo(pA0) ;  group:AddTail(line) ;  pH0 = pG0
    end
    if letter == 42 then
      line:AppendPoint(pA2) ;  line:LineTo(pG6) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;  line:LineTo(pG2) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD7) ;
      line:LineTo(pD1) ;  group:AddTail(line) ;
    end
    if letter == 43 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD1) ;  line:LineTo(pD7) ;
      group:AddTail(line)
    end
    if letter == 44 then
      line:AppendPoint(pC0) ;  line:LineTo(pE2) ;  line:LineTo(pC2) ;  line:LineTo(pC4) ;  line:LineTo(pF4) ;  line:LineTo(pF2) ;
      line:LineTo(pD0) ;  line:LineTo(pC0) ;  group:AddTail(line) ;
    end
    if letter == 45 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 46 then
      line:AppendPoint(pA1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  line:LineTo(pA0) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 47 then
      line:AppendPoint(pA0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 48 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG8) ;  line:LineTo(pA0) ; group:AddTail(line) ;
    end
    if letter == 49 then
      line:AppendPoint(pA6) ;  line:LineTo(pD8) ;  line:LineTo(pD0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 50 then
      line:AppendPoint(pA6) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;
      line:LineTo(pA2) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 51 then
      line:AppendPoint(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pG3) ;  line:LineTo(pG1) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pF4) ;  line:LineTo(pB4) ;  group:AddTail(line) ;
    end
    if letter == 52 then
      line:AppendPoint(pF0) ;  line:LineTo(pF8) ;  line:LineTo(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;
    end
    if letter == 53 then
      line:AppendPoint(pG8) ;  line:LineTo(pA8) ;  line:LineTo(pA5) ;  line:LineTo(pF4) ;  line:LineTo(pG3) ;  line:LineTo(pG1) ;
      line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    if letter == 54 then
      line:AppendPoint(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA1) ;  line:LineTo(pB0) ;
      line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  line:LineTo(pB4) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    if letter == 55 then
      line:AppendPoint(pB0) ;  line:LineTo(pG8) ;  line:LineTo(pA8) ;  group:AddTail(line) ;
    end
    if letter == 56 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;
      line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA5) ;  line:LineTo(pB4) ;
      line:LineTo(pA3) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB4) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 57 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG3) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;
      line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA5) ;  line:LineTo(pB4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  group:AddTail(line) ;
    end
    if letter == 58 then
      line:AppendPoint(pB8) ;  line:LineTo(pA8) ;  line:LineTo(pA7) ;  line:LineTo(pB7) ;  line:LineTo(pB8) ;  line:LineTo(pA8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  line:LineTo(pA0) ;  line:LineTo(pA1) ;
      group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 59 then
      line:AppendPoint(pB8) ;  line:LineTo(pA8) ;  line:LineTo(pA7) ;  line:LineTo(pB7) ;  line:LineTo(pB8) ;  line:LineTo(pA8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB3) ;  line:LineTo(pB4) ;  line:LineTo(pA4) ;  line:LineTo(pA3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 60 then
      line:AppendPoint(pF8) ;  line:LineTo(pA4) ;  line:LineTo(pG0) ;  group:AddTail(line)
    end
    if letter == 61 then
      line:AppendPoint(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;
      line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 62 then
      line:AppendPoint(pA8) ;  line:LineTo(pF4) ;  line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 63 then
      line:AppendPoint(pB5) ;  line:LineTo(pA6) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pE8) ;  line:LineTo(pF7) ;
      line:LineTo(pF5) ;  line:LineTo(pC3) ;  line:LineTo(pC2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB0) ;  line:LineTo(pE0) ;
      line:LineTo(pE1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 64 then
      line:AppendPoint(pG0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;
      line:LineTo(pG6) ;  line:LineTo(pG3) ;  line:LineTo(pE2) ;  line:LineTo(pB2) ;  line:LineTo(pB5) ;  line:LineTo(pE5) ;  line:LineTo(pE2) ;
      group:AddTail(line)
    end
    if letter == 65 then
      line:AppendPoint(pA0) ;  line:LineTo(pD8) ;  line:LineTo(pG0) ;  line:LineTo(pF3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 66 then
      line:AppendPoint(pA4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 67 then
      line:AppendPoint(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;
      line:LineTo(pF8) ;  line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 68 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 69 then
      line:AppendPoint(pG0) ;  line:LineTo(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pA4) ;  line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 70 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;
      line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 71 then
      line:AppendPoint(pG6) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA2) ;
      line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG3) ;  line:LineTo(pE3) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 72 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 73 then
      line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;  line:LineTo(pC0) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;  pH0 = pE0 ;
    end
    if letter == 74 then
      line:AppendPoint(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;  line:LineTo(pC8) ;
      group:AddTail(line) ;
    end
    if letter == 75 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA2) ;  line:LineTo(pG7) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 76 then
      line:AppendPoint(pA8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 77 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 78 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 79 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 80 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;
    end
    if letter == 81 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pD4) ; group:AddTail(line)
    end
    if letter == 82 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 83 then
      line:AppendPoint(pG5) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA5) ;
      line:LineTo(pG3) ;  line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA3) ;  group:AddTail(line) ;
    end
    if letter == 84 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD8) ;
      line:LineTo(pD0) ;  group:AddTail(line) ;
    end
    if letter == 85 then
      line:AppendPoint(pA8) ;  line:LineTo(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;
    end
    if letter == 86 then
      line:AppendPoint(pA8) ;  line:LineTo(pD0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 87 then
      line:AppendPoint(pA8) ;  line:LineTo(pB0) ;  line:LineTo(pD4) ;  line:LineTo(pF0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 88 then
      line:AppendPoint(pA0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 89 then
      line:AppendPoint(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD0) ;
      line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 90 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end

    if letter == 91 then
      line:AppendPoint(pC0) ;  line:LineTo(pB0) ;  line:LineTo(pB8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;
    end
    if letter == 92 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 93 then
      line:AppendPoint(pE0) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  line:LineTo(pE8) ;  group:AddTail(line) ;
    end
    if letter == 94 then
      line:AppendPoint(pD8) ;  line:LineTo(pG6) ;  line:LineTo(pG5) ;  line:LineTo(pD7) ;  line:LineTo(pA5) ;  line:LineTo(pA6) ;
      line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 95 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  group:AddTail(line) ;
    end
    if letter == 96 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    -- Start of Lower Case
    if letter == 97 then
      line:AppendPoint(pA0) ;  line:LineTo(pD8) ;  line:LineTo(pG0) ;  line:LineTo(pF3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 98 then
      line:AppendPoint(pA4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 99 then
      line:AppendPoint(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;
      line:LineTo(pF8) ;  line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 100 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 101 then
      line:AppendPoint(pG0) ;  line:LineTo(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pA4) ;  line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 102 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;
      line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 103 then
      line:AppendPoint(pG6) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA2) ;
      line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG3) ;  line:LineTo(pE3) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 104 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 105 then
      line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;  line:LineTo(pC0) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;  pH0 = pE0 ;
    end
    if letter == 106 then
      line:AppendPoint(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;  line:LineTo(pC8) ;
      group:AddTail(line) ;
    end
    if letter == 107 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA2) ;  line:LineTo(pG7) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 108 then
      line:AppendPoint(pA8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 109 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 110 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 111 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 112 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;
    end
    if letter == 113 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pD4) ; group:AddTail(line)
    end
    if letter == 114 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 115 then
      line:AppendPoint(pG5) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA5) ;
      line:LineTo(pG3) ;  line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA3) ;  group:AddTail(line) ;
    end
    if letter == 116 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD8) ;
      line:LineTo(pD0) ;  group:AddTail(line) ;
    end
    if letter == 117 then
      line:AppendPoint(pA8) ;  line:LineTo(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;
    end
    if letter == 118 then
      line:AppendPoint(pA8) ;  line:LineTo(pD0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 119 then
      line:AppendPoint(pA8) ;  line:LineTo(pB0) ;  line:LineTo(pD4) ;  line:LineTo(pF0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 120 then
      line:AppendPoint(pA0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 121 then
      line:AppendPoint(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD0) ;
      line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 122 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    -- End of Lower Case
    if letter == 123 then
      line:AppendPoint(pD0) ;  line:LineTo(pC0) ;  line:LineTo(pB1) ;  line:LineTo(pB2) ;  line:LineTo(pC3) ;  line:LineTo(pA4) ;
      line:LineTo(pC5) ;  line:LineTo(pB6) ;  line:LineTo(pB7) ;  line:LineTo(pC8) ;  line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 124 then
      line:AppendPoint(pA0) ;  line:LineTo(pA10) ;  line:LineTo(pC10) ;  line:LineTo(pC0) ;  line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 125 then
      line:AppendPoint(pD0) ;  line:LineTo(pE0) ;  line:LineTo(pF1) ;  line:LineTo(pF2) ;  line:LineTo(pE3) ;  line:LineTo(pG4) ;
      line:LineTo(pE5) ;  line:LineTo(pF6) ;  line:LineTo(pF7) ;  line:LineTo(pE8) ;  line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 126 then
      line:AppendPoint(pA2) ;  line:LineTo(pA3) ;  line:LineTo(pB5) ;  line:LineTo(pF3) ;  line:LineTo(pG5) ;
      line:LineTo(pG4) ;  line:LineTo(pF2) ;  line:LineTo(pB4) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    return pH0
  end -- function end

  -- ==============================================================================
  local function AddGroupToJob(job, group, layer_name)
     --  create a CadObject to represent the  group
    local cad_object = CreateCadGroup(group);
     -- create a layer with passed name if it doesnt already exist
    local layer = job.LayerManager:GetLayerWithName(layer_name)
     -- and add our object to it
    layer:AddObject(cad_object, true)
    return cad_object
  end -- end function

  -- =========================================================================
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: Not finding a job loaded")
      return false
    end
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    group = ContourGroup(true)
    while i <=  x do
      y = string.byte(string.sub(strup, i, i))
      ptx = MonoFont(job, ptx, y, size, lay, ang)
      i = i + 1
    end -- while end;
    AddGroupToJob(job, group, lay)
    job:Refresh2DView()
    return true ;
  end -- Draw Text function end

  -- =====================================================]]
  function DrawWriter(what, where, size, lay, ang)
    local group
  --[[ How to use:
  |    local TextMessage = "Your Text Here"
  |    local TextPt = Point2D(3.5,3.8)
  |    local TextHight = 0.5
  |    local TextLayer = "Jim Anderson"
  |    local TextAng = 20.0
  |    DrawWriter(TextMessage ,local TextPt , TextHight , TextLayer,TextAng )
  |    -- ==Draw Writer==
  |    -- Utilizing a provided string of text, the program walks the string and reproduces each letter (parametrically) on the drawing using vectors.
  function main()
      -- create a layer with passed name if it doesn't already exist
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    local TextMessage = "Aa Bb Cc Dd Ee Ff Gg Hh Ii Jj Kk Ll Mm Nn Oo Pp Qq Rr Ss Tt Uu Vv Ww Xx Yy Zz 1 2 3 4 5 6 7 8 9 0 ! @ # $ % & * ( ) { } [ ] ? , . : ; '' ' _ - + = ~ ^ < > |"
    local TextPt = Point2D(0.1, 2.0)
    local TextHight = 0.25
    local TextLayer = "Gadget Text"
    local TextAng = 10.0
    DrawWriter(TextMessage, TextPt, TextHight, TextLayer, TextAng)
    job:Refresh2DView()
    return true
  end
  -- -----------------------------------------------------]]
  -- ==============================================================================
  local function Polar2D(pt, ang, dis)
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
  end
  -- ==============================================================================
  local function MonoFont(job, pt, letter, scl, lay, ang)
    scl = (scl * 0.5) ;
    local pA0 = pt ;
    local pA1 = Polar2D(pt, ang + 90.0000, (0.2500 * scl)) ;  local pA2 = Polar2D(pt, ang + 90.0000, (0.5000 * scl)) ;
    local pA3 = Polar2D(pt, ang + 90.0000, (0.7500 * scl)) ;  local pA4 = Polar2D(pt, ang + 90.0000, (1.0000 * scl)) ;
    local pA5 = Polar2D(pt, ang + 90.0000, (1.2500 * scl)) ;  local pA6 = Polar2D(pt, ang + 90.0000, (1.5000 * scl)) ;
    local pA7 = Polar2D(pt, ang + 90.0000, (1.7500 * scl)) ;  local pA8 = Polar2D(pt, ang + 90.0000, (2.0000 * scl)) ;
    local pA9 = Polar2D(pt, ang + 90.0000, (2.2500 * scl)) ;  local pA10 = Polar2D(pt, ang + 90.0000, (2.5000 * scl)) ;
    local pB0 = Polar2D(pt, ang +  0.0000, (0.2500 * scl)) ;  local pB1 = Polar2D(pt, ang + 45.0000, (0.3536 * scl)) ;
    local pB2 = Polar2D(pt, ang + 63.4352, (0.5590 * scl)) ;  local pB3 = Polar2D(pt, ang + 71.5651, (0.7906 * scl)) ;
    local pB4 = Polar2D(pt, ang + 75.9638, (1.0308 * scl)) ;  local pB5 = Polar2D(pt, ang + 78.6901, (1.2748 * scl)) ;
    local pB6 = Polar2D(pt, ang + 80.5376, (1.5207 * scl)) ;  local pB7 = Polar2D(pt, ang + 81.8699, (1.7678 * scl)) ;
    local pB8 = Polar2D(pt, ang + 82.8750, (2.0156 * scl)) ;  local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl)) ;
    local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl)) ;  local pC1 = Polar2D(pt, ang + 26.5650, (0.5590 * scl)) ;
    local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl)) ;  local pC3 = Polar2D(pt, ang + 56.3099, (0.9014 * scl)) ;
    local pC4 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;  local pC5 = Polar2D(pt, ang + 68.1993, (1.3463 * scl)) ;
    local pC6 = Polar2D(pt, ang + 71.5650, (1.5811 * scl)) ;  local pC7 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;
    local pC8 = Polar2D(pt, ang + 75.9640, (2.0616 * scl)) ;  local pC10 = Polar2D(pt, ang + 78.6899, (2.5495 * scl)) ;
    local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl)) ;  local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl)) ;
    local pD2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;  local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl)) ;
    local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl)) ;  local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl)) ;
    local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl)) ;  local pE1 = Polar2D(pt, ang + 18.4346, (0.7906 * scl)) ;
    local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;  local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl)) ;
    local pE5 = Polar2D(pt, ang + 59.0371, (1.4578 * scl)) ;  local pE6 = Polar2D(pt, ang + 63.4349, (1.6771 * scl)) ;
    local pE7 = Polar2D(pt, ang + 66.4349, (1.9039 * scl)) ;  local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl)) ;
    local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl)) ;  local pF1 = Polar2D(pt, ang + 14.0360, (1.0308 * scl)) ;
    local pF2 = Polar2D(pt, ang + 26.5651, (1.1180 * scl)) ;  local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl)) ;
    local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl)) ;  local pF5 = Polar2D(pt, ang + 51.3425, (1.6006 * scl)) ;
    local pF6 = Polar2D(pt, ang + 56.3099, (1.8025 * scl)) ;  local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl)) ;
    local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl)) ;  local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl)) ;
    local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl)) ;  local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl)) ;
    local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl)) ;  local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl)) ;
    local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl)) ;  local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl)) ;
    local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl)) ;  local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl)) ;
    local pG10 = Polar2D(pt,59.0362, (2.9155 * scl))       ;  local pH0 = Polar2D(pt, ang +  0.0000, (1.5000 * scl)) ;
    local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))       ;  local layer = job.LayerManager:GetLayerWithName(lay) ;
    local line = Contour(0.0) ;
   -- ------------------------------------------------------------------
    if letter == 32 then
      pH0 = pH0
    end
    if letter == 33 then
      line:AppendPoint(pB0) ;  line:LineTo(pE0) ;  line:LineTo(pE2) ;  line:LineTo(pB2) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
      line = Contour(0.0) line:AppendPoint(pB3) ;  line:LineTo(pE3) ;  line:LineTo(pE8) ;  line:LineTo(pB8) ;  line:LineTo(pB3) ;  group:AddTail(line) ;
    end
    if letter == 34 then
      line:AppendPoint(pA7) ;  line:LineTo(pB10) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB7) ;  line:LineTo(pC10) ;
      group:AddTail(line) ;  pH0 = pE0
    end
    if letter == 35 then
      line:AppendPoint(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;
      line:LineTo(pG6) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;
      line = Contour(0.0) ;  line:AppendPoint(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;
    end
    if letter == 36 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;
      line:LineTo(pB4) ;  line:LineTo(pA5) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  group:AddTail(line) ;
      line = Contour(0.0) ;  line:AppendPoint(pC0) ;  line:LineTo(pE0) ;  line:LineTo(pE8) ;  line:LineTo(pC8) ;  line:LineTo(pC0) ;  group:AddTail(line) ;
    end
    if letter == 37 then
      line:AppendPoint(pC6) ;  line:LineTo(pC8) ;  line:LineTo(pA8) ;  line:LineTo(pA6) ;  line:LineTo(pE6) ;  line:LineTo(pG8) ;
      line:LineTo(pA0) ;  line:LineTo(pC2) ;  line:LineTo(pG2) ;  line:LineTo(pG0) ;  line:LineTo(pE0) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 38 then
      line:AppendPoint(pG2) ;  line:LineTo(pG1) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  line:LineTo(pA3) ;
      line:LineTo(pE6) ;  line:LineTo(pE7) ;  line:LineTo(pD8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA6) ;  line:LineTo(pG0) ;
      group:AddTail(line) ;
    end
    if letter == 39 then
      line:AppendPoint(pA7) ;  line:LineTo(pB10) ;  group:AddTail(line) ;  pH0 = pC0
    end
    if letter == 40 then
      line:AppendPoint(pB8) ;  line:LineTo(pA5) ;  line:LineTo(pA3) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  pH0 = pD0
    end
    if letter == 41 then
      line:AppendPoint(pA8) ;  line:LineTo(pB5) ;  line:LineTo(pB3) ;  line:LineTo(pA0) ;  group:AddTail(line) ;  pH0 = pG0
    end
    if letter == 42 then
      line:AppendPoint(pA2) ;  line:LineTo(pG6) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;  line:LineTo(pG2) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD7) ;
      line:LineTo(pD1) ;  group:AddTail(line) ;
    end
    if letter == 43 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD1) ;  line:LineTo(pD7) ;
      group:AddTail(line)
    end
    if letter == 44 then
      line:AppendPoint(pC0) ;  line:LineTo(pE2) ;  line:LineTo(pC2) ;  line:LineTo(pC4) ;  line:LineTo(pF4) ;  line:LineTo(pF2) ;
      line:LineTo(pD0) ;  line:LineTo(pC0) ;  group:AddTail(line) ;
    end
    if letter == 45 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 46 then
      line:AppendPoint(pA1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  line:LineTo(pA0) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 47 then
      line:AppendPoint(pA0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 48 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG8) ;  line:LineTo(pA0) ; group:AddTail(line) ;
    end
    if letter == 49 then
      line:AppendPoint(pA6) ;  line:LineTo(pD8) ;  line:LineTo(pD0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 50 then
      line:AppendPoint(pA6) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;
      line:LineTo(pA2) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 51 then
      line:AppendPoint(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pG3) ;  line:LineTo(pG1) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pF4) ;  line:LineTo(pB4) ;  group:AddTail(line) ;
    end
    if letter == 52 then
      line:AppendPoint(pF0) ;  line:LineTo(pF8) ;  line:LineTo(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;
    end
    if letter == 53 then
      line:AppendPoint(pG8) ;  line:LineTo(pA8) ;  line:LineTo(pA5) ;  line:LineTo(pF4) ;  line:LineTo(pG3) ;  line:LineTo(pG1) ;
      line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA1) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    if letter == 54 then
      line:AppendPoint(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA1) ;  line:LineTo(pB0) ;
      line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  line:LineTo(pB4) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    if letter == 55 then
      line:AppendPoint(pB0) ;  line:LineTo(pG8) ;  line:LineTo(pA8) ;  group:AddTail(line) ;
    end
    if letter == 56 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;
      line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA5) ;  line:LineTo(pB4) ;
      line:LineTo(pA3) ;  line:LineTo(pA1) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB4) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 57 then
      line:AppendPoint(pA1) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG3) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;
      line:LineTo(pB8) ;  line:LineTo(pA7) ;  line:LineTo(pA5) ;  line:LineTo(pB4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  group:AddTail(line) ;
    end
    if letter == 58 then
      line:AppendPoint(pB8) ;  line:LineTo(pA8) ;  line:LineTo(pA7) ;  line:LineTo(pB7) ;  line:LineTo(pB8) ;  line:LineTo(pA8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  line:LineTo(pA0) ;  line:LineTo(pA1) ;
      group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 59 then
      line:AppendPoint(pB8) ;  line:LineTo(pA8) ;  line:LineTo(pA7) ;  line:LineTo(pB7) ;  line:LineTo(pB8) ;  line:LineTo(pA8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB3) ;  line:LineTo(pB4) ;  line:LineTo(pA4) ;  line:LineTo(pA3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;  pH0 = pD0 ;
    end
    if letter == 60 then
      line:AppendPoint(pF8) ;  line:LineTo(pA4) ;  line:LineTo(pG0) ;  group:AddTail(line)
    end
    if letter == 61 then
      line:AppendPoint(pA2) ;  line:LineTo(pG2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA6) ;
      line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 62 then
      line:AppendPoint(pA8) ;  line:LineTo(pF4) ;  line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 63 then
      line:AppendPoint(pB5) ;  line:LineTo(pA6) ;  line:LineTo(pA7) ;  line:LineTo(pB8) ;  line:LineTo(pE8) ;  line:LineTo(pF7) ;
      line:LineTo(pF5) ;  line:LineTo(pC3) ;  line:LineTo(pC2) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pB0) ;  line:LineTo(pE0) ;
      line:LineTo(pE1) ;  line:LineTo(pB1) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 64 then
      line:AppendPoint(pG0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;
      line:LineTo(pG6) ;  line:LineTo(pG3) ;  line:LineTo(pE2) ;  line:LineTo(pB2) ;  line:LineTo(pB5) ;  line:LineTo(pE5) ;  line:LineTo(pE2) ;
      group:AddTail(line)
    end
    if letter == 65 then
      line:AppendPoint(pA0) ;  line:LineTo(pD8) ;  line:LineTo(pG0) ;  line:LineTo(pF3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 66 then
      line:AppendPoint(pA4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 67 then
      line:AppendPoint(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;
      line:LineTo(pF8) ;  line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 68 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 69 then
      line:AppendPoint(pG0) ;  line:LineTo(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pA4) ;  line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 70 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;
      line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 71 then
      line:AppendPoint(pG6) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA2) ;
      line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG3) ;  line:LineTo(pE3) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 72 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 73 then
      line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;  line:LineTo(pC0) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;  pH0 = pE0 ;
    end
    if letter == 74 then
      line:AppendPoint(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;  line:LineTo(pC8) ;
      group:AddTail(line) ;
    end
    if letter == 75 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA2) ;  line:LineTo(pG7) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 76 then
      line:AppendPoint(pA8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 77 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 78 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 79 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 80 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;
    end
    if letter == 81 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pD4) ; group:AddTail(line)
    end
    if letter == 82 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 83 then
      line:AppendPoint(pG5) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA5) ;
      line:LineTo(pG3) ;  line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA3) ;  group:AddTail(line) ;
    end
    if letter == 84 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD8) ;
      line:LineTo(pD0) ;  group:AddTail(line) ;
    end
    if letter == 85 then
      line:AppendPoint(pA8) ;  line:LineTo(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;
    end
    if letter == 86 then
      line:AppendPoint(pA8) ;  line:LineTo(pD0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 87 then
      line:AppendPoint(pA8) ;  line:LineTo(pB0) ;  line:LineTo(pD4) ;  line:LineTo(pF0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 88 then
      line:AppendPoint(pA0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 89 then
      line:AppendPoint(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD0) ;
      line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 90 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end

    if letter == 91 then
      line:AppendPoint(pC0) ;  line:LineTo(pB0) ;  line:LineTo(pB8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;
    end
    if letter == 92 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 93 then
      line:AppendPoint(pE0) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  line:LineTo(pE8) ;  group:AddTail(line) ;
    end
    if letter == 94 then
      line:AppendPoint(pD8) ;  line:LineTo(pG6) ;  line:LineTo(pG5) ;  line:LineTo(pD7) ;  line:LineTo(pA5) ;  line:LineTo(pA6) ;
      line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 95 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  group:AddTail(line) ;
    end
    if letter == 96 then
      line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    -- Start of Lower Case
    if letter == 97 then
      line:AppendPoint(pA0) ;  line:LineTo(pD8) ;  line:LineTo(pG0) ;  line:LineTo(pF3) ;  line:LineTo(pB3) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 98 then
      line:AppendPoint(pA4) ;  line:LineTo(pF4) ;  line:LineTo(pG5) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG1) ;  line:LineTo(pG3) ;  line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 99 then
      line:AppendPoint(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;
      line:LineTo(pF8) ;  line:LineTo(pG6) ;  group:AddTail(line) ;
    end
    if letter == 100 then
      line:AppendPoint(pA0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pA8) ;
      line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 101 then
      line:AppendPoint(pG0) ;  line:LineTo(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  line = Contour(0.0) ;
      line:AppendPoint(pA4) ;  line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 102 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;
      line:LineTo(pF4) ;  group:AddTail(line) ;
    end
    if letter == 103 then
      line:AppendPoint(pG6) ;  line:LineTo(pG7) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA2) ;
      line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG3) ;  line:LineTo(pE3) ;  line:LineTo(pE2) ;  group:AddTail(line) ;
    end
    if letter == 104 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA4) ;  line:LineTo(pG4) ;  group:AddTail(line) ;
    end
    if letter == 105 then
      line:AppendPoint(pB0) ;  line:LineTo(pB8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA0) ;  line:LineTo(pC0) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;  line:LineTo(pC8) ;  group:AddTail(line) ;  pH0 = pE0 ;
    end
    if letter == 106 then
      line:AppendPoint(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;  line:LineTo(pC8) ;
      group:AddTail(line) ;
    end
    if letter == 107 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA2) ;  line:LineTo(pG7) ;
      group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 108 then
      line:AppendPoint(pA8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 109 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 110 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF0) ;  line:LineTo(pF8) ;  group:AddTail(line) ;  pH0 = pG0 ;
    end
    if letter == 111 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;
    end
    if letter == 112 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;
    end
    if letter == 113 then
      line:AppendPoint(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA6) ;  line:LineTo(pB8) ;  line:LineTo(pF8) ;  line:LineTo(pG6) ;
      line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pG0) ;  line:LineTo(pD4) ; group:AddTail(line)
    end
    if letter == 114 then
      line:AppendPoint(pA0) ;  line:LineTo(pA8) ;  line:LineTo(pF8) ;  line:LineTo(pG7) ;  line:LineTo(pG5) ;  line:LineTo(pF4) ;
      line:LineTo(pA4) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD4) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 115 then
      line:AppendPoint(pG5) ;  line:LineTo(pG6) ;  line:LineTo(pF8) ;  line:LineTo(pB8) ;  line:LineTo(pA6) ;  line:LineTo(pA5) ;
      line:LineTo(pG3) ;  line:LineTo(pG2) ;  line:LineTo(pF0) ;  line:LineTo(pB0) ;  line:LineTo(pA2) ;  line:LineTo(pA3) ;  group:AddTail(line) ;
    end
    if letter == 116 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD8) ;
      line:LineTo(pD0) ;  group:AddTail(line) ;
    end
    if letter == 117 then
      line:AppendPoint(pA8) ;  line:LineTo(pA2) ;  line:LineTo(pB0) ;  line:LineTo(pF0) ;  line:LineTo(pG2) ;  line:LineTo(pG8) ;
      group:AddTail(line) ;
    end
    if letter == 118 then
      line:AppendPoint(pA8) ;  line:LineTo(pD0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 119 then
      line:AppendPoint(pA8) ;  line:LineTo(pB0) ;  line:LineTo(pD4) ;  line:LineTo(pF0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;
    end
    if letter == 120 then
      line:AppendPoint(pA0) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pA8) ;
      line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    if letter == 121 then
      line:AppendPoint(pA8) ;  line:LineTo(pD4) ;  line:LineTo(pG8) ;  group:AddTail(line) ;  line = Contour(0.0) ;  line:AppendPoint(pD0) ;
      line:LineTo(pD4) ;  group:AddTail(line) ;
    end
    if letter == 122 then
      line:AppendPoint(pA8) ;  line:LineTo(pG8) ;  line:LineTo(pA0) ;  line:LineTo(pG0) ;  group:AddTail(line) ;
    end
    -- End of Lower Case
    if letter == 123 then
      line:AppendPoint(pD0) ;  line:LineTo(pC0) ;  line:LineTo(pB1) ;  line:LineTo(pB2) ;  line:LineTo(pC3) ;  line:LineTo(pA4) ;
      line:LineTo(pC5) ;  line:LineTo(pB6) ;  line:LineTo(pB7) ;  line:LineTo(pC8) ;  line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 124 then
      line:AppendPoint(pA0) ;  line:LineTo(pA10) ;  line:LineTo(pC10) ;  line:LineTo(pC0) ;  line:LineTo(pA0) ;  group:AddTail(line) ;
    end
    if letter == 125 then
      line:AppendPoint(pD0) ;  line:LineTo(pE0) ;  line:LineTo(pF1) ;  line:LineTo(pF2) ;  line:LineTo(pE3) ;  line:LineTo(pG4) ;
      line:LineTo(pE5) ;  line:LineTo(pF6) ;  line:LineTo(pF7) ;  line:LineTo(pE8) ;  line:LineTo(pD8) ;  group:AddTail(line) ;
    end
    if letter == 126 then
      line:AppendPoint(pA2) ;  line:LineTo(pA3) ;  line:LineTo(pB5) ;  line:LineTo(pF3) ;  line:LineTo(pG5) ;
      line:LineTo(pG4) ;  line:LineTo(pF2) ;  line:LineTo(pB4) ;  line:LineTo(pA2) ;  group:AddTail(line) ;
    end
    return pH0
  end -- function end

  -- ==============================================================================
  local function AddGroupToJob(job, group, layer_name)
     --  create a CadObject to represent the  group
    local cad_object = CreateCadGroup(group);
     -- create a layer with passed name if it doesnt already exist
    local layer = job.LayerManager:GetLayerWithName(layer_name)
     -- and add our object to it
    layer:AddObject(cad_object, true)
    return cad_object
  end -- end function

  -- =========================================================================
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: Not finding a job loaded")
      return false
    end
    local strlen = string.len(what)
    local strup = what
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    group = ContourGroup(true)
    while i <=  x do
      y = string.byte(string.sub(strup, i, i))
      if (y >= 97) and (y <= 122) then -- Lower case
        ptx = MonoFont(job, ptx, y, (size * 0.75), lay, ang)
        ptx = Polar2D(ptx, ang, size * 0.05)
      else -- Upper case
        ptx = MonoFont(job, ptx, y, size, lay, ang)
        ptx = Polar2D(ptx, ang, size * 0.07)
      end
      i = i + 1
    end -- while end;
    AddGroupToJob(job, group, lay)
    job:Refresh2DView()
    return true
  end -- Draw Text function end

  --  ====================================================]]
  function Holer(pt, ang, dst, dia, lay)
      local job = VectricJob()
      if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false
      end
    --Caller: Holer(ptx, anx, BaseDim.HoleSpace, Milling.ShelfPinRadius, Milling.LNSideShelfPinDrill .. "-Base")
      local function AddGroupToJob(job, group, layer_name)
        local cad_object = CreateCadGroup(group);
        local layer = job.LayerManager:GetLayerWithName(layer_name)
        layer:AddObject(cad_object, true)
        return cad_object
      end
    local group = ContourGroup(true)
    group:AddTail(CreateCircle(pt.x, pt.y, dia, 0.0, 0.0))
    pt = Polar2D(pt, ang, dst)
    group:AddTail(CreateCircle(pt.x, pt.y, dia, 0.0, 0.0))
    AddGroupToJob(job, group, lay)
    return true
  end  --  function end

-- =====================================================]]
end -- DrawTools function end
-- =====================================================]]
╔╦╗╔═╗╔╦╗╔═╗  ╔═╗═╗ ╦╔═╗╔═╗╦═╗╔╦╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║╠═╣ ║ ╠═╣  ║╣ ╔╩╦╝╠═╝║ ║╠╦╝ ║    ║ ║ ║║ ║║  ╚═╗
═╩╝╩ ╩ ╩ ╩ ╩  ╚═╝╩ ╚═╩  ╚═╝╩╚═ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function ExportTools()
-- =====================================================]]
function LogWriter(LogName, xText)
  -- Adds a new xText Line to a app log file
  -- local LogName = Door.CSVPath .. "\\" .. Door.RuntimeLog .. ".txt"
  local fileW = io.open(LogName,  "a")
  if fileW then
    fileW:write(xText .. "\n")
    fileW:close()
  end -- if end
  Maindialog:UpdateLabelField("Door.Alert", "Note: Errors are logged in the CSF file folder.")
  return true
end -- function end
-- =====================================================]]
function Write_CSV(xFilename) -- Writes the values to a csv format file
 -- Usage: Write_CSV("C:\\Path\\MyName.csv")
 -- Door.CSVPath = dialog:GetTextField("DoorCSVPath")
 -- local filename = Path .. "\\" .. Name .. ".csv"
  local filename = xFilename
  xFilename
  local file = io.open(filename, "w")
  if file then  -- if the file was opened
    file:write("Count,Height,Width\n")  -- Header Line
    if Door.Unit then
      file:write("1,110,595\n");    file:write("1,150,75\n");     file:write("1,175,395\n");     file:write("1,140,495\n")
      file:write("1,175,445\n");    file:write("1,175,595\n");    file:write("2,200,100\n");     file:write("3,250,125\n")
      file:write("1,300,150\n");    file:write("2,350,175\n");    file:write("3,400,200\n");     file:write("1,450,225\n")
      file:write("2,500,250\n");    file:write("3,550,275\n");    file:write("1,600,300\n");     file:write("2,650,325\n")
      file:write("3,700,350\n");    file:write("1,750,375\n");    file:write("2,800,400\n");     file:write("3,850,425\n");
      file:write("1,900,450\n");    file:write("2,950,475\n");    file:write("3,1000,500\n");    file:write("1,1050,525\n");
      file:write("2,1100,550\n");   file:write("3,1150,575\n");   file:write("1,1200,600\n");    file:write("2,1250,625\n");
      file:write("3,1300,650\n");   file:write("1,1350,675\n");   file:write("2,1400,700\n");    file:write("3,1450,725\n");
      file:write("1,1500,750\n");   file:write("2,1550,775\n");   file:write("3,1600,800\n");    file:write("1,1650,825\n");
      file:write("2,1700,850\n");   file:write("3,1750,875\n");   file:write("1,1800,900\n");    file:write("2,1850,925\n");
      file:write("3,1900,950\n");   file:write("1,1950,975\n");   file:write("2,2000,1000\n");   file:write("3,2050,1025\n");
      file:write("1,2100,1050\n");  file:write("2,2150,1075\n");  file:write("3,2200,1100\n");   file:write("1,2250,1125\n");
      file:write("2,2300,1150\n");  file:write("3,2350,1175\n");  file:write("1,2400,1200\n");   file:write("2,2450,1225\n")
    else
      file:write("1,04.5000,23.2500\n");  file:write("1,06.0000,03.3125\n");  file:write("1,06.5000,15.5000\n");  file:write("1,05.3750,19.5000\n");
      file:write("1,07.1875,17.5000\n");  file:write("1,06.1875,23.5000\n");  file:write("2,07.8750,03.8750\n");  file:write("3,09.8750,05.0000\n");
      file:write("1,11.7500,05.8750\n");  file:write("2,13.7500,06.6750\n");  file:write("3,15.7500,07.8750\n");  file:write("1,17.1250,08.8250\n");
      file:write("2,19.5000,09.5000\n");  file:write("3,21.1250,10.3750\n");  file:write("1,23.6250,11.1250\n");  file:write("2,25.5000,12.1250\n");
      file:write("3,27.6250,13.7500\n");  file:write("1,29.5000,14.7500\n");  file:write("2,31.4375,15.7500\n");  file:write("3,33.4375,16.7500\n");
      file:write("1,35.4375,17.7500\n");  file:write("2,37.4375,18.6250\n");  file:write("3,39.3750,19.6250\n");  file:write("1,41.3750,20.6250\n");
      file:write("2,43.3750,21.6250\n");  file:write("3,45.1875,22.6250\n");  file:write("1,47.2500,23.6250\n");  file:write("2,49.1875,24.6250\n");
      file:write("3,51.1250,25.5000\n");  file:write("1,53.1250,26.5000\n");  file:write("2,55.1250,27.5000\n");  file:write("3,57.1250,28.5000\n");
      file:write("1,59.1250,29.5000\n");  file:write("2,61.2500,30.5000\n");  file:write("3,62.9375,31.4375\n");  file:write("1,64.9375,32.4375\n");
      file:write("2,66.9375,33.4375\n");  file:write("3,68.8125,34.4375\n");  file:write("1,70.8750,35.3750\n");  file:write("2,72.9375,36.4375\n");
      file:write("3,74.8750,37.4375\n");  file:write("1,76.9375,38.3750\n");  file:write("2,78.7500,39.3750\n");  file:write("3,80.7500,40.3750\n");
      file:write("1,82.6250,41.3750\n");  file:write("2,84.6250,42.3750\n");  file:write("3,86.6250,43.3750\n");  file:write("1,88.5000,44.2500\n");
      file:write("2,90.6250,45.2500\n");  file:write("3,92.6250,46.2500\n");  file:write("1,94.4375,47.2500\n");  file:write("2,95.4375,48.2500\n")
    end -- if end
    file:close()-- closes the open file
  end -- if end
  return  true
end
-- =====================================================]]
end -- ExportTools function end
-- =====================================================]]
╔╦╗═╗ ╦╔╦╗  ╔═╗╦╦  ╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║ ╔╩╦╝ ║   ╠╣ ║║  ║╣    ║ ║ ║║ ║║  ╚═╗
 ╩ ╩ ╚═ ╩   ╚  ╩╩═╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function FileTools()
-- =====================================================]]
  function LengthOfFile(filename)                       -- Returns file line count
--[[Counts the lines in a file
    Returns: number]]
    local len = 0
    if FileExists(filename) then
      local file = io.open(filename)
      if file then
      for _ in file:lines() do
        len = len + 1
      end
      file:close()
    end -- if end
    end
    return len
  end -- function end
  -- =====================================================]]
  function NameValidater(FileName)
    local MyTrue = true
    local strlen = string.len(FileName)
    local strup = string.upper(FileName)
    local i = 1
    local y = ""
    while i <=  strlen do
      y = string.byte(string.sub(strup, i, i))
      if y == 32 then   --  Space
        MyTrue = false
        break
      elseif y == 45 then  -- Dash
        MyTrue = false
        break
      elseif y == 127 then  -- Delete
        MyTrue = false
        break
      elseif y == 126 then  -- Delete
        MyTrue = false
        break

       elseif y == 123 then  -- Open brace
        MyTrue = false
        break
      elseif y == 124 then  -- Pipe
        MyTrue = false
        break
      elseif y == 125 then  -- Close brace
        MyTrue = false
        break

      elseif  -- Illegal Filename Characters
      (y == 33) or -- !	Exclamation mark
      (y == 34) or -- "	Double Quotes
      (y == 35) or -- #	Hash
      (y == 36) or -- $	Dollar
      (y == 37) or -- %	Percent
      (y == 38) or -- &	Ampersand
      (y == 39) or -- '	Apostrophe
      (y == 42) or -- *	Asterisk
      (y == 43) or -- +	Plus
      (y == 44) or -- ,	Comma
      (y == 47) or -- /	Slash
      (y == 58) or -- :	Colon
      (y == 59) or -- ;	Semi-colon
      (y == 60) or -- <	Less than
      (y == 62) or -- >	Greater than
      (y == 63) or -- ?	Question mark
      (y == 64) or -- @	At
      (y == 92) or -- \	Backslash
      (y == 96) or -- `	Single Quotes
      (y == 123) or -- { Open brace
      (y == 124) or -- | Pipe
      (y == 125)    -- } Close brace
      then
        MyTrue = false
        break
      elseif (y <= 31) then -- Control Codes
        MyTrue = false
        break
      elseif (y >= 48) and (y <= 57) then -- Numbers
        MyTrue = false
        break
      elseif (y >= 65) and (y <= 90) then -- Uppercase A to Z
        MyTrue = false
        break
      elseif (y >= 97) and (y <= 122) then -- Lowercase A to Z
        MyTrue = false
        break
      elseif (y >= 65) and (y <= 90) then -- Uppercase A to Z
        MyTrue = false
        break
      end -- if end
      i = i + 1  end -- while end;
    return MyTrue
  end -- if end
-- =====================================================]]
  function CopyFileFromTo(OldFile, NewFile)             -- Copy Old File to Newfile
    if FileExists(NewFile) then
      DisplayMessageBox("File copy " .. File .. " failed. \n\nFile found at: " .. NewFile  .. "\n" )
      return false
    elseif not FileExists(OldFile) then
      DisplayMessageBox("File copy of " .. File .. " failed. \n\nFile not found at: " .. OldFile .. "\n" )
      return false
    else
      local fileR = io.open(OldFile)      -- reader file
      local fileW = io.open(NewFile, "w") -- writer file
      if fileR and fileW then  -- if both files are open
        for Line in fileR:lines() do
          fileW:write(Line .. "\n")
        end -- for end
      end
      if fileR then fileR:close() end
      if fileW then fileW:close() end
      return true
    end -- for end
  end -- function end
-- =====================================================]]
  function ValidateName(FileName)                       -- Returns True if the file name is safe to use
  local MyTrue = true
  local strlen = string.len(FileName)
  local strup = string.upper(FileName)
  local i = 1
  local y = ""
  while i <=  strlen do
    y = string.byte(string.sub(strup, i, i))
    if y == 32 then -- Space
      MyTrue = true
    elseif y == 45 then -- hyphn
      MyTrue = true
    elseif (y >= 48) and (y <= 57) then -- numbers
      MyTrue = true
    elseif (y >= 65) and (y <= 90) then -- Uppercase
      MyTrue = true
    else
      MyTrue = false
      break
    end -- if end
    i = i + 1
  end -- while end
  return MyTrue
end -- if end
-- =====================================================]]
  function FileExists(name)                             -- Returns True if file is found
  -- call = ans = FileExists("sample.txt")
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else io.close(f) return false end
  end -- end function
  -- =====================================================]]
function FileAccess(FileName)                           -- returns true if file is available for update.
    if (not(os.rename(FileName, FileName))) then
      StatusMessage("Error", FileName, "The Gadget cannot access the ".. FileName ..
        " The OS has blocked write access. " ..
        "Verify the full path is correct and No application has the file open. ", "(1405)")
        return false
  else
    return true
  end -- if end
end -- function end
-- =====================================================]]
  function DiskRights(path)
  xx = io.open(path, "w")
  if xx == nil then
      io.close()
      return false
  else
      xx:close()
      return true
  end
end -- function rights
-- =====================================================]]
end -- FileTools function end
-- =====================================================]]
╔═╗╔═╗╔═╗╔╦╗╔═╗╔╦╗╦═╗╦ ╦  ╔╦╗╔═╗╔═╗╦  ╔═╗
║ ╦║╣ ║ ║║║║║╣  ║ ╠╦╝╚╦╝   ║ ║ ║║ ║║  ╚═╗
╚═╝╚═╝╚═╝╩ ╩╚═╝ ╩ ╩╚═ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function GeometryTools()
-- =====================================================]]
function SheetNew()                                     -- Adds a new sheet to the drawing
  if GetVersion() >= 10.5 then then
    local layer_manager = Milling.job.LayerManager
    -- get current sheet count - note sheet 0 the default sheet counts as one sheet
    local orig_num_sheets = layer_manager.NumberOfSheets
    -- get current active sheet index
    local orig_active_sheet_index = layer_manager.ActiveSheetIndex
    -- set active sheet to last sheet
    local num_sheets = layer_manager.NumberOfSheets
    layer_manager.ActiveSheetIndex = num_sheets - 1
    -- Add a new sheet
    layer_manager:AddNewSheet()
    -- set active sheet to last sheet we just added
    num_sheets = layer_manager.NumberOfSheets
    layer_manager.ActiveSheetIndex = num_sheets - 1
    Milling.job:Refresh2DView()
  end -- if end
  return true
end
-- =====================================================]]
function SheetSet(Name)                                 -- Move focus to a named sheet
  local job = VectricJob()
  local sheet_manager = job.SheetManager
  local sheet_ids = sheet_manager:GetSheetIds()
  for id in sheet_ids do
    if(sheet_manager:GetSheetName(id) == Name) then
    sheet_manager.ActiveSheetId = id
    end
  end
end
-- ====================================================]]
function SheetNextSize(X, Y)                           -- Make New Sheet to size (x, y)
  if X == nil then
    X = Milling.MaterialBlockWidth
  else
    X = X + (2 * Milling.Cal)
  end
  if Y == nil then
    Y = Milling.MaterialBlockHeight
  else
    Y = Y + (2 * Milling.Cal)
  end
  Milling.Sheet = Milling.Sheet + 1
  local sheet_manager = Milling.job.SheetManager
  local sheet_ids = sheet_manager:GetSheetIds()
  for id in sheet_ids do
    if(sheet_manager:GetSheetName(id) == "Sheet 1") then
     sheet_manager:CreateSheets(1, id, Box2D(Point2D(0, 0), Point2D(X, Y)))
    end
  end
  SheetSet("Sheet " .. tostring(Milling.Sheet))
  return true
end
-- =====================================================]]
function GetPolarAngle(Start, Corner, End)              -- Move focus to a named sheet
  local function GetPolarDirection(point1, point2)              --
    local ang = math.abs(math.deg(math.atan((point2.Y - point1.Y) / (point2.X - point1.X))))
    if point1.X < point2.X then
      if point1.Y < point2.Y then
        ang = ang + 0.0
      else
        ang = 360.0 - ang
      end -- if end
    else
      if point1.Y < point2.Y then
        ang = 180.0 - ang
      else
        ang = ang + 180.0
      end -- if end
    end -- if end
    if ang >=360 then
      ang = ang -360.0
    end -- if end
    return ang
  end -- function end
  return  math.abs(GetPolarDirection(Corner, Start) - GetPolarDirection(Corner, End))
end -- function end
-- =====================================================]]
function GetOrientation(point1, point2)                 -- Orientation of left, right, up or down
  if DecimalPlaces(point1.X,8) == DecimalPlaces(point2.X,8) then
    if point1.Y < point2.Y then
     return 90.0
    else
     return 270.0
    end
  elseif DecimalPlaces(point1.Y,8) == DecimalPlaces(point2.Y,8) then
      if point1.X < point2.X then
     return 0.0
    else
     return 180.0
    end
  else
    return nil
  end
end -- function end
-- =====================================================]]
function GetPolarDirection(point1, point2)              -- Retuens and amgle from two points
  local ang = math.abs(math.deg(math.atan((point2.Y - point1.Y) / (point2.X - point1.X))))
  if point1.X < point2.X then
    if point1.Y < point2.Y then
      ang = ang + 0.0
    else
      ang = 360.0 - ang
    end -- if end
  else
    if point1.Y < point2.Y then
      ang = 180.0 - ang
    else
      ang = ang + 180.0
    end -- if end
  end -- if end
  if ang >=360 then
    ang = ang -360.0
  end -- if end
  return ang
end -- function end
-- =====================================================]]
function CenterArc(A, B, RadiusD)                       -- Retuns 2DPoint from Arc point and Radius
  local radius = ((tonumber(RadiusD) or 0) * g_var.scl)
  local horda = (A - B).Length
  if math.abs(radius) < (horda / 2) and radius ~= 0 then
--D("Too small radius " .. radius .. "\nreplaced by the smallest possible " .. (horda / 2))
    radius = (horda / 2)
  end
  return Point2D(((A.x + B.x) / 2 + (B.y - A.y) * math.sqrt(math.abs(radius) ^ 2 - (horda / 2) ^ 2) / horda), ((A.y + B.y) / 2 + (A.x - B.x) * math.sqrt(math.abs(radius) ^ 2 - (horda / 2) ^ 2) / horda))
end
-- =====================================================]]
function Polar2D(pt, ang, dis)                          -- Retuns 2DPoint from Known Point, Angle direction, and Projected distance.
-- The Polar2D function will calculate a new point in space based on a Point of reference, Angle of direction, and Projected distance.
-- ::''Returns a 2Dpoint(x, y)''
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end -- End Function
-- =====================================================]]
function GetDistance(objA, objB)                        -- Returns Double from two Points
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- function end
-- =====================================================]]
function Arc2Bulge(p1, p2, Rad)                         -- Returns the Bulge factor for an arc
  local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
  local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
  local bulge = (2 * seg) / chord
  return bulge
end -- function end
-- =====================================================]]
function TrigIt()                                       -- Calulates Right Angle
-- ==Trig Function==
-- VECTRIC LUA SCRIPT
-- =====================================================]]
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you
--   make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages
--   arising from their use.
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software.
-- 2. If you use this software in a product, an acknowledgement in the product
--    documentation would be appreciated but is not required.
-- 3. Altered source versions must be plainly marked as such, and must not be
--    misrepresented as being the original software.
-- 4. This notice may not be removed or altered from any source distribution.
--
-- Right Triangle TrigFunction is written by Jim Anderson of Houston Texas 2020
-- =====================================================]]
-- Code Debugger
-- require("mobdebug").start()
-- =====================================================]]
-- Global Variables --
    Trig = {}
-- =====================================================]]
  function TrigTest() -- Test the All Right Angle
    TrigClear()
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  3.0  -- Rise  or (B2C)
    Trig.Adj =  4.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 1: \n" ..
    " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  0.0  -- Rise  or (B2C)
    Trig.Adj =  4.0  -- Base  or (A2C)
    Trig.Hyp =  5.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 2: \n" ..
    " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  3.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  5.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 3: \n" ..
    " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp = * " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  36.86897645844
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  3.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 4: \n" ..
    " Trig.A  = * " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  36.86897645844
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  0.0  -- Rise  or (B2C)
    Trig.Adj =  4.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 5: \n" ..
    " Trig.A  = * " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  36.86897645844
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  0.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  5.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 6: \n" ..
    " Trig.A  = * " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp = * " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
    " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
    )
    TrigClear()
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  3.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  9.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test 7: \n" ..
    " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
    " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
    " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
    " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
    " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
    " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
    " Trig.Slope = * " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
    " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
    " Trig.Circumscribing =  " .. tostring(Trig.Circumscribing) .. " \n" ..
    " Trig.Inscribing =  " .. tostring(Trig.Inscribing) .. " \n"
    )
    -- =====================================================]]
    TrigClear()
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  0.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  9.0
    Trig.Area =  0.0
    Trig.OutRadius =  0.0
    Trig.InRadius =  0.0
    Trig.Parameter =  0.0
    TrigIt()
    DisplayMessageBox("Test Error: \n" ..
      " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
      " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
      " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
      " Trig.Slope = * " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
      " Trig.Circumscribing =  " .. tostring(Trig.Circumscribing) .. " \n" ..
      " Trig.Inscribing =  " .. tostring(Trig.Inscribing) .. " \n"
    )
    return true
  end -- function end --
-- =====================================================]]
  function TrigClear()   -- Clears and resets Trig Table
    Trig.A  =  0.0
    Trig.B  =  0.0
    Trig.C  = 90.0
    Trig.Opp =  0.0  -- Rise  or (B2C)
    Trig.Adj =  0.0  -- Base  or (A2C)
    Trig.Hyp =  0.0  -- Slope or (A2B)
    Trig.Slope =  0.0
    return true
  end -- function end
-- =====================================================]]
      local function BSA()
        Trig.B  = (Trig.C - Trig.A)
        Trig.Slope = math.tan(math.rad(Trig.A)) * 12.0
        Trig.Area =  (Trig.Opp * Trig.Adj) * 0.5
        Trig.Inscribing = ((Trig.Opp + Trig.Adj) - Trig.Hyp) * 0.5
        Trig.Circumscribing =  Trig.Hyp * 0.5
        Trig.Parameter = Trig.Opp + Trig.Adj + Trig.Hyp
      end
      if Trig.A == 0.0 and Trig.B > 0.0 and Trig.Slope == 0.0 then
        Trig.A = Trig.C - Trig.B
      elseif Trig.A == 0.0 and Trig.B == 0.0 and Trig.Slope > 0.0 then
        Trig.A = math.deg(math.atan(Trig.Slope / 12.0))
      end -- if end
-- test 4
      if (Trig.A > 0.0) and (Trig.Opp >  0.0) then -- A and Rise or (B2C)
        Trig.Adj =  Trig.Opp / (math.tan(math.rad(Trig.A)))
        Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
        BSA()
        return true
      -- test 6
      elseif (Trig.A > 0.0) and (Trig.Hyp >  0.0)  then -- A and Slope or (A2B)
        Trig.Adj = math.cos(math.rad(Trig.A)) * Trig.Hyp
        Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
        BSA()
        return true
      -- test 5
      elseif (Trig.A > 0.0) and (Trig.Adj >  0.0)  then -- A and Base or (A2C)
        Trig.Opp = math.tan(math.rad(Trig.A)) * Trig.Adj
        Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
        BSA()
        return true
        -- test 1
      elseif (Trig.Opp >  0.0) and (Trig.Adj >  0.0) then -- Rise and Base
        Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
        Trig.A  = math.deg(math.atan(Trig.Opp / Trig.Adj))
        BSA()
        return true
      elseif (Trig.Adj >  0.0) and (Trig.Hyp >  0.0) then -- Rise and Slope
-- test 2
        Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
        Trig.A  = math.deg(math.atan(Trig.Opp / Trig.Adj))
        BSA()
        return true
      elseif (Trig.Opp >  0.0) and (Trig.Hyp >  0.0) then -- Base and Slope
-- test 3
        Trig.Adj = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Opp * Trig.Opp))
        Trig.A  = math.deg(math.atan(Trig.Opp / Trig.Adj))
        BSA()
        return true
      else
        DisplayMessageBox("Error: Trig Values did not match requirements: \n" ..
                          " Trig.A  =  " .. tostring(Trig.A) .. " \n" ..
                          " Trig.B  =  " .. tostring(Trig.B) .. " \n" ..
                          " Trig.C  =  " .. tostring(Trig.C) .. " \n" ..
                          " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..
                          " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" ..
                          " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
                          " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
                          " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
                          " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                          " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
                          " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
                          )
        return false
      end
    end -- function end
-- =====================================================]]
end -- Geometry Tools end
-- =====================================================]]
╦╔╗╔╦  ╔═╗╦╦  ╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
║║║║║  ╠╣ ║║  ║╣    ║ ║ ║║ ║║  ╚═╗
╩╝╚╝╩  ╚  ╩╩═╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function INITools()
  -- =====================================================]]
  function NameStrip(str, var)                            -- convert string to the correct data type
-- Local Words = NameStrip("KPSDFKSPSK - 34598923", "-") -- returns "KPSDFKSPSK"
    if "" == str then
      DisplayMessageBox("Error in string")
    else
      if string.find(str, var) then
        local j = assert(string.find(str, var) - 1)
        return All_Trim(string.sub(str, 1, j))
      else
        return str
      end
    end
  end -- function end
  -- =====================================================]]
  function HeadStrip(str, var)                            -- convert string to the correct data type
-- Local Words = HeadStrip("LastName23 = Smith", "=") -- returns "Smith"
    if "" == str then
      DisplayMessageBox("Error in string")
    else
      if string.find(str, var) then
        local j = assert(string.find(str, var) + 1)
        return All_Trim(string.sub(str, j))
      else
        return str
      end
    end
  end -- function end
  -- =====================================================]]
  function INI_AreDupGroups(xPath, xFile)                 -- Are there duplicate groups
    local GroupNames = {}
    local CleanNames = {}
    local DupGroups  = {}
      GroupNames = INI_ReadGroups(xFile, aName)
      CleanNames = RemoveDups(GroupNames)
    if TableLength(GroupNames) == TableLength(CleanNames)then
      return true
    else
      return false
    end
  end -- function end

  -- =====================================================]]
  function INI_FixDupGroups(xPath, xFile)                 -- Find and fix duplicate groups
    local GroupNames = {}
    local CleanNames = {}
    local DupGroups  = {}
      GroupNames = INI_ReadGroups(xFile, aName)
    return true
  end -- function end

  -- =====================================================]]
  function INI_DeleteGroup(xPath, xFile, xGroup)          -- Deletes only the first find of xGroup
-- Deletes old ini (.bak) file
-- Copy's the .ini to a backup (.bak) new file
-- Reads the new backup file and writes a new file to the xGroup value
-- Stops Writing lines until next Group is found
-- Writes to end of file
-- Call: DeleteGroup("C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin", "ProjectList", "Boston")
    local OfileName = xPath .. "\\" .. xFile .. ".bak"
    if FileExists(OfileName) then
      os.remove(OfileName)
    end
    local NfileName = xPath .. "\\" .. xFile .. ".ini"
--    os.rename(NfileName, OfileName) -- makes backup copy file
    if CopyFileFromTo(NfileName, OfileName) then
      local fileR   = io.open(OfileName)
      local fileW   = io.open(NfileName,  "w")
      local groups  = false
      local writit  = true
      local MyTxt   = ""
      local txt = ""
      if fileR and fileW then  -- files are open
        for Line in fileR:lines() do  -- read each line of the backup file
          txt = Line  -- copy line from file to txt
          if All_Trim(Line) == "[" .. All_Trim(xGroup) ..  MyTxt .. "]" then  -- look for a match
            groups = true
            txt = ""
          end -- if end
          if groups and MyTxt == "" then  -- if group is true turn off the write function
            writit = false
            if "[" == string.sub(All_Trim(txt), 1, 1) then  -- turns write function on if next group is found
              groups = false
              xGroup = "-"
              writit = true
              MyTxt   = "--"
            else
              writit = false
            end -- if end
          end -- if end
          if writit then
            fileW:write(txt .. "\n")
            txt = ""
          end -- if end
        end -- for end
        os.remove(OfileName)
      end -- if end
      if fileR then fileR:close() end
      if fileW then fileW:close() end
    end
    return true
  end -- function end

  -- =====================================================]]
  function INI_RenameGroup(xOldGroup, xNewGroup)          -- Renames a group
--Deletes old ini Hardware.bak file
--Copys the ini file to a backup copy file
--Reads the backup file and writes a new ini file to the xGroup
--Writes new file with new group  to the new ini file
  local NfileName = Project.AppPath .. "\\" .. "EasyDrawerHardware" .. ".ini"
  local OfileName = Project.AppPath .. "\\" .. "EasyDrawerHardware" .. ".bak"
  os.remove(OfileName)
  CopyFileFromTo(NfileName, OfileName) -- makes backup file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName, "w")
  if fileR and fileW then
    local groups = false
    local txt = ""
    for Line in fileR:lines() do
      if All_Trim(Line) == "[" .. All_Trim(xOldGroup) .. txt .. "]" then -- Group
        fileW:write(xNewGroup .. "\n")
        txt = "-"
      else
        fileW:write(Line .. "\n")
      end -- if end
    end -- for end
    fileR:close()
    fileW:close()
    os.remove(OfileName)
  end -- if end
  return true
end -- function end

  -- =====================================================]]
  function INI_DeleteItem(xPath, xFile, xGroup, xItem)
-- Deletes old ini (.bak) file
-- Copys the .ini to a backup (.bak) new file
-- Reads the new backup file and writes a new file to the xGroup value
-- Stops Writing lines until next Group is found
-- Writes to end of file
-- DeleteGroup("C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin", "ProjectList", "Boston")
  local NfileName = xPath .. "\\" .. xFile .. ".ini"
  local OfileName = xPath .. "\\" .. xFile .. ".bak"
  os.remove(OfileName)
  CopyFileFromTo(NfileName, OfileName) -- makes backup copy file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName,  "w")
  if fileR and fileW then
    local groups = false
    local writit = true
    local txt = ""
    for Line in fileR:lines() do
      txt = Line
      if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then
        groups = true
      end -- if end
      if groups then
  -- ===================
        if xItem == string.sub(Line, 1, string.len(xItem))  then  -- Item
          writit = false
          groups = false
        end -- if end
      end -- if end
  -- ===================
      if writit then
        fileW:write(txt .. "\n")
      end -- if end
      writit = true
    end -- for end
    os.remove(OfileName)
    fileR:close()
    fileW:close()
  end -- if end
  return true
end -- function end

-- =======================================================]]
  function INI_ValidateGroup(xFile, xGroup)               -- Reads INI file and returns true if group is found
  -- Reads INI file and returns true if the group is found
  local fileR = io.open(xFile)
  local group = false
  for Line in fileR:lines() do
    if string.upper(All_Trim(Line)) == "[" .. string.upper(All_Trim(xGroup)) .. "]" then  -- Group
    group = true
    break
    end -- if end
  end -- for end
  fileR:close()
  return group
end -- function end
-- =======================================================]]
  function INI_ValidateItem(xFile, xGroup, xItem)         -- Reads INI file and returns true if group and item is found
    local fileR = io.open(xFile)
    if fileR then
      local group = false
      local item = false
      local ItemLen = string.len(xItem)
      for Line in fileR:lines() do
        if All_Trim(Line) == "[" ..  string.upper(All_Trim(xGroup)) .. "]" then  -- Group
        group = true
        end -- if end
        if group then
          if string.upper(xItem) == string.upper(string.sub(Line, 1, string.len(xItem)))  then  -- Item
            item = true
            break
          end -- if end
        end -- if end
      end -- for end
      fileR:close()
    end -- if end
    return group
  end -- function end

  -- =====================================================]]
  function INI_StrValue(str, ty)
-- Convert string to the correct data type
    if nil == str then
      DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
      if "" == All_Trim(str) then
        DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
      else
        local j = (string.find(str, "=") + 1)
        if ty == "D" then -- Double
          return tonumber(string.sub(str, j))
        end -- if end
        if ty == "I" then  -- Intiger
          return math.floor(tonumber(string.sub(str, j)))
        end -- if end
        if ty == "S" then  -- String
          return All_Trim(string.sub(str, j))
        end -- if end
        if ty == "B" then  -- Bool
          if "TRUE" == All_Trim(string.sub(str, j)) then
            return true
          else
            return false
          end -- if end
        end -- if end
      end -- if end
    end -- if end
    return nil
  end -- function end

  -- =====================================================]]
  function INI_GetValue(xPath, FileName, GroupName, ItemName, ValueType)
    -- ==INI_GetValue(xPath, FileName, GroupName, ItemName, ValueType)==
    -- Returns a value from a file, group, and Item
    -- Usage: XX.YY = GetIniValue("C:/temp", "ScrewDia", "[Screws]", "Diameter", "D")
    local filenameR = xPath .. "\\" .. FileName .. ".ini"
    local FL = LengthOfFile(filenameR)
    local file = io.open(filenameR, "r")
    local dat = "."
    local ItemNameLen = string.len(ItemName)
    if file then
      while (FL >= 1) do
        dat = string.upper(All_Trim(file:read()))
        if dat == "[" .. string.upper(GroupName) .. "]" then
          break
        else
          FL = FL - 1
        end -- if end
      end -- while end
      while (FL >= 1) do
        dat = string.upper(All_Trim(file:read()))
        if string.upper(ItemName) == string.sub(dat, 1, ItemNameLen)  then
          break
        else
          FL = FL - 1
          if FL == 0 then
            dat = "Error - item not  found"
            break
          end -- if end
        end -- if end
      end -- while end
      file:close()-- closes the open file
    end -- if end
    local XX = StrIniValue(dat, ValueType)
    return XX
  end -- function end

  -- =====================================================]]
  function INI_GetIDFor(xPath, FileName, GroupName, ItemValue)
    -- == INI_GetIDFor(xPath, FileName, GroupName, ItemValue) ==
    -- Returns a ItemID from a file, group, and ItemValue
    -- Usage: XX.YY = INI_GetIDFor("C:/temp", "UserList", "[Users]", "Anderson")
    -- returns: "UserLastName22"
    local filenameR = xPath .. "\\" .. FileName .. ".ini"
    local FL = LengthOfFile(filenameR)
    local file = io.open(filenameR, "r")
    if file then
      local dat = "."
      local ItemValueLen = string.len(ItemValue)
      while (FL >= 1) do
        dat = string.upper(All_Trim(file:read()))
        if dat == "[" .. string.upper(GroupName) .. "]" then
          break
        else
          FL = FL - 1
        end -- if end
      end -- while end
      while (FL >= 1) do
        dat = string.upper(All_Trim(file:read()))
        if string.upper(ItemValue) == HeadStrip(dat, "=")  then
          break
        else
          FL = FL - 1
          if FL == 0 then
            dat = "Error - item not  found"
            break
          end -- if end
        end -- if end
      end -- while end
      file:close()-- closes the open file
    end -- if end
    local XX = NameStrip(dat, "=")
    return XX
  end -- function end

  -- =====================================================]]
  function INI_ReadGroups(xFile, aName)
  --[[Reads INI and returns a list contain the [Headers] as Array
  IniFile = {} Global variables
  xPath = script_path
  ]]
    local filename = xFile
    local file = io.open(filename, "r")
    if file then
      local fLength = (LengthOfFile(filename) - 1)
      local dat = All_Trim(file:read())
      while (fLength >= 1) do
        if "[" == string.sub(dat, 1, 1) then
          table.insert (aName, string.sub(dat, 2, -2))
        end
        dat = file:read()
        if dat then
          dat = All_Trim(dat)
        else
          file:close()-- closes the open file
          return true
        end
        fLength = fLength - 1
      end -- while
    end -- if
     if file then file:close() end
    return true
  end

  -- =====================================================]]
  function INI_ProjectHeaderReader(xPath)
  -- ==ProjectHeaderReader(xPath)==
  -- Gets the INI Header values of a ini file and uploads to "IniFile" Array
  --[[
  Gets the INI Header values of a ini file and uploads to "IniFile" Array
  IniFile = {} Global variables
  xPath = script_path
  ]]
    local filename = xPath .. "/CabinetProjects.ini"
    local file = io.open(filename, "r")
    if file then
      local Cabing = (LengthOfFile(filename) - 1)
      local dat = All_Trim(file:read())
      while (Cabing >= 1) do
        if "[" == string.sub(dat, 1, 1) then
          table.insert (Projects, string.sub(dat, 2, -2))
        end
        dat = file:read()
        if dat then
          dat = All_Trim(dat)
        else
          return true
        end
        Cabing = Cabing - 1
      end
      file:close()
    end
    return true
  end -- function end


  -- =====================================================]]
  function INI_AddNewProject(xPath, xGroup)
  -- Appends a New Project to CabinetProjectQuestion.ini
  -- ==AddNewProject(xPath)==
  -- Appends a New Project to CabinetProjectQuestion.ini
    local filename = xPath .. "/ProjectList.ini"
    local file = io.open(filename, "a")
    if file then
      file:write("[" .. All_Trim(xGroup) .. "] \n")
      file:write("load_date = " .. StartDate(true) .. " \n")
      file:write("#====================================== \n")
      file:close()-- closes the open file
    end
    return true
  end -- function end

  -- =====================================================]]
  function INI_StdHeaderReader(xPath, Fname)
  -- ==StdHeaderReader(xPath, Fname)==
  -- Gets the INI Header values of a ini file and uploads to "IniFile" Array
  --[[
  Gets the INI Header values of a ini file and uploads to "IniFile" Array
  IniFile = {} Global variables
  xPath = script_path
  ]]
    local filename = xPath .. "\\" .. Fname .. ".ini"
    local file = io.open(filename, "r")
    if file then
      local WallMilling = (LengthOfFile(filename) - 1)
      local dat = All_Trim(file:read())
      while (WallMilling >= 0) do
        if "[" == string.sub(dat, 1, 1) then
          table.insert (IniFile, string.sub(dat, 2, -2))
        end -- if end
        dat = file:read()
        if dat then
          dat = All_Trim(dat)
        else
          return true
        end -- if end
        WallMilling = WallMilling - 1
      end -- while end
      file:close()
    end
    return true
  end  -- function end


  -- =====================================================]]
  function INI_ReadProjectinfo(Table, xPath, xGroup, xFile)
-- ProjectQuestion = {}
-- ==ReadProjectinfo(xPath, xGroup, xFile)==
-- Reads an ini files group and sets the table.names
    Table.ProjectContactEmail       = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S")
    Table.ProjectContactName        = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S")
    Table.ProjectContactPhoneNumber = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S")
    Table.ProjectName               = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S")
    Table.ProjectPath               = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S")
    Table.StartDate                 = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S")
    return true
  end -- function end


  -- =====================================================]]
  function INI_UpdateItem(xPath, xFile, xGroup, xItem, xValue)
  -- Deletes old ini (.bak) file
  -- Copys the .ini to a backup (.bak) new file
  -- Reads the new backup file and writes a new file to the xGroup
  -- Writes new xValue for the for the xItem
  -- Reads and writes a new file to end of file
    local NfileName = xPath .. "\\" .. xFile .. ".ini"
    local OfileName = xPath .. "\\" .. xFile .. ".bak"
    os.remove(OfileName)
    if CopyFileFromTo(NfileName, OfileName) then-- makes backup file
      local fileR = io.open(OfileName)
      local fileW = io.open(NfileName,  "w")
      if fileR and fileW then
        local groups = false
        local txt = ""
        for Line in fileR:lines() do
          txt = Line
          if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then -- Group
            groups = true
          end -- if end
          if xItem == string.sub(Line, 1, string.len(xItem))  then  -- Item
            if groups then
              txt = xItem .. " = " .. xValue
              groups = false
            end -- if end
          end -- if end
          fileW:write(txt .. "\n")
          txt = ""
        end -- for end
        os.remove(OfileName)
        fileR:close()
        fileW:close()
      end
    end
    return true
  end -- function end


  -- =====================================================]]
  function INI_ReadProject(xPath, xFile, xGroup)
  -- Milling = {}
    Milling.LayerNameBackPocket          = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackPocket", "S")
    Milling.LayerNameTopBottomCenterDado = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomCenterDado", "S")
    Milling.LayerNameDrawNotes           = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawNotes", "S")
    Milling.LayerNameDrawFaceFrame       = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawFaceFrame", "S")
    Milling.BackPocketDepthWall          = GetIniValue(xPath, xFile, xGroup, "Milling.BackPocketDepthWall", "N")
    Milling.BlindDadoSetbackWall         = GetIniValue(xPath, xFile, xGroup, "Milling.BlindDadoSetbackWall", "N")
    Milling.CabDepthWall                 = GetIniValue(xPath, xFile, xGroup, "Milling.CabDepthWall", "N")
    return true
  end -- function end


  -- =====================================================]]
  function INI_TestDeleteDups()
    --[[ Requires 3 global variables
    clean  = {}
    dups   = {}
    Names  = {}
    ]]
    local myPath = "C:\\Users\\CNC\\Documents\\test"
    local myName = "Tester"
    local myfile = "C:\\Users\\CNC\\Documents\\test\\Tester.ini"
    INI_ReadGroups(myfile, Names)
    FindDups(Names, dups, clean)
    for i,v in ipairs(dups) do
      INI_DeleteGroup(myPath, myName, v)
    end
    return true
  -- =====================================================]]

end -- INI_Tools()

-- =====================================================]]
end -- INI Tools end
-- =====================================================]]
╔╦╗╔═╗╔╦╗╔═╗  ╦╔╦╗╔═╗╔═╗╦═╗╔╦╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║╠═╣ ║ ╠═╣  ║║║║╠═╝║ ║╠╦╝ ║    ║ ║ ║║ ║║  ╚═╗
═╩╝╩ ╩ ╩ ╩ ╩  ╩╩ ╩╩  ╚═╝╩╚═ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function ImportTools()
-- =====================================================]]
function Read_CSV(xFile, Header)
  --Read_CSV(Door.CSVFile, true)
  local fileR = io.open(xFile)
  local xLine = ""
  local result = {}
  if fileR then
    for Line in fileR:lines() do
      xLine = Line
      if Header then
        Header = false
      else
        xLine = All_Trim(Line)
        for match in (xLine..","):gmatch("(.-)"..",") do
          table.insert(result, match)
        end -- for end
        Door.Count     = tonumber(result[1])
        Door.Height    = tonumber(result[2])
        Door.Width     = tonumber(result[3])

        result = {}
        while Door.Count > 0 do
          if      Door.Style == StyleA.Name then
            DoorStyleA()
          elseif  Door.Style == StyleB.Name then
            DoorStyleB()
          elseif  Door.Style == StyleC.Name then
            DoorStyleC()
          elseif  Door.Style == StyleE.Name then
            DoorStyleE()
          elseif  Door.Style == StyleF.Name then
            DoorStyleF()
          elseif  Door.Style == StyleG.Name then
            DoorStyleG()
          else
            DisplayMessageBox("No Style Select!")
          end --if end
          Door.Count =  Door.Count - 1
        end -- for end
      end --if end
      Door.Record = Door.Record + 1
      MyProgressBar:SetPercentProgress(ProgressAmount(Door.Record))
    end --for end
  end --if end
  return true
end -- function end
-- =====================================================]]
end -- ImportTools function end
-- =====================================================]]
 ╦╔═╗╔╗   ╔╦╗╔═╗╔═╗╦  ╔═╗
 ║║ ║╠╩╗   ║ ║ ║║ ║║  ╚═╗
╚╝╚═╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function JobTools()
-- =====================================================]]
  function ValidJob()
  -- A better error message
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("Error: Cannot run Gadget, no drawing found \n" ..
                        "Please create a new file (drawing) and \n" ..
                        "specify the material dimensions \n"
      )
      return false
    else
      return true
    end  -- if end
  end -- ValidJob end
-- =====================================================]]
  function MoveSetectedVectors(job, NewBasePoint)
    local Selection = job.Selection
    if Selection.IsEmpty then
      MessageBox("LayoutImportedVectors: No vectors selected!")
      return false
    end
    local MySelection = Selection:GetBoundingBox();
    if not NewBasePoint then
      NewBasePoint = Point2D(0,0)
    end
    local MyNewLocatioin = BasePoint - MySelection.BLC
    local Txform = TranslationMatrix2D(MyNewLocatioin)
    Selection:Transform(Txform)
    return true
  end
-- =====================================================]]
  function FixPath(path)                                -- Lua Returns a fixed path
    return path:gsub("%\\", "/")
  end -- function end
-- =====================================================]]
  function FixPath(myPath) {                            -- JavaScript Tool Returns a fixed path
    /* myPath  = "C:\\User\\Bob\\Home\\Drawings"; */
    /* NewPath = "C:/User/Bob/Home/Drawings"; */
    var NewPath = "";
    var myLetter = "";
    var CheckPathLen = myPath.length;
    for (let i = 0; i < myPath.length; i++) {
      myLetter = myPath.charAt(i)
      if myLetter.charCodeAt(0) == 92 {
        NewPath = NewPath + "/";
      } else {
        NewPath = NewPath + myLetter;
      }
    }
    return NewPath;
  }
  -- =====================================================]]
  function GetUnits(UTable)                               -- returns Drawing Units data
    local mtl_block = MaterialBlock()
    if mtl_block.InMM then
      UTable.Units  = "Drawing Units: mm"
      UTable.Unit = true
      UTable.UnitCheck = {"metric", "kilometer", "kilometers", "kh", "meter", "meters", "m", "decimeter", "decimeters", "dm", "centimeter", "centimeters", "cm", "millimeter", "millimeters", "mm"}
      UTable.Cal = 25.4
    else
      UTable.Units  = "Drawing Units: inches"
      UTable.Unit = false
      UTable.UnitCheck = {"imperial", "miles", "mile", "mi", "yards", "yard", "yd", "feet", "foot", "ft", "inches", "inch", "in", "fractions", "fraction"}
      UTable.Cal = 1.0
    end
    return true
  end -- end function
  -- =====================================================]]
function CheckTheUnits(UTable, Value)                     -- Checks if the unit of messure in of drawing units
  local goodtogo = false
  for i=1, #UTable.UnitCheck  do
    if string.upper(Value) == string.upper(UTable.UnitCheck[i]) then
      goodtogo = true
      break
    end -- if end
  end -- for end
  if goodtogo then
    return true
  else
    return false
  end -- if end
end -- function end
  -- =====================================================]]
  function GetMatlBlk(Table)
    local mtl_block = MaterialBlock()
    if mtl_block.InMM then
      Table.Units = "Drawing Units: mm"
      Table.Unit = true
    else
      Table.Units = "Drawing Units: inches"
      Table.Unit = false
    end
    if mtl_block.Width> mtl_block.Height then
      Table.MaterialThickness = mtl_block.Height
      Table.MaterialLength = mtl_block.Width
      Table.Orantation = "H"
    else
      Table.MaterialThickness = mtl_block.Width
      Table.MaterialLength = mtl_block.Height
      Table.Orantation = "V"
    end
    Table.FrontThickness = Dovetail.MaterialThickness
    Table.SideThickness = Dovetail.MaterialThickness
    if mtl_block.Height == mtl_block.Width then
        MessageBox("Error! Material block cannot square")
    end
    return true
  end -- end function
  -- =====================================================]]
  function GetBoxJointMaterialSettings(Table)
    local mtl_block = MaterialBlock()
    --local units
    if mtl_block.InMM then
      Table.Units = "Drawing Units: mm"
      Table.Unit = true
    else
      Table.Units = "Drawing Units: inches"
      Table.Unit = false
    end
    if mtl_block.Width > mtl_block.Height then
      Table.MaterialThickness = mtl_block.Height
      Table.MaterialLength = mtl_block.Width
      Table.Orantation = "H"
    else
      Table.MaterialThickness = mtl_block.Width
      Table.MaterialLength = mtl_block.Height
      Table.Orantation = "V"
    end
    if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
    end
    -- Display material XY origin
    local xy_origin_text = "invalid"
    local xy_origin = mtl_block.XYOrigin
    if  xy_origin == MaterialBlock.BLC then
        Table.xy_origin_text = "Bottom Left Corner"
      if Table.Orantation == "V" then
        Table.Direction1 = 90.0
        Table.Direction2 = 0.0
        Table.Direction3 = 270.0
        Table.Direction4 = 180.0
        Table.Bulge = 1.0
      else
        Table.Direction1 = 0.0
        Table.Direction2 = 90.0
        Table.Direction3 = 180.0
        Table.Direction4 = 270.0
        Table.Bulge = -1.0
      end
    elseif xy_origin == MaterialBlock.BRC then
      Table.xy_origin_text = "Bottom Right Corner"
      if Table.Orantation == "V" then
        Table.Direction1 = 90.0
        Table.Direction2 = 180.0
        Table.Direction3 = 270.0
        Table.Direction4 = 0.0
        Table.Bulge = -1.0
      else
        Table.Direction1 = 180.0
        Table.Direction2 = 90.0
        Table.Direction3 = 0.0
        Table.Direction4 = 270.0
        Table.Bulge = 1.0
      end
    elseif xy_origin == MaterialBlock.TRC then
      Table.xy_origin_text = "Top Right Corner"
      if Table.Orantation == "V" then
        Table.Direction1 = 270.0
        Table.Direction2 = 180.0
        Table.Direction3 = 90.0
        Table.Direction4 = 0.0
        Table.Bulge = 1.0
      else
        Table.Direction1 = 180.0
        Table.Direction2 = 270.0
        Table.Direction3 = 0.0
        Table.Direction4 = 90.0
        Table.Bulge = -1.0
      end
    elseif xy_origin == MaterialBlock.TLC then
      Table.xy_origin_text = "Top Left Corner"
      if Table.Orantation == "V" then
        Table.Direction1 = 270.0
        Table.Direction2 = 0.0
        Table.Direction3 = 90.0
        Table.Direction4 = 180.0
        Table.Bulge = -1.0
      else
        Table.Direction1 = 0.0
        Table.Direction2 = 270.0
        Table.Direction3 = 180.0
        Table.Direction4 = 90.0
        Table.Bulge = 1.0
      end
    elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      Table.xy_origin_text = "Center"
      if Table.Orantation == "V" then
        Table.Direction1 = 0.0
        Table.Direction2 = 0.0
        Table.Direction3 = 0.0
        Table.Direction4 = 0.0
        Table.Bulge = 1.0
      else
        Table.Direction1 = 0.0
        Table.Direction2 = 0.0
        Table.Direction3 = 0.0
        Table.Direction4 = 0.0
        Table.Bulge = -1.0
      end
        MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
    else
        Table.xy_origin_text = "Unknown XY origin value!"
        MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
      if Table.Orantation == "V" then
        Table.Direction1 = 0
        Table.Direction2 = 0
        Table.Direction3 = 0
        Table.Direction4 = 0
      else
        Table.Direction1 = 0
        Table.Direction2 = 0
        Table.Direction3 = 0
        Table.Direction4 = 0
      end
    end
    -- Setup Fingers and Gaps
    Table.NoFingers0 = 1 + (Rounder(BoxJoint.MaterialLength / BoxJoint.MaterialThickness, 0))
    Table.NoFingers2 = Rounder(BoxJoint.NoFingers0 / 2, 0)
    Table.FingerSize = BoxJoint.MaterialLength /  BoxJoint.NoFingers0
    Table.NoFingers1 = BoxJoint.NoFingers0 - BoxJoint.NoFingers2
    return true
  end -- function end
-- =====================================================]]
function GetMaterialSettings(Table)
  local MaterialBlock = MaterialBlock()
  Table.MaterialBlockThickness = MaterialBlock.Thickness
  Table.xy_origin = MaterialBlock.XYOrigin
  if MaterialBlock.InMM then
    Table.Units  = "Drawing Units: mm"
    Table.Unit = true
    Table.Cal = 25.4
  else
    Table.Units  = "Drawing Units: inches"
    Table.Unit = false
    Table.Cal = 1.0
  end
  --local units
	if MaterialBlock.Width > MaterialBlock.Height then
    Table.Orantation = "H" -- Horizontal
	elseif MaterialBlock.Width < MaterialBlock.Height then
    Table.Orantation = "V"  -- Vertical
  else
    Table.Orantation = "S" -- Squair
	end
  if Table.xy_origin == MaterialBlock.BLC then
    Table.XYorigin = "Bottom Left Corner"
  elseif Table.xy_origin == MaterialBlock.BRC then
    Table.XYorigin = "Bottom Right Corner"
  elseif Table.xy_origin == MaterialBlock.TRC then
    Table.XYorigin = "Top Right Corner"
  else
    Table.XYorigin = "Top Left Corner"
  end -- if end
  Table.UnitDisplay  = "Note: Units: (" .. Table.Units ..")"
  return true
end -- end function
-- =====================================================]]
function IsSingleSided(Table)
    local SingleSided = Table.job.IsSingleSided
    if not SingleSided then
      DisplayMessageBox("Error: Job must be a single sided job")
      return false
    end  -- if end
  end --IsSingleSided function end
-- =====================================================]]
function IsDoubleSided(Table)
  if not Table.job.IsDoubleSided then
    DisplayMessageBox("Error: Job must be a Double Sided Project")
    return false
  else
    return true
  end  -- if end
end-- IsDoubleSided function
-- =====================================================]]
function ShowSetting(Table)
  local name = ""
      DisplayMessageBox(
    name .. " MaterialThickness = " .. tostring(Table.MaterialThickness) .."\n" ..
    name .. " BottleRad         = " .. tostring(Table.BottleRad)         .."\n" ..
    name .. " SideLenght        = " .. tostring(Table.SideLenght)        .."\n" ..
    name .. " SideHight         = " .. tostring(Table.SideHight)         .."\n" ..
    name .. " EndLenght         = " .. tostring(Table.EndLenght)         .."\n" ..
    name .. " EndHight          = " .. tostring(Table.EndHight)          .."\n" ..
    name .. " TopLenght         = " .. tostring(Table.TopLenght)         .."\n" ..
    name .. " TopWidht          = " .. tostring(Table.TopWidht)          .."\n" ..
    name .. " HandleLenght      = " .. tostring(Table.HandleLenght)      .."\n" ..
    name .. " HandleWidht       = " .. tostring(Table.HandleWidht)       .."\n" ..
    name .. " HandleRad         = " .. tostring(Table.HandleRad)         .."\n" ..
    name .. " MillingBitRad     = " .. tostring(Table.MillingBitRad)     .."\n" ..
    "\n")
end -- ShowSettings function end
-- =====================================================]]
function MakeLayers()
  local Red, Green, Blue = 0, 0, 0
  local function GetColor(str) -- returns color value for a Color Name
    local sx = str
    local Red = 0
    local Green = 0
    local Blue = 0
    local Colors = {}
    Colors.Black = "0,0,0"
    Colors.Red = "255,0,0"
    Colors.Blue = "0,0,255"
    Colors.Yellow = "255,255,0"
    Colors.Cyan = "0,255,255"
    Colors.Magenta = "255,0,255"
    Colors.Green = "0,128,0"
    if "" == str then
      DisplayMessageBox("Error: Empty string passed")
    else
      str = Colors[str]
      if "string" == type(str) then
        if string.find(str, ",") then
          Red   = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          str  = string.sub(str, assert(string.find(str, ",") + 1))
          Green = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          Blue  = tonumber(string.sub(str, assert(string.find(str, ",") + 1)))
        end
      else
        DisplayMessageBox("Error: Color " .. sx .. " not Found" )
        Red = 0
        Green = 0
        Blue = 0
      end
    end
    return Red, Green, Blue
  end
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackPocket)
        Red, Green, Blue = GetColor(Milling.LNBackPocketColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile)
        Red, Green, Blue = GetColor(Milling.LNBackProfileColor)
        layer:SetColor (Red, Green, Blue)
  return true
end -- function end
  -- =====================================================]]
function MyLayerClear(LayerName)
  local Mylayer = Milling.job.LayerManager:GetLayerWithName(LayerName)
     if Mylayer.IsEmpty then
        Milling.job.LayerManager:RemoveLayer(Mylayer)
     end -- if end
  return true
end -- function end
-- =====================================================]]
function LayerClear()                                   --  calling MyLayerClear
  MyLayerClear(Milling.LNBackPocket  .. "-Wall")
  MyLayerClear(Milling.LNBackPocket  .. "-Base")
  MyLayerClear(Milling.LNBackProfile .. "-Wall")
  MyLayerClear(Milling.LNBackProfile .. "-Base")
  MyLayerClear("PartLabels")
  return true
end -- function end
-- =====================================================]]

-- =====================================================]]
end -- Job Tools end
-- =====================================================]]
╦  ╔═╗╔═╗╦╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
║  ║ ║║ ╦║║     ║ ║ ║║ ║║  ╚═╗
╩═╝╚═╝╚═╝╩╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function LogicTools()
-- =====================================================]]
function DialogStringChecks()
  local MyTrue = false
  if Milling.LNBottomProfile == "" then
    MessageBox("Error: Bottom Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif  Milling.LNSideProfile  == "" then
    MessageBox("Error: Side Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif  Milling.LNSidePocket  == "" then
    MessageBox("Error: Side Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNFrontProfile == "" then
    MessageBox("Error: Front Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNFrontPocket  == "" then
    MessageBox("Error: Front Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBackProfile  == "" then
    MessageBox("Error: Back Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBackPocket == "" then
    MessageBox("Error: Back Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNDrawNotes == "" then
    MessageBox("Error: Draw Notes layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNPartLabels == "" then
    MessageBox("Error: Part Lables layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBlume == "" then
    MessageBox("Error: Blume layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Project.ProjectName == "" then
    MessageBox("Error: Project Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactEmail  == "" then
    MessageBox("Error: Contact Email cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactName == "" then
    MessageBox("Error: Contact Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactPhoneNumber == "" then
    MessageBox("Error: Project Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.DrawerID == "" then
    MessageBox("Error: Contact Phone Number cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ProjectPath == "" then
    MessageBox("Error: Project Path cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  else
    MyTrue = true
  end -- if end
  return MyTrue
end -- function end
-- =====================================================]]
 function CheckNumber(num)
  if type(num) == "number" then
    return true
  else
   return false
  end -- if end
end -- function end
-- =====================================================]]
 function AboveZero(num)
  if (type(num) == "number") and (num > 0.0)then
    return true
  else
   return false
  end -- if end
end -- function end
-- =====================================================]]
end -- LogicTools function end
-- =====================================================]]
╦  ╔═╗╔═╗╔═╗╦╔╗╔╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
║  ║ ║║ ╦║ ╦║║║║║ ╦   ║ ║ ║║ ║║  ╚═╗
╩═╝╚═╝╚═╝╚═╝╩╝╚╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function LogTools()
-- =====================================================]]
  function LogWriter(xPath, xFile, xText)
  -- Writes new xText Line to a log file
    local LogName = xPath .. "\\" .. xFile .. ".txt"
    local fileW = io.open(LogName,  "a")
    if fileW then
      fileW:write(xText .. "\n")
      fileW:close()
    end
    return true
  end -- function end
  -- =====================================================]]
  function LogWriter(LogName, xText)
  -- Adds a new xText Line to a app log file
   -- local LogName = Door.CSVPath .. "\\" .. Door.RuntimeLog .. ".txt"
    local fileW = io.open(LogName,  "a")
    if fileW then
      fileW:write(xText .. "\n")
      fileW:close()
    end -- if end
    Maindialog:UpdateLabelField("Door.Alert", "Note: Errors are logged in the CSF file folder.")
    return true
  end -- function end
-- =====================================================]]

-- =====================================================]]
end -- LogTools function end
-- =====================================================]]
╔╦╗╔═╗╔╦╗╦ ╦  ╔╦╗╔═╗╔═╗╦  ╔═╗
║║║╠═╣ ║ ╠═╣   ║ ║ ║║ ║║  ╚═╗
╩ ╩╩ ╩ ╩ ╩ ╩   ╩ ╚═╝╚═╝╩═╝╚═╝
function MathTools()
-- =====================================================]]
function ArcSegment (p1, p2, Rad)                       -- Returns the Arc Segment
  local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
  local segment = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
  return segment
end -- function end
-- =====================================================]]
function D(x)                                           -- Returns double the value
  return x * 2.0
end -- function end
-- =====================================================]]
function H(x)                                           -- Returns half the value
  return x * 0.5
end -- function end
-- =====================================================]]
function C(x)                                           -- Returns scale value
  return x * Project.Cal
end -- function end
-- =====================================================]]
function ChordSag2Radius (Chr, Seg)                     -- Returns the Rad from Chord and Seg
  local rad = ((((Chr * Chr)/(Seg * 4)) + Seg) / 2.0)
  return rad
end -- function end
-- =====================================================]]
function RadSag2Chord(Rad, Seg)                         -- Returns the Chord from Rad and Seg
  local Ang = 2 * math.acos(1 - (Seg/Rad))
  local Chord = (2 * Rad) * math.sin(Ang * 0.5)
  return Chord
end -- function end
-- =====================================================]]
function RadChord2Segment (Rad, Chord)       -- Returns the Arc Segment from Rad and Chord
  local segment = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - Chord^2))))
  return segment
end -- function end
-- =====================================================]]
function IsOdd(IsOdd_Number)                 -- Returns True/False
  if(IsOdd_Number%2 == 0)then
    return false
  end -- end if
  return true
end -- function end
-- =====================================================]]
function RoundTo(Num, Per)                   -- Returns the number from
  local Head = Num < 0 and math.ceil(Num) or math.floor(Num)
  local Tail = Num - Head
  local Value = Head + tonumber(string.sub(tostring(Tail), 1, Per + 2))
  return Value
end -- function end
-- =====================================================]]
function Round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
-- =====================================================]]
function DecimalPlaces(Dnum, Plac)
  return tonumber(string.sub(tostring(Dnum)  .. "000000000000000000000000000000000000",1, string.len(tostring(math.floor(Dnum))) + 1 + Plac))
end
-- =====================================================]]
function tointeger( x )
    local num = tonumber( x )
    return num < 0 and math.ceil( num ) or math.floor( num )
end
-- =====================================================]]
-- ===TrigIt===
-- Finds all 5 properties of a triangle
  function TrigIt(A, B, AB, AC, BC)
-- Sub Function to help other functions
-- Call = A, B, AB, AC, BC = Trig(A, B, AB, AC, BC)
-- C is the corner, A = small ang and B is the big angle
-- returns all values
-- A, B = angles
-- C = 90.0 Deg
-- B to C (BC) is Run - Base - adjacent
-- A to C (AC) is Rise - Height - opposite
-- A to B (AB) is Slope - hypotenuse


    if (B > 0.0) and (A == 0.0) then
      A = math.deg(math.rad(90) - math.rad(B))
    end
    if (A > 0.0) and (B == 0.0) then
      B = math.deg(math.rad(90) - math.rad(A))
    end
    if  (AC > 0.0) and (BC > 0.0) then
      AB = math.sqrt((AC ^ 2) + (BC ^ 2))
      A = math.deg(math.atan(BC/AC))
      B = math.deg(math.rad(90) - math.rad(A))
    elseif (AB > 0.0) and (BC > 0.0) then
      AB = math.sqrt((AB ^ 2) - (BC ^ 2))
      A = math.deg(math.atan(BC/AC))
      B = math.deg(math.rad(90) - math.rad(A))
    elseif (AB > 0.0) and (AC > 0.0) then
      AB = math.sqrt((AB ^ 2) - (AC ^ 2))
      A = math.deg(math.atan(BC/AC))
      B = math.deg(math.rad(90) - math.rad(A))
    elseif (A > 0.0) and (AC > 0.0) then
      AB = AC / math.cos(math.rad(A))
      BC = AB * math.sin(math.rad(A))
    elseif (A > 0.0) and (BC > 0.0) then
      AB = BC / math.sin(math.rad(A))
      AC = AB * math.cos(math.rad(A))
    elseif (A > 0.0) and (AB > 0.0) then
      BC = AB * math.sin(math.rad(A))
      AC = AB * math.cos(math.rad(A))
    else
      MessageBox("Error: No Missing Value")
    end -- if end
    return A, B, AB, AC, BC
  end
-- =====================================================]]
  function Maximum (a)                                  -- Returns the Max number from an array
-- print(maximum({8,10,23,12,5}))     --> 23   3
    local mi = 1 -- maximum index
    local m = a[mi]  -- maximum value
    for i,val in ipairs(a)  do
      if val > m then
        mi = i
        m = val
      end -- if end
    end
    return m, mi
  end   -- function end
-- =====================================================]]
  function IsEven(IsEven_Number)                        -- Returns T/F if number is even
    if IsEven_Number % 2 then
      return true
    else
      return false
    end -- if end
  end -- function end
end
-- =====================================================]]
╦═╗╔═╗╔═╗╦╔═╗╔╦╗╦═╗╦ ╦  ╔╦╗╔═╗╔═╗╦  ╔═╗
╠╦╝║╣ ║ ╦║╚═╗ ║ ╠╦╝╚╦╝   ║ ║ ║║ ║║  ╚═╗
╩╚═╚═╝╚═╝╩╚═╝ ╩ ╩╚═ ╩    ╩ ╚═╝╚═╝╩═╝╚═╝
function RegistryTools()
-- =====================================================]]
function DocVarChk(Name, Value)
  local job = VectricJob()
  local document_variable_list = job.DocumentVariables
  return document_variable_list:DocumentVariableExists(Name)
end -- function end
-- =====================================================]]
function DocVarGet(Name)
  local job = VectricJob()
  local document_variable_list = job.DocumentVariables
  return document_variable_list:GetDocumentVariable(Name, 0.0)
end -- function end
-- =====================================================]]
function DocVarSet(Name, Value)
  local job = VectricJob()
  local document_variable_list = job.DocumentVariables
  return document_variable_list:SetDocumentVariable(Name, Value)
end -- function end
-- =====================================================]]
function RegistryReadMaterial()                -- Read from Registry Material values for LUA Bit
  local RegistryRead              = Registry("Material")
  Milling.SafeZGap                = Rounder(RegistryRead:GetString("SafeZGap",              "0.500"), 4)
  Milling.StartZGap               = Rounder(RegistryRead:GetString("StartZGap",             "0.500"), 4)
  Milling.HomeX                   = Rounder(RegistryRead:GetString("HomeX",                 "0.000"), 4)
  Milling.HomeY                   = Rounder(RegistryRead:GetString("HomeY",                 "0.000"), 4)
  Milling.HomeZGap                = Rounder(RegistryRead:GetString("HomeZGap",              "0.750"), 4)
  return true
end -- function end
-- =====================================================]]
function RegistryLastTenFiles(FileName)        -- Adds to the top ten Log file list
  local Registry = Registry(RegName)
  LogFile.File10 = Registry:GetString("LogFile.File09", "No Log Yet" )
  LogFile.File09 = Registry:GetString("LogFile.File08", "No Log Yet" )
  LogFile.File08 = Registry:GetString("LogFile.File07", "No Log Yet" )
  LogFile.File07 = Registry:GetString("LogFile.File06", "No Log Yet" )
  LogFile.File06 = Registry:GetString("LogFile.File05", "No Log Yet" )
  LogFile.File05 = Registry:GetString("LogFile.File04", "No Log Yet" )
  LogFile.File04 = Registry:GetString("LogFile.File03", "No Log Yet" )
  LogFile.File03 = Registry:GetString("LogFile.File02", "No Log Yet" )
  LogFile.File02 = Registry:GetString("LogFile.File01", "No Log Yet" )
  LogFile.File01 = FileName
  return FileName
end -- function end
-- =====================================================]]
function RegistryRead()                        -- Read from Registry values
  local RegistryRead = Registry("RegName")
  local Yes_No       = RegistryRead:GetBool("BaseDim.Yes_No", ture)
  local CabHeight    = RegistryRead:GetDouble("BaseDim.CabHeight", 35.500)
  local CabCount     = RegistryRead:GetInt("BaseDim.CabCount", 36)
  local Name         = RegistryRead:GetString("BaseDim.Name", "Words")

  Milling.MillTool1.FeedRate                = RegistryRead:GetDouble("Milling.MillTool1.FeedRate",              30.000)
  Milling.MillTool1.InMM                    = RegistryRead:GetBool("Milling.MillTool1.InMM ",                   false)
  Milling.MillTool1.Name                    = RegistryRead:GetString("Milling.MillTool1.Name",                  "No Tool Selected")
  Milling.MillTool1.BitType                 = RegistryRead:GetString("Milling.MillTool1.BitType",               "END_MILL") -- BALL_NOSE, END_MILL, VBIT
  Milling.MillTool1.RateUnits               = RegistryRead:GetInt("Milling.MillTool1.RateUnits",                4)
  Milling.MillTool1.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool1.SpindleSpeed",             20000)
  Milling.MillTool1.ToolNumber              = RegistryRead:GetInt("Milling.MillTool1.ToolNumber",               1)
  Milling.MillTool1.Stepdown                = RegistryRead:GetDouble("Milling.MillTool1.Stepdown",              0.2000)
  Milling.MillTool1.Stepover                = RegistryRead:GetDouble("Milling.MillTool1.Stepover",              0.0825)
  Milling.MillTool1.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool1.ToolDia",               0.1250)
  Milling.MillTool1.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool1.PlungeRate",            15.000)

  Milling.MillTool2.FeedRate                = RegistryRead:GetDouble("Milling.MillTool2.FeedRate",              30.000)
  Milling.MillTool2.InMM                    = RegistryRead:GetBool("Milling.MillTool2.InMM ",                   false)
  Milling.MillTool2.Name                    = RegistryRead:GetString("Milling.MillTool2.Name",                  "No Tool Selected")
  Milling.MillTool2.BitType                 = RegistryRead:GetString("Milling.MillTool2.BitType",               "BALL_NOSE") -- BALL_NOSE, END_MILL, VBIT
  Milling.MillTool2.RateUnits               = RegistryRead:GetInt("Milling.MillTool2.RateUnits",                4)
  Milling.MillTool2.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool2.SpindleSpeed",             20000)
  Milling.MillTool2.ToolNumber              = RegistryRead:GetInt("Milling.MillTool2.ToolNumber",               2)
  Milling.MillTool2.Stepdown                = RegistryRead:GetDouble("Milling.MillTool2.Stepdown",              0.2000)
  Milling.MillTool2.Stepover                = RegistryRead:GetDouble("Milling.MillTool2.Stepover",              0.0825)
  Milling.MillTool2.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool2.ToolDia",               0.1250)
  Milling.MillTool2.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool2.PlungeRate",            15.000)

  Milling.MillTool3.FeedRate                = RegistryRead:GetDouble("Milling.MillTool3.FeedRate",              30.000)
  Milling.MillTool3.InMM                    = RegistryRead:GetBool("Milling.MillTool3.InMM",                    false)
  Milling.MillTool3.Name                    = RegistryRead:GetString("Milling.MillTool3.Name",                  "No Tool Selected")
  Milling.MillTool3.BitType                 = RegistryRead:GetString("Milling.MillTool3.BitType",               "END_MILL")  -- BALL_NOSE, END_MILL, VBIT
  Milling.MillTool3.RateUnits               = RegistryRead:GetInt("Milling.MillTool3.RateUnits",                4)
  Milling.MillTool3.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool3.SpindleSpeed",             20000)
  Milling.MillTool3.ToolNumber              = RegistryRead:GetInt("Milling.MillTool3.ToolNumber",               3)
  Milling.MillTool3.Stepdown                = RegistryRead:GetDouble("Milling.MillTool3.Stepdown",              0.2000)
  Milling.MillTool3.Stepover                = RegistryRead:GetDouble("Milling.MillTool3.Stepover",              0.0825)
  Milling.MillTool3.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool3.ToolDia",               0.1250)
  Milling.MillTool3.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool3.PlungeRate",            15.000)

  Milling.MillTool4.FeedRate                = RegistryRead:GetDouble("Milling.MillTool4.FeedRate",              30.000)
  Milling.MillTool4.InMM                    = RegistryRead:GetBool("Milling.MillTool4.InMM ",                   false)
  Milling.MillTool4.Name                    = RegistryRead:GetString("Milling.MillTool4.Name",                  "No Tool Selected")
  Milling.MillTool4.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool4.PlungeRate",            15.000)
  Milling.MillTool4.RateUnits               = RegistryRead:GetInt("Milling.MillTool4.RateUnits",                4)
  Milling.MillTool4.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool4.SpindleSpeed",             20000)
  Milling.MillTool4.Stepdown                = RegistryRead:GetDouble("Milling.MillTool4.Stepdown",              0.2000)
  Milling.MillTool4.Stepover                = RegistryRead:GetDouble("Milling.MillTool4.Stepover",              0.0825)
  Milling.MillTool4.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool4.ToolDia",               0.1250)
  Milling.MillTool4.ToolNumber              = RegistryRead:GetInt("Milling.MillTool4.ToolNumber",               5)

  Milling.MillTool5.FeedRate                = RegistryRead:GetDouble("Milling.MillTool5.FeedRate",              30.000)
  Milling.MillTool5.InMM                    = RegistryRead:GetBool("Milling.MillTool5.InMM ",                   false)
  Milling.MillTool5.Name                    = RegistryRead:GetString("Milling.MillTool5.Name",                  "No Tool Selected")
  Milling.MillTool5.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool5.PlungeRate",            15.000)
  Milling.MillTool5.RateUnits               = RegistryRead:GetInt("Milling.MillTool5.RateUnits",                4)
  Milling.MillTool5.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool5.SpindleSpeed",             20000)
  Milling.MillTool5.Stepdown                = RegistryRead:GetDouble("Milling.MillTool5.Stepdown",              0.2000)
  Milling.MillTool5.Stepover                = RegistryRead:GetDouble("Milling.MillTool5.Stepover",              0.0825)
  Milling.MillTool5.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool5.ToolDia",               0.1250)
  Milling.MillTool5.ToolNumber              = RegistryRead:GetInt("Milling.MillTool5.ToolNumber",               6)
  return true
end -- function end
-- =====================================================]]
function RegistryWrite()                       -- Write to Registry values
  local RegistryWrite = Registry("RegName")
  local RegValue
  RegValue = RegistryWrite:SetBool("ProjectQuestion.CabinetName", true)
  RegValue = RegistryWrite:SetDouble("BaseDim.CabDepth", 23.0000)
  RegValue = RegistryWrite:SetInt("BaseDim.CabHeight", 35)
  RegValue = RegistryWrite:SetString("BaseDim.CabLength", "Words")

  RegValue = RegistryWrite:SetDouble("Milling.MillTool1.FeedRate" ,     Milling.MillTool1.FeedRate)
  RegValue = RegistryWrite:SetBool("Milling.MillTool1.InMM",            Milling.MillTool1.InMM)
  RegValue = RegistryWrite:SetString("Milling.MillTool1.Name",          Milling.MillTool1.Name)
  RegValue = RegistryWrite:SetString("Milling.MillTool1.BitType",       Milling.MillTool1.BitType)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool1.PlungeRate" ,   Milling.MillTool1.PlungeRate)
  RegValue = RegistryWrite:SetInt("Milling.MillTool1.RateUnits",        Milling.MillTool1.RateUnits)
  RegValue = RegistryWrite:SetInt("Milling.MillTool1.SpindleSpeed",     Milling.MillTool1.SpindleSpeed)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool1.Stepdown" ,     Milling.MillTool1.Stepdown)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool1.Stepover" ,     Milling.MillTool1.Stepover)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool1.ToolDia" ,      Milling.MillTool1.ToolDia)
  RegValue = RegistryWrite:SetInt("Milling.MillTool1.ToolNumber",       Milling.MillTool1.ToolNumber)

  RegValue = RegistryWrite:SetDouble("Milling.MillTool2.FeedRate" ,     Milling.MillTool2.FeedRate)
  RegValue = RegistryWrite:SetBool("Milling.MillTool2.InMM",            Milling.MillTool2.InMM)
  RegValue = RegistryWrite:SetString("Milling.MillTool2.Name",          Milling.MillTool2.Name)
  RegValue = RegistryWrite:SetString("Milling.MillTool2.BitType",       Milling.MillTool2.BitType)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool2.PlungeRate" ,   Milling.MillTool2.PlungeRate)
  RegValue = RegistryWrite:SetInt("Milling.MillTool2.RateUnits",        Milling.MillTool2.RateUnits)
  RegValue = RegistryWrite:SetInt("Milling.MillTool2.SpindleSpeed",     Milling.MillTool2.SpindleSpeed)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool2.Stepdown" ,     Milling.MillTool2.Stepdown)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool2.Stepover" ,     Milling.MillTool2.Stepover)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool2.ToolDia" ,      Milling.MillTool2.ToolDia)
  RegValue = RegistryWrite:SetInt("Milling.MillTool2.ToolNumber",       Milling.MillTool2.ToolNumber)

  RegValue = RegistryWrite:SetDouble("Milling.MillTool3.FeedRate" ,     Milling.MillTool3.FeedRate)
  RegValue = RegistryWrite:SetBool("Milling.MillTool3.InMM",            Milling.MillTool3.InMM)
  RegValue = RegistryWrite:SetString("Milling.MillTool3.Name",          Milling.MillTool3.Name)
  RegValue = RegistryWrite:SetString("Milling.MillTool3.BitType",       Milling.MillTool3.BitType)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool3.PlungeRate",    Milling.MillTool3.PlungeRate)
  RegValue = RegistryWrite:SetInt("Milling.MillTool3.RateUnits",        Milling.MillTool3.RateUnits)
  RegValue = RegistryWrite:SetInt("Milling.MillTool3.SpindleSpeed",     Milling.MillTool3.SpindleSpeed)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool3.Stepdown" ,     Milling.MillTool3.Stepdown)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool3.Stepover" ,     Milling.MillTool3.Stepover)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool3.ToolDia" ,      Milling.MillTool3.ToolDia)
  RegValue = RegistryWrite:SetInt("Milling.MillTool3.ToolNumber",       Milling.MillTool3.ToolNumber)

  RegValue = RegistryWrite:SetDouble("Milling.MillTool4.FeedRate" ,     Milling.MillTool4.FeedRate)
  RegValue = RegistryWrite:SetBool("Milling.MillTool4.InMM",            Milling.MillTool4.InMM)
  RegValue = RegistryWrite:SetString("Milling.MillTool4.Name",          Milling.MillTool4.Name)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool4.PlungeRate" ,   Milling.MillTool4.PlungeRate)
  RegValue = RegistryWrite:SetInt("Milling.MillTool4.RateUnits",        Milling.MillTool4.RateUnits)
  RegValue = RegistryWrite:SetInt("Milling.MillTool4.SpindleSpeed",     Milling.MillTool4.SpindleSpeed)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool4.Stepdown" ,     Milling.MillTool4.Stepdown)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool4.Stepover" ,     Milling.MillTool4.Stepover)
  RegValue = RegistryWrite:SetDouble("Milling.MillTool4.ToolDia" ,      Milling.MillTool4.ToolDia)
  RegValue = RegistryWrite:SetInt("Milling.MillTool4.ToolNumber",       Milling.MillTool4.ToolNumber)
  return true
end -- function end
-- =====================================================]]
function REG_CheckRegistryBool()               -- Checks Registry for Bool values
  local RegistryRead = Registry("RegName")
  if RegistryRead:BoolExists("ProjectQuestion.Runtool") then
    DisplayMessageBox("Alert: The Runtool value is saved.")
  else
    DisplayMessageBox("Alert: The Runtool value is not saved.")
  end -- if end
  return true
end -- function end
-- =====================================================]]
function REG_CheckRegistryDouble()             -- Checks Registry for Double values
  local RegistryRead = Registry("RegName")
  if RegistryRead:DoubleExists("ProjectQuestion.ProjectCost") then
    DisplayMessageBox("Alert: The project cost is saved.")
  else
    DisplayMessageBox("Alert: The Project Cost is not saved.")
  end -- if end
  return true
end -- function end
-- =====================================================]]
function REG_CheckRegistryInt()                -- Checks Registry for Int values
  local RegistryRead = Registry("RegName")
  if RegistryRead:IntExists("ProjectQuestion.ProjectCount") then
    DisplayMessageBox("Alert: The Project Count is saved.")
  else
    DisplayMessageBox("Alert: The Project Count is not saved.")
  end -- if end
  return true
end -- function end
-- =====================================================]]
function REG_CheckRegistryString()             -- Checks Registry for String values
  local RegistryRead = Registry("RegName")
  if RegistryRead:StringExists("ProjectQuestion.ProjectPath") then
    DisplayMessageBox("Alert: The Project path is saved.")
  else
    DisplayMessageBox("Alert: The Project path is not saved.")
  end
  return true
end -- function end
-- =====================================================]]
end -- Registry end
-- =====================================================]]
╔═╗╔╦╗╦═╗╦╔╗╔╔═╗  ╔╦╗╔═╗╔═╗╦  ╔═╗
╚═╗ ║ ╠╦╝║║║║║ ╦   ║ ║ ║║ ║║  ╚═╗
╚═╝ ╩ ╩╚═╩╝╚╝╚═╝   ╩ ╚═╝╚═╝╩═╝╚═╝
function StringTools()
-- =====================================================]]
function StringToArraySplit(s, delimiter)
--[[
split_string = StringToArraySplit("Hello World,Jim,Bill,Tom", ",")
Returns = array
-- split_string[1] = "Hello World,)
-- split_string[2] = "Jim"
]]
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match)
  end
  return result
end
-- =====================================================]]
function WrapString(Str, Wid)                           -- wraps text at the nearest space and puts a return char in the space location
  --[[  How to use:
  Call WrapString(string, Number)
 WrapString("Jim is a tall man that lives in Texas. He was raised in North East Texas on 1000 acres from 1970 to 1982. This is a man that knows numbers of great people from a round the world.", 40)
 returns "Jim is a tall man that lives in Texas.\n
          He was raised in North East Texas on\n
          1000 acres from 1970 to 1982. This is a man\n
          that knows numbers of great people from\n
          a round the world."
 ]]
  local Wider = Wid
  local Posx = string.len(Str)
  local StrLen = string.len(Str)
  local pt = 0
  local function FindSpace(MyStr)
  local Pos = string.len(MyStr)
  local str = MyStr
    if string.find(MyStr, " ") ~= nil then
      while Pos>0 do
        Pos = Pos - 1
          if (string.byte(string.sub(str,-1)) == 32) then
            break
          else
            str = string.sub(str, 1, Pos)
          end
        end
    end
    return Pos
  end
  if StrLen > Wider then
    while Wider < Posx do
      pt = FindSpace(string.sub(Str,1, Wider))
      Str = string.sub(Str, 1, pt) .. "\n" ..  string.sub(Str, pt +2)
      Wider = Wider + Wid
    end
  end
  return Str
end -- function end
-- =====================================================]]
function CleanString(inStr)                             -- Check for ascii letters below 127
  local outStr, str1 = ""
  local inStrLen = string.len(inStr)
  for i = 1, inStrLen ,1 do
    str1 = string.sub(inStr, i, i)
    if string.byte(str1) <= 127 then
     outStr=outStr .. str1
    end
  end
  return outStr
end -- function end
  -- =====================================================]]
function CheckString(YourStr)                          -- Check string for specal bite chars for HTML
  local function FindLetter(TheStr, TestChar)
    local outStr = false
    local strChar = ""
    local TheStrLen = string.len(TheStr)
    for i = 1, TheStrLen ,1 do
      strChar = string.sub(TheStr, i, i)
      if string.byte(strChar) == string.byte(TestChar) then
        outStr = true
        break
      end
    end
    return outStr
  end -- function end
-- =====================================================]]
  local StrTest = false
  StrTest = SwitchLetter(YourStr,  "&")  -- Non frendly File Name letters
  StrTest = SwitchLetter(YourStr,  "#")
  StrTest = SwitchLetter(YourStr,  "@")
  StrTest = SwitchLetter(YourStr,  "^")
  StrTest = SwitchLetter(YourStr,  "$")
    return outStr
end -- function end
-- =====================================================]]
function MakeHTMLReady(MyStr)                          -- fixs string with specal bite chars for HTML
  local function SwitchLetter(MyStr, MyChar, NewStr)
  local outStr, str1 = ""
  local inStrLen = string.len(MyStr)
  for i = 1, inStrLen ,1 do
    str1 = string.sub(MyStr, i, i)
    if string.byte(str1) == string.byte(MyChar) then
     outStr=outStr .. NewStr
     else
         outStr=outStr .. str1
    end
  end
  return outStr
end -- function end
-- =====================================================]]
  local outStr = ""
  outStr = SwitchLetter(MyStr, "!",	"&#33;")
  outStr = SwitchLetter(outStr, "#",	"&#35;")
  outStr = SwitchLetter(outStr, "$",	"&#36;")
  outStr = SwitchLetter(outStr, "%",	"&#37;")
  outStr = SwitchLetter(outStr, "&",	"&#38;")
  outStr = SwitchLetter(outStr, "'",	"&#39;")
  outStr = SwitchLetter(outStr, "(",	"&#40;")
  outStr = SwitchLetter(outStr, ")",	"&#41;")
  outStr = SwitchLetter(outStr, "*",	"&#42;")
  outStr = SwitchLetter(outStr, "+",	"&#43;")
  outStr = SwitchLetter(outStr, ",",	"&#44;")
  outStr = SwitchLetter(outStr, "-",	"&#45;")
  outStr = SwitchLetter(outStr, ".",	"&#46;")
  outStr = SwitchLetter(outStr, "/",	"&#47;")
  outStr = SwitchLetter(outStr, ":",	"&#58;")
  outStr = SwitchLetter(outStr, ";",	"&#59;")
  outStr = SwitchLetter(outStr, "<",	"&#60;")
  outStr = SwitchLetter(outStr, "=",	"&#61;")
  outStr = SwitchLetter(outStr, ">",	"&#62;")
  outStr = SwitchLetter(outStr, "?",	"&#63;")
  outStr = SwitchLetter(outStr, "@",	"&#64;")
  outStr = SwitchLetter(outStr, "[",	"&#91;")
  outStr = SwitchLetter(outStr, "]",	"&#93;")
  outStr = SwitchLetter(outStr, "^",	"&#94;")
  outStr = SwitchLetter(outStr, "_",	"&#95;")
  outStr = SwitchLetter(outStr, "`",	"&#96;")
  outStr = SwitchLetter(outStr, "{",	"&#123")
  outStr = SwitchLetter(outStr, "|",	"&#124")
  outStr = SwitchLetter(outStr, "}",	"&#125")
  outStr = SwitchLetter(outStr, "~",	"&#126")
    return outStr
end -- function end
-- =====================================================]]
function SwitchLetter(MyStr, MyChar, NewStr)            -- swwap a leter for another letter
  local outStr, str1 = ""
  local inStrLen = string.len(MyStr)
  for i = 1, inStrLen ,1 do
    str1 = string.sub(MyStr, i, i)
    if string.byte(str1) == string.byte(MyChar) then
     outStr=outStr .. NewStr
     else
         outStr=outStr .. str1
    end
  end
  return outStr
end -- function end
-- =====================================================]]
function PadC(str, lenth)                        -- Adds spaces to front and back to center text in lenth
-- Local Word = PadC("K", 12) -- returns "     K      "
  if type(str) ~= "string" then
    str = tostring(str)
  end
  if string.len(str) < lenth then
  local a = math.floor(lenth - string.len(str) * 0.5) - 2
  local b = math.ceil(lenth - string.len(str) * 0.5) - 2
  --print ("a = " .. a)
  for _ = 1, a, 1 do
    str =  " " .. str
  end
  for _ = 1, b, 1 do
    str =  str .. " "
  end
  --print ("str len = " .. #str)
  end
  return str
end -- function end
-- =====================================================]]
function PadR(str, len)                        -- Adds spaces to Back of string
-- Local Word = Pad("KPSDFKSPSK", 12) -- returns "KPSDFKSPSK  "
  if type(str) ~= "string" then
    str = tostring(str)
  end
  while string.len(str) < len do
    str = str .. " "
  end
  return str
end -- function end
-- =====================================================]]
function PadL(str, len)              -- Adds spaces to Front of string
-- Local Word = Pad("KPSDFKSPSK", 12) -- returns "  KPSDFKSPSK"
  if type(str) ~= "string" then
    str = tostring(str)
  end
  while string.len(str) < len do
    str = " " .. str
  end
  return str
end -- function end
-- =====================================================]]
function NumberPad(str, front, back) -- Adds spaces to front and zeros to the back of string
  local mychar
  local  a,b,c,d = 0,0,0,0
  local x,y,z = "","",""
  if type(str) ~= "string" then
    str = tostring(str)
  end
  c = string.len(str)
  for i = 1, c, 1 do
    mychar = string.byte(string.sub(str, i,i))
    if mychar == 46 then
      b = i
    end
  end
--  print("b = " .. b)
  if b == 0 then
    str = str .. "."
    c = c + 1
    b = c
  end -- if loc
  x = string.sub(str, 1, b-1)
  y = string.sub(str, b+1)
  a = c - b
  a = #x
  d = #y
  if a < front then
    front = front - (a - 1)
    for _ = 1, front -1 do
      x = " " .. x
    end -- end for front
  end
  back = back - (c - b)
  for i = 1, back  do
    y = y .. "0"
  end -- end for back
  str =   x .. "." .. y
  return str
end -- function end
-- =====================================================]]
function All_Trim(s)                           -- Trims spaces off both ends of a string
  return s:match( "^%s*(.-)%s*$" )
end -- function end
-- =====================================================]]
function Make_Proper_Case(str)
  local str=string.gsub(string.lower(str),"^(%w)", string.upper)
  return string.gsub(str,"([^%w]%w)", string.upper)
end
-- =====================================================]]
function ifT(x)                                -- Converts Boolean True or False to String "Yes" or "No"
-- ===ifT(x)===
  if x then
    return "Yes"
  else
    return "No"
  end-- if end
end -- function end
-- =====================================================]]
function ifY(x)                                -- Converts String "Yes" or "No" to Boolean True or False
-- ===ifY(x)===
  if string.upper(x) == "YES" then
    return true
  else
    return false
  end-- if end
end -- function end
-- =***************************************************=]]
end -- String function end
-- =====================================================]]
╔═╗╔═╗╔═╗╔╦╗  ╔═╗╦ ╦╔╗╔╔═╗╔╦╗╦╔═╗╔╗╔
╚═╗║╣ ║╣  ║║  ╠╣ ║ ║║║║║   ║ ║║ ║║║║
╚═╝╚═╝╚═╝═╩╝  ╚  ╚═╝╝╚╝╚═╝ ╩ ╩╚═╝╝╚╝
function SeedTool()
-- =====================================================]]
  -- VECTRIC LUA SCRIPT
-- =====================================================]]
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
-- =====================================================]]
-- require("mobdebug").start()
-- require "strict"
local Tools
-- Global Variables --
local Ver = "1.0"  -- Version 7: Aug 2021 - Clean Up and added Ver to Dialog

-- Table Names
Milling = {}
Project = {}
-- =====================================================]]
function main(script_path)
--[[
	Gadget Notes: Dec 2019 - My New Gadget

  ]]
-- Localized Variables --

-- Job Validation --
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: No job loaded")
    return false
  end

  Tools = assert(loadfile(script_path .. "\\EasyGearToolsVer" .. Ver .. ".xlua")) (Tools) -- Load Tool Function
-- Get Data --

-- Calculation --

-- Do Something --


  return true
end  -- function end
-- ==================== End ============================]]
-- =====================================================]]
end -- Seed Tools function end
-- =====================================================]]
╔═╗╔═╗╔╦╗╦ ╦╔═╗
╚═╗║╣  ║ ║ ║╠═╝
╚═╝╚═╝ ╩ ╚═╝╩
function SetupAndLetter Seeds()
-- =====================================================]]
  function LUA_Seed()
    -- VECTRIC LUA SCRIPT
    -- ==============================================================================
    --  Gadgets are an entirely optional add-in to Vectric's core software products.
    --  They are provided 'as-is', without any express or implied warranty, and you
    --  make use of them entirely at your own risk.
    --  In no event will the author(s) or Vectric Ltd. be held liable for any damages
    --  arising from their use.
    --  Permission is granted to anyone to use this software for any purpose,
    --  including commercial applications, and to alter it and redistribute it freely,
    --  subject to the following restrictions:
    --  1. The origin of this software must not be misrepresented;
    --     you must not claim that you wrote the original software.
    --     If you use this software in a product, an acknowledgement in the product
    --     documentation would be appreciated but is not required.
    --  2. Altered source versions must be plainly marked as such, and
    --     must not be misrepresented as being the original software.
    --  3. This notice may not be removed or altered from any source distribution.
    -- ==============================================================================
    -- "AppName Here" was written by JimAndi Gadgets of Houston Texas
    -- ==============================================================================
    -- =====================================================]]
    -- require("mobdebug").start()
    -- require "strict"
    -- =====================================================]]
    -- Global variables
    -- =====================================================]]
  end -- lua function
-- =====================================================]]
  function Install_letter()
  -- Steps to Install:

  -- 1. Download the gadget x.zip that is attached to this post.
  -- 2. Rename it from x.zip to x.vgadget
  -- 3. In Vectric Pro or Aspire click on Gadgets -> Install Gadget and navigate to where you downloaded the file to, select it and click Ok.

  -- It should give you a pop up saying the gadget was installed and you should see x in the Gadgets menu.

  -- Image Here

  -- Steps for Use:
  -- 1. Select a layer that you want to calculate for
  -- 2. Enter the cut depth
  -- 3. Enter the percentage of coverage for the area that will be filled in
  -- 4. Enter the hardner to resin percentage
  -- 5. Click the Calculate Button and the results will be displayed below in the Results Pane.
  end -- install function

end -- Header function
-- =====================================================]]
╔╦╗╔═╗╔═╗╦  ╔═╗╔═╗╔╦╗╦ ╦╔═╗
 ║ ║ ║║ ║║  ╠═╝╠═╣ ║ ╠═╣╚═╗
 ╩ ╚═╝╚═╝╩═╝╩  ╩ ╩ ╩ ╩ ╩╚═╝
function Toolpaths()
-- =====================================================]]
  function CreateLayerProfileToolpath(name, layer_name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)
    -- clear current selection
    local selection = job.Selection
    selection:Clear()
    -- get layer
    local layer = job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
    -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
    -- Create tool we will use to machine vectors
    local tool = Tool("Lua End Mill", Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT

    tool.InMM = tool_in_mm
    tool.ToolDia = tool_dia
    tool.Stepdown = tool_stepdown
    tool.Stepover = tool_dia * 0.25
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass profile options
    local profile_data = ProfileParameterData()
    -- start depth for toolpath
    profile_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    profile_data.CutDepth = cut_depth
    -- direction of cut - ProfileParameterData.
    -- CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
    profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
    -- side we machine on - ProfileParameterData.
    -- PROFILE_OUTSIDE, ProfileParameterData.PROFILE_INSIDE or
    -- ProfileParameterData.PROFILE_ON
    profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
    -- Allowance to leave on when machining
    profile_data.Allowance = 0.0
    -- true to preserve start point positions, false to reorder start
    -- points to minimise toolpath length
    profile_data.KeepStartPoints = false
    -- true if want to create 'square' external corners on toolpath
    profile_data.CreateSquareCorners = false
    -- true to perform corner sharpening on internal corners (only with v-bits)
    profile_data.CornerSharpen = false
    -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.UseTabs = false
    -- length for tabs if being used
    profile_data.TabLength = 5.0
    -- Thickness for tabs if being used
    profile_data.TabThickness = 1.0
    -- if true then create 3d tabs else 2d tabs
    profile_data.Use3dTabs = true
    -- if true in Aspire, project toolpath onto composite model
    profile_data.ProjectToolpath = false
    -- Create object used to control ramping
    local ramping_data = RampingData()
    -- if true we do ramping into toolpath
    ramping_data.DoRamping = false
    -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG
    -- or RampingData.RAMP_SPIRAL
    ramping_data.RampType = RampingData.RAMP_ZIG_ZAG
    -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE
    -- or RampingData.CONSTRAIN_ANGLE
    ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE
    -- if we are constraining ramp by distance, distance to ramp over
    ramping_data.RampDistance = 100.0
    -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
    ramping_data.RampAngle = 25.0
    -- if we are contraining ramp by angle, max distance to travel before 'zig zaging'
    -- if zig zaging
    ramping_data.RampMaxAngleDist = 15
    -- if true we restrict our ramping to lead in section of toolpath
    ramping_data.RampOnLeadIn = false
    -- Create object used to control lead in/out
    local lead_in_out_data = LeadInOutData()
    -- if true we create lead ins on profiles (not for profile on)
    lead_in_out_data.DoLeadIn = false
    -- if true we create lead outs on profiles (not for profile on)
    lead_in_out_data.DoLeadOut = false
    -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
    lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD
    -- length of lead to create
    lead_in_out_data.LeadLength = 10.0
    -- Angle for linear leads
    lead_in_out_data.LinearLeadAngle = 45
    -- Radius for circular arc leads
    lead_in_out_data.CirularLeadRadius = 5.0
    -- distance to 'overcut' (travel past start point) when profiling
    lead_in_out_data.OvercutDistance = 0.0
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data, ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings )
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
    return true
end -- end function
-- =====================================================]]
  function CreateProfileToolpath(name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)
    -- Create tool we will use to machine vectors
    local tool = Tool("Lua End Mill", Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
    tool.InMM = tool_in_mm
    tool.ToolDia = tool_dia
    tool.Stepdown = tool_stepdown
    tool.Stepover = tool_dia * 0.25
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass profile options
    local profile_data = ProfileParameterData()
    -- start depth for toolpath
    profile_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    profile_data.CutDepth = cut_depth
    -- direction of cut - ProfileParameterData.
    -- CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
    profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
    -- side we machine on - ProfileParameterData.
    -- PROFILE_OUTSIDE, ProfileParameterData.PROFILE_INSIDE or
    -- ProfileParameterData.PROFILE_ON
    profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
    -- Allowance to leave on when machining
    profile_data.Allowance = 0.0
    -- true to preserve start point positions, false to reorder start
    -- points to minimise toolpath length
    profile_data.KeepStartPoints = false
    -- true if want to create 'square' external corners on toolpath
    profile_data.CreateSquareCorners = false
    -- true to perform corner sharpening on internal corners (only with v-bits)
    profile_data.CornerSharpen = false
    -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.UseTabs = false
    -- length for tabs if being used
    profile_data.TabLength = 5.0
    -- Thickness for tabs if being used
    profile_data.TabThickness = 1.0
    -- if true then create 3d tabs else 2d tabs
    profile_data.Use3dTabs = true
    -- if true in Aspire, project toolpath onto composite model
    profile_data.ProjectToolpath = false
    -- Create object used to control ramping
    local ramping_data = RampingData()
    -- if true we do ramping into toolpath
    ramping_data.DoRamping = false
    -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG
    -- or RampingData.RAMP_SPIRAL
    ramping_data.RampType = RampingData.RAMP_ZIG_ZAG
    -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE
    -- or RampingData.CONSTRAIN_ANGLE
    ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE
    -- if we are constraining ramp by distance, distance to ramp over
    ramping_data.RampDistance = 100.0
    -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
    ramping_data.RampAngle = 25.0
    -- if we are contraining ramp by angle, max distance to travel before 'zig zaging'
    -- if zig zaging
    ramping_data.RampMaxAngleDist = 15
    -- if true we restrict our ramping to lead in section of toolpath
    ramping_data.RampOnLeadIn = false
    -- Create object used to control lead in/out
    local lead_in_out_data = LeadInOutData()
    -- if true we create lead ins on profiles (not for profile on)
    lead_in_out_data.DoLeadIn = false
    -- if true we create lead outs on profiles (not for profile on)
    lead_in_out_data.DoLeadOut = false
    -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
    lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD
    -- length of lead to create
    lead_in_out_data.LeadLength = 10.0
    -- Angle for linear leads
    lead_in_out_data.LinearLeadAngle = 45
    -- Radius for circular arc leads
    lead_in_out_data.CirularLeadRadius = 5.0
    -- distance to 'overcut' (travel past start point) when profiling
    lead_in_out_data.OvercutDistance = 0.0
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data, ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings )
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
    return true
end -- end function
-- =====================================================]]
  function CreatePocketingToolpath(name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_stepover_percent, tool_in_mm)
  -- Create tool we will use to machine vectors
    local tool = Tool("Lua End Mill",Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
    tool.InMM = tool_in_mm
    tool.ToolDia = tool_dia
    tool.Stepdown = tool_stepdown
    tool.Stepover = tool_dia * (tool_stepover_percent / 100)
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC,...
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = tool_dia * (tool_stepover_percent / 100) -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass pocketing options
    local pocket_data = PocketParameterData()
    -- start depth for toolpath
    pocket_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    pocket_data.CutDepth = cut_depth
    -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or
    -- ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
    pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
    -- Allowance to leave on when machining
    pocket_data.Allowance = 0.0
    -- if true use raster clearance strategy , else use offset area clearance
    pocket_data.DoRasterClearance = true
    -- angle for raster if using raster clearance
    pocket_data.RasterAngle = 0
    -- type of profile pass to perform PocketParameterData.PROFILE_NONE ,
    -- PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
    pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
    -- if true we ramp into pockets (always zig-zag)
    pocket_data.DoRamping = false
    -- if ramping, distance to ramp over
    pocket_data.RampDistance = 10.0
    -- if true in Aspire, project toolpath onto composite model
    pocket_data.ProjectToolpath = false
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- if we are doing two tool pocketing define tool to use for area clearance
    local area_clear_tool = nill
    -- we just create a tool twice as large for testing here
    area_clear_tool = Tool("Lua Clearance End Mill", Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
    area_clear_tool.InMM = tool_in_mm
    area_clear_tool.ToolDia = tool_dia * 2
    area_clear_tool.Stepdown = tool_stepdown * 2
    area_clear_tool.Stepover = tool_dia * 2 *(tool_stepover_percent / 100)
    area_clear_tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC..
    area_clear_tool.FeedRate = 30
    area_clear_tool.PlungeRate = 10
    area_clear_tool.SpindleSpeed = 20000
    area_clear_tool.ToolNumber = 1
    area_clear_tool.VBit_Angle = 90.0 -- used for vbit only
    area_clear_tool.ClearStepover = tool_dia*2*(tool_stepover_percent/100) -- used for vbit
  -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePocketingToolpath(name,tool,area_clear_tool,pocket_data,pos_data,geometry_selector,create_2d_previews,display_warnings)
    if toolpath_id == nill then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
    return true
end -- end function
-- =====================================================]]
  function CreateDrillingToolpath(name, start_depth, cut_depth, retract_gap, tool_dia, tool_stepdown, tool_in_mm)
  -- Create tool we will use to machine vectors
    local tool = Tool("Lua Drill", Tool.THROUGH_DRILL) -- BALL_NOSE, END_MILL, VBIT, THROUGH_DRILL
    tool.InMM = tool_in_mm
    tool.ToolDia = tool_dia
    tool.Stepdown = tool_stepdown
    tool.Stepover = tool_dia * 0.25
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass profile options
    local drill_data = DrillParameterData()
    -- start depth for toolpath
    drill_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    drill_data.CutDepth = cut_depth
    -- if true perform peck drilling
    drill_data.DoPeckDrill = retract_gap > 0.0
    -- distance to retract above surface when peck drilling
    drill_data.PeckRetractGap = retract_gap
    -- if true in Aspire, project toolpath onto composite model
    drill_data.ProjectToolpath = false
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view,
    -- if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreateDrillingToolpath(name,tool,drill_data,pos_data,geometry_selector,create_2d_previews,display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
    return true
end -- end function
-- =====================================================]]
  function CreateVCarvingToolpath(name, start_depth, flat_depth, vbit_angle, vbit_dia, vbit_stepdown, tool_stepover_percent, tool_in_mm)
    --[[ -------------- CreateVCarvingToolpath --------------
    |
    | Create a VCarving toolpath within the program for the currently selected vectors
    | Parameters:
    | name, -- Name for toolpath
    | start_depth -- Start depth for toolpath below surface of material
    | flat_depth -- flat depth - if 0.0 assume not doing flat bottom
    | vbit_angle -- angle of vbit to use
    | vbit_dia -- diameter of VBit to use
    | vbit_stepdown -- stepdown for tool
    | tool_stepover_percent - percentage stepover for tool
    | tool_in_mm -- true if tool size and stepdown are in mm
    |
    | Return Values:
    | true if toolpath created OK else false
    |
  ]]
  -- Create tool we will use to machine vectors
    local tool = Tool("Lua VBit",Tool.VBIT )-- BALL_NOSE, END_MILL, VBIT
    tool.InMM = tool_in_mm
    tool.ToolDia = vbit_dia
    tool.Stepdown = vbit_stepdown
    tool.Stepover = vbit_dia * (tool_stepover_percent / 100)
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = vbit_dia * (tool_stepover_percent / 100) * 2 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    -- vcarve_data:SetHomePosition(0, 0, 1.0)
    vcarve_data:SetHomePosition(Milling.HomeX, Milling.HomeY, Milling.HomeZGap )
    -- vcarve_data.SafeZGap = 0.5
    vcarve_data.SafeZGap = Milling.SafeZGap
    -- Create object used to pass pocketing options - used for area clearance only
    local vcarve_data = VCarveParameterData()
    -- start depth for toolpath
    vcarve_data.StartDepth = start_depth
    -- flag indicating if we are creating a flat bottomed toolpath
    vcarve_data.DoFlatBottom = flat_depth > 0.0
    -- cut depth for toolpath this is depth below start depth
    vcarve_data.FlatDepth = flat_depth
    -- if true in Aspire, project toolpath onto composite model
    vcarve_data.ProjectToolpath = false
    -- set flag indicating we are using flat tool
    vcarve_data.UseAreaClearTool = true
    -- Create object used to pass pocketing options - used for area clearance only
    local pocket_data = PocketParameterData()
    -- start depth for toolpath
    pocket_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    pocket_data.CutDepth = flat_depth
    -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION
    -- or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
    pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
    -- if true use raster clearance strategy , else use offset area clearance
    pocket_data.DoRasterClearance = false
    -- set flag indicating we are using flat tool
    pocket_data.UseAreaClearTool = true
    -- angle for raster if using raster clearance
    pocket_data.RasterAngle = 0
    -- type of profile pass to perform PocketParameterData.PROFILE_NONE ,
    -- PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
    pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- if we are doing two tool pocketing define tool to use for area clearance
    local area_clear_tool = nil
    -- we just create a 10mm end mill
    area_clear_tool = Tool("Lua Clearance End Mill",Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
    area_clear_tool.InMM = true
    area_clear_tool.ToolDia = 10
    area_clear_tool.Stepdown = 3
    area_clear_tool.Stepover = 3
    area_clear_tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
    area_clear_tool.FeedRate = 30
    area_clear_tool.PlungeRate = 10
    area_clear_tool.SpindleSpeed = 20000
    area_clear_tool.ToolNumber = 2
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreateVCarvingToolpath(name,tool,area_clear_tool,vcarve_data,pocket_data,pos_data,geometry_selector,create_2d_previews,display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
    return true
end -- end function
-- =====================================================]]
  function CreatePrismToolpath(name, start_depth, cut_depth, vbit_angle, vbit_dia, vbit_stepdown, tool_stepover_percent, tool_in_mm)
  --[[ ------------------- CreatePrismToolpath -------------------
  |
  | Create a prism toolpath within the program for the currently selected vectors
  | Parameters:
  | name, -- Name for toolpath
  | start_depth -- Start depth for toolpath below surface of material
  | cut_depth -- cut depth for drilling toolpath
  | vbit_angle -- angle of vbit to use
  | vbit_dia -- diameter of VBit to use
  | vbit_stepdown -- stepdown for tool
  | tool_stepover_percent - percentage stepover for tool
  | tool_in_mm -- true if tool size and stepdown are in mm
  |
  | Return Values:
  | true if toolpath created OK else false
  |
  ]]
    -- Create tool we will use to machine vectors
    local tool = Tool("Lua VBit", Tool.VBIT ) -- BALL_NOSE, END_MILL, VBIT
    tool.InMM = tool_in_mm
    tool.ToolDia = vbit_dia
    tool.Stepdown = vbit_stepdown
    tool.Stepover = vbit_dia * (tool_stepover_percent / 100)
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = vbit_dia * (tool_stepover_percent / 100) * 2 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass profile options
    local prism_data = PrismCarveParameterData()
    -- start depth for toolpath
    prism_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    prism_data.CutDepth = cut_depth
    -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION
    -- or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
    prism_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
    -- calculate the minimum cut depth to fully form the bevel on the current
    -- selection with the current tool
    local min_bevel_depth = prism_data:CalculateMinimumBevelDepth(tool, true)
    if min_bevel_depth > cut_depth then
      DisplayMessageBox("A prism will not be fully formed with a depth of " .. cut_depth .. "\r\n" ..
                        "A depth of " .. min_bevel_depth .. " is required to fully form the prism"
                        )
    end -- if end
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePrismCarvingToolpath(name, tool, prism_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end -- if end
    return true
end -- end function
-- =====================================================]]
  function CreateFlutingToolpath(name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)
    --[[ ----------------- CreateFlutingToolpath -----------------
  | Create a flutting toolpath within the program for the currently selected vectors
  | Parameters:
  | name, -- Name for toolpath
  | start_depth -- Start depth for toolpath below surface of material
  | cut_depth -- cut depth for toolpath
  | tool_dia -- diameter of tool to use
  | tool_stepdown -- stepdown for tool
  | tool_in_mm -- true if tool size and stepdown are in mm
  |
  | Return Values:
  | true if toolpath created OK else false
  |
  ]]
    -- Create tool we will use to machine vectors
    local tool = Tool("Lua Ball Nose", Tool.BALL_NOSE) -- BALL_NOSE, END_MILL, VBIT, THROUGH_DRILL
    tool.InMM = tool_in_mm
    tool.ToolDia = tool_dia
    tool.Stepdown = tool_stepdown
    tool.Stepover = tool_dia * 0.25
    tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
    tool.FeedRate = 30
    tool.PlungeRate = 10
    tool.SpindleSpeed = 20000
    tool.ToolNumber = 1
    tool.VBit_Angle = 90.0 -- used for vbit only
    tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
    -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
    pos_data:SetHomePosition(0, 0, 1.0)
    pos_data.SafeZGap = 5.0
    -- Create object used to pass fluting options
    local fluting_data = FlutingParameterData()
    -- start depth for toolpath
    fluting_data.StartDepth = start_depth
    -- cut depth for toolpath this is depth below start depth
    fluting_data.CutDepth = cut_depth
    -- type of fluting FULL_LENGTH, RAMP_START or RAMP_START_END
    fluting_data.FluteType = FlutingParameterData.RAMP_START_END
    -- type of ramping RAMP_LINEAR, RAMP_SMOOTH
    fluting_data.RampType = FlutingParameterData.RAMP_LINEAR
    -- if true use ratio field for controling ramp length else absolute length value
    fluting_data.UseRampRatio = false
    -- length of ramp as ratio of flute length(range 0 - 1.0)
    -- (for start and end - ratio is of half length)
    fluting_data.RampRatio = 0.2
    -- length to ramp over - if UseRampRatio == false
    fluting_data.RampLength = 15
    -- if true in Aspire, project toolpath onto composite model
    fluting_data.ProjectToolpath = false
    -- Create object which can be used to automatically select geometry
    local geometry_selector = GeometrySelector()
    -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
    -- if this is true we will display errors and warning to the user
    local display_warnings = true
    -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreateFlutingToolpath(name, tool, fluting_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    else
      return true
    end

    end -- end function
-- =====================================================]]
  function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
    -- Please Note: SelectVectorsOnLayer is provided by Vectric and can be found in the SDK and Sample Gadget files.
    --[[  ---------------- SelectVectorsOnLayer ----------------
    -- |   SelectVectorsOnLayer("Stringer Profile", selection, true, falus, falus)
    -- |   Add all the vectors on the layer to the selection
    -- |     layer,            -- layer we are selecting vectors on
    -- |     selection         -- selection object
    -- |     select_closed     -- if true  select closed objects
    -- |     select_open       -- if true  select open objects
    -- |     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
    -- |  Return Values:
    -- |     true if selected one or more vectors|
    --]]
    local objects_selected = false
    local warning_displayed = false
    local pos = layer:GetHeadPosition()
    while pos ~= nil do
      local object
      object, pos = layer:GetNext(pos)
      local contour = object:GetContour()
      if contour == nil then
        if (object.ClassName == "vcCadObjectGroup") and select_groups then
          selection:Add(object, true, true)
          objects_selected = true
        else
          if not warning_displayed then
            local message = "Object(s) without contour information found on layer - ignoring"
            if not select_groups then
              message = message ..  "\r\n\r\n" ..
              "If layer contains grouped vectors these must be ungrouped for this script"
            end -- if end
            DisplayMessageBox(message)
            warning_displayed = true
          end -- if end
        end -- if end
      else  -- contour was NOT nil, test if Open or Closed
        if contour.IsOpen and select_open then
          selection:Add(object, true, true)
          objects_selected = true
        elseif select_closed then
          selection:Add(object, true, true)
          objects_selected = true
        end -- if end
      end -- if end
    end -- while end
    -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
    -- tell selection we have now finished updating
    if objects_selected then
      selection:GroupSelectionFinished()
    end -- if end
    return objects_selected
  end -- function end
-- =====================================================]]

end -- Toolpaths function end
-- =====================================================]]
