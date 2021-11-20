
_TITLE          = "Knights"
_VERSION        = 'v0.0.1'
_DESCRIPTION    = '2D vs/coop dungeon-crawler for 1 - 4 players'
_URL            = 'https://github.com/MadByteDE/Knights'

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

function love.exit()
    Game:exit()
end