module "aws_efs" {
  source = "./modules/aws_efs"
  depends_on = [aws_iam_role.efs_driver_role, aws_iam_role.harbor_role]

  # File system
  efs_name             = var.efs_name
  efs_token            = var.efs_token
  efs_enable_encrypted = var.efs_enable_encrypted
  efs_kms_key_arn      = module.aws_kms.kms_arn

  efs_performance_mode                = var.efs_performance_mode
  efs_throughput_mode                 = var.efs_throughput_mode
  efs_provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps

  # File system policy
  efs_enable_attach_policy               = var.efs_enable_attach_policy
  efs_bypass_policy_lockout_safety_check = var.efs_bypass_policy_lockout_safety_check
  efs_policy_statements                  = var.efs_policy_statements

  efs_mount_targets = { for k, v in zipmap(var.vpc_azs, module.aws_vpc.private_subnets) : k => { subnet_id = v } }
  # security group
  efs_security_group_vpc_id = module.aws_vpc.vpc_id
  efs_security_group_rules = {
    vpc = {
      description = "EFS ingress from VPC private subnets"
      cidr_blocks = module.aws_vpc.cidr_private_subnets
    }
  }

  # Backup policy
  efs_enable_backup_policy = var.efs_enable_backup_policy

  # Replication configuration
  efs_create_replication_configuration      = var.efs_create_replication_configuration
  efs_replication_configuration_destination = var.efs_replication_configuration_destination


  efs_tags_environment = var.efs_tags_environment
}

