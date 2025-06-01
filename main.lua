local gfx = require("graphics.graphics")
local gp3 = require "audio.gp3"
function love.load()

    shader = gfx.newShader([[ 
       
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      return pixel * color;
    }
    ]])
end

function love.update(dt)

end


function love.draw()
    love.graphics.setShader(shader)
    gfx.rect(10, 0, 50, 10, 255, 0)
    love.graphics.setShader()
end