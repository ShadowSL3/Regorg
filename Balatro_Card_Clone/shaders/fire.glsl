
extern number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float flicker = abs(sin(texture_coords.y * 20.0 + time * 5.0)) * 0.5;
    vec4 pixel = Texel(texture, texture_coords);
    pixel.r += flicker * 0.2;
    pixel.g -= flicker * 0.1;
    return pixel * color;
}
