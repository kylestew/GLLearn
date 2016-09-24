
uniform mat4 u_normalMatrix;

struct Light {
  vec3 position;
  vec3 intensity;
} light;

varying vec3 v_position;
varying vec3 v_normal;

void main() {
  // create a light source
  light.position = vec3(1, 0, 2);
  light.intensity = vec3(1, 1, 1);

  // ambient light
  vec3 ambient = vec3(0.1, 0.1, 0.1);

  // calculate the vector from this fragments surface to the light source
  vec3 surfaceToLight = normalize(light.position - v_position);

  // calculate the cosine of the angle of incidence
  vec4 norm = vec4(v_normal, 0) * u_normalMatrix;
  float brightness = max(dot(norm.xyz, surfaceToLight), 0.0);

  // define diffuse color of material
  vec3 matDiffuse = vec3(1, 0, 0);

  // lambertian shading
  vec3 color = ambient + matDiffuse * light.intensity * brightness;

  gl_FragColor = vec4(color, 1.0);
}
