shader_type canvas_item;

// GODOT 4.3+ FIX — THIS LINE IS REQUIRED
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

// ───── ALL CREEPY CONTROLS (tweakable in inspector) ─────
uniform bool enable_vhs = true;
uniform float scanline_count : hint_range(100.0, 800.0) = 320.0;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.3;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.18;
uniform float glitch_intensity : hint_range(0.0, 2.0) = 0.6;
uniform float roll_speed : hint_range(0.0, 30.0) = 7.0;
uniform float roll_amount : hint_range(0.0, 1.0) = 0.45;
uniform float tape_crease : hint_range(0.0, 1.0) = 0.4;
uniform float signal_loss : hint_range(0.0, 1.0) = 0.22;
uniform float chromatic_aberration : hint_range(0.0, 6.0) = 2.8;
uniform float curvature : hint_range(0.0, 6.0) = 2.2;
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.7;
uniform float creep_tint : hint_range(0.0, 2.0) = 1.0;
uniform float time_scale : hint_range(0.0, 3.0) = 1.0;

float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453); 
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = uv - 0.5;
    float dist = length(center);
    float t = TIME * time_scale;

    // Skip all effects if disabled
    if (!enable_vhs) {
        COLOR = texture(screen_tex, uv);
    } else {
        // ─── ROLLING TRACKING ERROR (horizontal jump) ───
        float roll = sin(uv.y * 25.0 + t * roll_speed) * roll_amount;
        uv.x += roll * 0.02;

        // ─── TAPE CREASE (wavy black lines) ───
        float crease = sin(uv.y * 12.0 - t * 0.9) * 0.5 + 0.5;
        crease *= rand(vec2(floor(uv.y * 80.0), t));
        uv.x -= crease * tape_crease * 0.015;

        // ─── CRT CURVATURE ───
        vec2 curved = uv + center * dist * curvature * 0.02;

        // ─── CHROMATIC ABERRATION (color split) ───
        vec3 col;
        col.r = texture(screen_tex, curved + vec2(chromatic_aberration, 0.0) * 0.001).r;
        col.g = texture(screen_tex, curved).g;
        col.b = texture(screen_tex, curved - vec2(chromatic_aberration, 0.0) * 0.001).b;

        // ─── SCANLINES ───
        float scan = sin(curved.y * scanline_count * 3.14159) * scanline_strength;
        col *= 1.0 - scan;

        // ─── HEAVY STATIC + GLITCH BARS ───
        float noise = rand(curved + t) * noise_strength;
        float glitch = step(0.98, rand(vec2(t * 3.0, uv.y * 10.0))) * glitch_intensity;
        col += noise + glitch;

        // ─── SIGNAL DROPOUTS (black flashes) ───
        float dropout = step(0.96, rand(vec2(t * 2.0, 0.0))) * signal_loss;
        col *= (1.0 - dropout);

        // ─── DARK VIGNETTE ───
        col *= 1.0 - dist * vignette_strength * 1.8;

        // ─── CREEPY COLOR TINT (green/blue rot) ───
        col += vec3(0.03, 0.07, 0.05) * creep_tint;

        COLOR.rgb = col;
        COLOR.a = 1.0;
    }
}