output "name" {
  description = "The name of the Helm release."
  value       = helm_release.this.name
}

output "namespace" {
  description = "The namespace in which the Helm release is deployed."
  value       = helm_release.this.namespace
}
