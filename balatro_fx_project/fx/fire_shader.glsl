extern number u_time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float fire = sin(screen_coords.y * 0.05 + u_time * 3.0) * 0.2;
    float glow = abs(sin(u_time * 2.0)) * 0.5 + 0.5;
    return vec4(1.0, 0.3 + fire, 0.1, glow);
}