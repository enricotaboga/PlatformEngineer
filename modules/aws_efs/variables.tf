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
  default     = "arn:aws:kms:eu-west-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
}

variable "efs_performance_mode" {
  description = "The performance mode of the file system"
  type        = string
  default     = "maxIO"
}

variable "efs_throughput_mode" {
  description = "Throughput mode for the file system"
  type        = string
  default     = "provisioned"
}

variable "efs_provisioned_throughput_in_mibps" {
  description = "Provisioned throughput in MiB/s when throughput mode is set to provisioned"
  type        = number
  default     = 256
}

variable "efs_enable_attach_policy" {
  description = "Whether to attach a file system policy"
  type        = bool
  default     = true
}

variable "efs_bypass_policy_lockout_safety_check" {
  description = "Whether to bypass the policy lockout safety check"
  type        = bool
  default     = false
}

variable "efs_policy_statements" {
  description = "The policy statements for the EFS file system"
  type        = list(object({
    sid        = string
    actions    = list(string)
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

variable "efs_mount_targets" {
  description = "Configuration for EFS mount targets"
  type        = map(object({
    subnet_id = string
  }))
  default = {
    "eu-west-1a" = {
      subnet_id = "subnet-abcde012"
    },
    "eu-west-1b" = {
      subnet_id = "subnet-bcde012a"
    },
    "eu-west-1c" = {
      subnet_id = "subnet-fghi345a"
    }
  }
}

variable "efs_security_group_vpc_id" {
  description = "VPC ID for the security group"
  type        = string
  default     = "vpc-1234556abcdef"
}

variable "efs_security_group_rules" {
  description = "Security group rules for the EFS file system"
  type        = map(object({
    description = string
    cidr_blocks = list(string)
  }))
  default = {
    vpc = {
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
    }
  }
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
  type        = object({
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

variable "efs_access_points" {
  description = "A map of objects representing EFS access points"
  type = map(object({
    name = string
    posix_user = object({
      gid            = number
      uid            = number
      secondary_gids = list(number)
    })
    tags = map(string)
    root_directory = object({
      path = string
      creation_info = object({
        owner_gid   = number
        owner_uid   = number
        permissions = string
      })
    })
  }))
}
