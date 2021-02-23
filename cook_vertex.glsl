#version 440

layout (location = 0) in vec3 vertex_position;
layout (location = 1) in vec3 vertex_color;
layout (location = 2) in vec2 vertex_texcoord;
layout (location = 3) in vec3 vertex_normal;

out vec3 vs_position;
out vec3 vs_color;
out vec2 vs_texcoord;
out vec3 vs_normal;
out vec3 vsViewDir;
out vec3 vsLightDir;
out float vsLightDistance;


uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 ortho = mat4(
		1.0f, 0.0f, 0.0f, 0.0f,
		0.0f, 1.0f, 0.0f, 0.0f,
		0.0f, 0.0f, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f
	);
uniform vec3 viewPos = vec3(0.f, 0.f, 1.f);
uniform vec3 lightPos = vec3(0.f, 0.f, 1.f);

void main()
{
	vs_position = vec4(ModelMatrix * vec4(vertex_position, 1.f)).xyz;
	vs_color = vertex_color;
	vs_texcoord = vec2(vertex_texcoord.x, vertex_texcoord.y * -1.f);
	vec4 fragPos = (ModelMatrix * vec4(vertex_position, 1.0));
	vs_normal = (ModelMatrix * vec4(vertex_normal, 0)).xyz;
	vsViewDir = normalize(viewPos - fragPos.xyz);
	vsLightDir = lightPos - fragPos.xyz;
	vsLightDistance = length(vsLightDir);
	vsLightDir /= vsLightDistance;
	vsLightDistance *= vsLightDistance;
	gl_Position =  ProjectionMatrix * ViewMatrix * ModelMatrix * ortho* vec4 (vertex_position, 1.0);
}