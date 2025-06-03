function love.load()
love.graphics.setBackgroundColor({1, 1, 1})
bg = love.graphics.newImage("dux.png")
end

function love.draw()
love.graphics.draw(bg, 0,0)
end