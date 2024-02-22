variable "kms_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "EC2 AutoScaling key usage"
}

variable "kms_key_usage" {
  description = "The cryptographic operations for which the KMS key can be used"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_key_administrators" {
  description = "List of IAM role ARNs who have administrative privileges to the KMS key"
  type        = list(string)
  default     = []
}

variable "kms_key_service_roles_for_autoscaling" {
  description = "List of IAM role ARNs representing AWS service roles that use the KMS key for autoscaling"
  type        = list(string)
  default     = []
}

variable "kms_aliases" {
  description = "List of aliases to assign to the KMS key"
  type        = list(string)
  default     = ["mykms/ebs"]
}

variable "kms_tags_environment" {
  description = "Environment tag to apply to the KMS key"
  type        = string
  default     = "dev"
}

variable kms_enable_default_policy {
  type        = bool
  default     = true
  description = "Specifies whether to enable the default key policy. "
}
