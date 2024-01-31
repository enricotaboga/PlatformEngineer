terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.34.0"
    }
  }
  backend "s3" {
    key    = "platformengineer-terraform/terraform.tfstate"
    bucket = "platformengineer-terraform"
    region = "us-east-1"
    dynamodb_table = "state-locking"
    encrypt        = true
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module aws_vpc {
  source = "./modules/aws_vpc"

  vpc_name  = var.vpc_name

  vpc_azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets

  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway = var.vpc_enable_vpn_gateway

  vpc_tags_environment = var.vpc_tags_environment
}

