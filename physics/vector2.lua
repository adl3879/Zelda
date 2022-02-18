local Vector2 = {}
Vector2.__index = Vector2

-- directions
Vector2.UP    = -1
Vector2.DOWN  =  1
Vector2.LEFT  = -1
Vector2.RIGHT =  1

setmetatable(Vector2, {
	__call = function(_, x, y)
		return setmetatable({
			x = x or 0,
			y = y or 0,
		}, Vector2)
	end
})

-- Get vectortor length 
function Vector2:get_length() return math.sqrt(self.x * self.x + self.y * self.y) end

-- Add
function Vector2:__add(vector2) return Vector2(self.x + vector2.x, self.y + vector2.y) end

-- Subtract
function Vector2:__sub(vector2) return Vector2(self.x - vector2.x, self.y - vector2.y) end

-- Multiply two objects together
function Vector2:__mul(scale) return Vector2(self.x * scale, self.y * scale) end

-- Divide two objects
function Vector2:__div(scale) return Vector2(self.x / scale, self.y / scale) end

-- Normalize vectortor
function Vector2:normalize()
	local len = self:get_length()
	self.x = self.x / len
	self.y = self.y / len
	return self
end

-- Print
function Vector2:print()
	print("x: ", self.x)
	print("y: ", self.y)
end

return Vector2
