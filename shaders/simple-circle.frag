/*
 * Create a circle with a simple distance function
 */

#define CIRCLE_COLOR    vec4(1.0, 0.4313, 0.3411, 1.0)
#define OUTSIDE_COLOR   vec4(0.3804, 0.7647, 1.0, 1.0)

void main() {
  // default window is 500x500
  if (distance(gl_FragCoord.xy, vec2(250.0, 250.0)) < 128.0)
    gl_FragColor = CIRCLE_COLOR;
  else
    gl_FragColor = OUTSIDE_COLOR;
}
