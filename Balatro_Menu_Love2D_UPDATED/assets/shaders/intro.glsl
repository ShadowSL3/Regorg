extern number time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float t = mod(time, 10.0);
    float offset = sin(t * 2.0 + tc.y * 10.0) * 0.01;
    vec4 pixel = Texel(tex, vec2(tc.x + offset, tc.y));
    return pixel * color;
}
