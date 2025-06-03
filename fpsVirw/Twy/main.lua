-- LOVE2D MOBILE ENGINE
-- Un motore di gioco completo per dispositivi mobili con UI integrata
-- Sviluppato per LÖVE Framework (https://love2d.org/)

-- Configurazione globale
local Engine = {
    width = 0,
    height = 0,
    scale = 1,
    scenes = {},
    currentScene = nil,
    assets = {},
    input = {
        touches = {},
        lastTouch = {x = 0, y = 0, id = nil},
        touchPressed = false
    },
    ui = {
        elements = {},
        activeElement = nil,
        font = nil,
        theme = {
            primary = {1, 0.4, 0.2, 1},
            secondary = {0.2, 0.6, 1, 1},
            background = {0.1, 0.1, 0.1, 1},
            text = {1, 1, 1, 1},
            disabled = {0.5, 0.5, 0.5, 1}
        },
        styles = {}
    },
    physics = {
        world = nil,
        objects = {},
        scale = 30, -- pixel per metro
        debug = false
    },
    animation = {
        sprites = {},
        active = {}
    },
    camera = {
        x = 0,
        y = 0,
        scale = 1,
        rotation = 0,
        target = nil,
        smoothing = 0.1
    },
    time = {
        dt = 0,
        total = 0
    },
    debug = {
        active = false,
        fps = 0,
        info = {}
    },
    audio = {
        music = {},
        sounds = {},
        currentMusic = nil
    },
    particles = {
        systems = {}
    }
}

-- Inizializzazione
function love.load()
    -- Impostazioni per dispositivi mobili
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Imposta le dimensioni dello schermo
    Engine.width = love.graphics.getWidth()
    Engine.height = love.graphics.getHeight()
    
    -- Calcola il fattore di scala per adattarsi a diverse risoluzioni
    local baseWidth, baseHeight = 1280, 720
    Engine.scale = math.min(Engine.width / baseWidth, Engine.height / baseHeight)
    
    -- Carica il font di default
    Engine.ui.font = {
        small = love.graphics.newFont(14 * Engine.scale),
        medium = love.graphics.newFont(18 * Engine.scale),
        large = love.graphics.newFont(24 * Engine.scale)
    }
    
    -- Inizializza il sistema fisico
    Engine.physics.world = love.physics.newWorld(0, 9.81 * Engine.physics.scale, true)
    
    -- Carica le scene
    initScenes()
    
    -- Imposta la scena iniziale
    Engine.changeScene("menu")
    
    -- Inizializza l'audio
    initAudio()
    
    -- Inizializza la UI
    initUI()
    
    -- Inizializza i sistemi di particelle
    initParticles()
    
    -- Imposta modalità debug
    Engine.debug.active = false
end

-- Aggiornamento dello stato del gioco
function love.update(dt)
    Engine.time.dt = dt
    Engine.time.total = Engine.time.total + dt
    
    -- Aggiorna il mondo fisico
    if Engine.physics.world then
        Engine.physics.world:update(dt)
    end
    
    -- Aggiorna la camera
    updateCamera(dt)
    
    -- Aggiorna le animazioni
    updateAnimations(dt)
    
    -- Aggiorna i sistemi di particelle
    updateParticles(dt)
    
    -- Aggiorna la scena corrente
    if Engine.currentScene and Engine.currentScene.update then
        Engine.currentScene:update(dt)
    end
    
    -- Aggiorna la UI
    updateUI(dt)
    
    -- Aggiorna debug info
    if Engine.debug.active then
        Engine.debug.fps = love.timer.getFPS()
    end
end

-- Disegno
function love.draw()
    -- Applica la trasformazione della camera
    love.graphics.push()
    applyCamera()
    
    -- Disegna la scena corrente
    if Engine.currentScene and Engine.currentScene.draw then
        Engine.currentScene:draw()
    end
    
    -- Disegna i sistemi di particelle
    drawParticles()
    
    -- Disegna il debug fisico se attivo
    if Engine.physics.debug then
        drawPhysicsDebug()
    end
    
    love.graphics.pop()
    
    -- Disegna la UI (senza trasformazioni della camera)
    drawUI()
    
    -- Disegna informazioni di debug
    if Engine.debug.active then
        drawDebug()
    end
end

-- Gestione degli input touch
function love.touchpressed(id, x, y, dx, dy, pressure)
    Engine.input.touches[id] = {x = x, y = y, pressure = pressure}
    Engine.input.lastTouch = {x = x, y = y, id = id}
    Engine.input.touchPressed = true
    
    -- Controlla interazioni UI
    checkUITouchPressed(x, y, id)
    
    -- Passa l'evento alla scena corrente
    if Engine.currentScene and Engine.currentScene.touchpressed then
        Engine.currentScene:touchpressed(id, x, y)
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    if Engine.input.touches[id] then
        Engine.input.touches[id].x = x
        Engine.input.touches[id].y = y
        Engine.input.touches[id].pressure = pressure
    end
    
    -- Aggiorna l'ultimo touch
    Engine.input.lastTouch = {x = x, y = y, id = id}
    
    -- Controlla interazioni UI
    checkUITouchMoved(x, y, id, dx, dy)
    
    -- Passa l'evento alla scena corrente
    if Engine.currentScene and Engine.currentScene.touchmoved then
        Engine.currentScene:touchmoved(id, x, y, dx, dy)
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    Engine.input.touches[id] = nil
    Engine.input.touchPressed = false
    
    -- Controlla interazioni UI
    checkUITouchReleased(x, y, id)
    
    -- Passa l'evento alla scena corrente
    if Engine.currentScene and Engine.currentScene.touchreleased then
        Engine.currentScene:touchreleased(id, x, y)
    end
end

-- Gestione del ridimensionamento della finestra
function love.resize(w, h)
    Engine.width = w
    Engine.height = h
    
    -- Ricalcola il fattore di scala
    local baseWidth, baseHeight = 1280, 720
    Engine.scale = math.min(Engine.width / baseWidth, Engine.height / baseHeight)
    
    -- Aggiorna la UI
    resizeUI()
    
    -- Passa l'evento alla scena corrente
    if Engine.currentScene and Engine.currentScene.resize then
        Engine.currentScene:resize(w, h)
    end
end

-- SISTEMA DI CAMBIO SCENE
function Engine.changeScene(sceneName)
    if Engine.scenes[sceneName] then
        -- Chiudi la scena corrente
        if Engine.currentScene and Engine.currentScene.exit then
            Engine.currentScene:exit()
        end
        
        -- Imposta la nuova scena
        Engine.currentScene = Engine.scenes[sceneName]
        
        -- Inizializza la nuova scena
        if Engine.currentScene.init then
            Engine.currentScene:init()
        end
    end
end

-- Inizializzazione delle scene
function initScenes()
    -- Scena del menu principale
    Engine.scenes.menu = {
        buttons = {},
        
        init = function(self)
            -- Crea i pulsanti del menu
            local buttonWidth = 200 * Engine.scale
            local buttonHeight = 60 * Engine.scale
            local spacing = 20 * Engine.scale
            local startY = Engine.height / 2 - (buttonHeight + spacing) * 1.5
            
            self.buttons = {
                Engine.ui.createButton("play", "GIOCA", Engine.width / 2 - buttonWidth / 2, startY, buttonWidth, buttonHeight, function()
                    Engine.changeScene("game")
                end),
                
                Engine.ui.createButton("settings", "IMPOSTAZIONI", Engine.width / 2 - buttonWidth / 2, startY + buttonHeight + spacing, buttonWidth, buttonHeight, function()
                    -- Apri menu impostazioni
                end),
                
                Engine.ui.createButton("exit", "ESCI", Engine.width / 2 - buttonWidth / 2, startY + (buttonHeight + spacing) * 2, buttonWidth, buttonHeight, function()
                    love.event.quit()
                end)
            }
            
            -- Aggiungi i pulsanti alla UI
            for _, button in ipairs(self.buttons) do
                Engine.ui.addElement(button)
            end
        end,
        
        update = function(self, dt)
            -- Aggiornamenti specifici del menu
        end,
        
        draw = function(self)
            -- Sfondo del menu
            love.graphics.setColor(0.1, 0.2, 0.3, 1)
            love.graphics.rectangle("fill", 0, 0, Engine.width, Engine.height)
            
            -- Titolo del gioco
            love.graphics.setFont(Engine.ui.font.large)
            love.graphics.setColor(1, 1, 1, 1)
            local title = "SUPER MOBILE GAME"
            local titleWidth = Engine.ui.font.large:getWidth(title)
            love.graphics.print(title, Engine.width / 2 - titleWidth / 2, Engine.height / 4)
        end,
        
        exit = function(self)
            -- Rimuovi i pulsanti dalla UI
            for _, button in ipairs(self.buttons) do
                Engine.ui.removeElement(button.id)
            end
        end,
        
        touchpressed = function(self, id, x, y)
            -- Gestione touch specifica del menu
        end
    }
    
    -- Scena di gioco
    Engine.scenes.game = {
        player = nil,
        enemies = {},
        
        init = function(self)
            -- Crea il giocatore
            self.player = {
                x = Engine.width / 2,
                y = Engine.height / 2,
                width = 50 * Engine.scale,
                height = 50 * Engine.scale,
                speed = 200 * Engine.scale,
                color = {1, 0, 0, 1},
                health = 100,
                
                -- Crea un corpo fisico per il giocatore
                physics = {
                    body = love.physics.newBody(Engine.physics.world, Engine.width / 2, Engine.height / 2, "dynamic"),
                    shape = love.physics.newRectangleShape(50 * Engine.scale, 50 * Engine.scale),
                    fixture = nil
                }
            }
            
            self.player.physics.fixture = love.physics.newFixture(self.player.physics.body, self.player.physics.shape, 1)
            self.player.physics.fixture:setRestitution(0.4)
            self.player.physics.fixture:setUserData({type = "player"})
            
            -- Crea il joystick virtuale
            self.joystick = Engine.ui.createJoystick("gameJoystick", 100 * Engine.scale, Engine.height - 100 * Engine.scale, 80 * Engine.scale)
            Engine.ui.addElement(self.joystick)
            
            -- Crea il pulsante di attacco
            self.attackButton = Engine.ui.createButton("attackBtn", "ATTACCO", Engine.width - 100 * Engine.scale, Engine.height - 100 * Engine.scale, 80 * Engine.scale, 80 * Engine.scale, function()
                self:playerAttack()
            end)
            Engine.ui.addElement(self.attackButton)
            
            -- Crea il pulsante di ritorno al menu
            self.menuButton = Engine.ui.createButton("menuBtn", "MENU", 50 * Engine.scale, 30 * Engine.scale, 80 * Engine.scale, 40 * Engine.scale, function()
                Engine.changeScene("menu")
            end)
            Engine.ui.addElement(self.menuButton)
            
            -- Imposta la camera per seguire il giocatore
            Engine.camera.target = self.player
            
            -- Crea un sistema di particelle per l'effetto di movimento
            self.moveParticles = love.graphics.newParticleSystem(createCircleImage(10, {1, 1, 1, 1}), 100)
            self.moveParticles:setParticleLifetime(0.2, 0.5)
            self.moveParticles:setEmissionRate(20)
            self.moveParticles:setSizes(0.8, 0.1)
            self.moveParticles:setColors(1, 1, 1, 1, 1, 1, 1, 0)
            self.moveParticles:setSpeed(10, 20)
            
            -- Aggiungi il sistema di particelle al motore
            Engine.particles.systems.playerMove = self.moveParticles
            
            -- Crea animazione per il giocatore
            self.playerAnimation = Engine.animation.create("player", {
                frames = {
                    {x = self.player.x, y = self.player.y, w = self.player.width, h = self.player.height, color = {1, 0, 0, 1}},
                    {x = self.player.x, y = self.player.y, w = self.player.width * 1.1, h = self.player.height * 1.1, color = {0.9, 0, 0, 1}},
                    {x = self.player.x, y = self.player.y, w = self.player.width * 1.2, h = self.player.height * 1.2, color = {0.8, 0, 0, 1}},
                    {x = self.player.x, y = self.player.y, w = self.player.width * 1.1, h = self.player.height * 1.1, color = {0.9, 0, 0, 1}}
                },
                frameTime = 0.15,
                loop = true
            })
            
            -- Avvia l'animazione
            Engine.animation.start("player")
        end,
        
        update = function(self, dt)
            -- Aggiorna la posizione del giocatore in base al joystick
            if self.joystick.active then
                local dx = self.joystick.dx * self.player.speed * dt
                local dy = self.joystick.dy * self.player.speed * dt
                
                -- Applica forza al corpo fisico
                self.player.physics.body:applyForce(dx * 10, dy * 10)
                
                -- Emetti particelle quando ci si muove
                if math.abs(dx) > 0.1 or math.abs(dy) > 0.1 then
                    self.moveParticles:setPosition(self.player.x, self.player.y)
                    self.moveParticles:emit(1)
                end
            end
            
            -- Aggiorna la posizione visiva del giocatore in base alla fisica
            self.player.x = self.player.physics.body:getX()
            self.player.y = self.player.physics.body:getY()
            
            -- Aggiorna l'animazione del giocatore
            local currentFrame = Engine.animation.getFrame("player")
            if currentFrame then
                currentFrame.x = self.player.x
                currentFrame.y = self.player.y
            end
            
            -- Aggiorna il sistema di particelle
            self.moveParticles:update(dt)
        end,
        
        draw = function(self)
            -- Disegna lo sfondo
            love.graphics.setColor(0.2, 0.3, 0.4, 1)
            love.graphics.rectangle("fill", -1000, -1000, 3000, 3000)
            
            -- Disegna una griglia per riferimento
            love.graphics.setColor(0.3, 0.4, 0.5, 0.3)
            local gridSize = 100
            for x = -1000, 2000, gridSize do
                love.graphics.line(x, -1000, x, 2000)
            end
            for y = -1000, 2000, gridSize do
                love.graphics.line(-1000, y, 2000, y)
            end
            
            -- Disegna il giocatore (usiamo l'animazione)
            local frame = Engine.animation.getFrame("player")
            if frame then
                love.graphics.setColor(frame.color)
                love.graphics.rectangle("fill", frame.x - frame.w / 2, frame.y - frame.h / 2, frame.w, frame.h)
            else
                -- Fallback se l'animazione non è disponibile
                love.graphics.setColor(self.player.color)
                love.graphics.rectangle("fill", self.player.x - self.player.width / 2, self.player.y - self.player.height / 2, self.player.width, self.player.height)
            end
            
            -- Disegna l'HUD del giocatore
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(Engine.ui.font.small)
            love.graphics.print("HP: " .. self.player.health, self.player.x - 20, self.player.y - 50)
        end,
        
        exit = function(self)
            -- Rimuovi gli elementi UI
            Engine.ui.removeElement(self.joystick.id)
            Engine.ui.removeElement(self.attackButton.id)
            Engine.ui.removeElement(self.menuButton.id)
            
            -- Rimuovi il corpo fisico del giocatore
            self.player.physics.body:destroy()
            
            -- Ferma l'animazione
            Engine.animation.stop("player")
            
            -- Rimuovi il sistema di particelle
            Engine.particles.systems.playerMove = nil
        end,
        
        playerAttack = function(self)
            -- Crea un effetto di attacco
            local attackEffect = love.graphics.newParticleSystem(createCircleImage(10, {1, 0.5, 0, 1}), 100)
            attackEffect:setParticleLifetime(0.2, 0.4)
            attackEffect:setEmissionRate(100)
            attackEffect:setSizes(1, 0.1)
            attackEffect:setColors(1, 0.5, 0, 1, 1, 0, 0, 0)
            attackEffect:setSpeed(50, 150)
            attackEffect:setPosition(self.player.x, self.player.y)
            attackEffect:emit(30)
            
            -- Aggiungi il sistema di particelle al motore
            Engine.particles.systems.playerAttack = attackEffect
            
            -- Rimuovi l'effetto dopo un certo tempo
            love.timer.after(0.5, function()
                Engine.particles.systems.playerAttack = nil
            end)
        end,
        
        touchpressed = function(self, id, x, y)
            -- Gestione touch specifica del gioco
        end
    }
end

-- SISTEMA UI
function initUI()
    Engine.ui.styles = {
        button = {
            normal = {
                bgColor = Engine.ui.theme.primary,
                textColor = Engine.ui.theme.text,
                borderColor = {1, 1, 1, 0.5},
                borderWidth = 2 * Engine.scale
            },
            hover = {
                bgColor = {Engine.ui.theme.primary[1] * 1.2, Engine.ui.theme.primary[2] * 1.2, Engine.ui.theme.primary[3] * 1.2, 1},
                textColor = Engine.ui.theme.text,
                borderColor = {1, 1, 1, 0.8},
                borderWidth = 2 * Engine.scale
            },
            pressed = {
                bgColor = {Engine.ui.theme.primary[1] * 0.8, Engine.ui.theme.primary[2] * 0.8, Engine.ui.theme.primary[3] * 0.8, 1},
                textColor = Engine.ui.theme.text,
                borderColor = {1, 1, 1, 1},
                borderWidth = 2 * Engine.scale
            },
            disabled = {
                bgColor = Engine.ui.theme.disabled,
                textColor = {0.8, 0.8, 0.8, 0.5},
                borderColor = {0.8, 0.8, 0.8, 0.3},
                borderWidth = 2 * Engine.scale
            }
        }
    }
end

function Engine.ui.createButton(id, text, x, y, width, height, callback)
    return {
        id = id,
        type = "button",
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        enabled = true,
        visible = true,
        state = "normal", -- normal, hover, pressed, disabled
        onClick = callback,
        
        draw = function(self)
            if not self.visible then return end
            
            local style = Engine.ui.styles.button[self.state]
            
            -- Sfondo
            love.graphics.setColor(style.bgColor)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 8 * Engine.scale)
            
            -- Bordo
            love.graphics.setColor(style.borderColor)
            love.graphics.setLineWidth(style.borderWidth)
            love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 8 * Engine.scale)
            
            -- Testo
            love.graphics.setColor(style.textColor)
            love.graphics.setFont(Engine.ui.font.medium)
            local textWidth = Engine.ui.font.medium:getWidth(self.text)
            local textHeight = Engine.ui.font.medium:getHeight()
            love.graphics.print(self.text, self.x + self.width / 2 - textWidth / 2, self.y + self.height / 2 - textHeight / 2)
        end,
        
        isInside = function(self, x, y)
            return self.visible and self.enabled and
                   x >= self.x and x <= self.x + self.width and
                   y >= self.y and y <= self.y + self.height
        end
    }
