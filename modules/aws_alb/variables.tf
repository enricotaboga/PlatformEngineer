variable "alb_name" {
  type        = string
  description = "The name of the ALB"
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

variable "alb_tags" {
  type        = map(string)
  description = "Tags to apply to all resources in the module"
}

variable alb_security_group_cirdIP {
  type        = string
  default     = ""
  description = "0.0.0.0/32"
}
