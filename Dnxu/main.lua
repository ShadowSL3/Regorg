-- Dipendenze richieste: love-svg, love-audio, love.graphics
-- IK semplificato + gestione cutscene modulare + supporto audio e "SVG"

local svg = require("svg") -- love-svg (o converti le icone in PNG in alternativa)

-- Actor con articolazioni per sistema IK base
local Actor = {
    x = 400, y = 300,
    bones = {
        { length = 50, angle = 0 },
        { length = 40, angle = 0 }
    }
}

function Actor:updateIK(targetX, targetY)
    local dx = targetX - self.x
    local dy = targetY - self.y
    local angle1 = math.atan2(dy, dx)
    self.bones[1].angle = angle1
    self.bones[2].angle = angle1 + 0.5 * math.sin(love.timer.getTime()) -- animazione dinamica
end

function Actor:draw()
    local x, y = self.x, self.y
    for _, bone in ipairs(self.bones) do
        local bx = x + math.cos(bone.angle) * bone.length
        local by = y + math.sin(bone.angle) * bone.length
        love.graphics.setLineWidth(5)
        love.graphics.line(x, y, bx, by)
        x, y = bx, by
    end
end

-- Sistema di cutscene
local CutsceneManager = {
    steps = {},
    current = 1,
    timer = 0,
    active = true
}

function CutsceneManager:addStep(duration, action)
    table.insert(self.steps, { duration = duration, action = action })
end

function CutsceneManager:update(dt)
    if not self.active then return end
    local step = self.steps[self.current]
    if not step then return end

    step.action(dt)
    self.timer = self.timer + dt
    if self.timer >= step.duration then
        self.timer = 0
        self.current = self.current + 1
        if self.current > #self.steps then
            self.active = false
        end
    end
end

-- Risorse
local iconSVG
local bgm

function love.load()
    love.window.setTitle("Cutscene System with IK - Love2D")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Carica SVG (convertito in PNG se love-svg non disponibile)
    iconSVG = svg.load("assets/icon.svg", 64, 64)

    -- Audio
    bgm = love.audio.newSource("assets/voice.ogg", "stream")
    bgm:setVolume(0.6)
    bgm:setLooping(false)

    -- Definizione Cutscene
    CutsceneManager:addStep(2, function(dt)
        Actor:updateIK(500, 300)
    end)

    CutsceneManager:addStep(3, function(dt)
        if not bgm:isPlaying() then bgm:play() end
        Actor:updateIK(600, 350)
    end)

    CutsceneManager:addStep(2, function(dt)
        Actor:updateIK(700, 280)
    end)
end

function love.update(dt)
    CutsceneManager:update(dt)
end

function love.draw()
    -- UI/Decorazioni
    love.graphics.setColor(1, 1, 1)
    if iconSVG then iconSVG:draw(50, 50) end

    -- Disegna attore con IK
    Actor:draw()

    -- Transizione cinematografica
    if CutsceneManager.active then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end