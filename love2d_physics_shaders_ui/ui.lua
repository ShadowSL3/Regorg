-- Advanced UI system inspired by Balatro
local ui = {}

-- UI Constants
ui.FONTS = {
    small = nil,
    medium = nil,
    large = nil,
    title = nil
}

ui.COLORS = {
    background = {0.08, 0.05, 0.12, 1.0},
    panel = {0.12, 0.08, 0.18, 0.95},
    highlight = {0.9, 0.4, 0.1, 1.0},
    text = {0.95, 0.95, 0.95, 1.0},
    text_dim = {0.7, 0.7, 0.7, 1.0},
    text_highlight = {1.0, 0.8, 0.3, 1.0},
    selection = {0.3, 0.6, 1.0, 0.8}
}

-- Menu system
ui.menus = {
    current = "main",
    main = {
        title = "MAIN MENU",
        items = {
            {text = "PLAY", action = function() ui.setCurrentMenu("play") end},
            {text = "OPTIONS", action = function() ui.setCurrentMenu("options") end},
            {text = "QUIT", action = function() love.event.quit() end}
        }
    },
    play = {
        title = "PLAY",
        items = {
            {text = "START GAME", action = function() ui.inGame = true; ui.closeMenus() end},
            {text = "BACK", action = function() ui.setCurrentMenu("main") end}
        }
    },
    options = {
        title = "OPTIONS",
        items = {
            {text = "GAME", action = function() ui.setCurrentMenu("game_options") end},
            {text = "GRAPHICS", action = function() ui.setCurrentMenu("graphics_options") end},
            {text = "BACK", action = function() ui.setCurrentMenu("main") end}
        }
    },
    game_options = {
        title = "GAME OPTIONS",
        items = {
            {text = "PHYSICS COUNT", value = "20", increment = function() 
                PHYSICS_COUNT = math.min(200, PHYSICS_COUNT + 10)
                ui.menus.game_options.items[1].value = tostring(PHYSICS_COUNT)
                resetPhysics()
            end, decrement = function() 
                PHYSICS_COUNT = math.max(10, PHYSICS_COUNT - 10)
                ui.menus.game_options.items[1].value = tostring(PHYSICS_COUNT)
                resetPhysics()
            end},
            {text = "GRAVITY", value = "800", increment = function() 
                gravity = math.min(2000, gravity + 100)
                ui.menus.game_options.items[2].value = tostring(gravity)
            end, decrement = function() 
                gravity = math.max(100, gravity - 100)
                ui.menus.game_options.items[2].value = tostring(gravity)
            end},
            {text = "BACK", action = function() ui.setCurrentMenu("options") end}
        }
    },
    graphics_options = {
        title = "GRAPHICS OPTIONS",
        items = {
            {text = "GRAPHICS PRESET", value = "HIGH", 
             toggle = function() 
                local presets = {"LOW", "MEDIUM", "HIGH", "ULTRA"}
                local current
                for i, preset in ipairs(presets) do
                    if preset == ui.menus.graphics_options.items[1].value then
                        current = i
                        break
                    end
                end
                current = current % #presets + 1
                ui.menus.graphics_options.items[1].value = presets[current]
                applyGraphicsPreset(presets[current])
             end},
            {text = "VOLUMETRIC FOG", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[2].value
                ui.menus.graphics_options.items[2].value = current == "ON" and "OFF" or "ON"
                toggleShader("fog", ui.menus.graphics_options.items[2].value == "ON")
            end},
            {text = "GOD RAYS", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[3].value
                ui.menus.graphics_options.items[3].value = current == "ON" and "OFF" or "ON"
                toggleShader("godrays", ui.menus.graphics_options.items[3].value == "ON")
            end},
            {text = "BLOOM", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[4].value
                ui.menus.graphics_options.items[4].value = current == "ON" and "OFF" or "ON" 
                toggleShader("bloom", ui.menus.graphics_options.items[4].value == "ON")
            end},
            {text = "CHROMATIC ABERRATION", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[5].value
                ui.menus.graphics_options.items[5].value = current == "ON" and "OFF" or "ON"
                toggleShader("chromatic", ui.menus.graphics_options.items[5].value == "ON")
            end},
            {text = "NOISE", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[6].value
                ui.menus.graphics_options.items[6].value = current == "ON" and "OFF" or "ON"
                toggleShader("noise", ui.menus.graphics_options.items[6].value == "ON")
            end},
            {text = "SHOW BUFFERS", value = "OFF", toggle = function() 
                local current = ui.menus.graphics_options.items[7].value
                ui.menus.graphics_options.items[7].value = current == "ON" and "OFF" or "ON"
                SHOW_BUFFERS = ui.menus.graphics_options.items[7].value == "ON"
            end},
            {text = "MOTION BLUR", value = "ON", toggle = function() 
                local current = ui.menus.graphics_options.items[8].value
                ui.menus.graphics_options.items[8].value = current == "ON" and "OFF" or "ON"
                toggleShader("motionblur", ui.menus.graphics_options.items[8].value == "ON")
            end},
            {text = "BACK", action = function() ui.setCurrentMenu("options") end}
        }
    },
    pause = {
        title = "PAUSED",
        items = {
            {text = "RESUME", action = function() ui.closeMenus() end},
            {text = "OPTIONS", action = function() ui.setCurrentMenu("options") end},
            {text = "QUIT TO MENU", action = function() ui.inGame = false; ui.setCurrentMenu("main") end}
        }
    }
}