end

function Engine.ui.createJoystick(id, x, y, radius)
    return {
        id = id,
        type = "joystick",
        x = x,
        y = y,
        baseRadius = radius,
        knobRadius = radius / 2,
        knobX = x,
        knobY = y,
        dx = 0,
        dy = 0,
        active = false,
        touchId = nil,
        visible = true,
        
        draw = function(self)
            if not self.visible then return end
            
            -- Base del joystick
            love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
            love.graphics.circle("fill", self.x, self.y, self.baseRadius)
            
            -- Bordo della base
            love.graphics.setColor(0.4, 0.4, 0.4, 0.7)
            love.graphics.setLineWidth(2 * Engine.scale)
            love.graphics.circle("line", self.x, self.y, self.baseRadius)
            
            -- Leva del joystick
            love.graphics.setColor(0.8, 0.8, 0.8, 0.9)
            love.graphics.circle("fill", self.knobX, self.knobY, self.knobRadius)
            
            -- Bordo della leva
            love.graphics.setColor(1, 1, 1, 0.9)
            love.graphics.setLineWidth(2 * Engine.scale)
            love.graphics.circle("line", self.knobX, self.knobY, self.knobRadius)
        end,
        
        isInside = function(self, x, y)
            return self.visible and
                   math.sqrt((x - self.x)^2 + (y - self.y)^2) <= self.baseRadius
        end,
        
        update = function(self, x, y)
            if not self.active then return end
            
            -- Calcola il vettore dal centro alla posizione attuale
            local dx = x - self.x
            local dy = y - self.y
            
            -- Calcola la distanza
            local distance = math.sqrt(dx^2 + dy^2)
            
            -- Normalizza il vettore se necessario
            if distance > self.baseRadius then
                dx = dx / distance * self.baseRadius
                dy = dy / distance * self.baseRadius
                distance = self.baseRadius
            end
            
            -- Aggiorna la posizione della leva
            self.knobX = self.x + dx
            self.knobY = self.y + dy
            
            -- Aggiorna i valori normalizzati
            self.dx = dx / self.baseRadius
            self.dy = dy / self.baseRadius
        end,
        
        reset = function(self)
            self.knobX = self.x
            self.knobY = self.y
            self.dx = 0
            self.dy = 0
            self.active = false
            self.touchId = nil
        end
    }
