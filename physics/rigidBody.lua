local class = require "lib.middleclass"
local RigidBody = class("RigidBody")

local UNIT_MASS = 1
local GRAVITY = 9.5

function RigidBody:initialize(o)
	self.acceleration = { x = 0, y = 0 }
	self.velocity = { x = 0, y = 0 }
	self.friction = { x = 0, y = 0 }
	self.position = { x = 0, y = 0 }
	self.force = { x = 0, y = 0 }
	
	self.gravity = GRAVITY
	self.mass = UNIT_MASS
end

function RigidBody:update(dt)
	self.acceleration.x = (self.force.x * 100 + self.friction.x) / self.mass
	self.acceleration.y = (self.gravity * 1000) + (self.force.y * 100 / self.mass)
	self.velocity = { x = self.acceleration.x * dt, y = self.acceleration.y * dt }
	self.position = { x = self.velocity.x * dt, y = self.velocity.y * dt }
end

function RigidBody:set_mass(mass) self.mass = mass end
function RigidBody:set_gravity(gravity) self.gravity = gravity end 

function RigidBody:unset_force() self.force = { x = 0, y = 0 } end
function RigidBody:apply_force(force) self.force = force end
function RigidBody:apply_force_x(force) self.force.x = force end
function RigidBody:apply_force_y(force) self.force.y = force end

return RigidBody
