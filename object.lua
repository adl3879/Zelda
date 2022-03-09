local class = require "lib.middleclass"

local GameObject = class("GameObject")

function GameObject:initialize()
	self.objects = {
		["actor"] = {},
		["enemies"] = {},
		["vegetation"] = {}
	}
end

function GameObject:new(group, id, object)
	-- store object in map (table)
	self.objects[group][id] = object
end

function GameObject:update(dt)
	for _, value in pairs(self.objects) do
		--value:update(dt)
		for _, obj in pairs(value) do
			obj:update(dt)
		end
	end
end

function GameObject:draw()
	self:render_object("vegetation")
	self:render_object("enemies")
	self:render_object("actor")
end

function GameObject:render_object(group)
	for key, value in pairs(self.objects[group]) do
		value:draw()
	end
end

function GameObject:get_player(id)
	return self.objects["actor"]["player"]
end

function GameObject:get_group(group)
	return self.objects[group]
end

function GameObject:destroy(group, id)
	self.objects[group][id] = nil
end

local GameObjectInstance = GameObject:new()

return GameObjectInstance
