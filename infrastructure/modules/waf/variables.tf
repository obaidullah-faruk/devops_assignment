variable "name_prefix" {
  description = "Prefix applied to all WAF resource names."
  type        = string
}

variable "block_mode" {
  description = "If true, managed rules operate in BLOCK mode; if false, COUNT/audit mode."
  type        = bool
  default     = true
}

variable "rate_limit_per_ip" {
  description = "Maximum requests per 5-minute window per IP before blocking."
  type        = number
  default     = 2000
}
