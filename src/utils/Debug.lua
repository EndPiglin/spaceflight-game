Debug = {}

function Debug.draw(rocket, planet)
    local speed = rocket.velocity:len()
    local inAtmo = planet:isInAtmosphere(rocket.pos)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format(
        "FPS: %d\nPos: %.1f, %.1f\nVel: %.1f, %.1f\nSpeed: %.1f\nAngle: %.0f°\n%s",
        love.timer.getFPS(),
        rocket.pos.x, rocket.pos.y,
        rocket.velocity.x, rocket.velocity.y,
        speed,
        math.deg(rocket.angle),
        inAtmo and "IN ATMOSPHERE" or "IN SPACE"
    ), 10, 10)
end

return Debug
