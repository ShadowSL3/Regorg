vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float scanline = sin(tc.y * 800.0) * 0.04;
    return Texel(tex, tc) - vec4(scanline, scanline, scanline, 0.0);
}