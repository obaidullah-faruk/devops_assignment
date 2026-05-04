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

## Terraform commands to deploy infrastructure
```bash
terraform init
terraform plan -var-file=terraform-development.tfvars
terraform apply -var-file=terraform-development.tfvars

terraform plan -var-file=terraform-production.tfvars
terraform apply -var-file=terraform-production.tfvars
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

**Prompt 5**
> "Logs and traces must correlate. Please update the application's logging configuration so that the OpenTelemetry trace_id and span_id are automatically injected into the JSON log output for every request. Also add a few logger.info() statements inside the src/modules/hero/api.py endpoints so that I have some actual log messages to test the correlation with."

**Prompt 6**
> "Create Terraform infrastructure inside an "infrastructure" directory.

Region: us-east-1
Structure:
- main.tf
- variables.tf
- providers.tf
- backend.tf
- terraform-production.tfvars
- terraform-development.tfvars

Use modular architecture with modules:
- modules/networking
- modules/alb
- modules/ecs
- modules/ecr
- modules/iam
- modules/waf

Backend:
- Use S3 bucket "goldkinen-devops-assignment-terraform-state"
- Enable native state locking with use_lockfile = true
- Do not use DynamoDB

Networking module:
- Create VPC
- 2 public subnets (for ALB across AZs)
- 2 private subnets (for ECS Fargate and optional RDS)
- Internet Gateway
- Route tables
- Single NAT Gateway in one public subnet

WAF:
- Create WAFv2 WebACL (REGIONAL)
- Use AWS managed core rule set
- Attach WebACL to ALB

General:
- Use variables for environment (dev/prod)
- Separate tfvars for development and production
- Ensure modules expose outputs and are reusable

Use the latest terraform version"

**Prompt 7**
> "Instead of manual db_password, create a random password and made it sensitive in terraform and use it in the database."

**Prompt 8**
> "Update the Terraform configuration to complete the missing IAM setup.

IAM:
- In iam.tf, attach the AWS managed policy:
  arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess
- Attach this policy to the ECS Task Role
- Keep existing policies:
  - AmazonECSTaskExecutionRolePolicy (for execution role)
  - CloudWatch Logs permissions
- Remove any inline X-Ray policies that duplicate this functionality"

**Prompt 9**
>"Create Terraform configuration to enable GitHub Actions OIDC authentication with AWS.
- Create an IAM OIDC identity provider for GitHub
- Create an IAM Role for GitHub Actions:

  - Restrict access to my GitHub repository 
https://github.com/obaidullah-faruk/devops_assignment (only for main branch)

- Attach policies to the role to allow:
  - ECR (push images)
  - ECS (update service)
  - IAM PassRole (for ECS task execution)"