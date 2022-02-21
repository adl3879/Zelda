local class = require "lib.middleclass"
local Animation = require "utils.animation"
local enemy_anim = require "res.animation.enemy"

local Enemy = class("Enemy")

Enemy.static.behaviour = {
	["idle"] = function(self, dt)
		self.animation:play(self.name.."_idle")
	end
}

function Enemy:initialize(name, id, x, y, width, height)
	self.name = name
	self.position = { x = x, y = y }
	self.size = { w = width, h = height }
	self.state = "idle"
	self.id = id
	
	-- animation
	self.animation = Animation:new(enemy_anim, "sprite")
end

function Enemy:update(dt)
	Enemy.behaviour[self.state](self, dt)
	self.animation:update(dt)
end

function Enemy:draw()
	self.animation:render(self.position.x, self.position.y)
end

function Enemy:destroy()
	GameObjectInstance:destroy(self.id)
end

return Enemy
