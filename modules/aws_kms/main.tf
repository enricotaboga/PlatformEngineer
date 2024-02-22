module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description = var.kms_description
  key_usage   = var.kms_key_usage

  # Policy
  enable_default_policy = var.kms_enable_default_policy

  # Aliases
  aliases = var.kms_aliases

  tags = {
    Terraform   = "true"
    Environment = var.kms_tags_environment
  }
}