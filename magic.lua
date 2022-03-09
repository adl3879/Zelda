local class = require "lib.middleclass"
require "utils/settings"

local Magic = class("Magic")

Magic.static.SPRITES = {}

function Magic:initialize()
	for key, value in pairs(magic_data) do
		Magic.SPRITES[key] = love.graphics.newImage(value["graphic"])
	end
end

function Magic:heal(player, strength, cost)
	if player.energy >= cost and player.health < player.stats.health then
		player.health = player.health + strength
		player.energy = player.energy - cost

		if player.health > player.stats.health then
			player.health = player.stats.health
		end

		local px = player.position.x - 40
		local py = player.position.y - 80
		ParticleEffectInstance:create("heal", px, py)
		ParticleEffectInstance:create("aura", px, py)
	end
end

function Magic:flame(player)
	local px = player.position.x
	local py = player.position.y
	ParticleEffectInstance:create("flame", px, py)
end

return Magic
