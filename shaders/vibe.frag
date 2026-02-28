#include <flutter/runtime_effect.glsl>

uniform vec2 uScreenSize;
uniform float uTime;
uniform float uScale;

uniform float uBgBrightness;

uniform vec3 uColor0;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
uniform vec3 uColor5;

uniform vec3 uRotation0;
uniform vec3 uRotation1;
uniform vec3 uRotation2;

out vec4 fragColor;

vec4 permute(vec4 x) { return mod(((x * 34.0) + 1.0) * x, 289.0); }
vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

float snoise3(vec3 v) {
  const vec2 C = vec2(0.1666667, 0.3333333);
  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

  vec3 i  = floor(v + dot(v, C.yyy));
  vec3 x0 = v - i + dot(i, C.xxx);

  vec3 g  = step(x0.yzx, x0.xyz);
  vec3 l  = 1.0 - g;
  vec3 i1 = min(g.xyz, l.zxy);
  vec3 i2 = max(g.xyz, l.zxy);

  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + 2.0 * C.xxx;
  vec3 x3 = x0 - 1.0 + 3.0 * C.xxx;

  i = mod(i, 289.0);
  vec4 p = permute(permute(permute(
               i.z + vec4(0.0, i1.z, i2.z, 1.0))
             + i.y + vec4(0.0, i1.y, i2.y, 1.0))
             + i.x + vec4(0.0, i1.x, i2.x, 1.0));

  float n_ = 0.142857142857;
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_);

  vec4 x = x_ * ns.x + ns.yyyy;
  vec4 y = y_ * ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4(x.xy, y.xy);
  vec4 b1 = vec4(x.zw, y.zw);

  vec4 s0 = floor(b0) * 2.0 + 1.0;
  vec4 s1 = floor(b1) * 2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
  vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

  vec3 p0 = vec3(a0.xy, h.x);
  vec3 p1 = vec3(a0.zw, h.y);
  vec3 p2 = vec3(a1.xy, h.z);
  vec3 p3 = vec3(a1.zw, h.w);

  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2,p2), dot(p3,p3)));
  p0 *= norm.x; p1 *= norm.y; p2 *= norm.z; p3 *= norm.w;

  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot(m * m, vec4(dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3)));
}

float tri(in float x) { return abs(fract(x) - 0.5); }
vec3  tri3(in vec3 p)  { return vec3(tri(p.z + tri(p.y * 20.0)),
                                     tri(p.z + tri(p.x * 1.0)),
                                     tri(p.y + tri(p.x * 1.0))); }

float triNoise3D(in vec3 p, in float spd) {
  float z  = 0.4;
  float rz = 0.1;
  vec3  bp = p;
  for (float i = 0.0; i <= 4.0; i++) {
    vec3 dg = tri3(bp * 0.01);
    p += (dg + uTime * 0.1 * spd);
    bp *= 4.0;
    z  *= 0.9;
    p  *= 1.6;
    rz += (tri(p.z + tri(0.6 * p.x + 0.1 * tri(p.y)))) / z;
  }
  return smoothstep(0.0, 8.0, rz + sin(rz + sin(z) * 2.8) * 2.2);
}

