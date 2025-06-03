-- main.lua
function love.load()
    -- Inizializza il mazzo
    suits = {"cuori", "quadri", "fiori", "picche"}
    values = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
    deck = {}
    hand = {}
    score = 0

    -- Crea il mazzo
    for _, suit in ipairs(suits) do
        for _, value in ipairs(values) do
            table.insert(deck, {suit = suit, value = value})
        end
    end

    -- Mescola il mazzo
    shuffleDeck()
end

function shuffleDeck()
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function drawCard()
    if #deck > 0 then
        local card = table.remove(deck)
        table.insert(hand, card)
    end
end

-- Calcola il punteggio di una mano (corretto)
function calculateScore()
    score = 0 -- Resetta il punteggio

    if #hand == 0 then
        return -- Nessuna carta, punteggio resta 0
    end

    local counts = {}
    for _, card in ipairs(hand) do
        counts[card.value] = (counts[card.value] or 0) + 1
    end

    -- Controlla coppie, tris, ecc.
    local pairs = 0
    local tris = 0
    for _, count in pairs(counts) do
        if count == 2 then
            pairs = pairs + 1
        elseif count == 3 then
            tris = tris + 1
        end
    end

    -- Assegna il punteggio in base alla combinazione migliore
    if tris > 0 then
        score = 100 * tris -- Tris dà 100 punti
    elseif pairs > 0 then
        score = 50 * pairs -- Coppia dà 50 punti
    else
        score = 10 -- Mano base (es. carta alta)
    end
end

function love.update(dt)
    -- Logica di aggiornamento (es. animazioni)
end

function love.draw()
    -- Disegna la mano
    love.graphics.setColor(1, 1, 1)
    for i, card in ipairs(hand) do
        love.graphics.print(card.value .. " di " .. card.suit, 50, 50 + i * 20)
    end
    love.graphics.print("Punteggio: " .. score, 50, 200)
end

function love.keypressed(key)
    if key == "space" then
        drawCard() -- Pesca una carta
        calculateScore()
    elseif key == "r" then
        -- Resetta la mano
        hand = {}
        score = 0
        shuffleDeck()
    end
end