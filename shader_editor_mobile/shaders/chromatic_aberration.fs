
vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
    float offset = 0.005;
    float r = Texel(tex, texCoords + vec2(offset, 0.0)).r;
    float g = Texel(tex, texCoords).g;
    float b = Texel(tex, texCoords - vec2(offset, 0.0)).b;
    return vec4(r, g, b, 1.0) * color;
}
