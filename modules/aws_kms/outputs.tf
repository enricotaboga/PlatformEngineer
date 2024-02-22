output "kms_arn" {
  description = "ARN from KMS resource"
  value       = module.kms.key_arn
}