# Devops Assessment

## Base Repository
https://github.com/goldkinen/python-fastapi-template.git

## How to Run

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
git clone https://github.com/goldkinen/devops-assessment.git
cd devops-assessment
uv venv --python 3.13
source .venv/bin/activate
uv sync

export PYTHONPATH=$(pwd)
export $(xargs < .env)
uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload
```

## To Run using Docker 
```
docker compose up --build

```



## Prompts Used

**Prompt 1**
> "Dockerize this fastapi application. Write a Dockerfile using python:3.13-slim as the base image. Install uv inside the container and use uv sync to install dependencies. Then write a docker-compose.yml file that spins up the app and a postgresql 18 database. Please use .env.example as a template for the environment variables."

