
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
-- tilelayer.lua: tilelayer file for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Layer = {}
Layer.__index = Layer

local lg = love.graphics

local Common = require("common")

local valid_data = {
    name        = "string",
    visible     = "boolean",
    x           = "number",
    y           = "number",
    tilesize    = "number",
    tileswide   = "number",
    tileshigh   = "number",
    tileset     = "table"}


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function updateCanvas(self)
    self.canvas:renderTo(function()
        love.graphics.clear()
        self:iterate(function(tile, x, y)
            tile:draw(self)
        end)
    end)
end

local function drawCanvas(self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, self.x, self.y)
    love.graphics.setBlendMode("alpha")
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Constructor --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Layer.new(layerdata)
    local self = setmetatable({}, Layer)
    self:setData(layerdata)
    self.name = self.name or "Layer"
    self.x = self.x or 0
    self.y = self.y or 0
    self.visible = self.visible or true
    local worldwidth, worldheight = self:getWorldDimensions()
    self.canvas = lg.newCanvas(worldwidth, worldheight)
    updateCanvas(self)
    return self
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Layer:setData(tiledata)
    local validated_data = Common.validate(tiledata, valid_data)
    Common.copy(validated_data, self)
end


function Layer:setTile(x, y, tiledata)
    if self.tilearray[y] then
        local tile = self.tilearray[y][x]
        tile:setData(tiledata)
        updateCanvas(self)
    end
end

function Layer:getTile(x, y)
    return self.tilearray[y][x]
end

function Layer:idxToWorld(x, y)
    return x*self.tilesize, y*self.tilesize
end

function Layer:worldToIdx(x, y)
    return math.floor(x/self.tilesize)+1, math.floor(y/self.tilesize)+1
end

function Layer:getWorldDimensions()
    local worldwidth = self.tileswide*self.tilesize
    local worldheight = self.tileshigh*self.tilesize
    return worldwidth, worldheight
end

function Layer:iterate(f)
    for y = 0, self.tileshigh-1 do
        for x = 0, self.tileswide-1 do
        print(x..", "..y)
        local tile = self.tilearray[y][x]
        f(tile, x, y)
        end
    end
end

function Layer:update(dt)
    if not self.visible then return end
end

function Layer:draw()
    if not self.visible then return end
    drawCanvas(self)
    -- drawAnimatedTiles(self)
end

return Layer