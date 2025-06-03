extern number time;
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc)
{
    float intensity = 0.2 + 0.1 * sin(time * 2.0);
    return vec4(intensity, intensity * 0.9, intensity * 0.6, 1.0);
}