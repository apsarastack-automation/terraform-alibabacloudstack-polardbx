output "db_instance_id" {
  description = "The ID of the PolarDBX instance for which the backup policy is configured."
  value       = module.backup_policy.db_instance_id
}

output "backup_policy_applied" {
  description = "Whether the backup policy was applied."
  value       = module.backup_policy.backup_policy_applied
}

output "backup_period" {
  description = "The configured backup cycle."
  value       = module.backup_policy.backup_period
}

output "backup_set_retention" {
  description = "The configured retention period of the backup set."
  value       = module.backup_policy.backup_set_retention
}
