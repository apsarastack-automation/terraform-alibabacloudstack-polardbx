output "instance_id" {
  description = "The ID of the read-only PolarDBX instance."
  value       = var.create_readonly_instance ? alibabacloudstack_polardbx_readonly_instance.default[0].id : null
}

output "instance_name" {
  description = "The name of the read-only PolarDBX instance."
  value       = var.name
}

output "primary_db_instance_id" {
  description = "The ID of the primary PolarDBX instance."
  value       = var.primary_db_instance_id
}

output "is_read_db_instance" {
  description = "Whether this is a read-only instance."
  value       = var.create_readonly_instance ? true : false
}

output "vswitch_id" {
  description = "The ID of the VSwitch used by the instance."
  value       = var.vswitch_id
}

output "cn_node_class" {
  description = "The class of computing nodes (CN)."
  value       = var.cn_node_class
}

output "dn_node_class" {
  description = "The class of storage nodes (DN)."
  value       = var.dn_node_class
}

output "engine_version" {
  description = "The database engine version."
  value       = var.engine_version
}

output "connection_string" {
  description = "The connection string of the instance."
  value       = var.create_readonly_instance ? alibabacloudstack_polardbx_readonly_instance.default[0].connection_string : null
}

output "status" {
  description = "The status of the resource."
  value       = var.create_readonly_instance ? alibabacloudstack_polardbx_readonly_instance.default[0].status : null
}
