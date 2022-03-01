local class = require "lib.middleclass"

local Grass = class("Grass")

function Grass:initialize(id, rect)
	self.id = id
	self.image = love.graphics.newImage("res/gfx/grass/grass_1.png")
	self.rect = rect or {}
end

function Grass:update(dt)

end

function Grass:draw()
	love.graphics.draw(self.image, self.rect.x, self.rect.y)
end

return Grass
