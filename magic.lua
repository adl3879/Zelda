local class = require "lib.middleclass"
require "utils/settings"

local Magic = class("Magic")

Magic.static.SPRITES = {}

function Magic:initialize()
	for key, value in pairs(magic_data) do
		Magic.SPRITES[key] = love.graphics.newImage(value["graphic"])
	end
end

function Magic:render()
	
end

return Magic
