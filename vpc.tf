module "aws_vpc" {
  source = "./modules/aws_vpc"

  vpc_name = var.vpc_name

  vpc_azs             = var.vpc_azs
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets
  vpc_private_subnet_tags = var.vpc_private_subnet_tags
  vpc_public_subnet_tags = var.vpc_public_subnet_tags

  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway = var.vpc_enable_vpn_gateway

  vpc_tags_environment = var.environment
}