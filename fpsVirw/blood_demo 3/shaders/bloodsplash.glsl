extern number alpha;
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    float dist = length(screen_coords - love_ScreenSize.xy * 0.5);
    float factor = 1.0 - smoothstep(0.0, 200.0, dist);
    return vec4(color.rgb * factor, color.a * alpha);
}
