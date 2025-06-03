local menu = {}

local items = {
    {name = "File", options = {"New", "Save", "Load"}},
    {name = "Edit", options = {"Undo", "Redo"}},
    {name = "Settings", options = {"Font Size", "Theme"}},
    {name = "Help", options = {"About"}}
}
local selected = nil

function menu.load()
end

function menu.draw(x, y, w, h)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1)
    local item_width = w / #items
    for i, item in ipairs(items) do
        love.graphics.print(item.name, x + (i - 0.5) * item_width, y + 10)
    end
end

function menu.touchpressed(id, x, y)
    if y < 50 then
        local item_width = love.graphics.getWidth() / #items
        local index = math.floor(x / item_width) + 1
        if items[index] then
            selected = items[index].name
            print("Selected: " .. selected)
        end
    end
end

return menu