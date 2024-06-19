variable "create_iam_role" {
  description = "Whether to create the IAM role"
  type        = bool
  default     = true
}

variable "create_iam_role_policy_attachment" {
  description = "Whether to create the IAM role policy attachment"
  type        = bool
  default     = true
}

variable "create_iam_policy" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

variable "aws_account" {
  description = "The AWS account ID."
  type        = string
  default     = ""
}

variable "eks_oidc_provider" {
  description = "The EKS OIDC provider URL."
  type        = string
  default     = ""
}

variable "kubernetes_ns" {
  description = "The Kubernetes namespace where the service account resides."
  type        = string
  default     = ""
}

variable "kubernetes_sa" {
  description = "The Kubernetes service account name."
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "Optional custom assume role policy for the IAM role."
  type        = string
  default     = ""
}

variable "iam_role_name" {
  description = "The name of the IAM role for the policy attachment."
  type        = string
  default     = ""
}

variable "iam_policy_arn" {
  description = "The ARN of the IAM policy to attach to the role."
  type        = string
  default     = ""  # Default to an empty string, handled in locals
}

variable "iam_policy_name" {
  description = "The name of the IAM policy to create."
  type        = string
  default     = ""
}

variable "iam_policy_path" {
  description = "The path for the IAM policy."
  type        = string
  default     = ""
}

variable "iam_policy_description" {
  description = "The description for the IAM policy."
  type        = string
  default     = ""
}

variable "iam_policy_content" {
  description = "The policy document (JSON) for the IAM policy."
  type        = string
  default     = ""
}
