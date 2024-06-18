variable "name" {
  description = "The name of the Helm release."
  type        = string
}

variable "repository" {
  description = "The URL of the Helm chart repository."
  type        = string
}

variable "chart" {
  description = "The name of the Helm chart to deploy."
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace to deploy the release into."
  type        = string
}

variable "create_namespace" {
  description = "Whether to create the namespace if it does not exist."
  type        = bool
  default     = false
}

variable "set_values" {
  description = "A map of Helm chart values to set."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable values {
  type        = list(string)
  description = "Values file path"
  default = []
}

variable helm_version {
  type        = string
  description = "Helm version"
  default = ""
}