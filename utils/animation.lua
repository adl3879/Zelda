local class = require "lib.middleclass"

local Animation = class("Animation")

function Animation:initialize(data, type)
	self.current_time = 0
	self.animation_states = data
	self.current_state = {}
	self.type = type or "sequence"

	for key, value in ipairs(self.animation_states) do
		if self.type == "sequence" then
			local quads = {}

			for y = 0, value.sprite:getHeight() - value.size.height, value.size.height do
				for x = 0, value.sprite:getWidth() - value.size.width, value.size.width do
					local quad = love.graphics.newQuad(x, y, value.size.width, value.size.height, value.sprite:getDimensions())
					table.insert(quads, quad)
				end
			end

			-- update animation state to include quads
			self.animation_states[key].quads = quads
		end
	end -- 0(n ^ 3) too bad
end

function Animation:play(name)
	self.current_state = self.animation_states[name]
end

function Animation:render(x, y, flip, center)
	local current_sprite = self.current_state.sprite

	if self.type == "sequence" then
		local sprite_num = math.floor(self.current_time / self.current_state.duration * #self.current_state.quads) + 1

		if flip then
			love.graphics.draw(current_sprite, self.current_state.quads[spriteNum], x, y, 0, -1, 1, self.current_state.width, 0)
		else
			love.graphics.draw(current_sprite, self.current_state.quads[spriteNum], x, y)
		end
	elseif self.type == "sprite" then
		local sprite_num = math.floor(self.current_time / self.current_state.duration * #self.current_state.sprites) + 1

		if flip then
			love.graphics.draw(self.current_state.sprites[sprite_num], x, y, 0, self.current_state.size[3], -self.current_state.size[4], self.current_state.size[1], 0)
		elseif center == "center" then
			love.graphics.draw(self.current_state.sprites[sprite_num], x, y, 0, self.current_state.size[3], self.current_state.size[4], self.current_state.size[1] / 2, self.current_state.size[2] / 2)
		else
			love.graphics.draw(self.current_state.sprites[sprite_num], x, y)
		end
	end
end

function Animation:update(dt)
	-- update current time wrt the delta time
	self.current_time = self.current_time + dt
	if self.current_time > self.current_state.duration then
		self.current_time = self.current_time - self.current_state.duration
	end
end

function Animation:get_size()
	if self.type == "sequence" then
		return self.current_state.width, self.current_state.height
	elseif self.type == "sprite" then
		return self.current_state.size[1], self.current_state.size[2]
	end
end

return Animation
