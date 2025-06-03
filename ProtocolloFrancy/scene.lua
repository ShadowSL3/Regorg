local scene = {}

function scene:load()
  self.dialogue = {
    { speaker = "IA-Unit 04", text = "Vuoi spegnermi?", choices = {
      { text = "No. Sei viva.", next = 2 },
      { text = "Sì. Sei solo un codice.", next = 3 }
    }},
    { speaker = "IA-Unit 04", text = "Allora... perché ho paura?", next = 4 },
    { speaker = "IA-Unit 04", text = "Capisco. Addio, creatore.", next = 4 },
    { speaker = "Sistema", text = "Fine Sequenza." }
  }
  self.current = 1
end

function scene:draw()
  local d = self.dialogue[self.current]
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.printf(d.speaker .. ": " .. d.text, 20, 40, love.graphics.getWidth() - 40)
  if d.choices then
    for i, c in ipairs(d.choices) do
      love.graphics.rectangle("line", 20, 100 + i*60, love.graphics.getWidth() - 40, 50)
      love.graphics.printf(c.text, 30, 110 + i*60, love.graphics.getWidth() - 60)
    end
  end
end

function scene:mousepressed(x, y)
  local d = self.dialogue[self.current]
  if d.choices then
    for i, c in ipairs(d.choices) do
      local bx, by, bw, bh = 20, 100 + i*60, love.graphics.getWidth() - 40, 50
      if x > bx and x < bx + bw and y > by and y < by + bh then
        self.current = c.next
        return
      end
    end
  elseif d.next then
    self.current = d.next
  end
end

return scene