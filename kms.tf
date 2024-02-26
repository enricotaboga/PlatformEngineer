module "aws_kms" {
  source = "./modules/aws_kms"

  kms_description = var.kms_description
  kms_key_usage   = var.kms_key_usage

  # Policy
  kms_enable_default_policy = var.kms_enable_default_policy

  # Aliases
  kms_aliases = var.kms_aliases
  
  kms_tags_environment = var.kms_tags_environment
}
