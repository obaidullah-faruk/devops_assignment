variable "name_prefix" {
  description = "Name for the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability: MUTABLE | IMMUTABLE."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable vulnerability scanning on image push."
  type        = bool
  default     = true
}
