module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name                       = var.alb_name
  vpc_id                     = var.alb_vpc_id
  subnets                    = var.alb_subnets
  security_group_ingress_rules = var.alb_security_group_ingress_rules
  security_group_egress_rules  = var.alb_security_group_egress_rules
  listeners = var.alb_listeners
  target_groups = var.alb_target_groups
  tags = var.alb_tags
}
