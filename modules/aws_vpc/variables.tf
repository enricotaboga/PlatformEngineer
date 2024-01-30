variable vpc_name {
  type        = string
  default     = "my-vpc"
  description = "Name for the vpc"
}

variable vpc_cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr"
}

variable vpc_azs {
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  description = "A list contaning the VPC AZs"
}

variable vpc_private_subnets {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "A list contaning the VPC private subnets"
}

variable vpc_public_subnets {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "A list contaning the VPC public subnets"
}

variable vpc_enable_nat_gateway {
  type        = bool
  default     = "true"
  description = "Enable nat gateway for the vpc"
}

variable vpc_enable_vpn_gateway {
  type        = bool
  default     = "false"
  description = "Enable vpn gateway for the vpc"
}

variable vpc_tags_environment {
  type        = string
  default     = "dev"
  description = "Tag to identify the vpc environment"
}