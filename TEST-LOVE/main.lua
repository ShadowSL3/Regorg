local timeLeft = 5 -- secondi
local showFinalCountdown = false
local bigNumber = 0
local countdownScale = 1

function love.update(dt)
    timeLeft = timeLeft - dt

    if timeLeft <= 10 and not showFinalCountdown then
        showFinalCountdown = true
    end

    if showFinalCountdown then
        bigNumber = math.ceil(timeLeft)
        countdownScale = 1.5 + 0.5 * math.sin(love.timer.getTime() * 8)
    end
end

function love.draw()
    if showFinalCountdown and bigNumber > 0 then
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.setFont(love.graphics.newFont(96))
        love.graphics.printf(
            tostring(bigNumber),
            0, love.graphics.getHeight()/2 - 48,
            love.graphics.getWidth(),
            "center",
            0,
            countdownScale, countdownScale
        )
    end
end