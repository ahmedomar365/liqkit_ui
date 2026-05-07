#version 460 core
#include <flutter/runtime_effect.glsl>

// liqkit_ui — Apple-Liquid-Glass-styled fragment shader.
//
// Designed for use with `BackdropFilter(filter: ImageFilter.shader(shader))`
// on Impeller (iOS/Android). The engine auto-binds:
//   • uSize (first vec2 uniform) = the saveLayer bounds in physical pixels.
//   • uBackdrop (first sampler2D) = the captured backdrop pixels at the
//     saveLayer bounds.
//
// Per-pixel pipeline inside the rounded-rect glass shape:
//   1. SDF coverage (anti-aliased mask).
//   2. Edge-bulge height field → surface normal.
//   3. Snell refraction → small backdrop-pixel displacement near rim.
//   4. 17-tap rosette blur (frosted material).
//   5. Mix toward tintColor (dark mode = near-black; light mode = near-white).
//   6. Always-visible material cues: top-edge highlight, bottom shadow,
//      ambient rim, optional Fresnel + chromatic + specular.
//   7. Premultiplied RGBA output (Flutter requires premultiplied).

uniform vec2 uSize;          // saveLayer pixel size (= glass tile pixel size)
uniform vec4 uParams1;       // x: radius, y: ior, z: thickness, w: edgeWidth
uniform vec4 uParams2;       // x: chroma, y: blurPx, z: rimBrightness, w: mode
uniform vec4 uTintRGB;       // x,y,z: RGB tint color; w: tint amount (0..1)
uniform sampler2D uBackdrop; // engine-bound captured backdrop

out vec4 fragColor;

