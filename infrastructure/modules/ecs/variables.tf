variable "name_prefix" {
  description = "Prefix applied to all ECS resource names."
  type        = string
}

variable "environment" {
  description = "Deployment environment passed as an env var to the container."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to place ECS tasks in."
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group."
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB (used to allow ingress to tasks)."
  type        = string
}

variable "task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role."
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS Task Role."
  type        = string
}

variable "container_image" {
  description = "Full ECR image URI including tag."
  type        = string
}

variable "container_port" {
  description = "Port the container listens on."
  type        = number
  default     = 8000
}

variable "task_cpu" {
  description = "CPU units for the Fargate task."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MB) for the Fargate task."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of task replicas to run."
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "AWS region (used for CloudWatch log configuration)."
  type        = string
}

variable "database_url" {
  description = "Full PostgreSQL connection string passed to the container."
  type        = string
  sensitive   = true
  default     = ""
}
