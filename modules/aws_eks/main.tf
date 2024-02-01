module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.eks_vpc_id
  subnet_ids               = var.eks_vpc_subnet_ids
  control_plane_subnet_ids = var.eks_vpc_control_plane_subnet_ids

  eks_managed_node_groups = {
    green = {
      min_size     = var.eks_ng_min_size
      max_size     = var.eks_ng_max_size
      desired_size = var.eks_ng_desired_size

      instance_types = var.eks_ng_instance_types
      capacity_type  = var.eks_ng_capacity_type
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = var.eks_fargate_name
      selectors = [
        {
          namespace = var.eks_fargate_namespace
        }
      ]
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = var.eks_aws_auth_roles

  aws_auth_users = var.eks_aws_auth_users

  aws_auth_accounts = var.eks_aws_auth_accounts

  tags = {
    Environment = var.eks_tags_environment
    Terraform   = "true"
  }
}