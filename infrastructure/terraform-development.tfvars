# ── Development environment ─────────────────────────────────────
# Apply: terraform apply -var-file=terraform-development.tfvars
# ───────────────────────────────────────────────────────────────

environment          = "development"
aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# Image tag — overridden in CI/CD with the Git SHA being deployed
image_tag = "latest"

# ECS sizing — smaller for dev
task_cpu              = 256
task_memory           = 512
service_desired_count = 1

# ECR
ecr_image_tag_mutability = "MUTABLE"
ecr_scan_on_push         = true

# ALB
health_check_path = "/health"
certificate_arn   = "" # HTTP-only in dev; add ACM ARN to enable HTTPS

# WAF — count/audit mode in dev to avoid blocking legitimate traffic
waf_block_mode        = false
waf_rate_limit_per_ip = 5000

# RDS
db_name                   = "appdb"
db_username               = "postgres"
rds_instance_class        = "db.t3.micro"
rds_allocated_storage     = 20
rds_max_allocated_storage = 50
rds_multi_az              = false
rds_deletion_protection   = false
rds_skip_final_snapshot   = true
rds_backup_retention_days = 3
