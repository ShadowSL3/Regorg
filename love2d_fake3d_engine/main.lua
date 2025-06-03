local Camera = require("camera")
local Mesh = require("mesh")

function love.load()
    love.window.setTitle("Fake 3D Engine (LÖVE)")
    love.window.setMode(800, 600, {resizable=false})
    love.graphics.setBackgroundColor(0.05, 0.05, 0.08)

    camera = Camera.new()
    meshes = {
        Mesh.cube(0, 0, 5, 1),
        Mesh.cube(2, 0, 8, 1.5),
        Mesh.cube(-2, 0, 10, 0.5)
    }
end

function love.update(dt)
    camera:update(dt)
end

function love.draw()
    for _, mesh in ipairs(meshes) do
        mesh:draw(camera)
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
end
