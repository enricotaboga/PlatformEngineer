module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      resolve_conflicts_on_update = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts_on_update = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts_on_update = "OVERWRITE"
      resolve_conflicts_on_create = "OVERWRITE"
    }
  }

  vpc_id                   = var.eks_vpc_id
  subnet_ids               = var.eks_vpc_subnet_ids
  control_plane_subnet_ids = var.eks_vpc_control_plane_subnet_ids

  eks_managed_node_groups = {
      default = {
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

  access_entries = var.eks_access_entries

  node_security_group_additional_rules = var.eks_node_security_group_additional_rules

  tags = {
    Environment = var.eks_tags_environment
    Terraform   = "true"
  }
}