
uniform mat4 u_modelMatrix;
uniform mat4 u_modelViewProjectionMatrix;
uniform mat4 u_normalMatrix; 

attribute vec4 a_position;
attribute vec3 a_normal;

varying vec3 v_position;
varying vec3 v_normal;

void main() {
  // calculate the location of the vert in world coordinates
  v_position = vec3(u_modelMatrix * a_position);

  // transform the normal from model space to world space (IRT light)
  // we have a pre-prepared normal matrix to do this
  v_normal = a_normal;

  gl_Position = u_modelViewProjectionMatrix * a_position;
}
