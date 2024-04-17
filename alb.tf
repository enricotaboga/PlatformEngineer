module "aws_alb" {
  source = "./modules/alb"

  alb_name                       = var.alb_name

  alb_vpc_id                     = module.aws_vpc.vpc_id

  alb_subnets                    = module.aws_vpc.public_subnets

  alb_security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = var.alb_security_group_cirdIP
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = var.alb_security_group_cirdIP
    }
  }

  alb_security_group_egress_rules = var.alb_security_group_egress_rules

  alb_listeners                  = {
    http = {
      port     = 80
      protocol = "HTTP"
      default_action = {
        type = "forward"
        target_group_name = "http"
      }
    }
    https = {
      port     = 443
      protocol = "HTTPS"
      certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      default_action = {
        type = "forward"
        target_group_name = "https"
      }
    }
  }
  alb_target_groups              = {
    http = {
      name_prefix      = "http-tg-"
      backend_protocol = "HTTP"
      backend_port     = 30080
      target_type      = "instance"
    }
    https = {
      name_prefix      = "https-tg-"
      backend_protocol = "HTTPS"
      backend_port     = 30443
      target_type      = "instance"
    }
  }
  alb_tags                       = {
    Environment = var.alb_environment_tags
    Project     = "Project X"
  }
}

