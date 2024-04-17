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

#EFS variables

variable "efs_name" {
  description = "The name of the EFS file system"
  type        = string
  default     = "my-efs"
}

variable "efs_token" {
  description = "Creation token for the EFS file system"
  type        = string
  default     = "my-efs-token"
}

variable "efs_enable_encrypted" {
  description = "Whether the file system is encrypted"
  type        = bool
  default     = true
}

variable "efs_kms_key_arn" {
  description = "ARN of the KMS key to use for encryption"
  type        = string
  default     = ""
}

variable "efs_performance_mode" {
  description = "The performance mode of the file system"
  type        = string
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  description = "Throughput mode for the file system"
  type        = string
  default     = "provisioned"
}

variable "efs_provisioned_throughput_in_mibps" {
  description = "Provisioned throughput in MiB/s when throughput mode is set to provisioned"
  type        = number
  default     = 1
}

variable "efs_enable_attach_policy" {
  description = "Whether to attach a file system policy"
  type        = bool
  default     = false
}

variable "efs_bypass_policy_lockout_safety_check" {
  description = "Whether to bypass the policy lockout safety check"
  type        = bool
  default     = false
}

variable "efs_policy_statements" {
  description = "The policy statements for the EFS file system"
  type = list(object({
    sid     = string
    actions = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::111122223333:role/EfsReadOnly"]
        }
      ]
    }
  ]
}

variable "efs_security_group_vpc_id" {
  description = "VPC ID for the security group"
  type        = string
  default     = "vpc-1234556abcdef"
}

variable "efs_enable_backup_policy" {
  description = "Whether to enable the backup policy"
  type        = bool
  default     = true
}

variable "efs_create_replication_configuration" {
  description = "Whether to create replication configuration"
  type        = bool
  default     = true
}

variable "efs_replication_configuration_destination" {
  description = "Replication configuration destination"
  type = object({
    region = string
  })
  default = {
    region = "eu-west-2"
  }
}

variable "efs_tags_environment" {
  description = "The environment tag for EFS-related resources"
  type        = string
  default     = "dev"
}

variable "efs_mount_targets" {
  type        = any
  default     = {}
  description = "List of mount targets to be created in the EFS"
}


#KMS variables

variable "kms_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "EC2 AutoScaling key usage"
}

variable "kms_key_usage" {
  description = "The cryptographic operations for which the KMS key can be used"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_aliases" {
  description = "List of aliases to assign to the KMS key"
  type        = list(string)
  default     = ["mykms/ebs"]
}

variable "kms_tags_environment" {
  description = "Environment tag to apply to the KMS key"
  type        = string
  default     = "dev"
}

variable "kms_enable_default_policy" {
  type        = bool
  default     = true
  description = "Specifies whether to enable the default key policy. "
}

variable "eks_context" {
  type        = string
  default     = ""
  description = "Context of the eks cluster"
}

variable "eks_access_entries" {
  description = "Access entries with dynamic policy associations and conditional access scopes."
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        namespaces = optional(list(string))
        type       = string
      })
    }))
  }))
  default = {
    admin = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam:::user/"
      policy_associations = {
        single = { # "single" aqui é um exemplo; pode ser qualquer chave.
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = ["*"] # Opcional, dependendo do valor de "type".
            type       = "namespace"
          }
        }
      }
    }
  }
}

variable "aws_account" {
  type        = string
  default     = ""
  description = "Id of aws account"
}

variable harbor_namespace {
  type        = string
  default     = "harbor"
  description = "Harbor namespace name"
}

variable "alb_name" {
  type        = string
  description = "The name of the ALB"
  default = "my-alb"
}

variable "alb_vpc_id" {
  type        = string
  description = "The VPC ID where the ALB is deployed"
}

variable "alb_subnets" {
  type        = list(string)
  description = "List of subnet IDs for the ALB"
}

variable "alb_security_group_ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    description = string
    cidr_ipv4   = string
  }))
  description = "Ingress rules for the ALB security group"
}

variable "alb_security_group_egress_rules" {
  type = map(object({
    ip_protocol = string
    cidr_ipv4   = string
  }))
  description = "Egress rules for the ALB security group"
}

variable "alb_listeners" {
  type = map(object({
    port     = number
    protocol = string
    redirect = optional(object({
      port        = string
      protocol    = string
      status_code = string
    }))
    certificate_arn = optional(string)
    forward = optional(object({
      target_group_key = string
    }))
  }))
  description = "Configuration for ALB listeners"
}

variable "alb_target_groups" {
  type = map(object({
    name_prefix  = string
    protocol     = string
    port         = number
    target_type  = string
  }))
  description = "Configuration for ALB target groups"
}

variable "alb_environment_tags" {
  type        = map(string)
  description = "Tags to apply to all resources in the module"
  default = "dev"
}
