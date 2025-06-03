extern number time;
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc)
{
    float brightness = abs(sin(time)) * 0.3;
    return vec4(brightness, brightness * 0.8, brightness * 0.6, 1.0);
}