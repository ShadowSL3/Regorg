local shader, time = nil, 0

function love.load()
    local path = "fx/fire_shader.glsl"
    shader = love.graphics.newShader(path)
end

local fx = {}

function fx.load() time = 0 end

function fx.update(dt) time = time + dt end

function fx.apply(callback)
    shader:send("u_time", time)
    love.graphics.setShader(shader)
    callback()
    love.graphics.setShader()
end

return fx