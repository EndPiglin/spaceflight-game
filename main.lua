local Rocket = require("src.Class.Rocket")
local Planet = require("src.Class.Planet")
local Camera = require("src.libs.hump.camera")
local Debug = require("src.utils.Debug")

function love.load()
    rocket = Rocket(400, 100, 100, 50)
    planet = Planet(400, 300, 5000, 60, 200, 50)
    cam = Camera(rocket.pos.x, rocket.pos.y, 1)
end

function love.update(dt)
    if love.keyboard.isDown("a") then rocket:rotateLeft(dt) end
    if love.keyboard.isDown("d") then rocket:rotateRight(dt) end
    if love.keyboard.isDown("w") then rocket:applyThrust(dt)
    else rocket:cutThrust() end

    rocket:update(dt, {planet})

    local inAtmo = planet:isInAtmosphere(rocket.pos)
    local speed = 0.02

    if inAtmo then
        cam.scale = cam.scale + (1.5 - cam.scale) * speed
        cam.x = cam.x + (rocket.pos.x - cam.x) * speed
        cam.y = cam.y + (rocket.pos.y - cam.y) * speed
    else
        cam.scale = cam.scale + (0.25 - cam.scale) * speed
        cam.x = cam.x + (planet.pos.x - cam.x) * speed
        cam.y = cam.y + (planet.pos.y - cam.y) * speed
    end
end

function love.draw()
    cam:attach()
    planet:draw()
    rocket:draw()
    cam:detach()

    Debug.draw(rocket, planet)
end
