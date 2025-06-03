local love = require "love"
local player_height = 30

local function player()

    local x_position = love.graphics.getWidth() / 2
    local y_position = love.graphics.getHeight() / 2
    local player_speed = 250
    local player_points = 0
    local player_length = 30
    local current_direction = "empty"
    local bodies = {}
    local head = {
        x = x_position, y = y_position
    }
    local directions = {
        "right",
        "left",
        "up",
        "down",
    }
    math.randomseed(os.time())

    local getDirection = function ()
        current_direction = directions[math.random(1, #directions)]
    end

    local checkCollision = function (bodyPart, headPart)
        return headPart.x == bodyPart.x and headPart.y == bodyPart.y
    end


    -- Block the player from getting out of the screen
    local screenSpace = function ()
        if head.x > love.graphics.getWidth() then
           head.x = 0
           current_direction = "right"
        elseif head.x < 0 then
            head.x = love.graphics.getWidth()
            current_direction = "left"
        end
        
        if head.y > love.graphics.getHeight() then
            head.y = 0
            current_direction = "down"
        elseif head.y < 0 then
            head.y = love.graphics.getHeight()
            current_direction = "up"
        end
    end

    -- Handle player input movement
    local handleInput = function ()

        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            current_direction = "up"
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            current_direction = "down"
        elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            current_direction = "left"
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            current_direction = "right"
        end
    end

    local c = function()
        for i = 2, #bodies, 1 do
            if checkCollision(bodies[i], head) then
                print("====================================================")
                print("body part hit: " .. i)
                print("head coord: " .. head.x .. "::" .. head.y)
                print("body coord: " .. bodies[i].x .. "::" .. bodies[i].y)
                print("====================================================")
            else
                print("====================================================")
                print("head coord: " .. head.x .. "::" .. head.y)
                print("body coord: " .. bodies[i].x .. "::" .. bodies[i].y)
                print("====================================================")
            end
        end
    end

    local movement  = function(dt)
        
        handleInput()
        screenSpace()

        for i = #bodies, 1, -1 do
            if i == 1 then
                bodies[i].x = head.x
                bodies[i].y = head.y
            else
                local previewSnake = bodies[i - 1]
                bodies[i].x = previewSnake.x
                bodies[i].y = previewSnake.y
            end
        end

        if current_direction == "up" then
            head.y = head.y - player_speed * dt
        elseif current_direction == "down" then
            head.y = head.y + player_speed * dt
        elseif current_direction == "left" then
            head.x = head.x - player_speed * dt
        elseif current_direction == "right" then
            head.x = head.x + player_speed * dt
        end

    end

    -- Draw the player on the screen
    local display_player = function()
        -- Draw the player's head
        love.graphics.setColor{0, 0.9, 1}
        love.graphics.rectangle("fill", head.x, head.y, 30, 30)

        -- Draw the player's body
        love.graphics.setColor{0.7, 0.35, 0.4, 1.0}
        for i, body in ipairs(bodies) do
            if #bodies > 0 then
                love.graphics.rectangle("fill", bodies[i].x, bodies[i].y, 30, 30)
            end
        end
    end


    local function increasePlayerLength(amount)
        local lastBody = bodies[#bodies]
        for _ = 1, amount do
            table.insert(bodies, { x = lastBody.x, y = lastBody.y})
        end
    end
    
    local function updatePoints(points)
        player_points = points
        increasePlayerLength(player_points)
    end
    
    local function eat(objectFood)
        local foodX, foodY = objectFood.getCoords()
        local foodRadius = 16
    
        --[[
        if head.x == foodX and head.y == foodY then
            table.insert(bodies, { x = foodX, y = foodY })
            objectFood.invertExist()
            print("Chomp")
        end]]--

        
        if head.x < foodX + foodRadius and
           head.x + player_length > foodX - foodRadius and
           head.y < foodY + foodRadius and
           head.y + player_height > foodY - foodRadius then
            --updatePoints(objectFood.getPoints())
            table.insert(bodies, { x = foodX, y = foodY })
            objectFood.invertExist()
            print("Chomp")
        end
    end    

    local restart = function()
        x_position = love.graphics.getWidth() / 2
        y_position = love.graphics.getHeight() / 2
        player_points = 0
        current_direction = "right"
        bodies = {}
        table.insert(bodies, { x = x_position, y = y_position })
        getDirection()
    end

    getDirection()

    return {
        movement = movement,
        display_player = display_player,
        updatePoints = updatePoints,
        restart = restart,
        eat = eat,
        c = c,
    }
    
end

return player
