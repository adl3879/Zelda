local class = require "lib.middleclass"

local GameObject = class("GameObject")

function GameObject:initialize()
	self.objects = {}
end

function GameObject:new(id, object)
	-- store object in map (table)
	self.objects[id] = object
end

function GameObject:update(dt)
	for key, value in pairs(self.objects) do
		value:update(dt)
	end
end

function GameObject:draw()
	for key, value in pairs(self.objects) do
		value:draw()
	end
end

function GameObject:get(id)
	return self.objects[id]
end

function GameObject:destroy(id)
	self.objects[id] = nil
end

local GameObjectInstance = GameObject:new()

return GameObjectInstance
