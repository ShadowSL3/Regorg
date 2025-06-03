
extern number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texColor = Texel(texture, texture_coords);
    float threshold = sin(time * 2.0) * 0.5 + 0.5;
    if (texColor.a < threshold) discard;
    return texColor * color;
}
