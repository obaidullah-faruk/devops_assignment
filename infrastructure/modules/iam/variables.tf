variable "name_prefix" {
  description = "Prefix applied to all IAM resource names."
  type        = string
}

variable "aws_region" {
  description = "AWS region (used to scope CloudWatch log group ARNs)."
  type        = string
}
