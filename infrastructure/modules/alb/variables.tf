variable "name_prefix" {
  description = "Prefix applied to all resource names."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to deploy the ALB into."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}

variable "container_port" {
  description = "Port the application containers listen on."
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "HTTP path for the target-group health check."
  type        = string
  default     = "/health"
}

variable "web_acl_arn" {
  description = "ARN of the WAFv2 WebACL to associate with the ALB."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS. Leave empty to use HTTP only."
  type        = string
  default     = ""
}
