local class = require "lib.middleclass"
require "utils.settings"

local Weapon = class("Weapon")

Weapon.static.SPRITES = {}

function Weapon:initialize()
	self.name = ""
	self.weapons = weapon_data
	self.create = false
	
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
	self.create = true
end

function Weapon:destroy()
	self.create = false
end

function Weapon:render(player)
	self.name = player.weapons[player.current_weapon_idx]
	local direction = player.direction
	local px, py = player.physics:getPosition()
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
	else
		return
	end
end

function Weapon:get_stats()
	return {
		["cooldown"] = self.weapons[self.name]["cooldown"],
		["damage"] = self.weapons[self.name]["damage"],
	}
end

return Weapon
