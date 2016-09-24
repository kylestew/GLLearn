
// provided uniforms from glslViewer
uniform vec2 u_resolution;

void main() {
  // normalize frag coord from its space to screen space [0, 1]
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  // == coordinates ==
  // X, Y --> Red, Green
  // Bottom Left: 0, 0 - black
  // Top Left: 0, 1 - green
  // Bottom Right: 1, 0 - red
  // Top Right: 1, 1 - yellow
  vec4 col = vec4(gl_FragCoord.xy / u_resolution.xy, 0, 1);

  gl_FragColor = col;
}
