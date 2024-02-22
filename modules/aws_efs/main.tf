module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = var.efs_name
  creation_token = var.efs_token
  encrypted      = var.efs_enable_encrypted
  kms_key_arn    = var.efs_kms_key_arn

  performance_mode                = var.efs_performance_mode
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  # File system policy
  attach_policy                      = var.efs_enable_attach_policy
  bypass_policy_lockout_safety_check = var.efs_bypass_policy_lockout_safety_check
  policy_statements = var.efs_policy_statements

  # Mount targets / security group
  mount_targets = var.efs_mount_targets
  security_group_description = "EFS security group"
  security_group_vpc_id      = var.efs_security_group_vpc_id
  security_group_rules = var.efs_security_group_rules

  # Access point(s)
  access_points = var.efs_access_points

  # Backup policy
  enable_backup_policy = var.efs_enable_backup_policy

  # Replication configuration
  create_replication_configuration = var.efs_create_replication_configuration
  replication_configuration_destination = var.efs_replication_configuration_destination

  tags = {
    Environment = var.efs_tags_environment
    Terraform   = "true"
  }
}