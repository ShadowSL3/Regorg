extern number time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float scanline = sin(tc.y * love_ScreenSize.y * 3.1415) * 0.04;
    float vignette = smoothstep(0.0, 0.5, distance(tc, vec2(0.5))) * 0.5;
    vec4 pixel = Texel(tex, tc);
    pixel.rgb += scanline - vignette;
    return pixel * color;
}
