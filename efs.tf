module "aws_efs" {
  source = "./modules/aws_efs"

  # File system
  efs_name             = var.efs_name
  efs_token            = var.efs_token
  efs_enable_encrypted = var.efs_enable_encrypted
  efs_kms_key_arn      = var.kms_arn

  efs_performance_mode                = var.efs_performance_mode
  efs_throughput_mode                 = var.efs_throughput_mode
  efs_provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps

  # File system policy
  efs_enable_attach_policy               = var.efs_enable_attach_policy
  efs_bypass_policy_lockout_safety_check = var.efs_bypass_policy_lockout_safety_check
  efs_policy_statements                  = var.efs_policy_statements

  # Mount targets / security group
  efs_mount_targets         = var.efs_mount_targets
  efs_security_group_vpc_id = var.efs_security_group_vpc_id
  efs_security_group_rules  = var.efs_security_group_rules

  # Access point(s)
  efs_access_points = var.efs_access_points

  # Backup policy
  efs_enable_backup_policy = var.efs_enable_backup_policy

  # Replication configuration
  efs_create_replication_configuration      = var.efs_create_replication_configuration
  efs_replication_configuration_destination = var.efs_replication_configuration_destination


  efs_tags_environment = var.efs_tags_environment
}