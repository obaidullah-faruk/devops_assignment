# ──────────────────────────────────────────────────────────────
# Root outputs.tf — expose key values after apply
# ──────────────────────────────────────────────────────────────

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer. Point your domain's CNAME here."
  value       = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL. Use this as the base for docker push and image_tag."
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = module.ecs.service_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint (host:port)."
  value       = module.rds.db_endpoint
}

output "rds_database_name" {
  description = "Name of the PostgreSQL database."
  value       = module.rds.db_name
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "waf_web_acl_arn" {
  description = "ARN of the WAFv2 WebACL attached to the ALB."
  value       = module.waf.web_acl_arn
}

output "container_image" {
  description = "Full container image URI that was deployed (ECR URL + image tag)."
  value       = local.container_image
}
