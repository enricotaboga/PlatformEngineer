module "aws_eks" {
  source = "./modules/aws_eks"

  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version

  eks_cluster_endpoint_public_access = var.eks_cluster_endpoint_public_access

  eks_vpc_id                       = module.aws_vpc.vpc_id
  eks_vpc_subnet_ids               = module.aws_vpc.private_subnets
  eks_vpc_control_plane_subnet_ids = module.aws_vpc.private_subnets

  # EKS Node group
  eks_ng_min_size       = var.eks_ng_min_size
  eks_ng_max_size       = var.eks_ng_max_size
  eks_ng_desired_size   = var.eks_ng_desired_size
  eks_ng_instance_types = var.eks_ng_instance_types
  eks_ng_capacity_type  = var.eks_ng_capacity_type


  # Fargate Profile(s)
  eks_fargate_name = var.eks_fargate_name

  eks_fargate_namespace = var.eks_fargate_namespace


  # aws-auth configmap
  eks_access_entries = var.eks_access_entries

  eks_tags_environment = var.environment
}