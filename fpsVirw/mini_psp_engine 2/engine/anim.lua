local anim = {}
anim.__index = anim

function anim.new(img, fw, fh, speed)
  local a = {
    image = img,
    frameW = fw,
    frameH = fh,
    speed = speed or 0.1,
    timer = 0,
    current = 1,
    frames = math.floor(img:width() / fw),
  }
  setmetatable(a, anim)
  return a
end

function anim:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.speed then
    self.current = (self.current % self.frames) + 1
    self.timer = 0
  end
end

function anim:draw(x, y)
  local sx = (self.current - 1) * self.frameW
  screen:blit(x, y, self.image, sx, 0, self.frameW, self.frameH)
end

return anim
