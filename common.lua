
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
-- common.lua: common functions for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Common = {}

-- Dependencies
local Log = require("log")

local sformat = string.format


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Common.copy(t, to)
    local to = to or {}
    for key, value in pairs(t) do
        to[key] = value
    end
    return to
end

function Common.validate(t, valid_data)
    local validated_data = t or {}
    for k, v in pairs(t) do
        if valid_data[k] then
            local valuetype = type(v)
            if valuetype == valid_data[k] then
                validated_data[k] = v
            else
                local str = "Validation failed: Value '%s' is of type '%s', should be '%s'"
                Log.warn(str, k, valuetype, valid_data[k])
            end
        end
    end
    return validated_data
end

function Common.assert(condition, msg, ...)
    msg = sformat(msg or "Assertion failed", ...)
    local success, ret = pcall(function()
        return assert(condition or false, "\n"..msg.."\n")
    end)
    if not success then
        local output = debug.traceback(ret, 2)
        -- Display the message
        print(output)
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