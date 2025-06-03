local s_font

local currentObject = 2.1
local maxObject = 4
local cazz = {}
function love.load()
   s_font = love.graphics.newFont("m6x11plus.ttf", 20)

love.graphics.setFont(s_font)
for i = 0, 9 do
    table.insert(cazz, {
         x = 50 + i * 60,
         y = 300,
         r = 20
   })
end
end


function love.draw()
   love.graphics.print("Current Object"..  currentObject ..  "/"  .. maxObject, 10, 35)
for _, c in ipairs(cazz) do
        love.graphics.circle("fill", c.x, c.y, c.r)
end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
   if currentObject < maxObject then
   currentObject = currentObject + 1
   end
end