end

function Engine.ui.addElement(element)
    Engine.ui.elements[element.id] = element
end

function Engine.ui.removeElement(id)
    Engine.ui.elements[id] = nil
end

function updateUI(dt)
    -- Aggiorna gli elementi UI che richiedono un aggiornamento
    for id, element in pairs(Engine.ui.elements) do
        if element.update then
            element:update(dt)
        end
    end
end

function drawUI()
    -- Disegna tutti gli elementi UI
    for id, element in pairs(Engine.ui.elements) do
        if element.draw then
            element:draw()
        end
    end
end

function resizeUI()
    -- Ridimensiona gli elementi UI (da implementare per ogni tipo di elemento)
end

function checkUITouchPressed(x, y, id)
    -- Controlla se il tocco ha colpito un elemento UI
    for elemId, element in pairs(Engine.ui.elements) do
        if element.isInside and element:isInside(x, y) then
            Engine.ui.activeElement = element
            
            if element.type == "button" then
                element.state = "pressed"
            elseif element.type == "joystick" then
                element.active = true
                element.touchId = id
                element:update(x, y)
            end
            
            return true
        end
    end
    
    return false
end

function checkUITouchMoved(x, y, id, dx, dy)
    -- Aggiorna l'elemento UI attivo
    if Engine.ui.activeElement and Engine.ui.activeElement.touchId == id then
        if Engine.ui.activeElement.type == "joystick" then
            Engine.ui.activeElement:update(x, y)
        end
    end
