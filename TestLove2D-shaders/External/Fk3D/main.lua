local fk3d = {}
fk3d.camera = { x = 0, y = 0, z = 0, fov = 300 }

local canvas
local postShader
local iStartTime = love.timer.getTime()
function love.load()
    love.graphics.setBackgroundColor(0.05, 0.05, 0.08)

    canvas = love.graphics.newCanvas()

    -- Post-processing shader (luna glow)
    postShader = love.graphics.newShader[[
        // https://www.shadertoy.com/view/Ms23DR

extern float millis;

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec2 uv = texture_coords;
    uv = curve( uv );
    vec4 oricolv4 = Texel(tex, vec2(uv.x,uv.y));
    vec3 oricol = vec3(oricolv4.x, oricolv4.y, oricolv4.z);
    vec3 col;
	float x =  sin(0.3*millis+uv.y*21.0)*sin(0.7*millis+uv.y*29.0)*sin(0.3+0.33*millis+uv.y*31.0)*0.0017;

    col.r = Texel(tex,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
    col.g = Texel(tex,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
    col.b = Texel(tex,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
    col.r += 0.08*Texel(tex,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.05*Texel(tex,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.08*Texel(tex,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
	col *= vec3(pow(vig,0.3));

    col *= vec3(0.95,1.05,0.95);
	col *= 2.8;
    
    float distortion = sin(0.3 * millis + uv.y * 25.0) * 
                   sin(0.7 * millis * uv.y * 33.0) * 
                   sin(0.3 + 0.33 * millis + uv.y * 37.0) * 0.0022;
   col.r = Texel(tex, uv + vec2( distortion + 0.003,  0.003)).r;
   col.g = Texel(tex, uv + vec2( distortion - 0.002, -0.002)).g;
   col.b = Texel(tex, uv + vec2( distortion - 0.004,  0.000)).b;

    col += 0.5 * pow(col, vec3(2.0));
	float scans = clamp(0.35+0.35*sin(3.5*millis+uv.y*screen_coords.y*1.5), 0.0, 1.0);
	float strenght = pow(scans, 0.5);
    col *=  vec3(0.3 + 0.7 * strenght);
	float s = pow(scans,5.7);
	col = col*vec3( 0.4+0.7*s) ;

    float vignette = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
    col *= vec3(pow(vignette,0.33));

    float grain = (fract(sin(dot(screen_coords.xy, vec2(12.9898, 87.255)) * 43758.5453)));
    col *= 1.0 + 0.2 * (grain, - 0.5);
    col += 0.05 * pow(col, vec3(2.0));
    col *= 1.0+0.01*sin(10.0*millis);
	if (uv.x < 0.0 || uv.x > 1.0)
		col *= 0.0;
	if (uv.y < 0.0 || uv.y > 1.0)
		col *= 0.0;
	
	col *= 1.0 - 0.65 * vec3(clamp((mod(texture_coords.x, 2.0)-1.0)*2.0,0.0,1.0));
	
    float comp = smoothstep( 0.1, 0.9, sin(millis) );
 
	// Remove the next line to stop cross-fade between original and postprocess
    //	col = mix( col, oricol, comp );

    return vec4(col, 1.0);
}
    ]]

    -- Oggetti 3D simulati
    fk3d.objects = {
        { x = -50, y = 0, z = 100, size = 40, color = {1, 0.4, 0.4} },
        { x = 100, y = 50, z = 200, size = 60, color = {0.4, 1, 0.4} },
        { x = -120, y = -60, z = 50, size = 30, color = {0.4, 0.4, 1} },
        { x = 0, y = 0, z = 150, size = 80, color = {1, 1, 0.4} },
        { x = 0, y = -100, z = 300, size = 90, color = {0.9, 0.9, 1.0}, glow = true }, -- LUNA
    }
end

function love.update(dt)
    for _, obj in ipairs(fk3d.objects) do
        local angle = dt * 0.5
        local x, z = obj.x, obj.z
        obj.x = x * math.cos(angle) - z * math.sin(angle)
        obj.z = x * math.sin(angle) + z * math.cos(angle)
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2

    table.sort(fk3d.objects, function(a, b) return a.z > b.z end)

    for _, obj in ipairs(fk3d.objects) do
        local scale = fk3d.camera.fov / (fk3d.camera.fov + obj.z)
        local sx = obj.x * scale
        local sy = obj.y * scale
        local size = obj.size * scale

        love.graphics.setColor(obj.color)
        love.graphics.circle("fill", cx + sx, cy + sy, size)
    end

    love.graphics.setCanvas()
    love.graphics.setShader(postShader)
    postShader:send('millis', love.timer.getTime() - iStartTime)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()

    love.graphics.print("FK3D + Canvas + Post-processing (Luna Glow)", 10, 10)
end