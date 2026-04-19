shader_type canvas_item;

uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float curvature : hint_range(0.0, 1.0) = 0.3;

vec2 apply_curvature(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    uv.x *= 1.0 + pow(uv.y, 2.0) * curvature * 0.3;
    uv.y *= 1.0 + pow(uv.x, 2.0) * curvature * 0.3;
    return uv * 0.5 + 0.5;
}

void fragment() {
    vec2 uv = apply_curvature(UV);
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0);
    }

    vec4 col = texture(TEXTURE, uv);

    // Green phosphor tint — kill red and blue channels
    col.r *= 0.15;
    col.g *= 1.15;
    col.b *= 0.15;

    // Scanlines
    float scan = sin(uv.y / TEXTURE_PIXEL_SIZE.y * PI);
    col.rgb *= 1.0 - scanline_intensity * 0.6 * (1.0 - scan * scan);

    // Vignette
    vec2 v = uv * (1.0 - uv.yx);
    col.rgb *= pow(v.x * v.y * 16.0, 0.35);

    COLOR = col;
}