local class = require "lib.middleclass"
local Collider = require "physics.collider"
require "utils.settings"

local Weapon = class("Weapon")

Weapon.static.SPRITES = {}

function Weapon:initialize()
	self.name = "sword"
	self.weapons = weapon_data
	self.create = false
	self.size = { w = 44, h = 24 }
	
	for key, value in pairs(self.weapons) do
		local temp = {}
		temp["up"] = love.graphics.newImage(value["graphic"].."up.png")
		temp["left"] = love.graphics.newImage(value["graphic"].."left.png")
		temp["down"] = love.graphics.newImage(value["graphic"].."down.png")
		temp["right"] = love.graphics.newImage(value["graphic"].."right.png")
		temp["full"] = love.graphics.newImage(value["graphic"].."full.png")
		
		Weapon.SPRITES[key] = temp
	end
end

function Weapon:spawn()
	colliders[self.name] = Collider:new("attacker")
	colliders[self.name]:new_box_collider(10, 10, self.size.w, self.size.h)
	self.create = true
end

function Weapon:destroy()
	colliders[self.name] = nil
	self.create = false
end

function Weapon:render(player)
	self.name = player.weapons[player.current_weapon_idx]
	local direction = player.direction
	local px, py = player:get_position()
	local p_width, p_height = player.animation:get_size()
	
	if player.state == "attacking" and self.spawn then
		if direction == "left" then
			love.graphics.draw(Weapon.SPRITES[self.name]["left"], (px - p_width), py)
		elseif direction == "right" then
			love.graphics.draw(Weapon.SPRITES[self.name]["right"], (px + p_width / 2), py)
		elseif direction == "up" then
			love.graphics.draw(Weapon.SPRITES[self.name]["up"], px, (py - p_height))
		elseif direction == "down" then
			love.graphics.draw(Weapon.SPRITES[self.name]["down"], px, (py + p_height / 2))
		end
	end
end

function Weapon:update(player, dt)
	if self.create then
		local direction = player.direction
		local px, py = player:get_position()
		local p_width, p_height = player.animation:get_size()
		
		if direction == "left" then
			px, py = (px - p_width + 22), py + 11
			self.size = { w = 44, h = 24 }
		elseif direction == "right" then
			px, py = (px + p_width - 10), py + 12
			self.size = { w = 44, h = 24 }
		elseif direction == "up" then
			px, py = px + 12, (py - p_height / 2 - 11)
			self.size = { w = 24, h = 44 }
		elseif direction == "down" then
			px, py = px + 12, (py + p_height / 2 + 22)
			self.size = { w = 24, h = 44 }
		end
	
		colliders[self.name]:set_box_collider(px, py, self.size.w, self.size.h)
	end
end

function Weapon:get_stats()
	return {
		["cooldown"] = self.weapons[self.name]["cooldown"],
		["damage"] = self.weapons[self.name]["damage"],
	}
end

return Weapon
