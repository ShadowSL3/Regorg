-- CRT shader for LÖVE based on Shadertoy example
-- https://www.shadertoy.com/view/Ms23DR

extern float millis; -- Time in milliseconds
extern vec2 screen_size; -- Screen resolution

vec2 curve(vec2 uv)
{
    uv = (uv - 0.5) * 2.0;
    uv *= 1.1;    
    uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
    uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
    uv = (uv / 2.0) + 0.5;
    uv = uv * 0.92 + 0.04;
    return uv;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = texture_coords;
    uv = curve(uv);
    
    // Check if we're outside the valid UV range
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }
    
    vec4 oricolv4 = Texel(tex, vec2(uv.x, uv.y));
    vec3 oricol = vec3(oricolv4.x, oricolv4.y, oricolv4.z);
    vec3 col;
    
    // Horizontal distortion
    float x = sin(0.3 * millis + uv.y * 21.0) * 
              sin(0.7 * millis + uv.y * 29.0) * 
              sin(0.3 + 0.33 * millis + uv.y * 31.0) * 0.0017;

    // RGB separation and ghosting effect
    col.r = Texel(tex, vec2(x + uv.x + 0.001, uv.y + 0.001)).x + 0.05;
    col.g = Texel(tex, vec2(x + uv.x + 0.000, uv.y - 0.002)).y + 0.05;
    col.b = Texel(tex, vec2(x + uv.x - 0.002, uv.y + 0.000)).z + 0.05;
    
    // Secondary ghost images
    col.r += 0.08 * Texel(tex, 0.75 * vec2(x + 0.025, -0.027) + vec2(uv.x + 0.001, uv.y + 0.001)).x;
    col.g += 0.05 * Texel(tex, 0.75 * vec2(x - 0.022, -0.02) + vec2(uv.x + 0.000, uv.y - 0.002)).y;
    col.b += 0.08 * Texel(tex, 0.75 * vec2(x - 0.02, -0.018) + vec2(uv.x - 0.002, uv.y + 0.000)).z;

    // Color correction
    col = clamp(col * 0.6 + 0.4 * col * col * 1.0, 0.0, 1.0);

    // Initial vignette
    float vig = (0.0 + 1.0 * 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
    col *= vec3(pow(vig, 0.3));

    // Color tuning
    col *= vec3(0.95, 1.05, 0.95);
    col *= 2.8;
    
    // Apply second RGB shift
    float distortion = sin(0.3 * millis + uv.y * 25.0) * 
                       sin(0.7 * millis + uv.y * 33.0) * 
                       sin(0.3 + 0.33 * millis + uv.y * 37.0) * 0.0022;
                       
    vec3 colShift;                   
    colShift.r = Texel(tex, uv + vec2(distortion + 0.003, 0.003)).r;
    colShift.g = Texel(tex, uv + vec2(distortion - 0.002, -0.002)).g;
    colShift.b = Texel(tex, uv + vec2(distortion - 0.004, 0.000)).b;
    
    // Mix the color shifts
    col = mix(col, colShift, 0.5);
    
    // Add bloom effect
    col += 0.5 * pow(col, vec3(2.0));
    
    // Scanlines based on screen coordinates
    float scans = clamp(0.35 + 0.35 * sin(3.5 * millis + uv.y * screen_coords.y * 1.5), 0.0, 1.0);
    float strength = pow(scans, 0.5);
    col *= vec3(0.3 + 0.7 * strength);
    
    float s = pow(scans, 5.7);
    col = col * vec3(0.4 + 0.7 * s);

    // Final vignette
    float vignette = (0.0 + 1.0 * 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
    col *= vec3(pow(vignette, 0.33));

    // Film grain
    float grain = fract(sin(dot(screen_coords.xy, vec2(12.9898, 87.255))) * 43758.5453);
    col *= 1.0 + 0.2 * (grain - 0.5);
    
    // Final touches
    col += 0.05 * pow(col, vec3(2.0));
    col *= 1.0 + 0.01 * sin(10.0 * millis);
    
    // Apply phosphor pattern (subtle CRT RGB pattern)
    col *= 1.0 - 0.65 * vec3(clamp((mod(screen_coords.x, 2.0) - 1.0) * 2.0, 0.0, 1.0));
    
    // Uncomment this to enable crossfade with original image
    // float comp = smoothstep(0.1, 0.9, sin(millis));
    // col = mix(col, oricol, comp);

    return vec4(col, oricolv4.a * color.a);
}