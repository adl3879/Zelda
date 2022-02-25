local class = require "lib.middleclass"
local Animation = require "utils.animation"
local enemy_anim = require "res.animation.enemy"
local Vector2 = require "physics.vector2"
require "utils.settings"

local Enemy = class("Enemy")

function math.inverse(number) return 1 / number end

function Enemy:initialize(name, id, x, y, width, height)
	self.name = name
	self.position = { x = x, y = y }
	self.size = { w = width, h = height }
	self.state = "attack"
	self.id = id
	
	self.player_distance = 0
	self.player_direcion = 0
	self.can_attack = true
	self.attack_time = love.timer.getTime()
	
	-- stats
	local monster_info = monster_data[self.name]
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
		self.animation:play(self.name.."_attack")
		-- print("attacking")
	end,
	
	["take_hit"] = function(self, dt)
		local player = GameObjectInstance:get("player") -- player instance
		
		self.animation:play(self.name.."_idle")
		self.health = self.health - (player.stats.attack * dt + math.inverse(self.resistance))
		if self.health <= 0 then self:destroy() end
	end
}

function Enemy:update(dt)
	Enemy.behaviour[self.state](self, dt)
	self.animation:update(dt)
	self:update_state()
end

function Enemy:draw()
	self.animation:render(self.position.x, self.position.y, false, "center")
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
	self.player_distance, self.player_direction = self:get_player_distance_direction()
	local player = GameObjectInstance:get("player") -- player instance 
	
	if self.player_distance <= self.attack_radius and love.timer.getTime() > (self.attack_time + 0.001) then 
		if player.state == "attacking" then
			self.state = "take_hit"
		else
			self.state = "attack"
			self.attack_time = love.timer.getTime()
		end
	elseif self.player_distance <= self.notice_radius then
		self.state = "move"
	else
		self.state = "idle"
	end
end

return Enemy
