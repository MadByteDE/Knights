
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

local Log = {}
Log.__index = Log

local DEFAULT_DIRPATH = "logs/"
local DEFAULT_FILENAME = "latest.log"
local MESSAGE_TYPES = {"warn", "info", "debug"}
local sformat, supper, unpack, print = string.format, string.upper, unpack, print
local fs = love.filesystem


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function log(status, msg, ...)
    -- Get amount of lines in the log file
    local _, lines = fs.read(Log.filepath):gsub("\n", "")
    -- Get more infos
    local header = supper(status) .." ".. os.date("%H:%M:%S")
    local debuginfo = debug.getinfo(3, "Sl")
    local src = debuginfo.short_src .." ".. debuginfo.currentline
    -- Format the string
    local string = "%s [%s] %s: %s"
    local output = sformat(string, lines + 1, header, src, sformat(msg, ...))
    -- Write to log file
    Log.write(output)
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Log:init(dirpath, filename)
    self.dirpath = dirpath or DEFAULT_DIRPATH
    self.filename = filename or DEFAULT_FILENAME
    self.filepath = self.dirpath .. self.filename

    -- Create directory if needed
    if not fs.getInfo(self.dirpath) then
        local ok = fs.createDirectory(self.dirpath)
        if not ok then
            print("Unable to create directory at path '"..self.dirpath.."'")
        end
    end

    -- Create methods for all message types
    for _, type in pairs(MESSAGE_TYPES) do
        self[type] = function(msg, ...)
            log(type, msg, ...)
        end
    end

    -- Create the log file
    self.file = fs.write(self.filepath, "")

    -- Print where the file has been created
    local absolute_path = fs.getSaveDirectory() .."/".. self.filepath
    print(sformat("Created log file at '%s'", absolute_path))
end


function Log.write(msg)
    -- Show message in console
    print(msg)
    -- Write to file
    fs.append(Log.filepath, msg.."\n")
end


-- Init itself
Log:init()

return Log