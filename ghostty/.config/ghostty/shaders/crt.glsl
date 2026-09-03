// ─────────────────────────────────────────────────────────────────────────
//  Subtle CRT shader for Ghostty
//  Effects: screen curvature, bloom, scanlines, vignette.
//  All effects are intentionally mild. Tweak the knobs in CONFIG below.
//  Shadertoy-compatible: iChannel0 = terminal output, iResolution, iTime.
// ─────────────────────────────────────────────────────────────────────────

// ── CONFIG ── tweak these, higher = stronger ──────────────────────────────
const float CURVATURE   = 0.03;  // screen bend. 0.0 = flat, ~0.3 = chunky CRT
const float BLOOM       = 0.45;  // glow bleed from bright text
const float BLOOM_RADIUS= 2.0;   // how far the glow spreads (in pixels * this)
const float SCANLINE    = 0.22;  // dark horizontal line strength. 0 = off
const float SCAN_DENSITY= 1.0;   // 1.0 = one line per physical pixel row
const float VIGNETTE    = 0.18;  // corner darkening
const float ABERRATION  = 0.0008;// RGB color fringing at the edges (subtle)
// ───────────────────────────────────────────────────────────────────────────

// Barrel-distort the UVs to simulate a curved glass tube.
vec2 curve(vec2 uv) {
    uv = uv * 2.0 - 1.0;                       // -1 .. 1
    vec2 offset = abs(uv.yx) / vec2(6.0, 4.0);
    uv = uv + uv * offset * offset * CURVATURE * 6.0;
    return uv * 0.5 + 0.5;                      // back to 0 .. 1
}

// Cheap bloom: sample neighbours, keep only their bright parts, add back.
vec3 bloom(vec2 uv) {
    vec2 px = (1.0 / iResolution.xy) * BLOOM_RADIUS;
    vec3 sum = vec3(0.0);
    // 3x3 weighted taps — light but enough to glow
    sum += texture(iChannel0, uv + px * vec2(-1.0, -1.0)).rgb * 0.5;
    sum += texture(iChannel0, uv + px * vec2( 0.0, -1.0)).rgb * 0.75;
    sum += texture(iChannel0, uv + px * vec2( 1.0, -1.0)).rgb * 0.5;
    sum += texture(iChannel0, uv + px * vec2(-1.0,  0.0)).rgb * 0.75;
    sum += texture(iChannel0, uv + px * vec2( 1.0,  0.0)).rgb * 0.75;
    sum += texture(iChannel0, uv + px * vec2(-1.0,  1.0)).rgb * 0.5;
    sum += texture(iChannel0, uv + px * vec2( 0.0,  1.0)).rgb * 0.75;
    sum += texture(iChannel0, uv + px * vec2( 1.0,  1.0)).rgb * 0.5;
    sum /= 5.5;
    return max(sum - 0.15, 0.0);               // only the brighter bits glow
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    // 1) Curvature
    vec2 cuv = curve(uv);

    // Anything that curved off the glass is black bezel.
    if (cuv.x < 0.0 || cuv.x > 1.0 || cuv.y < 0.0 || cuv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // 2) Base color with a touch of chromatic aberration toward the edges
    vec2 dir = cuv - 0.5;
    vec3 col;
    col.r = texture(iChannel0, cuv + dir * ABERRATION).r;
    col.g = texture(iChannel0, cuv).g;
    col.b = texture(iChannel0, cuv - dir * ABERRATION).b;

    // 3) Bloom
    col += bloom(cuv) * BLOOM;

    // 4) Scanlines — dark line every physical row
    float scan = sin(cuv.y * iResolution.y * 3.14159 * SCAN_DENSITY);
    col *= 1.0 - SCANLINE * (0.5 + 0.5 * scan);

    // 5) Vignette
    float vig = 1.0 - dot(dir, dir) * VIGNETTE * 4.0;
    col *= clamp(vig, 0.0, 1.0);

    fragColor = vec4(col, 1.0);
}
