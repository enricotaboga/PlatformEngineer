module "acm" {
  source = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.acm_domain_name
  zone_id      = var.acm_zone_id

  validation_method = "DNS"

  subject_alternative_names = ["*.${var.acm_domain_name}"]

  wait_for_validation = true

  tags = {
    Environment = var.acm_tags_environment
    Terraform   = "true"
  }
}