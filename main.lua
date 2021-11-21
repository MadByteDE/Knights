
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

-- Show debug output immediately
io.stdout:setvbuf("no")

_TITLE          = "Knights"
_VERSION        = 'v0.0.1'
_DESCRIPTION    = '2D vs/coop dungeon-crawler for 1 - 4 players'
_URL            = 'https://github.com/MadByteDE/Knights'
_DEBUG          = true

Log = require("log").new()
Common = require("common")

local Game = require("game")

function love.load()
    Game:init()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end

function love.keypressed(key)
    Game:keypressed(key)
end

function love.quit()
    Game:quit()
end