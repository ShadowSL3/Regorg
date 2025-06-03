function love.load()
sound = love.audio.newSource("applause.wav", "stream")
love.audio.play(sound)
end