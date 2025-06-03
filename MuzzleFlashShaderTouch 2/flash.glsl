extern vec2 flashPos;
extern number alpha;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float dist = distance(tc, flashPos);
    float intensity = smoothstep(0.3, 0.0, dist);
    vec3 flashColor = vec3(1.0, 0.85, 0.5); // arancione-bianco
    return vec4(flashColor * intensity * alpha, intensity * alpha);
}