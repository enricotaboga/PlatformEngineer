output "vpc_id" {
  description = "ID of the VPC"
  value       = module.aws_vpc.vpc_id
}

output "private_subnets" {
  description = "ID of private subnet"
  value       = module.aws_vpc.private_subnets
}

output "public_subnets" {
  description = "ID of public subnet"
  value       = module.aws_vpc.public_subnets
}