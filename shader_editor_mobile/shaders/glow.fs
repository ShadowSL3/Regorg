
extern number time;
vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
    vec4 pixel = Texel(tex, texCoords);
    float glow = abs(sin(time)) * 0.5;
    return pixel + vec4(glow, glow, glow, 1.0);
}
