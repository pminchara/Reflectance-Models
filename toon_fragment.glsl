#version 410

struct Material
{
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

struct PointLight
{
	vec3 position;
	float intensity;
	vec3 color;
	float constant;
	float linear;
	float quadratic;
};

in vec3 vs_position;
in vec3 vs_color;
in vec2 vs_texcoord;
in vec3 vs_normal;

out vec4 fs_color;

uniform mat4 ViewMatrix;
uniform Material material;
uniform PointLight pointLight;
vec3 cameraPos  = vec3 (0.0, 0.0, 1.0);
const float material_kd = 0.8;
const float material_ks = 0.8;
  
float specular_exponent = 20.0;


void main(){

	// ambient intensity
	vec3 Ia = material.ambient;

	// diffuse intensity
	// raise light position to eye space
	vec3 light_position_eye = vec3 (ViewMatrix * vec4 (pointLight.position, 1.0));
	vec3 distance_to_light_eye = light_position_eye - vs_position;
	vec3 direction_to_light_eye = normalize (distance_to_light_eye);
	float dot_prod = dot (direction_to_light_eye, vs_normal);
	dot_prod = max (dot_prod, 0.0);
	int levels = 3;
	float toon_shade_diff = floor(dot_prod*levels)/levels;
	vec3 Id = material.diffuse * toon_shade_diff * material_kd; // final diffuse intensity
	
	// specular intensity
	vec3 surface_to_viewer_eye = normalize (-vs_position);	
	vec3 reflection_eye = reflect (-direction_to_light_eye, vs_normal);
	float dot_prod_specular = dot (reflection_eye, surface_to_viewer_eye);
	dot_prod_specular = max (dot_prod_specular, 0.0);
	float specular_factor = pow (dot_prod_specular, specular_exponent);	
	float toon_shade_spec = floor(specular_factor*levels)/levels;
	vec3 Is = material.specular * toon_shade_spec * material_ks ; // final specular intensity
	
	// final colour
	fs_color = vec4 (Is + Id + Ia, 1.0);
}