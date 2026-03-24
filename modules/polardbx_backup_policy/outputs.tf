output "db_instance_id" {
  description = "The ID of the PolarDBX instance for which the backup policy is configured."
  value       = var.db_instance_id
}

output "backup_policy_applied" {
  description = "Whether the backup policy was applied."
  value       = true
}

output "backup_period" {
  description = "The backup cycle."
  value       = var.backup_period
}

output "backup_set_retention" {
  description = "The retention period of the backup set."
  value       = var.backup_set_retention
}

output "backup_plan_begin" {
  description = "The start time of the backup."
  value       = var.backup_plan_begin
}

output "remove_log_retention" {
  description = "The retention period of transaction logs."
  value       = var.remove_log_retention
}