-- UI State
ui.selectedItem = 1
ui.menuOpen = true
ui.inGame = false
ui.menuScale = 1
ui.time = 0
ui.shakeAmount = 0

-- Core UI Functions
function ui.setCurrentMenu(menu)
    ui.menus.current = menu
    ui.selectedItem = 1
    ui.shakeAmount = 0.5 -- Menu transition effect
    love.audio.play(ui.sounds.menuChange)
end

function ui.closeMenus()
    ui.menuOpen = false
    love.audio.play(ui.sounds.menuClose)
end

function ui.openMenu(menu)
    ui.menuOpen = true
    if menu then
        ui.setCurrentMenu(menu)
    end
    love.audio.play(ui.sounds.menuOpen)
end

function ui.toggleMenu()
    if ui.menuOpen then
        ui.closeMenus()
    else
        if ui.inGame then
            ui.openMenu("pause")
        else
            ui.openMenu("main")
        end
    end
end

function ui.update(dt)
    ui.time = ui.time + dt
    ui.shakeAmount = math.max(0, ui.shakeAmount - dt * 2)
end

function ui.drawItem(item, x, y, selected, width, height)
    local currentMenu = ui.menus[ui.menus.current]
    local shake = selected and ui.shakeAmount * 5 or 0
    local wobble = selected and math.sin(ui.time * 8) * 3 or 0
    local scale = selected and 1.1 or 1.0
    
    -- Background
    if selected then
        love.graphics.setColor(ui.COLORS.selection)
        love.graphics.rectangle("fill", x - width/2 - 10 + math.random(-shake, shake), 
                                         y - height/2 + math.random(-shake, shake), 
                                         width + 20, height + 10, 5, 5)
    end
    
    -- Text
    love.graphics.setFont(ui.FONTS.medium)
    if selected then
        love.graphics.setColor(ui.COLORS.text_highlight)
    else
        love.graphics.setColor(ui.COLORS.text)
    end
    
    -- Draw item text with custom positioning
    love.graphics.printf(item.text, x - width/2 + wobble, y - height/2, width, "left")
    
    -- For options with values
    if item.value then
        love.graphics.setColor(selected and ui.COLORS.text_highlight or ui.COLORS.text_dim)
        love.graphics.printf(item.value, x - width/2, y - height/2, width, "right")
    end
end

function ui.draw()
    if not ui.menuOpen and not ui.inGame then
        ui.openMenu("main")
    end
    
    if ui.menuOpen then
        -- Draw menu background
        love.graphics.setColor(ui.COLORS.background)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        local currentMenu = ui.menus[ui.menus.current]
        local centerX = love.graphics.getWidth() / 2
        local centerY = love.graphics.getHeight() / 2
        local itemHeight = 50
        local menuWidth = 400
        local totalHeight = #currentMenu.items * itemHeight
        local startY = centerY - totalHeight / 2 + 40
        
        -- Draw title with effects
        love.graphics.setFont(ui.FONTS.title)
        love.graphics.setColor(ui.COLORS.highlight)
        local titleWidth = ui.FONTS.title:getWidth(currentMenu.title)
        local titleScale = 1 + math.sin(ui.time * 2) * 0.05
        love.graphics.push()
        love.graphics.translate(centerX, startY - 80)
        love.graphics.scale(titleScale, titleScale)
        love.graphics.print(currentMenu.title, -titleWidth/2, 0)
        love.graphics.pop()
        
        -- Draw menu items
        for i, item in ipairs(currentMenu.items) do
            local y = startY + (i-1) * itemHeight
            local selected = (i == ui.selectedItem)
            ui.drawItem(item, centerX, y, selected, menuWidth, 40)
        end
        
        -- Draw decorative elements (Balatro style stars/diamonds)
        ui.drawDecorations()
    elseif ui.inGame then
        -- In-game UI
        ui.drawInGameUI()
    end
