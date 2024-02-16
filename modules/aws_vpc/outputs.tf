output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "ID of private subnet"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "ID of public subnet"
  value       = module.vpc.public_subnets
}