local shader
local showHand = false

function love.load()
    love.window.setMode(800, 600)
    shader = love.graphics.newShader("shader_hand.glsl")
    shader:send("resolution", {800, 600})
end

function love.update(dt)
    shader:send("time", love.timer.getTime())
end

function love.touchpressed(id, x, y, dx, dy, pressure)
showHand = true
end
function love.touchreleased( id, x, y, dx, dy, pressure )
showHand = true 
end
function love.draw()
    if showHand then
        love.graphics.setShader(shader)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setShader()
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Premi 'M' per evocare la mano di luce", 10, 10)
end