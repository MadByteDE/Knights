
local Game = {}

function Game:init()
end

function Game:update(dt)
end

function Game:draw()
end

function Game:keypressed(key)
    if key == "escape" then love.event.quit() end
end

function Game:quit()
end

return Game