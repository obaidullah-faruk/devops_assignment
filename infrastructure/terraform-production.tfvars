# ── Production environment ──────────────────────────────────────
# Apply: terraform apply -var-file=terraform-production.tfvars
# ───────────────────────────────────────────────────────────────

environment          = "production"
aws_region           = "us-east-1"
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# Image tag — overridden in CI/CD with the Git SHA being deployed
image_tag = "latest"

# ECS sizing — larger for prod
task_cpu              = 512
task_memory           = 1024
service_desired_count = 1

# ECR
ecr_image_tag_mutability = "IMMUTABLE"
ecr_scan_on_push         = true

# ALB
health_check_path = "/health"
certificate_arn   = "" # Set to your ACM certificate ARN to enable HTTPS

# WAF — full block mode in production
waf_block_mode        = true
waf_rate_limit_per_ip = 2000

# RDS
db_name                   = "appdb"
db_username               = "postgres"
rds_instance_class        = "db.t3.small"
rds_allocated_storage     = 20
rds_max_allocated_storage = 200
rds_multi_az              = true
rds_deletion_protection   = false
rds_skip_final_snapshot   = false
rds_backup_retention_days = 7
