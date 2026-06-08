local Class = require("src.libs.hump.class")
local vector = require("src.libs.hump.vector")

Rocket = Class{}

function Rocket:init(x, y, weight, thrustPower)
    self.pos = vector(x, y)
    self.velocity = vector(0, 0)
    self.weight = weight
    self.thrustPower = thrustPower or 100
    self.angle = 0
    self.rotSpeed = 2
    self.ignited = false
end

function Rocket:update(dt, planets)
    for _, p in ipairs(planets) do
        local accel, r = p:getGravityAt(self.pos)
        self.velocity = self.velocity + accel * dt

        if p:isInAtmosphere(self.pos) then
            local drag = p:getAtmDrag(self.pos, self.velocity)
            self.velocity = self.velocity + drag * dt
        end
    end

    self.pos = self.pos + self.velocity * dt

    for _, p in ipairs(planets) do
        local dir = self.pos - p.pos
        local r = dir:len()
        if r <= p.radius then
            local normal = dir:normalized()
            self.pos = p.pos + normal * p.radius
            local radial = self.velocity.x * normal.x + self.velocity.y * normal.y
            if radial < 0 then
                self.velocity = self.velocity - normal * radial
            end
        end
    end
end

function Rocket:applyThrust(dt)
    local dir = vector.fromPolar(self.angle - math.pi / 2, 1)
    self.velocity = self.velocity + dir * self.thrustPower * dt
    self.ignited = true
end

function Rocket:cutThrust()
    self.ignited = false
end

function Rocket:rotateLeft(dt)
    self.angle = self.angle - self.rotSpeed * dt
end

function Rocket:rotateRight(dt)
    self.angle = self.angle + self.rotSpeed * dt
end

-- Change later for modular parts, for now one part 
function Rocket:draw()
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("fill", -5, -35, 10, 70)
    love.graphics.pop()
end

return Rocket
