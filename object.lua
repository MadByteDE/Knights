
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
-- objet.lua: Object file for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Object = {}
Object.__index = Object


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Constructor --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Object.new(x, y)
    local self = {}
    self:setPosition(x, y)
    self:setDimensions()
    self:setRadius()
    self:setAngle()
    self:setOffset()
    return setmetatable(self, Object)
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Object:setPosition(x, y)
    self.x = x or self.x or 0
    self.y = y or self.y or 0
end

function Object:setRadius(r)
    self.radius = r or self.radius or 16
end

function Object:setAngle(angle)
    self.angle = angle or self.angle or 0
end

function Object:setOffset(ox, oy)
    self.ox = ox or self.ox or 0
    self.oy = oy or self.oy or 0
end

function Object:setDimensions(w, h)
    self.width = w or self.width or 16
    self.height = h or self.height or 16
end

function Object:drawRectangle(mode, x, y, w, h)
    local x, y = x or self.x, y or self.y
    local w, h = w or self.radius, h or self.radius
    love.graphics.rectangle(mode or "line", x, y, w, h)
end

function Object:drawCircle(mode, x, y, r)
    local x, y = x or self.x, y or self.y
    local r = r or self.radius
    love.graphics.circle(mode or "line", x, y, r)
end

function Object:update()
end

function Object:draw()
    self:drawRectangle()
    self:drawCircle()
end


return Object