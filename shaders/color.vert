
uniform mat4 u_modelViewProjectionMatrix;

attribute vec4 a_position;

void main() {
  vec4 pos = u_modelViewProjectionMatrix * a_position;
  gl_Position = pos;
}
