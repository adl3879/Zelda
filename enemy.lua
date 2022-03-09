local class = require "lib.middleclass"
local Animation = require "utils.animation"
local enemy_anim = require "res.animation.enemy"
local Vector2 = require "physics.vector2"
local Collider = require "physics.collider"
require "utils.settings"

local Enemy = class("Enemy")

function math.inverse(number) return 1 / number end

function Enemy:initialize(name, id, x, y, width, height)
	self.name = name
	self.position = { x = x, y = y }
	self.size = { w = width, h = height }
	self.state = "idle"
	self.id = id
	
	self.player_distance = 0
	self.player_direcion = 0
	self.can_attack = true
	self.attack_time = love.timer.getTime()
	self.alpha = 1 
	
	-- stats
	local monster_info = monster_data[self.name]
	self.health = monster_info.health
	self.exp = monster_info.exp
	self.speed = monster_info.speed
	self.attack_damage = monster_info.damage
	self.resistance = monster_info.resistance
	self.attack_radius = monster_info.attack_radius
	self.notice_radius = monster_info.notice_radius
	self.attack_type = monster_info.attack_type
	
	-- animation
	self.animation = Animation:new(enemy_anim, "sprite")
	
	-- collider
	local offset = { x = 4, y = 4 } 
	colliders[self.id] = Collider:new("attackable")
	if self.name == "racoon" then
		self.size = { w = 240, h = 240 }
	end
	colliders[self.id]:new_box_collider(self.position.x, self.position.y, self.size.w - offset.x, self.size.h - offset.y)
end

-- define behaviours
Enemy.static.behaviour = {
	["idle"] = function(self, dt)
		self.animation:play(self.name.."_idle")
	end,
	
	["move"] = function(self, dt)
		self.animation:play(self.name.."_move")
		
		-- move player to the direction
		self.position.x = self.position.x + (self.player_direction.x * dt * self.speed)
		self.position.y = self.position.y + (self.player_direction.y * dt * self.speed)
	end,
	
	["attack"] = function(self, dt)
		local player = GameObjectInstance:get_player() -- player instance
		self.animation:play(self.name.."_attack")
		player:take_damage(self.attack_damage, self.attack_type)
	end,
	
	["take_hit"] = function(self, dt)
		local player = GameObjectInstance:get_player() -- player instance
		
		self.animation:play(self.name.."_idle")

		self.health = self.health - (player.stats.attack * math.inverse(self.resistance))
		self.alpha = wave_value()
	end,

	["dead"] = function(self, dt)
		self:destroy()
		ParticleEffectInstance:create(self.name, self.position.x - 32, self.position.y - 32)
	end
}

function Enemy:update(dt)
	local player = GameObjectInstance:get_player()
	Enemy.behaviour[self.state](self, dt)
	self.animation:update(dt)
	self:update_state()
	local px, py
	if self.name == "racoon" then
		 px = self.position.x + 120
		 py = self.position.y + 120
	 else
		 px = self.position.x
		 py = self.position.y
	end
	colliders[self.id]:set_box_collider(px, py)

	if colliders[self.id]:enter("attacker") then
		self.state = "take_hit"
	end
	
	if colliders[self.id]:enter("player") then
		-- player.is_collided = true
	end
	
	if self.state ~= "take_hit" then self.alpha = 1 end
end

function Enemy:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	self.animation:render(self.position.x, self.position.y, false, "center")
	love.graphics.setColor(1, 1, 1)
end

function Enemy:destroy()
	GameObjectInstance:destroy("enemies", self.id)
end

function Enemy:get_player_distance_direction()
	local player = GameObjectInstance:get_player() -- player instance
	
	local player_vec = Vector2(player:get_position())
	local enemy_vec = Vector2(self.position.x, self.position.y)
	local distance = (player_vec - enemy_vec):get_length()
	local direction = (player_vec - enemy_vec):normalize() -- magnitude becomes 1
	
	return distance, direction
end

function Enemy:update_state()
	self.player_distance, self.player_direction = self:get_player_distance_direction()
	local player = GameObjectInstance:get_player() -- player instance 
	
	if self.player_distance <= self.attack_radius then 
		self.state = "attack"
	elseif self.player_distance <= self.notice_radius then
		self.state = "move"
	else
		self.state = "idle"
	end

	if self.health < 0 then self.state = "dead" end
end

return Enemy
