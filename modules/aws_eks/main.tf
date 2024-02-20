# Use a null_resource as an indirect synchronization point
resource "null_resource" "cluster_sync" {
  triggers = {
    cluster_endpoint = module.eks.cluster_endpoint
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name

  # Indirectly enforce dependency without causing a cycle
  depends_on = [null_resource.cluster_sync]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [null_resource.cluster_sync]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

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

  # aws-auth configmap
  manage_aws_auth_configmap = var.eks_manage_aws_auth_configmap

  aws_auth_roles = var.eks_aws_auth_roles

  aws_auth_users = var.eks_aws_auth_users

  aws_auth_accounts = var.eks_aws_auth_accounts

  tags = {
    Environment = var.eks_tags_environment
    Terraform   = "true"
  }
}