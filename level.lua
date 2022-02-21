local map_data = require "res.map.map"
local Enemy = require "enemy"

local Level = {}

function Level:new()
	-- sprite visible setup
	self.visible_sprites = 10
	self.ent_map = {}
	self.ent_size = { w = 0, h = 0 }
	self.ent_tilesize = { w = 0, h = 0 }
	self.ent_firstgid = 0

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
	if self.map.layers["platform"] then
		for i, obj in pairs(self.map.layers["platform"].objects) do
			spawn_platform(obj.x, obj.y, obj.width, obj.height)
		end
	end
	
	-- spawn enemies
	if self.map.layers["entities"] then
		for key, value in pairs(map_data.tilesets) do
			if value.name == "Floor" then
				self.ent_firstgid = value.firstgid
				self.ent_tilesize = { w = value.tilewidth, h = value.tileheight }
				break
			end
		end
	
		for key, value in pairs(map_data.layers) do
			if value.type == "tilelayer" and value.name == "entities" then
				self.ent_map = value.data
				self.ent_size = { w = value.width, h = value.height }
				break
			end
		end
		
		-- loop through entity map data
		for y = 0, self.ent_size.h - 1 do
			for x = 0, self.ent_size.w - 1 do
				local index = (x + y * self.ent_size.w) + 1
				
				if self.ent_map[index] == 0 then goto continue end
				
				local enemy_idx_check = function(col) 
					return self.ent_map[index] == self.ent_firstgid + col
				end
				
				local px = (x / 2) * self.ent_tilesize.w
				local py = ((y - 1) / 2) * self.ent_tilesize.h
				local id = tostring(index)	-- unique identifier
				
				-- create enemy objects
				if enemy_idx_check(390) then
					GameObjectInstance:new(id, Enemy:new("bamboo", id,  px, py))
				elseif enemy_idx_check(391) then
					GameObjectInstance:new(id, Enemy:new("spirit", id, px, py))
				elseif enemy_idx_check(392) then
					GameObjectInstance:new(id, Enemy:new("racoon", id, px, py))
				elseif enemy_idx_check(393) then
					GameObjectInstance:new(id, Enemy:new("squid", id, px, py))
				end
				
				::continue::
			end
		end
	end
end

function spawn_platform(x, y, width, height)
	if width > 0 and height > 0 then
		local collider = world:newRectangleCollider(x, y, width, height)
		collider:setType("static")
	end
end

return Level
