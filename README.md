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

## To Run a client
```
uv run --with requests python test_api.py
```



## Prompts Used

**Prompt 1**
> "Dockerize this fastapi application. Write a Dockerfile using python:3.13-slim as the base image. Install uv inside the container and use uv sync to install dependencies. Then write a docker-compose.yml file that spins up the app and a postgresql 18 database. Please use .env.example as a template for the environment variables."

**Prompt 2**
> "
api.py
Write a single file python script as a client to quickly test these 4 api endpoints "

**Prompt 3**
> "I need to instrument this FastAPI app for the AWS Distro for OpenTelemetry (ADOT). Please update pyproject.toml with the necessary standard OpenTelemetry Python packages (API, SDK, FastAPI instrumentation, and OTLP exporter). Then, update src/main.py to initialize tracing and send traces to a local OTLP endpoint."

**Prompt 4**
> "Update the docker-compose.yml to include a local AWS OTel Collector sidecar (amazon/aws-otel-collector) and a Jaeger container (jaegertracing/all-in-one:latest). Provide a basic otel-local-config.yaml to configure the ADOT collector to export traces to the local Jaeger instance, so that I can view them in the browser at http://localhost:16686."
