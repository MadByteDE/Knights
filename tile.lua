
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
-- tile.lua: Tile file for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Tile = {}
Tile.__index = Tile

local Common = require("common")
local Log = require("log")

local valid_data = {
    id      = "number",
    idx_x   = "number",
    idx_y   = "number",
    angle   = "number",
    flip_x  = "boolean",
    tileset = "table",}


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Constructor --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Tile.new(tiledata)
    local self = setmetatable({}, Tile)
    self:setData(tiledata)
    return self
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Tile:getInfo(tilesize)
    local angle = math.rad(90 * self.angle)
    local sx, sy = 1, 1
    local ox, oy = tilesize/2, tilesize/2
    local kx, ky = 0, 0
    if self.flip_x then
        sy = sy * -1
        ox = tilesize - ox
        kx = kx * -1
        ky = ky * -1
    end
    return angle, sx, sy, ox, oy, kx, ky
end

function Tile:setData(tiledata)
    local validated_data = Common.validate(tiledata, valid_data)
    Common.copy(validated_data, self)
end

function Tile:draw(layer)
    local world_x, world_y = layer:idxToWorld(self.idx_x, self.idx_y)
    local x, y = layer.x + world_x, layer.y + world_y
    local tw = layer.tilesize
    local angle, sx, sy, ox, oy, kx, ky = self:getInfo(tw)
    local quad = self.tileset[self.id].quad
    if quad then
        love.graphics.push()
        love.graphics.translate(tw/2, tw/2)
        love.graphics.draw(self.tileset.image, quad, x, y, angle, sx, sy, ox, oy)
        love.graphics.pop()
    else
        love.graphics.rectangle("line", world_x, world_y, tw, tw)
    end
end

return Tile