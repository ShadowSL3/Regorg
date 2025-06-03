function love.load()
    clap = love.audio.newSource("Samples/clap-808.wav", "stream")
  myVoice = love.audio.newSource("hacked.mp3", "static")

end

function love.update(dt)
     myVoice:play()
     
end

function love.draw()
   love.graphics.print("FPS: " ..tostring(love.timer.getFPS( )), 13, 10)
end