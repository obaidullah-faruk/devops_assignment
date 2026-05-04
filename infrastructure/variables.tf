# ──────────────────────────────────────────────────────────────
# Root variables.tf
# ──────────────────────────────────────────────────────────────

# ── General ────────────────────────────────────────────────────
variable "project_name" {
  description = "Short name used to prefix all resources."
  type        = string
  default     = "devops-assessment"
}

variable "environment" {
  description = "Deployment environment: development | production."
  type        = string

  validation {
    condition     = contains(["development", "production"], var.environment)
    error_message = "environment must be 'development' or 'production'."
  }
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

# ── Networking ──────────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ, minimum 2)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ, minimum 2)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ── ECR ─────────────────────────────────────────────────────────
variable "ecr_image_tag_mutability" {
  description = "Image tag mutability: MUTABLE | IMMUTABLE."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable automatic vulnerability scanning on image push."
  type        = bool
  default     = true
}

# ── Container image tag ─────────────────────────────────────────
# The full image URI is derived automatically:
#   module.ecr.repository_url + ":" + var.image_tag
# Set this in CI/CD to the Git SHA or semantic version being deployed.
variable "image_tag" {
  description = "Docker image tag to deploy (e.g. git SHA or semver). Combined with the ECR repository URL."
  type        = string
  default     = "latest"
}

# ── ECS / Fargate ───────────────────────────────────────────────
variable "container_port" {
  description = "Port the application container listens on."
  type        = number
  default     = 8000
}

variable "task_cpu" {
  description = "CPU units for the ECS task (1 vCPU = 1024)."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MB) for the ECS task."
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Desired number of running ECS tasks."
  type        = number
  default     = 1
}

# ── ALB ─────────────────────────────────────────────────────────
variable "health_check_path" {
  description = "HTTP path used by the ALB target-group health check."
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS. Leave empty string to use HTTP only."
  type        = string
  default     = ""
}

# ── WAF ─────────────────────────────────────────────────────────
variable "waf_block_mode" {
  description = "Set WAF managed rules to BLOCK (true) or COUNT/audit mode (false)."
  type        = bool
  default     = true
}

variable "waf_rate_limit_per_ip" {
  description = "Maximum requests per 5-minute window per source IP before blocking."
  type        = number
  default     = 2000
}

# ── RDS ─────────────────────────────────────────────────────────
variable "db_name" {
  description = "PostgreSQL database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username."
  type        = string
  default     = "postgres"
}

variable "rds_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Initial allocated storage in GB."
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum autoscaled storage in GB."
  type        = number
  default     = 100
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment for high availability."
  type        = bool
  default     = false
}

variable "rds_deletion_protection" {
  description = "Prevent the RDS instance from being deleted."
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on destroy. Set to false in production."
  type        = bool
  default     = true
}

variable "rds_backup_retention_days" {
  description = "Number of days to retain automated RDS backups."
  type        = number
  default     = 7
}
