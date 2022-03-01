local class = require "lib.middleclass"

local Collider = class("Collider")

colliders = {}

function Collider:initialize(class)
	self.class = class or ""
	self.type = ""
	self.box = {}
	self.colliders = {}
end

function Collider:new_box_collider(x, y, w, h)
	self.type = "box"
	self.box = { x = x, y = y, w = w, h = h }
end

function Collider:set_box_collider(x, y, w, h)
	self.box.x = x
	self.box.y = y
	self.box.w = w or self.box.w
	self.box.h = h or self.box.h
end

function Collider:draw()
	local px = self.box.x - (self.box.w / 2)
	local py = self.box.y - (self.box.h / 2)
	love.graphics.rectangle("line", px, py, self.box.w, self.box.h)
end

function Collider:enter(class)
	for key, collider in pairs(colliders) do
		if collider.class == class then
			local x_overlaps = (self.box.x < collider.box.x + collider.box.w) and (self.box.x + self.box.w > collider.box.x)
			local y_overlaps = (self.box.y < collider.box.y + collider.box.h) and (self.box.y + self.box.h > collider.box.y)
			
			return x_overlaps and y_overlaps
		end		
	end
end

return Collider