end

function ui.drawDecorations()
    love.graphics.setColor(ui.COLORS.highlight[1], ui.COLORS.highlight[2], ui.COLORS.highlight[3], 0.3)
    local w, h = love.graphics.getDimensions()
    
    -- Draw card suit symbols or stars in corners
    for i = 1, 20 do
        local x = math.sin(ui.time * 0.5 + i * 0.7) * w * 0.4 + w * 0.5
        local y = math.cos(ui.time * 0.7 + i * 0.5) * h * 0.4 + h * 0.5
        local size = 10 + math.sin(ui.time + i) * 5
        ui.drawStar(x, y, size)
    end
end

function ui.drawStar(x, y, size)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(ui.time * 0.2)
    
    local points = {}
    for i = 1, 5 do
        local angle = (i * 2 - 1) * math.pi / 5 - math.pi / 2
        table.insert(points, math.cos(angle) * size)
        table.insert(points, math.sin(angle) * size)
        
        local smallAngle = (i * 2) * math.pi / 5 - math.pi / 2
        table.insert(points, math.cos(smallAngle) * size * 0.4)
        table.insert(points, math.sin(smallAngle) * size * 0.4)
    end
    
    love.graphics.polygon("fill", points)
    love.graphics.pop()
end

function ui.drawInGameUI()
    -- Top info panel
    love.graphics.setColor(ui.COLORS.panel)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 40)
    
    -- Display current status
    love.graphics.setFont(ui.FONTS.medium)
    love.graphics.setColor(ui.COLORS.text)
    
    local statusText = slowMotion and "SLOW MOTION" or "NORMAL SPEED"
    love.graphics.print(statusText, 20, 10)
    
    -- Display FPS
    local fps = tostring(love.timer.getFPS())
    local fpsWidth = ui.FONTS.medium:getWidth(fps)
    love.graphics.print("FPS: " .. fps, love.graphics.getWidth() - fpsWidth - 20, 10)
    
    -- Controls help at bottom
    love.graphics.setColor(ui.COLORS.panel)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 30, love.graphics.getWidth(), 30)
    
    love.graphics.setFont(ui.FONTS.small)
    love.graphics.setColor(ui.COLORS.text_dim)
    love.graphics.print("ESC: Menu | I: Slow Motion | SPACE: Reset", 20, love.graphics.getHeight() - 25)
end

