output "eks_oidc_provider" {
  description = "OIDC of the EKS cluster"
  value       = module.eks.oidc_provider
}