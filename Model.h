#pragma once

#include"Mesh.h"
#include"Shader.h"
#include"Material.h"
#include"OBJLoader.h"

class Model
{
private:
	Material * material;
	std::vector<Mesh*> meshes;
	glm::vec3 position;
	glm::vec3 rotation;
	glm::vec3 scale;

	void updateUniforms()
	{

	}

public:
	Model(
		glm::vec3 position,
		Material* material,
		std::vector<Mesh*>& meshes
	)
	{
		this->position = position;
		this->material = material;

		for (auto* i : meshes)
		{
			this->meshes.push_back(new Mesh(*i));
		}

		for (auto& i : this->meshes)
		{
			i->move(this->position);
			i->setOrigin(this->position);
		}
	}

	//OBJ file loaded model
	Model(
		glm::vec3 position,
		Material* material,
		const char* objFile, glm::vec3 rotation, glm::vec3 scale
	)
	{
		this->position = position;
		this->material = material;
		this->rotation = rotation;
		this->scale = scale;

		std::vector<Vertex> mesh = loadOBJ(objFile);
		this->meshes.push_back(new Mesh(mesh.data(), mesh.size(), NULL, 0, glm::vec3(0.f, 0.f, 0.f),
			glm::vec3(0.f), this->rotation, this->scale));

		for (auto& i : this->meshes)
		{
			i->move(this->position);
			i->setOrigin(this->position);
		}
	}

	~Model()
	{
		for (auto*& i : this->meshes)
			delete i;
	}

	//Functions
	void rotate(const glm::vec3 rotation)
	{
		for (auto& i : this->meshes)
			i->rotate(rotation);
	}

	void update()
	{

	}

	void render(Shader* shader)
	{
		//Update the uniforms
		this->updateUniforms();

		//Update uniforms
		this->material->sendToShader(*shader);

		//Use a program (BECAUSE SHADER CLASS LAST UNIFORM UPDATE UNUSES IT)
		shader->use();

		//Draw
		for (auto& i : this->meshes)
		{
			i->render(shader); //Activates shader also
			i->rotate(glm::vec3(0.f, 0.1f, 0.f));
		}
	}
};