end

function checkUITouchReleased(x, y, id)
    -- Gestisce il rilascio del tocco su un elemento UI
    if Engine.ui.activeElement and Engine.ui.activeElement.touchId == id then
        if Engine.ui.activeElement.type == "button" then
            if Engine.ui.activeElement:isInside(x, y) and Engine.ui.activeElement.onClick then
                Engine.ui.activeElement.onClick()
            end
            Engine.ui.activeElement.state = "normal"
        elseif Engine.ui.activeElement.type == "joystick" then
            Engine.ui.activeElement:reset()
        end
        
        Engine.ui.activeElement = nil
    end
end

-- SISTEMA CAMERA
function applyCamera()
    local tx = -Engine.camera.x + Engine.width / 2
    local ty = -Engine.camera.y + Engine.height / 2
    
    love.graphics.translate(tx, ty)
    love.graphics.scale(Engine.camera.scale, Engine.camera.scale)
    love.graphics.rotate(Engine.camera.rotation)
end

function updateCamera(dt)
    if Engine.camera.target then
        -- Calcola la posizione desiderata
        local targetX = Engine.camera.target.x
        local targetY = Engine.camera.target.y
        
        -- Applica smoothing
        Engine.camera.x = Engine.camera.x + (targetX - Engine.camera.x) * Engine.camera.smoothing
        Engine.camera.y = Engine.camera.y + (targetY - Engine.camera.y) * Engine.camera.smoothing
    end
