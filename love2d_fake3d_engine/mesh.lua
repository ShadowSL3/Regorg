local Mesh = {}
Mesh.__index = Mesh

function Mesh.new(vertices)
    return setmetatable({ vertices = vertices }, Mesh)
end

function Mesh.cube(x, y, z, size)
    local s = size / 2
    local verts = {
        -- Front face
        {x-s,y-s,z-s}, {x+s,y-s,z-s}, {x+s,y+s,z-s},
        {x-s,y-s,z-s}, {x+s,y+s,z-s}, {x-s,y+s,z-s},
        -- Back face
        {x-s,y-s,z+s}, {x+s,y-s,z+s}, {x+s,y+s,z+s},
        {x-s,y-s,z+s}, {x+s,y+s,z+s}, {x-s,y+s,z+s},
        -- Left face
        {x-s,y-s,z-s}, {x-s,y+s,z-s}, {x-s,y+s,z+s},
        {x-s,y-s,z-s}, {x-s,y+s,z+s}, {x-s,y-s,z+s},
        -- Right face
        {x+s,y-s,z-s}, {x+s,y+s,z-s}, {x+s,y+s,z+s},
        {x+s,y-s,z-s}, {x+s,y+s,z+s}, {x+s,y-s,z+s},
        -- Top face
        {x-s,y-s,z-s}, {x+s,y-s,z-s}, {x+s,y-s,z+s},
        {x-s,y-s,z-s}, {x+s,y-s,z+s}, {x-s,y-s,z+s},
        -- Bottom face
        {x-s,y+s,z-s}, {x+s,y+s,z-s}, {x+s,y+s,z+s},
        {x-s,y+s,z-s}, {x+s,y+s,z+s}, {x-s,y+s,z+s},
    }
    return Mesh.new(verts)
end

function Mesh:draw(camera)
    local function project(x, y, z)
        -- Rotate Y
        local s, c = math.sin(camera.rotY), math.cos(camera.rotY)
        x, z = c*x - s*z, s*x + c*z

        -- Translate
        x, y, z = x - camera.x, y - camera.y, z - camera.z

        -- Perspective projection
        if z <= 0 then z = 0.01 end
        local scale = 1 / math.tan(camera.fov / 2)
        return (x * scale / z) * 400 + 400, (y * scale / z) * 400 + 300
    end

    for i = 1, #self.vertices, 3 do
        local v1 = self.vertices[i]
        local v2 = self.vertices[i+1]
        local v3 = self.vertices[i+2]
        local x1, y1 = project(v1[1], v1[2], v1[3])
        local x2, y2 = project(v2[1], v2[2], v2[3])
        local x3, y3 = project(v3[1], v3[2], v3[3])

        love.graphics.setColor(0.3, 0.7, 1.0)
        love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.polygon("line", x1, y1, x2, y2, x3, y3)
    end
end

return Mesh
