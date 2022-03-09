local class = require "lib.middleclass"

local Animation = require "utils.animation"
local Weapon = require "weapon"
local Magic = require "magic"
local Collider = require "physics.collider"

local player_anim = require "res.animation.player"

local Player = class("Player")

function Player:initialize()
	self.animation = Animation:new(player_anim, "sprite")
	self.position = { x = 1980, y = 1300 }
	self.last_safe_pos = { x = 0, y = 0 }
	self.state = "idle"
	self.direction = "down"
	self.attack_time = Player.ATTACK_TIME
	self.alpha = 1

	-- take damage
	self.vulnerable = false

	-- weapons
	self.weapons = { "sword", "lance", "axe", "rapier", "sai" }
	self.weapon = Weapon:new()
	self.current_weapon_idx = 1
	self.can_switch_weapon = false
	self.weapon_switch_time = love.timer.getTime()
	
	-- magic
	self.magic_list = { "flame", "heal" }
	self.magic = Magic:new()
	self.magic_index = 1
	self.can_switch_magic = true
	self.magic_switch_time = love.timer.getTime()
	self.magic_duration = love.timer.getTime()
 
	-- collider (makes it a rigid body)
	self.physics = world:newCircleCollider(self.position.x, self.position.y, 30)
	colliders["player"] = Collider:new("player")
	colliders["player"]:new_box_collider(self.position.x, self.position.y, 60, 60)
	self.is_collided = false
	
	-- stats
	self.stats = { health = 100, energy = 60, attack = 10, magic = 4, speed = 6 }
	self.health = self.stats["health"]
	self.energy = self.stats["energy"]
	self.exp = 123
	self.speed = self.state["speed"]
end

-- constant variabes
Player.static.WALKING_SPEED = 40000
Player.static.ATTACK_TIME = 30

-- player behaviour
Player.static.behaviour = {
	["idle"] = function(self, dt)
		self.animation:play("idle_down") -- idle if nothing is going on
		
		if love.keyboard.isDown("left", "right", "up", "down") then
			self.state = "walking"
		end
	end,

	["walking"] = function(self, dt)
		if love.keyboard.isDown("left") then
			self.direction = "left"
			self.physics:applyForce(-Player.WALKING_SPEED, 0)
			self.animation:play("walk_left")
		elseif love.keyboard.isDown("right") then
			self.direction = "right"
			self.physics:applyForce(Player.WALKING_SPEED, 0)
			self.animation:play("walk_right")
		elseif love.keyboard.isDown("up") then
			self.direction = "up"
			self.physics:applyForce(0, -Player.WALKING_SPEED)
			self.animation:play("walk_up")
		elseif love.keyboard.isDown("down") then
			self.direction = "down"
			self.physics:applyForce(0, Player.WALKING_SPEED)
			self.animation:play("walk_down")
		else 
			self.state = "idle"
		end
		
		-- attacking
		if love.keyboard.isDown("space") then
			self.state = "attacking"
			self.weapon:spawn()
		end

	end,
	
	["attacking"] = function(self, dt)
		self.animation:play("attack_"..self.direction)
		self.attack_time = self.attack_time - (100 * dt)
		
		if (self.attack_time < 0) then
			self.state = "walking"
			self.attack_time = Player.ATTACK_TIME
			self.weapon:destroy()
		end
	end,

	["magic"] = function(self, dt)
		if self.magic_list[self.magic_index] == "heal" then
			self.animation:play("attack_down") -- idle if nothing is going on
			self.magic:heal(self, 0.5, 0.5)
		elseif self.magic_list[self.magic_index] == "flame" then
			self.animation:play("attack_"..self.direction)
			self.magic:flame(self)
		end

		if love.timer.getTime() > self.magic_duration + 0.05 then
			self.state = "idle"
		end
	end
}

function Player:update(dt)
	self.physics:setLinearVelocity(0, 0)

	-- handle state
	Player.behaviour[self.state](self, dt)

	-- camera
	cam:lookAt(self.physics:getPosition())
	
	-- collider
	self.position.x, self.position.y = self:get_position()
	colliders["player"]:set_box_collider(self.position.x, self.position.y, 60, 60)
	if self.is_collided then
		self.position.x = self.last_safe_pos.x
		self.position.y = self.last_safe_pos.y
	else
		self.last_safe_pos.x = self.position.x
		self.last_safe_pos.y = self.position.y
	end
	self.is_collided = false

	-- switch_weapon_and_magic
	self:switch_weapon_and_magic()

	-- magic
	if love.keyboard.isDown("z") then
		self.state = "magic"
		self.magic_duration = love.timer.getTime()
	end
	
	self.animation:update(dt)
	self.weapon:update(self, dt)

	self:check_vulnerability()
	if not self.vulnerable then 
		self.alpha = 1
	end
end

function Player:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	self.animation:render(self.position.x, self.position.y, false, "center")
	love.graphics.setColor(1, 1, 1)

	self.weapon:render(self)
end

function Player:get_position()
	return self.physics:getPosition()
end

function Player:check_vulnerability()
	local enemies = GameObjectInstance:get_group("enemies")
	local vulnerable = false
	for _, enemy in pairs(enemies) do
		if enemy.state == "attack" then
			vulnerable = true
			break
		else
			vulnerable = false
		end
	end
	self.vulnerable = vulnerable
end

function Player:take_damage(damage, type)
	if self.vulnerable then
		self.alpha = wave_value()
	end
	self.health = self.health - (damage * 0.0033)

	ParticleEffectInstance:create(type, self.position.x - 32, self.position.y - 32)
end

function Player:switch_weapon_and_magic()
	-- change weapon
	if self.state ~= "attacking" and love.keyboard.isDown("q") and love.timer.getTime() > (self.weapon_switch_time + 0.5) then
		self.current_weapon_idx = self.current_weapon_idx + 1
		if self.current_weapon_idx > #self.weapons then self.current_weapon_idx = 1 end
		self.can_switch_weapon = true
		self.weapon_switch_time = love.timer.getTime()
	elseif not love.keyboard.isDown("q") then
		self.can_switch_weapon = false
	end
	
	-- change magic
	if self.state ~= "attacking" and love.keyboard.isDown("e") and love.timer.getTime() > (self.magic_switch_time + 0.5) then
		self.magic_index = self.magic_index + 1
		if self.magic_index > #self.magic_list then self.magic_index = 1 end
		self.can_switch_magic = true
		self.magic_switch_time = love.timer.getTime()
	elseif not love.keyboard.isDown("e") then
		self.can_switch_magic = false
	end
end

-- add "Player" as a game object
GameObjectInstance:new("actor", "player", Player:new())

return Player
