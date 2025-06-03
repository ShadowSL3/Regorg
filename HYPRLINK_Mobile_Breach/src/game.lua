local game = {}

function game.load()
    game.network = { status = "scanning..." }
end

function game.update(dt)
    -- Logica hacking
end

function game.draw()
    love.graphics.print("Stato: " .. game.network.status, 20, 60)
end

return game