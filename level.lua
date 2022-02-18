local Level = {}

function Level:new()
	-- sprite visible setup
	self.visible_sprites = 10

	self.map = sti("res/map/map.lua", { "box2d" })

	-- sprite setup
	self:create_map()
end

function Level:render()
	self.map:drawLayer(self.map.layers["bkg"])
	self.map:drawLayer(self.map.layers["vegetation"])
	-- love.graphics.draw(self.bkg, 0, 0)
end

function Level:update(dt)
	local map_width = self.map.width * self.map.tilewidth
	local map_height = self.map.height * self.map.tileheight

	if cam.x > (map_width - love.graphics.getWidth() / 2) then
		cam.x = (map_width - love.graphics.getWidth() / 2)
	end
	if cam.y > (map_height - love.graphics.getHeight() / 2) then
		cam.y = (map_height - love.graphics.getHeight() / 2)
	end

	self.map:update(dt)

	-- platform collision
end

function Level:create_map()
	-- self.bkg = love.graphics.newImage("res/gfx/tilemap/ground.png")
	if self.map.layers["platform"] then
		for i, obj in pairs(self.map.layers["platform"].objects) do
			spawn_platform(obj.x, obj.y, obj.width, obj.height)
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
