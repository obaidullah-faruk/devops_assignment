output "db_instance_id" {
  description = "ID of the RDS instance."
  value       = aws_db_instance.postgres.id
}

output "db_endpoint" {
  description = "Endpoint (host:port) of the RDS instance."
  value       = aws_db_instance.postgres.endpoint
}

output "db_host" {
  description = "Hostname of the RDS instance (without port)."
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "Port of the RDS instance."
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Database name."
  value       = aws_db_instance.postgres.db_name
}

output "db_username" {
  description = "Master username."
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "db_security_group_id" {
  description = "Security group ID attached to the RDS instance."
  value       = aws_security_group.rds.id
}

output "db_password" {
  description = "Master password (auto-generated)."
  value       = random_password.db_password.result
  sensitive   = true
}

output "database_url" {
  description = "Full PostgreSQL connection string for the application."
  value       = "postgresql+asyncpg://${aws_db_instance.postgres.username}:${random_password.db_password.result}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
  sensitive   = true
}
