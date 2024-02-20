terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
  backend "s3" {
    key            = "platformengineer-terraform/terraform.tfstate"
    bucket         = "platformengineer-terraform"
    region         = "us-east-1"
    dynamodb_table = "state-locking"
    encrypt        = true
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "aws_vpc" {
  source = "./modules/aws_vpc"

  vpc_name = var.vpc_name

  vpc_azs             = var.vpc_azs
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets

  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway = var.vpc_enable_vpn_gateway

  vpc_tags_environment = var.environment
}

module "aws_eks" {
  source     = "./modules/aws_eks"

  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version

  eks_cluster_endpoint_public_access = var.eks_cluster_endpoint_public_access

  eks_vpc_id                       = module.aws_vpc.vpc_id
  eks_vpc_subnet_ids               = module.aws_vpc.private_subnets
  eks_vpc_control_plane_subnet_ids = module.aws_vpc.private_subnets

  # EKS Node group
  eks_ng_min_size     = var.eks_ng_min_size
  eks_ng_max_size     = var.eks_ng_max_size
  eks_ng_desired_size = var.eks_ng_desired_size
  eks_ng_instance_types = var.eks_ng_instance_types
  eks_ng_capacity_type  = var.eks_ng_capacity_type


  # Fargate Profile(s)
  eks_fargate_name = var.eks_fargate_name

  eks_fargate_namespace = var.eks_fargate_namespace
 

  # aws-auth configmap
  eks_manage_aws_auth_configmap = var.eks_manage_aws_auth_configmap

  eks_aws_auth_roles = var.eks_aws_auth_roles

  eks_aws_auth_users = var.eks_aws_auth_users

  eks_aws_auth_accounts = var.eks_aws_auth_accounts

  eks_tags_environment = var.environment
}