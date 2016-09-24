
uniform mat4 u_modelViewProjectionMatrix;

attribute vec4 a_position;
attribute vec3 a_normal;

varying vec3 v_normal;

void main() {
  v_normal = a_normal;

  vec4 pos = u_modelViewProjectionMatrix * a_position;
  gl_Position = pos;
}
