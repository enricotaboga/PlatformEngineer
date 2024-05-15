output "hosted_zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

output "acm_arn" {
  value = module.acm.acm_certificate_arn
}
