local Light = {}

Light.direction = {x = 0.5, y = -1, z = -0.3}

function Light.computeIntensity(normal)
    local len = math.sqrt(normal.x^2 + normal.y^2 + normal.z^2)
    if len == 0 then return 0.2 end
    local nx, ny, nz = normal.x/len, normal.y/len, normal.z/len
    local lx, ly, lz = Light.direction.x, Light.direction.y, Light.direction.z
    local dot = nx * lx + ny * ly + nz * lz
    return math.max(0.2, dot)
end

return Light
