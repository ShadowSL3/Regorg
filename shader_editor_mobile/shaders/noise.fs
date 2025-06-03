
extern number time;
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}
vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
    float noise = rand(texCoords + time);
    vec4 pixel = Texel(tex, texCoords);
    return pixel + vec4(noise * 0.2, noise * 0.2, noise * 0.2, 0.0);
}
