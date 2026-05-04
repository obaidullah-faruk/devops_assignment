variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository (owner/repo) to restrict OIDC access to."
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository to allow pushing images to."
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role to pass."
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role to pass."
  type        = string
}
