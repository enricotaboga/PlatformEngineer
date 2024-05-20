module "aws_acm" {
  source     = "./modules/aws_acm"
  acm_domain_name = var.domain
  acm_zone_id = data.aws_route53_zone.selected.zone_id
  acm_tags_environment = var.environment
}

data "aws_route53_zone" "selected" {
  name         = "${var.domain}."  
  private_zone = false           
}

