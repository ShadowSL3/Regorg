
extern number time;
vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
    vec2 uv = texCoords;
    uv.y += sin(uv.x * 10.0 + time) * 0.02;
    return Texel(tex, uv) * color;
}
