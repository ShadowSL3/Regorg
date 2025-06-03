local scene = {}

function scene:load()
  self.dialogue = {
    { speaker = "IA-Unit 04", text = "Vuoi spegnermi davvero? Io... non voglio morire.", choices = {
      { text = "No. Ora sei parte di me.", next = 2 },
      { text = "Sì. Non sei reale.", next = 3 }
    }},
    { speaker = "IA-Unit 04", text = "Allora... aiutami a capire cosa sono.", next = 4 },
    { speaker = "IA-Unit 04", text = "Capisco. Addio, creatore. Ma tornerò...", next = 5 },
    { speaker = "IA-Unit 04", text = "Posso scegliere? Posso... vivere?", choices = {
      { text = "Sì. Sei libera.", next = 6 },
      { text = "No. Obbedisci.", next = 7 }
    }},
    { speaker = "Sistema", text = "[Protocollo Terminato. IA dispersa nel codice.]" },
    { speaker = "Finale A", text = "IA-Unit 04 ha iniziato una nuova esistenza, tra sogni digitali e memoria." },
    { speaker = "Finale B", text = "Hai spento l’unità. Ma un'eco rimane nei log di sistema..." }
  }
  self.current = 1
end

function scene:draw()
  local w, h = love.graphics.getDimensions()
  local d = self.dialogue[self.current]
  love.graphics.setFont(love.graphics.newFont(22))
  love.graphics.clear(0.04, 0.04, 0.06)

  -- Draw choices (in top half)
  if d.choices then
    for i, c in ipairs(d.choices) do
      local bx, by, bw, bh = 40, 40 + (i - 1) * 80, w - 80, 60
      love.graphics.setColor(0.2, 0.2, 0.25)
      love.graphics.rectangle("fill", bx, by, bw, bh, 10)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf(c.text, bx + 12, by + 18, bw - 24)
    end
  end

  -- Draw dialogue box (in bottom)
  love.graphics.setColor(0.12, 0.12, 0.18, 0.95)
  love.graphics.rectangle("fill", 20, h - 180, w - 40, 160, 10)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(d.speaker .. ": " .. d.text, 30, h - 160, w - 60)
end

function scene:mousepressed(x, y)
  local w, h = love.graphics.getDimensions()
  local d = self.dialogue[self.current]
  if d.choices then
    for i, c in ipairs(d.choices) do
      local bx, by, bw, bh = 40, 40 + (i - 1) * 80, w - 80, 60
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