end

-- SISTEMA ANIMAZIONI
function Engine.animation.create(id, options)
    Engine.animation.sprites[id] = {
        frames = options.frames,
        frameTime = options.frameTime or 0.1,
        currentFrame = 1,
        timer = 0,
        loop = options.loop or false,
        isPlaying = false
    }
    
    return Engine.animation.sprites[id]
end

function Engine.animation.start(id)
    local sprite = Engine.animation.sprites[id]
    if sprite then
        sprite.isPlaying = true
        Engine.animation.active[id] = sprite
    end
end

function Engine.animation.stop(id)
    local sprite = Engine.animation.sprites[id]
    if sprite then
        sprite.isPlaying = false
        Engine.animation.active[id] = nil
    end
end

function Engine.animation.getFrame(id)
    local sprite = Engine.animation.sprites[id]
    if sprite and sprite.frames and #sprite.frames > 0 then
        return sprite.frames[sprite.currentFrame]
    end
    return nil
end

function updateAnimations(dt)
    -- Aggiorna tutte le animazioni attive
    for id, sprite in pairs(Engine.animation.active) do
        if sprite.isPlaying then
            sprite.timer = sprite.timer + dt
            
            if sprite.timer >= sprite.frameTime then
                sprite.timer = sprite.timer - sprite.frameTime
                sprite.currentFrame = sprite.currentFrame + 1
                
                -- Gestione del loop o fine animazione
                if sprite.currentFrame > #sprite.frames then
                    if sprite.loop then
                        sprite.currentFrame = 1
                    else
                        sprite.currentFrame = #sprite.frames
                        sprite.isPlaying = false
                        Engine.animation.active[id] = nil
                    end
                end
            end
        end
    end
