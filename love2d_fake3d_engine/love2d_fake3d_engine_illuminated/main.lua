local Camera = require("camera")
local Mesh = require("mesh")
local Skybox = require("skybox")

function love.load()
    love.window.setTitle("Fake 3D Engine (Illuminated)")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    camera = Camera.new()
    meshes = {
        Mesh.triangle3D(0, 0, 5, 1.5),
        Mesh.triangle3D(-1.5, 0, 8, 1),
        Mesh.triangle3D(1.5, 0, 10, 2)
    }
end

function love.update(dt)
    camera:update(dt)
end

function love.draw()
    Skybox.draw()
    for _, mesh in ipairs(meshes) do
        mesh:draw(camera)
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
end
