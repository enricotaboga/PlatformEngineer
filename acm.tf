module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.domain
  zone_id      = data.aws_route53_zone.selected.zone_id

  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain}"]

  wait_for_validation = true

  tags = {
    Name = var.domain
  }
}

data "aws_route53_zone" "selected" {
  name         = "${var.domain}."  
  private_zone = false           
}

