shader_type canvas_item;

uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float curvature : hint_range(0.0, 1.0) = 0.4;
uniform float glitch_strength : hint_range(0.0, 1.0) = 0.4;

vec2 apply_curvature(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    uv.x *= 1.0 + pow(uv.y, 2.0) * curvature * 0.3;
    uv.y *= 1.0 + pow(uv.x, 2.0) * curvature * 0.3;
    return uv * 0.5 + 0.5;
}

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec2 uv = apply_curvature(UV);
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0);
    }

    // Horizontal jitter on random scanlines
    float jitter_line = floor(uv.y * 40.0);
    float jitter = (rand(vec2(jitter_line, floor(TIME * 8.0))) - 0.5)
                   * glitch_strength * 0.04;
    uv.x = clamp(uv.x + jitter, 0.0, 1.0);

    // Rolling brightness band (interference)
    float roll = sin(uv.y * 3.0 - TIME * 2.5) * 0.08 * glitch_strength;

    vec4 col = texture(TEXTURE, uv);
    col.rgb += roll;

    // Slight colour channel split on glitched lines
    if (abs(jitter) > 0.005) {
        col.r = texture(TEXTURE, uv + vec2(0.005, 0.0)).r;
        col.b = texture(TEXTURE, uv - vec2(0.005, 0.0)).b;
    }

    // Noise grain
    float noise = rand(uv + vec2(TIME)) * 0.08 * glitch_strength;
    col.rgb += noise;

    // Scanlines
    float scan = sin(uv.y / TEXTURE_PIXEL_SIZE.y * PI);
    col.rgb *= 1.0 - scanline_intensity * 0.6 * (1.0 - scan * scan);

    // Vignette
    vec2 v = uv * (1.0 - uv.yx);
    col.rgb *= pow(v.x * v.y * 16.0, 0.3);

    COLOR = col;
}