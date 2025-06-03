local gfx = {}

function gfx.draw(img, x, y)
  img:blit(x, y)
end

function gfx.rect(mode, x, y, w, h, color)
  color = color or Color.new(255, 255, 255)
  if mode == "fill" then
    screen:fillRect(x, y, w, h, color)
  end
end

function gfx.print(text, x, y, color)
  screen:print(x, y, text, color or Color.new(255,255,255))
end

return gfx