function ui.keypressed(key)
    if key == "escape" then
        ui.toggleMenu()
        return true
    end
    
    if ui.menuOpen then
        local currentMenu = ui.menus[ui.menus.current]
        
        if key == "up" or key == "w" then
            ui.selectedItem = ((ui.selectedItem - 2) % #currentMenu.items) + 1
            love.audio.play(ui.sounds.menuMove)
            return true
        elseif key == "down" or key == "s" then
            ui.selectedItem = (ui.selectedItem % #currentMenu.items) + 1
            love.audio.play(ui.sounds.menuMove)
            return true
        elseif key == "return" or key == "space" then
            local item = currentMenu.items[ui.selectedItem]
            if item.action then
                item.action()
                love.audio.play(ui.sounds.menuSelect)
            elseif item.toggle then
                item.toggle()
                love.audio.play(ui.sounds.menuToggle)
            end
            return true
        elseif key == "left" or key == "a" then
            local item = currentMenu.items[ui.selectedItem]
            if item.decrement then
                item.decrement()
                love.audio.play(ui.sounds.menuAdjust)
            elseif item.toggle then
                item.toggle()
                love.audio.play(ui.sounds.menuToggle)
            end
            return true
        elseif key == "right" or key == "d" then
            local item = currentMenu.items[ui.selectedItem]
            if item.increment then
                item.increment()
                love.audio.play(ui.sounds.menuAdjust)
            elseif item.toggle then
                item.toggle()
                love.audio.play(ui.sounds.menuToggle)
            end
            return true
        end
    end
    
    return false
end

function setupUI()
    -- Initialize variables
    PHYSICS_COUNT = 20
    SHOW_BUFFERS = false
    
    -- Load fonts (with fallbacks)
    local function loadFont(size)
        local success, font = pcall(love.graphics.newFont, "fonts/RubikMono-Bold.ttf", size)
        if success then return font end
        success, font = pcall(love.graphics.newFont, "fonts/DejaVuSansMono-Bold.ttf", size)
        if success then return font end
        return love.graphics.newFont(size)
    end
    
    ui.FONTS.small = loadFont(14)
    ui.FONTS.medium = loadFont(20)
    ui.FONTS.large = loadFont(30)
    ui.FONTS.title = loadFont(48)
    
    -- Set default font
    love.graphics.setFont(ui.FONTS.medium)
    
    -- Load sound effects
    ui.sounds = {
        menuMove = love.audio.newSource("sounds/menu_move.wav", "static") or {},
        menuSelect = love.audio.newSource("sounds/menu_select.wav", "static") or {},
        menuToggle = love.audio.newSource("sounds/menu_toggle.wav", "static") or {},
        menuOpen = love.audio.newSource("sounds/menu_open.wav", "static") or {},
        menuClose = love.audio.newSource("sounds/menu_close.wav", "static") or {},
        menuChange = love.audio.newSource("sounds/menu_change.wav", "static") or {}
    }
    
    -- Handle missing sound files
    for name, source in pairs(ui.sounds) do
        if not source.play then
            ui.sounds[name] = {
                play = function() end
            }
        end
    end
    
    -- Apply default graphics preset
    applyGraphicsPreset("HIGH")
end

function applyGraphicsPreset(preset)
    if preset == "LOW" then
        toggleShader("fog", false)
        toggleShader("godrays", false)
        toggleShader("bloom", false)
        toggleShader("chromatic", false)
        toggleShader("noise", false)
        toggleShader("motionblur", false)
        
        ui.menus.graphics_options.items[2].value = "OFF"
        ui.menus.graphics_options.items[3].value = "OFF"
        ui.menus.graphics_options.items[4].value = "OFF"
        ui.menus.graphics_options.items[5].value = "OFF"
        ui.menus.graphics_options.items[6].value = "OFF"
        ui.menus.graphics_options.items[8].value = "OFF"
    elseif preset == "MEDIUM" then
        toggleShader("fog", true)
        toggleShader("godrays", true)
        toggleShader("bloom", false)
        toggleShader("chromatic", false)
        toggleShader("noise", false)
        toggleShader("motionblur", false)
        
        ui.menus.graphics_options.items[2].value = "ON"
        ui.menus.graphics_options.items[3].value = "ON"
        ui.menus.graphics_options.items[4].value = "OFF"
        ui.menus.graphics_options.items[5].value = "OFF"
        ui.menus.graphics_options.items[6].value = "OFF"
        ui.menus.graphics_options.items[8].value = "OFF"
    elseif preset == "HIGH" then
        toggleShader("fog", true)
        toggleShader("godrays", true)
        toggleShader("bloom", true)
        toggleShader("chromatic", true)
        toggleShader("noise", false)
        toggleShader("motionblur", false)
        
        ui.menus.graphics_options.items[2].value = "ON"
        ui.menus.graphics_options.items[3].value = "ON"
        ui.menus.graphics_options.items[4].value = "ON"
        ui.menus.graphics_options.items[5].value = "ON"
        ui.menus.graphics_options.items[6].value = "OFF"
        ui.menus.graphics_options.items[8].value = "OFF"
    elseif preset == "ULTRA" then
        toggleShader("fog", true)
        toggleShader("godrays", true)
        toggleShader("bloom", true)
        toggleShader("chromatic", true)
        toggleShader("noise", true)
        toggleShader("motionblur", true)
        
        ui.menus.graphics_options.items[2].value = "ON"
        ui.menus.graphics_options.items[3].value = "ON"
        ui.menus.graphics_options.items[4].value = "ON"
        ui.menus.graphics_options.items[5].value = "ON"
        ui.menus.graphics_options.items[6].value = "ON"
        ui.menus.graphics_options.items[8].value = "ON"
    end
end

return ui