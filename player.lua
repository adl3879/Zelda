local class = require "lib.middleclass"

local Animation = require "utils.animation"
local Weapon = require "weapon"
local Magic = require "magic"

local player_anim = require "res.animation.player"

local Player = class("Player")

function Player:initialize()
	self.animation = Animation:new(player_anim, "sprite")
	self.initial_pos = { x = 1980, y = 1300 }
	self.state = "idle"
	self.direction = "down"
	self.attack_time = Player.ATTACK_TIME
	
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
 
	-- collider (make it a rigid body)
	self.physics = world:newCircleCollider(self.initial_pos.x, self.initial_pos.y, 30)
	
	-- stats
	self.stats = { health = 100, energy = 60, attack = 10, magic = 4, speed = 6 }
	self.health = self.stats["health"] * 0.5
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
	end
}

function Player:update(dt)
	self.physics:setLinearVelocity(0, 0)

	-- handle state
	Player.behaviour[self.state](self, dt)

	-- camera
	cam:lookAt(self.physics:getPosition())
	
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
	
	self.animation:update(dt)
end

function Player:draw()
	local px, py = self.physics:getPosition()
	self.animation:render(px, py, false, "center")
	self.weapon:render(self)
end

-- add "Player" as a game object
GameObjectInstance:new("player", Player:new())

return Player
