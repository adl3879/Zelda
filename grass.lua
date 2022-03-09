local class = require "lib.middleclass"
local Collider = require "physics.collider"

local Grass = class("Grass")

function Grass:initialize(id, rect, name)
	self.id = id
	self.state = "idle"
	self.rect = rect or {}
	local sprite = "res/gfx/grass/"..name..".png"
	self.image = love.graphics.newImage(sprite)
	
	-- stats
	self.health = 50
	
	-- collider
	colliders[self.id] = Collider:new("attackable")
	colliders[self.id]:new_box_collider(self.rect.x + 32, self.rect.y + 32, 56, 56)
end

Grass.static.behaviour = {
	["idle"] = function(self, dt)
		-- does nothing
	end,

	["take_hit"] = function(self, dt)	
		ParticleEffectInstance:create("leaf", self.rect.x - 32, self.rect.y - 32)

		self.health = self.health - (self.health * dt + 0.5)
		if self.health <= 0 then self:destroy() end
	end
}

function Grass:update(dt)
	Grass.behaviour[self.state](self, dt)

	if colliders[self.id]:enter("attacker") then
		self.state = "take_hit"
	else
		self.state = "idle"
	end
end

function Grass:draw()
	love.graphics.draw(self.image, self.rect.x, self.rect.y)
end

function Grass:destroy()
	GameObjectInstance:destroy("vegetation", self.id)
end

return Grass
