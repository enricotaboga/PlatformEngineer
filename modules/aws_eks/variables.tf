variable eks_cluster_name {
  type        = string
  default     = "my-eks"
  description = "Name for the EKS Cluster"
}

variable eks_cluster_version {
  type        = string
  default     = "1.28"
  description = "Version for the EKS Cluster"
}

variable eks_cluster_endpoint_public_access {
  type        = bool
  default     = true
  description = "Enable public access to the cluster"
}

variable eks_vpc_id {
  type        = string
  default     = ""
  description = "VPC id that will be used to build the eks cluster"
}

variable eks_vpc_subnet_ids {
  type        = list
  default     = []
  description = "List of subnet ids that will be used to build the eks cluster"
}

variable eks_vpc_control_plane_subnet_ids {
  type        = list
  default     = []
  description = "List of subnet ids that will be used to build the eks control plane"
}

variable eks_ng_name {
  type        = string
  default     = "my-eks-ng"
  description = "Name for the EKS node group"
}

variable eks_ng_min_size {
  type        = number
  default     = 1
  description = "Minimal number of nodes in the cluster node group"
}

variable eks_ng_max_size {
  type        = number
  default     = 5
  description = "Maximal number of nodes in the cluster node group"
}

variable eks_ng_desired_size {
  type        = number
  default     = 3
  description = "Desired number of nodes in the cluster node group"
}

variable eks_ng_instance_types {
  type        = string
  default     = "t4g.small"
  description = "Instace type for the EKS node group"
}

variable eks_ng_capacity_type {
  type        = string
  default     = "SPOT"
  description = "Capacity type for the EKS node group"
}

variable eks_fargate_name {
  type        = string
  default     = "my-fargate"
  description = "Fargate name that will be used in the EKS cluster"
}

variable eks_fargate_namespace {
  type        = string
  default     = "my-fargate"
  description = "EKS namespace chose to deploy the fargate"
}

variable eks_manage_aws_auth_configmap {
  type        = bool
  default     = true
  description = "Enable aws_auth to manage the access control"
}

variable eks_aws_auth_roles {
  type        = map(object)
  default     = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    }
  ]
  description = "Enable a specific role to access the EKS cluster and sets its permissions"
}

variable eks_aws_auth_users {
  type        = map(object)
  default     = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    }
  ]
  description = "Enable a specific user to access the EKS cluster and sets its permissions"
}

variable eks_aws_auth_accounts {
  type        = set(string)
  default     = ["777777777777","888888888888"]
  description = "Enable a specific accounts to access the EKS cluster and sets its permissions"
}

variable vpc_tags_environment {
  type        = string
  default     = "dev"
  description = "Tag to identify the eks environment"
}