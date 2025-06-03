
vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
    vec4 sum = vec4(0.0);
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            sum += Texel(tex, texCoords + vec2(x, y) * 0.002);
        }
    }
    return sum / 9.0;
}
