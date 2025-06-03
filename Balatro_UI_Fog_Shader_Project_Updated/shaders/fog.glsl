extern number time;
extern vec2 resolution;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    float fog = sin((screen_coords.y + time * 50.0) * 0.01) * 0.05;
    fog += 0.08 * (screen_coords.y / resolution.y);
    return vec4(vec3(0.1, 0.1, 0.1) + fog, 1.0);
}