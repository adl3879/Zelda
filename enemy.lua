local class = require "lib.middleclass"
local Animation = require "utils.animation"
local enemy_anim = require "res.animation.enemy"
local Vector2 = require "physics.vector2"
require "utils.settings"

local Enemy = class("Enemy")

function Enemy:initialize(name, id, x, y, width, height)
	self.name = name
	self.position = { x = x, y = y }
	self.size = { w = width, h = height }
	self.state = "idle"
	self.id = id
	
	-- stats
	monster_info = monster_data[self.name]
	self.health = monster_info.health
	self.exp = monster_info.exp
	self.speed = monster_info.speed
	self.attack_damage = monster_info.attack_damage
	self.resistance = monster_info.resistance
	self.attack_radius = monster_info.attack_radius
	self.notice_radius = monster_info.notice_radius
	self.attack_type = monster_info.attack_type
	
	-- animation
	self.animation = Animation:new(enemy_anim, "sprite")
end

Enemy.static.behaviour = {
	["idle"] = function(self, dt)
		self.animation:play(self.name.."_idle")
		-- print("idling")
	end,
	
	["move"] = function(self, dt)
		-- print("moving")
	end,
	
	["attack"] = function(self, dt)
		self.animation:play(self.name.."_attack")
		-- print("attacking")
	end
}

function Enemy:update(dt)
	Enemy.behaviour[self.state](self, dt)
	self.animation:update(dt)
	self:update_state()
end

function Enemy:draw()
	self.animation:render(self.position.x, self.position.y)
end

function Enemy:destroy()
	GameObjectInstance:destroy(self.id)
end

function Enemy:get_player_distance_direction()
	local player = GameObjectInstance:get("player") -- player instance
	
	local player_vec = Vector2(player:get_position())
	local enemy_vec = Vector2(self.position.x, self.position.y)
	local distance = (player_vec - enemy_vec):get_length()
	local direction = (player_vec - enemy_vec):normalize() -- magnitude becomes 1
	
	return distance, direction
end

function Enemy:update_state()
	local distance, direction = self:get_player_distance_direction()
	
	if distance <= self.attack_radius then
		self.state = "attack"
	elseif distance <= self.notice_radius then
		self.state = "move"
	else
		self.state = "idle"
	end
end

return Enemy