end

-- SISTEMA PARTICELLE
function initParticles()
    -- Inizializza i sistemi di particelle globali
end

function updateParticles(dt)
    -- Aggiorna tutti i sistemi di particelle
    for id, system in pairs(Engine.particles.systems) do
        if system then
            system:update(dt)
        end
    end
end

function drawParticles()
    -- Disegna tutti i sistemi di particelle
    love.graphics.setColor(1, 1, 1, 1)
    for id, system in pairs(Engine.particles.systems) do
        if system then
            love.graphics.draw(system)
        end
    end
end

-- SISTEMA AUDIO
function initAudio()
    -- Carica i suoni e la musica
    Engine.audio.sounds.click = love.audio.newSource("assets/sounds/click.wav", "static")
    Engine.audio.sounds.explosion = love.audio.newSource("assets/sounds/explosion.wav", "static")
    
    -- Crea un suono di fallback se i file non esistono
    if not love.filesystem.getInfo("assets/sounds/click.wav") then
        Engine.audio.sounds.click = createDummySound(220, 0.1)
    end
    
    if not love.filesystem.getInfo("assets/sounds/explosion.wav") then
        Engine.audio.sounds.explosion = createDummySound(100, 0.3)
    end
    
    -- Musica
    if love.filesystem.getInfo("assets/music/background.mp3") then
        Engine.audio.music.background = love.audio.newSource("assets/music/background.mp3", "stream")
        Engine.audio.music.background:setLooping(true)
    end
end

function Engine.playSound(soundName, volume, pitch)
    local sound = Engine.audio.sounds[soundName]
    if sound then
        -- Clona il suono per permettere sovrapposizioni
        local clone = sound:clone()
        clone:setVolume(volume or 1)
        clone:setPitch(pitch or 1)
        clone:play()
        return clone
    end
    return nil
end

function Engine.playMusic(musicName, volume)
    -- Interrompi la musica corrente
    if Engine.audio.currentMusic then
        Engine.audio.currentMusic:stop()
    end
    
    -- Avvia la nuova musica
    local music = Engine.audio.music[musicName]
    if music then
        music:setVolume(volume or 0.5)
        music:play()
        Engine.audio.currentMusic = music
    end
end

function Engine.stopMusic()
    if Engine.audio.currentMusic then
        Engine.audio.currentMusic:stop()
        Engine.audio.currentMusic = nil
    end
end

-- SISTEMA FISICO
function drawPhysicsDebug()
    love.graphics.setColor(0, 1, 0, 0.5)
    
    -- Disegna tutti i corpi fisici
    for _, body in ipairs(Engine.physics.world:getBodies()) do
        for _, fixture in ipairs(body:getFixtures()) do
            local shape = fixture:getShape()
            
            if shape:getType() == "circle" then
                local x, y = body:getWorldPoint(shape:getPoint())
                local radius = shape:getRadius()
                love.graphics.circle("line", x, y, radius)
            elseif shape:getType() == "polygon" then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            elseif shape:getType() == "edge" then
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            elseif shape:getType() == "chain" then
                local points = {body:getWorldPoints(shape:getPoints())}
                love.graphics.line(points)
            end
        end
    end
end

-- DEBUG
function drawDebug()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Engine.ui.font.small)
    
    local y = 10
    love.graphics.print("FPS: " .. Engine.debug.fps, 10, y)
    y = y + 20
    
    if Engine.currentScene and Engine.currentScene.player then
        love.graphics.print("Player X: " .. math.floor(Engine.currentScene.player.x), 10, y)
        y = y + 20
        love.graphics.print("Player Y: " .. math.floor(Engine.currentScene.player.y), 10, y)
        y = y + 20
    end
    
    -- Aggiungi altre informazioni debug
    love.graphics.print("Active Particles: " .. table.count(Engine.particles.systems), 10, y)
    y = y + 20
    love.graphics.print("Active Animations: " .. table.count(Engine.animation.active), 10, y)
    y = y + 20
    
    -- Memoria usata
    local mem = collectgarbage("count")
    love.graphics.print("Memory: " .. math.floor(mem / 1024) .. " MB", 10, y)
end

