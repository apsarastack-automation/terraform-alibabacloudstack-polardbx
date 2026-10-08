output "instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = local.instance_id
}

output "instance_name" {
  description = "The name of the PolarDBX instance."
  value       = var.name
}

output "database_names" {
  description = "List of created database names."
  value       = keys(alibabacloudstack_polardbx_database.default)
}

output "account_names" {
  description = "List of created account names."
  value       = keys(alibabacloudstack_polardbx_account.default)
}

output "vswitch_id" {
  description = "The ID of the VSwitch used by the instance."
  value       = var.vswitch_id
}

output "cn_node_class" {
  description = "The class of computing nodes (CN)."
  value       = local.cn_node_class
}

output "dn_node_class" {
  description = "The class of storage nodes (DN)."
  value       = local.dn_node_class
}

output "backup_set_id" {
  description = "The ID of the backup set created by the manual backup. Null when enable_backup is false."
  value       = var.enable_backup ? alibabacloudstack_polardbx_backup.this[0].backup_set_id : null
}

output "backup_status" {
  description = "The status of the manual backup. Valid values: 0 (creating), 1 (success), 2 (failed). Null when enable_backup is false."
  value       = var.enable_backup ? alibabacloudstack_polardbx_backup.this[0].status : null
}