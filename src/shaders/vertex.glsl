varying vec2 vUv;
varying float vDistort;

uniform float u_time;
uniform float uSpeed;
uniform float uNoiseDensity;
uniform float uNoiseStrength;
uniform float uFreq;
uniform float uAmp;

#pragma glslify: pnoise = require(glsl-noise/periodic/3d)
#pragma glslify: rotateY = require(glsl-rotate/rotateY)

void main() {
  vUv = uv;

  float t = u_time * uSpeed;
  // You can also use classic perlin noise or simplex noise,
  // I'm using its periodic variant out of curiosity
  float distortion = pnoise((normal + t), vec3(10.0) * uNoiseDensity) * uNoiseStrength;

  // Disturb each vertex along the direction of its normal
  vec3 pos = position + (normal * distortion);

  // Create a sine wave from top to bottom of the sphere
  // To increase the amount of waves, we'll use uFreq
  // To make the waves bigger we'll use uAmp
  float angle = sin(uv.y * uFreq + t) * uAmp;
  pos = rotateY(pos, angle);

  vDistort = distortion;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}