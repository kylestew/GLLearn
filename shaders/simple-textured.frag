
// glslViewer feeds in textures in order of arguments
uniform sampler2D u_tex0;
uniform vec2 u_tex0Resolution;

uniform vec2 u_resolution;
uniform float u_time;

void main() {
  // need to normalize frag coord from its space
  // see: screen-mapped.frag
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  // account for window aspect ratio
  float aspect = u_resolution.x / u_resolution.y;
  st.x *= aspect;

  // account for image aspect ratio
  float imgAspect = u_tex0Resolution.x / u_tex0Resolution.y;
  // sample texture
  vec4 img = texture2D(u_tex0, st * vec2(1., imgAspect));

  // mix with a color
  vec3 col = vec3(st.x, st.y, (1.0 + sin(u_time)) * 0.5);
  col = mix(col, img.rgb, img.a);

  gl_FragColor = vec4(col, 1.0);
}