vec2 rotate(vec2 p, float a) {
  float s = sin(a), c = cos(a);
  return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float light(float intensity, float attenuation, float dist) {
  return intensity / (1.0 + dist + dist * attenuation);
}

vec4 makeNoiseBlob2(vec2 uv, vec3 color1, vec3 color2, float strength, float offset) {
  float len = length(uv);
  float n0  = snoise3(vec3(uv * 1.2 + offset, uTime * 0.5 + offset)) * 0.5 + 0.5;
  float r0  = mix(0.0, 1.0, n0);
  float d0  = distance(uv, r0 / max(len, 0.0001) * uv);
  float v0  = smoothstep(r0 + 0.1 + (sin(uTime + offset) + 1.0), r0, len);
  float v1  = light(0.15 * (1.0 + 1.5 * (-sin(uTime * 2.0 + offset * 0.5) * 0.5)) + 0.3 * strength, 10.0, d0);

  vec3 col = mix(color1, color2, uv.y * 2.0);
  col = clamp(col + v1, 0.0, 1.0);
  return vec4(col, v0);
}

vec4 makeBlob(vec2 uv,
              float blob,
              vec3 color1,
              vec3 color2,
              float width,
              float baseReaction,
              float offset,
              vec2 noiseOffset) {
  float len         = length(uv);
  float outerRadius = blob + width * 0.5 + baseReaction;
  vec4  noise       = makeNoiseBlob2(uv + noiseOffset, color1, color2, 0.0, offset);
  noise.a           = mix(0.0, noise.a, smoothstep(outerRadius, 0.5, len));
  return noise;
}

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;

  vec2 uv = fragCoord / uScreenSize.xy;
  uv = uv * 2.0 - 1.0;
  uv.y *= uScreenSize.y / min(uScreenSize.x, uScreenSize.y) / uScale;
  uv.x *= uScreenSize.x / min(uScreenSize.x, uScreenSize.y) / uScale;

  vec2  ruv  = uv * 2.0;
  float pa   = atan(ruv.y, ruv.x);
  float idx  = (pa / 3.1415) / 2.0;

  vec2  ruv1 = rotate(uv * 2.0, 3.1415);
  float pa1  = atan(ruv1.y, ruv1.x);
  float idx1 = (pa1 / 3.1415) / 2.0;
  float idx21= (pa1 / 3.1415 + 1.0) / 2.0 * 3.1415;

  float spark = triNoise3D(vec3(idx, 0.0, 0.0), 0.1);
  spark = mix(spark, triNoise3D(vec3(idx1, 0.0, idx1), 0.1), smoothstep(0.9, 1.0, sin(idx21)));
  spark = spark * 0.2 + pow(spark, 10.0);
  spark = smoothstep(0.0, spark, 0.3) * spark;

  vec3 bg    = vec3(uBgBrightness);
  vec3 color = vec3(0.0);

  float n0 = snoise3(vec3(uv * 1.2, uTime * 0.5));

  vec3 colors[6];
  colors[0] = uColor0; colors[1] = uColor1; colors[2] = uColor2;
  colors[3] = uColor3; colors[4] = uColor4; colors[5] = uColor5;

  vec3 rots[3];
  rots[0] = uRotation0; rots[1] = uRotation1; rots[2] = uRotation2;

  float CIRCLE_WIDTH_BASE  = 0.8;
  float CIRCLE_WIDTH_STEP  = 0.2;
  float SPARK_STRENGTH_BASE= 1.0;
  float SPARK_STRENGTH_STEP= 0.3;
  float CIRCLE_RADIUS_BASE = 0.95;
  float CIRCLE_RADIUS_STEP = 0.15;
  float CIRCLE_OFFSET_STEP = 1.57;

  float totalAlpha = 0.0;

  for (int i = 0; i < 3; i++) {
    float fi     = float(i);
    float radius = CIRCLE_RADIUS_BASE - CIRCLE_RADIUS_STEP * fi;
    vec4  blob   = makeBlob(
      uv,
      mix(radius, radius + 0.3, n0),
      colors[i],
      colors[i + 3],
      CIRCLE_WIDTH_BASE - CIRCLE_WIDTH_STEP * fi,
      (SPARK_STRENGTH_BASE - SPARK_STRENGTH_STEP * fi) * spark,
      CIRCLE_OFFSET_STEP * fi,
      rotate(rots[i].xy, uTime * rots[i].z)
    );
    color = mix(color, blob.rgb, blob.a);
    totalAlpha = totalAlpha + blob.a * (1.0 - totalAlpha);
  }

  float bgAlpha = uBgBrightness;
  float finalAlpha = clamp(totalAlpha + bgAlpha, 0.0, 1.0);
  color = mix(color, bg, bgAlpha * (1.0 - totalAlpha));

  vec2 uvNorm = fragCoord / uScreenSize.xy;
  vec2 edge = smoothstep(0.0, 0.15, uvNorm) * smoothstep(0.0, 0.15, 1.0 - uvNorm);
  float edgeFade = edge.x * edge.y;

  fragColor = vec4(color, finalAlpha * edgeFade);
}
