local ui = {}

function ui.button(x, y, w, h, text, selected)
  screen:fillRect(x, y, w, h, selected and Color.new(255,255,0) or Color.new(80,80,80))
  screen:print(x+4, y+4, text, Color.new(255,255,255))
end

return ui
