extern number time;
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords;
    float scanline = sin(screen_coords.y * 12.0 + time * 5.0) * 0.02;
    vec4 texcolor = Texel(tex, uv + vec2(0.0, scanline));
    return texcolor * color;
}