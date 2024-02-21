variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region wich resources will be created"
}

variable "vpc_name" {
  type        = string
  default     = "my-vpc"
  description = "Name for the vpc"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr"
}

variable "vpc_azs" {
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  description = "A list contaning the VPC AZs"
}

variable "vpc_private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "A list contaning the VPC private subnets"
}

variable "vpc_public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "A list contaning the VPC public subnets"
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  default     = "true"
  description = "Enable nat gateway for the vpc"
}

variable "vpc_enable_vpn_gateway" {
  type        = bool
  default     = "false"
  description = "Enable vpn gateway for the vpc"
}

variable "eks_cluster_name" {
  type        = string
  default     = "my-eks"
  description = "Name for the EKS Cluster"
}

variable "eks_cluster_version" {
  type        = string
  default     = "1.28"
  description = "Version for the EKS Cluster"
}

variable "eks_cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Enable public access to the cluster"
}

variable "eks_vpc_id" {
  type        = string
  default     = ""
  description = "VPC id that will be used to build the eks cluster"
}

variable "eks_vpc_subnet_ids" {
  type        = list(any)
  default     = []
  description = "List of subnet ids that will be used to build the eks cluster"
}

variable "eks_vpc_control_plane_subnet_ids" {
  type        = list(any)
  default     = []
  description = "List of subnet ids that will be used to build the eks control plane"
}

variable "eks_ng_name" {
  type        = list(string)
  default     = ["my-eks-ng"]
  description = "Name for the EKS node group"
}

variable "eks_ng_min_size" {
  type        = number
  default     = 1
  description = "Minimal number of nodes in the cluster node group"
}

variable "eks_ng_max_size" {
  type        = number
  default     = 5
  description = "Maximal number of nodes in the cluster node group"
}

variable "eks_ng_desired_size" {
  type        = number
  default     = 3
  description = "Desired number of nodes in the cluster node group"
}

variable "eks_ng_instance_types" {
  type        = list(string)
  default     = ["t4g.small"]
  description = "Instace type for the EKS node group"
}
variable "eks_ng_capacity_type" {
  type        = string
  default     = "SPOT"
  description = "Capacity type for the EKS node group"
}

variable "eks_fargate_name" {
  type        = string
  default     = "my-fargate"
  description = "Fargate name that will be used in the EKS cluster"
}

variable "eks_fargate_namespace" {
  type        = string
  default     = "my-fargate"
  description = "EKS namespace chose to deploy the fargate"
}

variable "eks_manage_aws_auth_configmap" {
  type        = bool
  default     = true
  description = "Enable aws_auth to manage the access control"
}

variable "eks_aws_auth_roles" {
  type = set(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    }
  ]
  description = "Enable a specific role to access the EKS cluster and sets its permissions"
}

variable "eks_aws_auth_users" {
  type = set(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    }
  ]
  description = "Enable a specific user to access the EKS cluster and sets its permissions"
}

variable "eks_aws_auth_accounts" {
  type        = set(string)
  default     = ["777777777777", "888888888888"]
  description = "Enable a specific accounts to access the EKS cluster and sets its permissions"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Tag to identify the environment"
}