-- UTILITY FUNCTIONS
function createCircleImage(radius, color)
    local size = radius * 2
    local canvas = love.graphics.newCanvas(size, size)
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColor(color or {1, 1, 1, 1})
    love.graphics.circle("fill", radius, radius, radius)
    love.graphics.setCanvas()
    
    return canvas
end

function createDummySound(frequency, duration)
    -- Crea un suono procedurale usando SoundData
    local sampleRate = 44100
    local samples = math.floor(sampleRate * (duration or 1))
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local amplitude = 0.5 * (1 - t / duration)
        local value = amplitude * math.sin(2 * math.pi * frequency * t)
        soundData:setSample(i, value)
    end
    
    return love.audio.newSource(soundData)
end

-- Helper per contare elementi in una tabella
function table.count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Controlla se ci sono file necessari e crea directory se necessario
function checkFiles()
    -- Crea directory per assets se non esiste
    if not love.filesystem.getInfo("assets") then
        love.filesystem.createDirectory("assets")
        love.filesystem.createDirectory("assets/sounds")
        love.filesystem.createDirectory("assets/music")
        love.filesystem.createDirectory("assets/images")
    end
end

-- Chiamato all'inizio per controllare i file
checkFiles()

-- SISTEMA SALVATAGGIO E CARICAMENTO DATI
function Engine.saveGame(data, filename)
    filename = filename or "savegame.dat"
    local success, message = love.filesystem.write(filename, love.data.compress("string", "zlib", love.data.encode("string", "json", data)))
    return success, message
end

function Engine.loadGame(filename)
    filename = filename or "savegame.dat"
    if love.filesystem.getInfo(filename) then
        local data = love.filesystem.read(filename)
        if data then
            local decoded = love.data.decode("string", "json", love.data.decompress("string", "zlib", data))
            return decoded
        end
    end
    return nil
end

-- GESTIAMO IL MULTITHREADING
function initThreads()
    -- Thread per calcoli pesanti in background
    Engine.threads = {}
    
    -- Thread per il caricamento delle risorse
    Engine.threads.loader = love.thread.newThread([[
        local channel = love.thread.getChannel("loader")
        local resultChannel = love.thread.getChannel("loaderResult")
        
        while true do
            local task = channel:demand()
            if task.command == "load" then
                local result = {}
                for _, file in ipairs(task.files) do
                    local success, data = pcall(love.filesystem.read, file)
                    result[file] = success and data or nil
                end
                resultChannel:push(result)
            elseif task.command == "quit" then
                break
            end
        end
    ]])
    
    Engine.threads.loader:start()
end

function Engine.loadResourcesAsync(files, callback)
    if not Engine.threads.loader then
        initThreads()
    end
    
    local loaderChannel = love.thread.getChannel("loader")
    loaderChannel:push({command = "load", files = files})
    
    -- Timer per controllare i risultati
    Engine.resourceLoadTimer = love.timer.getTime()
    Engine.resourceLoadCallback = callback
end

function Engine.checkResourceLoading()
    if Engine.resourceLoadTimer then
        local resultChannel = love.thread.getChannel("loaderResult")
        local result = resultChannel:peek()
        
        if result then
            resultChannel:clear()
            Engine.resourceLoadTimer = nil
            
            if Engine.resourceLoadCallback then
                Engine.resourceLoadCallback(result)
                Engine.resourceLoadCallback = nil
            end
        end
    end
end

-- NETWORKING (Versione base)
Engine.network = {
    connected = false,
    socket = nil,
    address = nil,
    port = nil,
    messages = {}
}

function Engine.network.connect(address, port)
    if not love.filesystem.getInfo("socket") then
        return false, "Socket library not available"
    end
    
    local socket = require("socket")
    Engine.network.socket = socket.tcp()
    Engine.network.socket:settimeout(0)
    
    local success, err = Engine.network.socket:connect(address, port)
    if success or err == "timeout" then
        Engine.network.connected = true
        Engine.network.address = address
        Engine.network.port = port
        return true
    else
        return false, err
    end
end

function Engine.network.disconnect()
    if Engine.network.socket then
        Engine.network.socket:close()
        Engine.network.socket = nil
        Engine.network.connected = false
    end
end

function Engine.network.send(data)
    if not Engine.network.connected or not Engine.network.socket then
        return false, "Not connected"
    end
    
    local serialized = love.data.encode("string", "json", data)
    local success, err = Engine.network.socket:send(serialized .. "\n")
    return success, err
end

function Engine.network.update()
    if not Engine.network.connected or not Engine.network.socket then
        return
    end
    
    local data, err, partial = Engine.network.socket:receive("*l")
    if data then
        local success, message = pcall(love.data.decode, "string", "json", data)
        if success then
            table.insert(Engine.network.messages, message)
        end
    elseif err ~= "timeout" then
        -- Errore nella connessione
        Engine.network.disconnect()
    end
end

-- Questo sistema può essere utilizzato per notifiche, popups, toast, ecc.
Engine.notifications = {
    items = {},
    defaultDuration = 3,
    maxItems = 5
}

