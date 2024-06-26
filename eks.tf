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

  eks_node_security_group_additional_rules = {
    ingress_nlb_ingress = {
      description              = "NLB SG"
      protocol                 = "tcp"
      from_port                = 80
      to_port                  = 80
      type                     = "ingress"
      source_security_group_id = aws_security_group.ingress_sg.id
    }
  }

  eks_tags_environment = var.environment
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [module.aws_eks]

  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.eks_cluster_name} --alias ${var.eks_context} && sleep 60"
  }
}