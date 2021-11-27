
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
-- room.lua: Room file for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Room = {}
Room.__index = Room

local Assets    = require("assets")
local Common    = require("common")
local Array     = require("array")
local Layer     = require("layer")
local Tile      = require("tile")

local fs = love.filesystem


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function loadTileset(name, tilesize)
    local filename = name..".lua"
    local path = "tileset/"..filename
    local tileset
    if fs.getInfo(path) then
        tileset = fs.load(path)()
        tileset.name = name
        tileset.image = Assets.image[name]
        tileset.imagewidth = tileset.image:getWidth()
        tileset.imageheight = tileset.image:getHeight()

        local tile_id = 0
        for yy=0, tileset.imageheight / tilesize-1 do
            for xx=0, tileset.imagewidth / tilesize-1 do
                local tile = tileset.tiles[tile_id]
                local iw, ih = tileset.imagewidth, tileset.imageheight
                local x, y = xx*tilesize, yy*tilesize
                tile.quad = love.graphics.newQuad(x, y, tilesize, tilesize, iw, ih)
                tileset[tile_id] = tile
                tile_id = tile_id + 1
            end
        end
    end
    return tileset
end

local function createLayers(roomdata)
    local layers = Array.new()
    for i = 1, #roomdata.layers do
        -- Create layer data
        local layerdata = roomdata.layers[i]
        layerdata.tilesize  = roomdata.tilewidth
        layerdata.tileswide = roomdata.tileswide
        layerdata.tileshigh = roomdata.tileshigh
        layerdata.tilearray = {}
        for y = 0, layerdata.tileshigh do
            layerdata.tilearray[y] = {}
            for x = 0, layerdata.tileswide do
                layerdata.tilearray[y][x] = {}
            end
        end

        -- Merge tile data from tileset and layer
        local tileset = loadTileset(roomdata.tileset, layerdata.tilesize)

        for _, layertile in ipairs(layerdata.tiles) do
            local tiledata = {}
            --FIXME: Remove this hack
            if layertile.tile == -1 then layertile.tile = 0 end
            tiledata.id     = layertile.tile
            tiledata.idx_x  = layertile.x
            tiledata.idx_y  = layertile.y
            tiledata.flip_x = layertile.flipX
            tiledata.angle  = layertile.rot
            tiledata.tileset= tileset
            layerdata.tilearray[layertile.y][layertile.x] = Tile.new(tiledata)
        end

        -- Add new layer to room
        local layer = Layer.new(layerdata)
        layers:add(layer, {id=layerdata.number+1})
    end
    return layers
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Constructor --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Room.new(roomdata)
    local self = setmetatable({}, Room)
    self.layers = createLayers(roomdata)
    return self
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Room:update(dt)
    -- self.layers:update(dt)
end

function Room:draw(x, y)
    local layers = self.layers:getItems()
    for i = #layers, 1, -1 do
        local layer = layers[i]
        love.graphics.push()
        love.graphics.translate(x or 0, y or 0)
        layer:draw()
        love.graphics.pop()
    end
end

return Room