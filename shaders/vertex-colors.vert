
uniform mat4 u_modelViewProjectionMatrix;

attribute vec4 a_position;
attribute vec4 a_color;

varying vec4 color;

void main() {
  color = vec4(a_color.xyz, 1.0);

  gl_Position = u_modelViewProjectionMatrix * a_position;
}
