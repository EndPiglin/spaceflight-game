local Class = require("src.libs.hump.class")
local vector = require("src.libs.hump.vector")

Planet = Class{}

function Planet:init(x, y, mass, radius, atmRadius, G)
    self.pos = vector(x, y)
    self.mass = mass
    self.radius = radius
    self.atmRadius = atmRadius or radius * 3
    self.G = G or 1000
    self.dragCoeff = 0.5
end

function Planet:getGravityAt(point)
    local dir = self.pos - point
    local r = dir:len()
    if r < self.radius then r = self.radius end
    return dir:normalized() * (self.G * self.mass / (r * r)), r
end

function Planet:isInAtmosphere(point)
    local r = (self.pos - point):len()
    return r < self.atmRadius and r > self.radius
end

function Planet:getAtmDrag(point, velocity)
    local r = (self.pos - point):len()
    local depth = 1 - (r - self.radius) / (self.atmRadius - self.radius)
    return velocity * (-self.dragCoeff * depth * depth)
end

function Planet:draw()
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
end

return Planet
