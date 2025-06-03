
engine = {}
function engine.newScene()
    local s = {objects = {}}
    function s:addCube(pos, color)
        table.insert(self.objects, {pos=pos, color=color})
    end
    function s:update(dt)
        -- animazione semplice
        for _, obj in ipairs(self.objects) do
            obj.pos.y = obj.pos.y + math.sin(love.timer.getTime()) * 0.01
        end
    end
    function s:render()
        for _, obj in ipairs(self.objects) do
            love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b)
            love.graphics.rectangle("fill", 400 + obj.pos.x * 50, 300 + obj.pos.y * 50, 50, 50)
        end
    end
    return s
end
