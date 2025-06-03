function love.conf(t)
    t.window.title = "Shader Editor"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.minwidth = 320
    t.window.minheight = 480
    t.accelerometerjoystick = true
    t.modules.audio = true
    t.modules.graphics = true
    t.modules.touch = true
    t.modules.window = true
    t.identity = "shader_editor"
end
