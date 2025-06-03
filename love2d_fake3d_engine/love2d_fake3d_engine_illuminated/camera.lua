local Camera = {}
Camera.__index = Camera

function Camera.new()
    return setmetatable({
        x = 0, y = 0, z = -5,
        rotY = 0,
        speed = 5,
        fov = math.rad(70)
    }, Camera)
end

function Camera:update(dt)
    local sp = self.speed * dt
    if love.keyboard.isDown("w") then self.z = self.z + sp end
    if love.keyboard.isDown("s") then self.z = self.z - sp end
    if love.keyboard.isDown("a") then self.x = self.x - sp end
    if love.keyboard.isDown("d") then self.x = self.x + sp end
    if love.keyboard.isDown("left") then self.rotY = self.rotY - dt * 1.5 end
    if love.keyboard.isDown("right") then self.rotY = self.rotY + dt * 1.5 end
end

return Camera
