# ──────────────────────────────────────────────────────────────
# Root main.tf — wires all modules together
# container_image is derived automatically from the ECR module.
# ──────────────────────────────────────────────────────────────

locals {
  env_short       = var.environment == "development" ? "dev" : "prod"
  name_prefix     = "${var.project_name}-${local.env_short}"
  container_image = "${module.ecr.repository_url}:${var.image_tag}"
}

# ── Networking ─────────────────────────────────────────────────
module "networking" {
  source = "./modules/networking"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ── ECR ────────────────────────────────────────────────────────
module "ecr" {
  source = "./modules/ecr"

  name_prefix          = local.name_prefix
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
}

# ── IAM ────────────────────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  name_prefix = local.name_prefix
  aws_region  = var.aws_region
}

# ── WAF ────────────────────────────────────────────────────────
module "waf" {
  source = "./modules/waf"

  name_prefix       = local.name_prefix
  block_mode        = var.waf_block_mode
  rate_limit_per_ip = var.waf_rate_limit_per_ip
}

# ── ALB ────────────────────────────────────────────────────────
module "alb" {
  source = "./modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  container_port    = var.container_port
  health_check_path = var.health_check_path
  web_acl_arn       = module.waf.web_acl_arn
  certificate_arn   = var.certificate_arn
}

# ── RDS ────────────────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  name_prefix                 = local.name_prefix
  vpc_id                      = module.networking.vpc_id
  private_subnet_ids          = module.networking.private_subnet_ids
  vpc_cidr                    = var.vpc_cidr

  db_name               = var.db_name
  db_username           = var.db_username
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  multi_az              = var.rds_multi_az
  deletion_protection   = var.rds_deletion_protection
  skip_final_snapshot   = var.rds_skip_final_snapshot
  backup_retention_days = var.rds_backup_retention_days
}

# ── ECS ────────────────────────────────────────────────────────
module "ecs" {
  source = "./modules/ecs"

  name_prefix             = local.name_prefix
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  alb_target_group_arn    = module.alb.target_group_arn
  alb_security_group_id   = module.alb.security_group_id
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn           = module.iam.ecs_task_role_arn
  container_image         = local.container_image
  container_port          = var.container_port
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  desired_count           = var.service_desired_count
  aws_region              = var.aws_region
  database_url            = module.rds.database_url
}
