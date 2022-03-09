local class = require "lib.middleclass"

local Collider = class("Collider")

colliders = {}

function Collider:initialize(class)
	self.class = class or ""
	self.type = ""
	self.box = { x = 0, y = 0, w = 0, h = 0 }
	self.circle = { x = 0, y = 0, r = 0 }
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

function Collider:new_circle_collider(x, y, r)
	self.type = "circle"
	self.circle = { x = x, y = y, r = r }
end

function Collider:set_circle_collider(x, y, r)
	self.circle.x = x
	self.circle.y = y
	self.circle.r = r or self.circle.r
end

function Collider:draw()
	local px, py
	
	if self.type == "box" then
		px = self.box.x - (self.box.w / 2)
		py = self.box.y - (self.box.h / 2)
		love.graphics.rectangle("line", px, py, self.box.w, self.box.h)
	elseif self.type == "circle" then
		px = self.circle.x + self.circle.r
		py = self.circle.y + self.circle.r
		love.graphics.circle("line", px, py, self.circle.r)
	end
end

function Collider:enter(class)
	for key, collider in pairs(colliders) do
		if collider.class == class then
			if self.type == "box" and collider.type == "box" then
				return self:check_box_collision(collider.box)
			elseif self.type == "circle" and collider.type == "box" then
				return self:check_circle_collision(collider.box)
			end
		end
	end
end

function Collider:check_box_collision(rect)
	local x_overlaps = (self.box.x < rect.x + rect.w) and (self.box.x + self.box.w > rect.x)
	local y_overlaps = (self.box.y < rect.y + rect.h) and (self.box.y + self.box.h > rect.y)

	return x_overlaps and y_overlaps
end

function Collider:check_circle_collision(rect)
	local circle_distance = {}
	circle_distance.x = math.abs(self.circle.x - rect.x)
	circle_distance.y = math.abs(self.circle.y - rect.y)

	if circle_distance.x > (rect.w / 2 + self.circle.r) then return false end
	if circle_distance.y > (rect.h / 2 + self.circle.r) then return false end

	if circle_distance.x <= (rect.w / 2) then return true end
	if circle_distance.y <= (rect.h / 2) then return true end

	local corner_distance_sq = ((circle_distance.x - rect.w / 2) ^ 2) + ((circle_distance.y - rect.h / 2) ^ 2)

	return corner_distance_sq <= (self.circle.r ^ 2)
end

return Collider
