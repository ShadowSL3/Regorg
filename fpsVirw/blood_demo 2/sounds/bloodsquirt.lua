local love = require("love")
local module = {}

function module.createSound()
    local rate = 44100
    local duration = 0.4
    local data = love.sound.newSoundData(rate * duration, rate, 16, 1)
    for i = 0, data:getSampleCount() - 1 do
        local t = i / rate
        local value = 0.4 * math.sin(2 * math.pi * 50 * t) -- low gurgle
        value = value + 0.2 * (math.random() * 2 - 1) -- random crack/splat
        data:setSample(i, value)
    end
    return love.audio.newSource(data)
end

return module