function Engine.notifications.add(message, type, duration)
    table.insert(Engine.notifications.items, {
        message = message,
        type = type or "info", -- info, warning, error, success
        duration = duration or Engine.notifications.defaultDuration,
        time = 0,
        alpha = 0
    })
    
    -- Rimuovi notifiche in eccesso
    while #Engine.notifications.items > Engine.notifications.maxItems do
        table.remove(Engine.notifications.items, 1)
    end
end

function Engine.notifications.update(dt)
    for i = #Engine.notifications.items, 1, -1 do
        local item = Engine.notifications.items[i]
        item.time = item.time + dt
        
        -- Fade in
        if item.time < 0.3 then
            item.alpha = item.time / 0.3
        -- Fade out
        elseif item.time > item.duration - 0.3 then
            item.alpha = (item.duration - item.time) / 0.3
        else
            item.alpha = 1
        end
        
        -- Rimuovi se scaduto
        if item.time >= item.duration then
            table.remove(Engine.notifications.items, i)
        end
    end
end

function Engine.notifications.draw()
    local padding = 10 * Engine.scale
    local height = 40 * Engine.scale
    local spacing = 5 * Engine.scale
    local width = 300 * Engine.scale
    
    for i, item in ipairs(Engine.notifications.items) do
        local y = Engine.height - (padding + height) * i
        
        -- Background
        local bgColor
        if item.type == "info" then
            bgColor = {0.2, 0.6, 1, item.alpha * 0.9}
        elseif item.type == "warning" then
            bgColor = {1, 0.7, 0.2, item.alpha * 0.9}
        elseif item.type == "error" then
            bgColor = {1, 0.3, 0.3, item.alpha * 0.9}
        elseif item.type == "success" then
            bgColor = {0.3, 0.8, 0.3, item.alpha * 0.9}
        end
        
        love.graphics.setColor(bgColor)
        love.graphics.rectangle("fill", Engine.width - width - padding, y - height, width, height, 6 * Engine.scale)
        
        -- Border
        love.graphics.setColor(1, 1, 1, item.alpha * 0.5)
        love.graphics.setLineWidth(1 * Engine.scale)
        love.graphics.rectangle("line", Engine.width - width - padding, y - height, width, height, 6 * Engine.scale)
        
        -- Text
        love.graphics.setColor(1, 1, 1, item.alpha)
        love.graphics.setFont(Engine.ui.font.small)
        love.graphics.printf(item.message, Engine.width - width - padding + 10, y - height + 10, width - 20, "left")
    end
end

-- GESTIONE LIVELLI
Engine.levels = {
    current = nil,
    data = {}
}

function Engine.levels.load(levelName)
    if Engine.levels.data[levelName] then
        Engine.levels.current = Engine.levels.data[levelName]
        
        -- Carica gli oggetti del livello
        if Engine.currentScene and Engine.currentScene.loadLevel then
            Engine.currentScene:loadLevel(Engine.levels.current)
        end
        
        return true
    end
    return false
end

function Engine.levels.create(levelName, data)
    Engine.levels.data[levelName] = data
end

-- Esempio di formato livello
function createExampleLevel()
    Engine.levels.create("level1", {
        name = "Level 1",
        width = 2000,
        height = 2000,
        background = {0.1, 0.1, 0.2, 1},
        objects = {
            {
                type = "platform",
                x = 500,
                y = 400,
                width = 300,
                height = 30,
                properties = {
                    material = "wood"
                }
            },
            {
                type = "enemy",
                x = 800,
                y = 300,
                properties = {
                    enemyType = "basic",
                    patrol = {
                        {x = 700, y = 300},
                        {x = 900, y = 300}
                    }
                }
            },
            {
                type = "collectible",
                x = 500,
                y = 300,
                properties = {
                    itemType = "coin"
                }
            }
        },
        spawn = {
            x = 100,
            y = 100
        }
    })
end

-- Chiamiamo questa funzione all'inizio
createExampleLevel()

-- RISORSE LOCALI (per rendere l'engine funzionante anche senza assets esterni)
function Engine.createLocalResources()
    Engine.assets.localImages = {}
    
    -- Crea placeholder per texture
    Engine.assets.localImages.placeholder = createCircleImage(50, {0.8, 0.8, 0.8, 1})
    
    -- Sfondo semplice
    local bgCanvas = love.graphics.newCanvas(256, 256)
    love.graphics.setCanvas(bgCanvas)
    love.graphics.clear(0.2, 0.3, 0.4, 1)
    
    -- Disegna pattern
    love.graphics.setColor(0.3, 0.4, 0.5, 1)
    for y = 0, 256, 32 do
        for x = 0, 256, 32 do
            love.graphics.rectangle("fill", x, y, 16, 16)
        end
    end
    
    love.graphics.setCanvas()
    Engine.assets.localImages.background = bgCanvas
    
    -- Ritorna alla canvas principale
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
}
}
-- Avvia la creazione delle risorse locali
Engine.createLocalResources()

-- Ritorna l'oggetto Engine globale per permettere l'accesso dall'esterno
return Engine