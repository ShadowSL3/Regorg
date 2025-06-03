dofile("engine/init.lua")

local x = 10
local selected = false

function love.load()
  -- load assets here
end

function love.update(dt)
  input.update()
  if input.pressed(pad.cross) then
    selected = not selected
  end
end

function love.draw()
  gfx.rect("fill", 0, 0, 480, 272, Color.new(0, 0, 0))
  ui.button(x, 50, 100, 30, "Start", selected)
  gfx.print("Mini PSP Engine", 10, 10)
end
