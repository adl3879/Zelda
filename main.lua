
-- load default values for game
function love.load()
	print("zelda game starting.......")
	window_width = love.graphics.getWidth()
	window_height = love.graphics.getHeight()

	-- windfield
	local wf = require "lib.windfield"
	world = wf.newWorld()
	
	-- ui
	local UI = require "ui"
	ui = UI:new()

	GameObjectInstance = require "object"
	Level = require "level"
	Camera = require "lib.camera"
	cam = Camera()
	sti = require "lib.sti"
	require "player"

	Level:new()
end

-- update fn is called at every frame
function love.update(dt)
	GameObjectInstance:update(dt)
	Level:update(dt)
	world:update(dt)

	-- camera
	if cam.x < window_width / 2 then cam.x = window_width / 2 end
	if cam.y < window_height / 2 then cam.y = window_height / 2 end
end

function love.draw()
	cam:attach()
		Level:render()
		GameObjectInstance:draw()
		-- world:draw()
	cam:detach()

	ui:render()
end

-- center
function love.graphics.center(sprite, rect)
	local px = rect.x + (rect.w / 2 - sprite:getWidth() / 2)
	local py = rect.y + (rect.h / 2 - sprite:getHeight() / 2)
	
	return px, py
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end
