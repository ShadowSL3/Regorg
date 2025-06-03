local input = {}
local old = {}

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

return input
