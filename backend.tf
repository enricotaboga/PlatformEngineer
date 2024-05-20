terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
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

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.eks_context
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.eks_context
}