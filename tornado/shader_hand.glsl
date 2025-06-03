extern number time;
extern vec2 resolution;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 78.233);
    return fract(p.x * p.y);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    float a = hash(i);
    float b = hash(i+vec2(1.0,0.0));
    float c = hash(i+vec2(0.0,1.0));
    float d = hash(i+vec2(1.0,1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p){
    float total = 0.0;
    float amplitude = 0.5;
    for (int i=0; i<5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
    vec2 uv = (screen_coords.xy / resolution.xy) * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    // Forma base della mano (ellisse + dita proceduralmente definite)
    float handShape = smoothstep(0.3, 0.0, length(uv - vec2(0.0, 0.0)));
    handShape *= smoothstep(0.05, 0.0, abs(uv.x) - 0.15);
    handShape *= smoothstep(0.5, 0.0, uv.y);

    // Aggiunta dita
    for (int i = -2; i <= 2; i++) {
        vec2 fingerPos = uv - vec2(float(i) * 0.1, 0.3);
        handShape += smoothstep(0.08, 0.0, length(fingerPos));
    }

    // Glow dinamico con FBM
    float glow = fbm(uv * 4.0 + time * 0.5) * 0.5 + 0.5;

    // Combinazione mano + glow
    float intensity = handShape * glow;

    // Colore mistico
    vec3 finalColor = mix(vec3(0.2, 0.5, 1.0), vec3(0.8, 1.0, 1.0), glow);

    return vec4(finalColor, intensity);
}