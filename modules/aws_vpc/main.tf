module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  private_subnet_tags = var.vpc_private_subnet_tags
  public_subnet_tags = var.vpc_public_subnet_tags

  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_vpn_gateway = var.vpc_enable_vpn_gateway

  tags = {
    Terraform = "true"
    Environment = var.vpc_tags_environment
  }
}