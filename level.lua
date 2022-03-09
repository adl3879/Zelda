local map_data = require "res.map.map"
local Enemy = require "enemy"
local Grass = require "grass"

local Level = {}

function Level:new()
	self.map = sti("res/map/map.lua", { "box2d" })

	-- sprite setup
	self:create_map()
end

function Level:render()
	self.map:drawLayer(self.map.layers["bkg"])
	self.map:drawLayer(self.map.layers["vegetation"])
end

function Level:update(dt)
	local map_width = self.map.width * self.map.tilewidth
	local map_height = self.map.height * self.map.tileheight

	if cam.x > (map_width - window_width / 2) then cam.x = map_width - window_width / 2 end
	if cam.y > (map_height - window_height / 2) then cam.y = map_height - window_height / 2 end

	self.map:update(dt)
end

function Level:create_map()
	-- grass
	if self.map.layers["grass"] then
		spawn_attackable_objects("grass", "grass_1", function(enemy_idx_check, id, pos, size)
			local rect = { x = pos.x, y = pos.y, w = size.w, h = size.h }
			
			local grass_type = ""
			if enemy_idx_check(12383) then grass_type = "grass_1"
			elseif enemy_idx_check(12384) then grass_type = "grass_2"
			elseif enemy_idx_check(12385) then grass_type = "grass_3" end
			GameObjectInstance:new("vegetation", id, Grass:new(id, rect, grass_type))
		end)
	end

	-- platforms
	if self.map.layers["platform"] then
		for i, obj in pairs(self.map.layers["platform"].objects) do
			spawn_platform(obj.x, obj.y, obj.width, obj.height)
		end
	end
	
	-- spawn enemies
	if self.map.layers["entities"] then
		spawn_attackable_objects("entities", "Floor", function(enemy_idx_check, id, pos, size)
			-- create enemy objects
			local monster_name = ""
			if enemy_idx_check(390) then monster_name = "bamboo"
			elseif enemy_idx_check(391) then monster_name = "spirit"
			elseif enemy_idx_check(392) then monster_name = "racoon"
			elseif enemy_idx_check(393) then monster_name = "squid" end
			GameObjectInstance:new("enemies", id, Enemy:new(monster_name, id, pos.x, pos.y, size.w, size.h))
		end)
	end
end

function spawn_platform(x, y, width, height)
	if width > 0 and height > 0 then
		local collider = world:newRectangleCollider(x, y, width, height)
		collider:setType("static")
	end
end

function spawn_attackable_objects(layer_name, sprite_name, fn)
	local firstgid, tilesize, data, size
	
	for key, value in pairs(map_data.tilesets) do
		if value.name == sprite_name then
			firstgid = value.firstgid
			tilesize = { w = value.tilewidth, h = value.tileheight }
			break
		end
	end

	for key, value in pairs(map_data.layers) do
		if value.type == "tilelayer" and value.name == layer_name then
			data = value.data
			size = { w = value.width, h = value.height }
			break
		end
	end
	
	-- loop through entity map data
	for y = 0, size.h - 1 do
		for x = 0, size.w - 1 do
			local index = (x + y * size.w) + 1
			
			if data[index] ~= 0 then
				local enemy_idx_check = function(col)
					if layer_name == "grass" then
						return data[index] == col
					else
						return data[index] == firstgid + col
					end
				end
				
				local px = (x / 2) * tilesize.w
				local py = ((y - 1) / 2) * tilesize.h
				local id = tostring(index)	-- unique identifier
				
				fn(enemy_idx_check, id, { x = px, y = py }, { w = tilesize.w, h = tilesize.h })
			end
		end
	end
end

return Level
