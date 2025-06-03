local Skybox = {}

function Skybox.draw()
    love.graphics.setColor(0.1, 0.15, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
end

return Skybox
