
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
-- array.lua: Array class for Knights: Quest for Gems --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local Array = {}
Array.__index = Array


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Local functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Constructor --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Array.new()
    local self = setmetatable({
        items = {},
        next_id = 0,
        -- maybe later store ids of removed items and reuse their space for new items
        --reuse_ids = {},
    }, Array)

    return self
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Public functions --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Array:add(item, flags)
    local flags = flags or {}
    if flags.id then
        item.id = flags.id
    else
        item.id = self.next_id
        self.next_id = self.next_id + 1
    end
    self.items[item.id] = item
    return item
end

function Array:remove(id)
    if self.items[id] then
        self.items[id] = nil
    end
end

function Array:get(id)
    return self.items[id]
end

function Array:getItems()
    return self.items
end

function Array:clear()

end

function Array:sort(f)
    table.sort(self.items, f or function(a, b) return a.id > b.id end)
end

function Array:update(dt)
    for key = #self.items, 1, -1 do
        local item = self.items[key]
        if item.update then
            if item.is_alive then item:update(dt)
            else
                self.items[item.id] = nil
            end
        end
    end
end

function Array:draw()
    for key = 1, #self.items do
        local item = self.items[key]
        if item.draw then
            item:draw()
        end
    end
end

return Array