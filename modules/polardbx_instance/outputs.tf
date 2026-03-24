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