float sdRoundRect(vec2 p, vec2 b, float r) {
  vec2 q = abs(p) - b + vec2(r);
  return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;

  // Unpack uniforms.
  float radius     = uParams1.x;
  float ior        = uParams1.y;
  float thickness  = uParams1.z;
  float edgeWidth  = uParams1.w;
  float chroma     = uParams2.x;
  float blurPx     = max(uParams2.y, 1.0);
  float rimBright  = max(uParams2.z, 0.0);
  float mode       = uParams2.w; // 0 = light, 1 = medium, 2 = full

  vec2 halfSize = uSize * 0.5;
  vec2 local    = frag - halfSize;

  // Coverage (anti-aliased).
  float d = sdRoundRect(local, halfSize, radius);
  float cov = 1.0 - smoothstep(-1.0, 1.0, d);
  if (cov <= 0.001) {
    fragColor = vec4(0.0);
    return;
  }

  // Edge bulge — height field is concentrated near the rim, interior is flat.
  float edge = exp(-(d * d) / max(edgeWidth * edgeWidth, 1.0));

  // SDF gradient (central differences).
  float e = 1.0;
  float gx = sdRoundRect(local + vec2(e, 0.0), halfSize, radius)
           - sdRoundRect(local - vec2(e, 0.0), halfSize, radius);
  float gy = sdRoundRect(local + vec2(0.0, e), halfSize, radius)
           - sdRoundRect(local - vec2(0.0, e), halfSize, radius);
  vec2 sdfGrad = vec2(gx, gy) / (2.0 * e);

  // Edge-bulge gradient → surface normal.
  vec2 gradH = edge * (-2.0 * d / max(edgeWidth * edgeWidth, 1.0))
             * sdfGrad * 18.0;
  vec3 N = normalize(vec3(-gradH.x, -gradH.y, 1.0));

  // Snell refraction → backdrop displacement (only near the rim).
  vec3 V = vec3(0.0, 0.0, -1.0);
  vec3 T = refract(V, N, 1.0 / max(ior, 1.01));
  float h = thickness * (0.45 + 0.55 * edge);
  vec2 offsetPx = T.xy * h / max(abs(T.z), 0.25);
  vec2 uv = clamp((frag + offsetPx) / uSize, vec2(0.0), vec2(1.0));

  // 17-tap rosette blur.
  vec2 u   = vec2(blurPx) / uSize;
  vec2 inn = u * 0.7071;
  vec2 outA = u * vec2(1.848, 0.765);
  vec2 outB = u * vec2(0.765, 1.848);

  vec3 sum = texture(uBackdrop, uv).rgb * 0.16;
  sum += texture(uBackdrop, clamp(uv + vec2( u.x,    0.0), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2(-u.x,    0.0), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2( 0.0,    u.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2( 0.0,   -u.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2( inn.x,  inn.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2( inn.x, -inn.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2(-inn.x,  inn.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2(-inn.x, -inn.y), vec2(0.0), vec2(1.0))).rgb * 0.06;
  sum += texture(uBackdrop, clamp(uv + vec2( outA.x,  outA.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2(-outA.x,  outA.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2( outA.x, -outA.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2(-outA.x, -outA.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2( outB.x,  outB.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2(-outB.x,  outB.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2( outB.x, -outB.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  sum += texture(uBackdrop, clamp(uv + vec2(-outB.x, -outB.y), vec2(0.0), vec2(1.0))).rgb * 0.045;
  vec3 blurred = sum;

  // Mix toward tint color, then a small vibrancy lift on very dark results.
  // The 0.02 ceiling is intentional — anything higher pushes dark-mode glass
  // toward a flat-gray look that breaks the "I can see through to the page"
  // illusion. Apple's vibrancyDark uses only a few %.
  float tintAmt = clamp(uTintRGB.w, 0.0, 1.0);
  vec3 tinted = mix(blurred, uTintRGB.rgb, tintAmt);
  float lum = dot(tinted, vec3(0.299, 0.587, 0.114));
  float vibrancy = smoothstep(0.30, 0.0, lum) * 0.02;
  vec3 backdrop = mix(tinted, vec3(1.0), vibrancy);

  // Always-visible material cues.
  float topLit       = clamp(N.y, 0.0, 1.0) * edge * 0.10 * rimBright;
  float bottomShadow = clamp(-N.y, 0.0, 1.0) * edge * 0.06 * rimBright;
  float perimeter    = edge * 0.05 * rimBright;

  // Schlick Fresnel.
  float f0 = pow((ior - 1.0) / (ior + 1.0), 2.0);
  float ndotv = clamp(dot(N, vec3(0.0, 0.0, 1.0)), 0.0, 1.0);
  float fresnel = f0 + (1.0 - f0) * pow(1.0 - ndotv, 5.0);

  vec3 color;
  if (mode < 0.5) {
    color = backdrop;
    color += vec3(topLit + perimeter);
    color *= 1.0 - bottomShadow;
  } else if (mode < 1.5) {
    color = backdrop;
    color += vec3(topLit + perimeter + fresnel * 0.10);
    color *= 1.0 - bottomShadow;
  } else {
    float chromaAmt = chroma * edge * 0.5;
    vec2 cOff = (offsetPx / uSize) * chromaAmt;
    float r = texture(uBackdrop, clamp(uv + cOff, vec2(0.0), vec2(1.0))).r;
    float b = texture(uBackdrop, clamp(uv - cOff, vec2(0.0), vec2(1.0))).b;
    vec3 chroma3 = vec3(r, blurred.g, b);
    chroma3 = mix(chroma3, uTintRGB.rgb, tintAmt);
    float clum = dot(chroma3, vec3(0.299, 0.587, 0.114));
    chroma3 = mix(chroma3, vec3(1.0), smoothstep(0.30, 0.0, clum) * 0.02);
    color = chroma3;
    color += vec3(topLit + perimeter + fresnel * 0.12);
    color *= 1.0 - bottomShadow;

    vec3 L = normalize(vec3(-0.35, -0.45, 0.82));
    vec3 H = normalize(L + vec3(0.0, 0.0, 1.0));
    float spec = pow(max(dot(N, H), 0.0), 80.0) * (0.12 + edge * 0.20);
    color += vec3(spec * 0.30 * rimBright);
  }

  // Premultiplied output.
  float alpha = cov;
  fragColor = vec4(color * alpha, alpha);
}
