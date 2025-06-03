local input = {}
local old = {}
local isPSP = type(Controls) ~= "nil"

if not isPSP then
  love.keyboard.keysPressed = {}

  function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
  end

  function input.update()
    old = input.current or {}
    input.current = love.keyboard.keysPressed
    love.keyboard.keysPressed = {}
  end

  function input.pressed(btn)
    return input.current and input.current[btn]
  end

  function input.down(btn)
    return love.keyboard.isDown(btn)
  end
else
  function input.update()
    old = pad or Controls.read()
    pad = Controls.read()
  end

  function input.pressed(btn)
    return pad:pressed(btn) and not old:pressed(btn)
  end

  function input.down(btn)
    return pad:pressed(btn)
  end
end

return input
