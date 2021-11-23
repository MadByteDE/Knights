
-- Knights: Quest for Gems - A 2D top-down vs/coop dungeon-crawler for 1-4 players
-- Copyright (C) 2021 Lars Loenneker

-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 3
-- of the License, or (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see https://www.gnu.org/licenses/gpl-3.0.txt.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Log.lua: Logging tool for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Common = {}

-- Dependencies
local Log = require("log")

local sformat = string.format


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Common.assert(condition, msg, ...)
    msg = sformat(msg or "Assertion failed", ...)
    local success, ret = pcall(function()
        return assert(condition or false, "\n"..msg.."\n")
    end)
    if not success then
        local output = debug.traceback(ret, 2)
        -- Display the message
        if Log then Log.write(output)
        else print(output) end
        -- Quit the program
        love.event.quit()
    end
    return ret
end


-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua

function Common.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

return Common