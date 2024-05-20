variable "acm_domain_name" {
  description = "The domain name for the ACM certificate."
  type        = string
}

variable "acm_zone_id" {
  description = "The Route 53 zone ID where the domain is located."
  type        = string
}

variable "acm_tags_environment" {
  description = "The environment in which the ACM certificate is being used (e.g., development, production)."
  type        = string
}
