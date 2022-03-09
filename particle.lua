local class = require "lib.middleclass"

local Particle = class("Particle")

function Particle:initialize(frames, x, y)
	self.frames = frames
	self.frame_index = 0 
	self.animation_speed = 0.15
	self.position = { x = x, y = y }
end

local ParticleEffect = class("ParticleEffect")

ParticleEffect.static.FRAMES = {
	-- magic
	["flame"] = import_folder("res/gfx/particles/flame/frames"),
	["aura"] = import_folder("res/gfx/particles/aura"),
	["heal"] = import_folder("res/gfx/particles/heal/frames"),

	-- attacks
	["claw"] = import_folder("res/gfx/particles/claw"),
	["sparkle"] = import_folder("res/gfx/particles/sparkle"),
	["slash"] = import_folder("res/gfx/particles/slash"),
	["leaf_attack"] = import_folder("res/gfx/particles/leaf_attack"),
	["thunder"] = import_folder("res/gfx/particles/thunder"),

	-- monster deaths
	["squid"] = import_folder("res/gfx/particles/smoke_orange"),
	["racoon"] = import_folder("res/gfx/particles/raccoon"),
	["spirit"] = import_folder("res/gfx/particles/nova"),
	["bamboo"] = import_folder("res/gfx/particles/bamboo"),

	-- leafs
	["leaf"] = {
		import_folder("res/gfx/particles/leaf1"),
		import_folder("res/gfx/particles/leaf2"),
		import_folder("res/gfx/particles/leaf3"),
		import_folder("res/gfx/particles/leaf4"),
		import_folder("res/gfx/particles/leaf5"),
		import_folder("res/gfx/particles/leaf6"),
	}
}

function ParticleEffect:initialize()
	self.particles = {}
end

function ParticleEffect:update(dt)
	if #self.particles > 0 then
		for i, p in ipairs(self.particles) do
			p.frame_index = math.floor(p.frame_index + p.animation_speed) + 1
			if p.frame_index > #p.frames then
				-- remove particle
				table.remove(self.particles, i)
			end
		end
	end
end

function ParticleEffect:draw()
	if #self.particles > 0 then
		for i, p in ipairs(self.particles) do
			if p.frames[p.frame_index] ~= nil then
				love.graphics.draw(p.frames[p.frame_index], p.position.x, p.position.y)
			end
		end
	end
end

function ParticleEffect:create(name, x, y)
	local frames
	if name == "leaf" then
		frames = ParticleEffect.FRAMES["leaf"][math.random(#ParticleEffect.FRAMES["leaf"])]	
	else
		frames = ParticleEffect.FRAMES[name]
	end
	table.insert(self.particles, Particle:new(frames, x, y))
end

function ParticleEffect.__string()
	return "Singleton Class of ParticleEffect"
end

local ParticleEffectInstance = ParticleEffect:new()
return ParticleEffectInstance
