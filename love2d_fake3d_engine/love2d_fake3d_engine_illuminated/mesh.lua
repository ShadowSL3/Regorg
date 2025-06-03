local Mesh = {}
Mesh.__index = Mesh
local Light = require("light")

function Mesh.new(vertices)
    return setmetatable({ vertices = vertices }, Mesh)
end

function Mesh.triangle3D(x, y, z, size)
    local s = size
    local verts = {
        {x, y - s, z},
        {x - s, y + s, z},
        {x + s, y + s, z}
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

        if z <= 0 then z = 0.01 end
        local scale = 1 / math.tan(camera.fov / 2)
        return (x * scale / z) * 400 + 400, (y * scale / z) * 400 + 300, z
    end

    for i = 1, #self.vertices, 3 do
        local v1 = self.vertices[i]
        local v2 = self.vertices[i+1]
        local v3 = self.vertices[i+2]

        local x1, y1, z1 = v1[1], v1[2], v1[3]
        local x2, y2, z2 = v2[1], v2[2], v2[3]
        local x3, y3, z3 = v3[1], v3[2], v3[3]

        local u1, v1s = project(x1, y1, z1)
        local u2, v2s = project(x2, y2, z2)
        local u3, v3s = project(x3, y3, z3)

        local ux, uy, uz = x2 - x1, y2 - y1, z2 - z1
        local vx, vy, vz = x3 - x1, y3 - y1, z3 - z1
        local nx = uy * vz - uz * vy
        local ny = uz * vx - ux * vz
        local nz = ux * vy - uy * vx

        local intensity = Light.computeIntensity({x = nx, y = ny, z = nz})
        love.graphics.setColor(0.3 * intensity, 0.7 * intensity, 1.0 * intensity)
        love.graphics.polygon("fill", u1, v1s, u2, v2s, u3, v3s)
    end
end

return Mesh
