output "db_instance_id" {
  description = "The ID of the PolarDBX instance for which the manual backup was created."
  value       = var.db_instance_id
}

output "backup_set_id" {
  description = "The ID of the backup set created by the manual backup."
  value       = module.polardbx_backup.backup_set_id
}

output "backup_status" {
  description = "The status of the manual backup. Valid values: 0 (creating), 1 (success), 2 (failed)."
  value       = module.polardbx_backup.backup_status
}
