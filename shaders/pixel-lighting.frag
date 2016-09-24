
uniform vec3 u_eye;

varying vec4 v_worldPosition;
varying vec3 v_worldNormal;

struct Light {
  vec3 position;
  vec3 intensity;
} light;

void main() {
  // create a light source
  light.position = vec3(1.5, 0.5, 1.5); // specified in world space
  light.intensity = vec3(1, 1, 1);

  // material color
  vec3 ambient = vec3(0.08, 0.08, 0.08);
  vec3 matDiffuse = vec3(0, 0, 1);
  vec3 matSpecular = 0.6 * vec3(190.0/255.0, 0.0, 1.0);
  float materialShininess = 1.0;

  // calculate the vector from this fragments surface to the light source
  // both are in world space
  vec3 surfaceToLight = normalize(light.position - v_worldPosition.xyz);

  // diffuse component - calculate the cosine of the angle of incidence
  vec3 normal = normalize(v_worldNormal);
  float diffuseFactor = max(dot(normal, surfaceToLight), 0.0);

  // specular component - calculate the cosine of the angle between the reflected beam and the viewer
  vec3 incidenceVector = -surfaceToLight;
  vec3 reflectionVector = reflect(incidenceVector, normal);
  vec3 surfaceToCamera = normalize(u_eye - v_worldPosition.xyz);
  float cosAngle = max(0.0, dot(surfaceToCamera, reflectionVector));
  float specularFactor = pow(cosAngle, materialShininess);

  // phong lighting model
  vec3 color = ambient + matDiffuse * light.intensity * diffuseFactor + specularFactor * matSpecular;

  gl_FragColor = vec4(color, 1.0);
}
