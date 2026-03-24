output "id" {
  description = "The ID of the read-write splitting configuration, same as db_instance_id."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].id : null
}

output "db_instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = var.db_instance_id
}

output "attend_htap_list" {
  description = "List of HTAP instances to attend."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].attend_htap_list : []
}

output "auto_attend_htap" {
  description = "Whether to automatically attend HTAP instances."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].auto_attend_htap : false
}

output "delay_execution_strategy" {
  description = "Delay execution strategy."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].delay_execution_strategy : 0
}

output "enable_consistent_replica_read" {
  description = "Whether to enable consistent replica read."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].enable_consistent_replica_read : false
}

output "enable_htap" {
  description = "Whether to enable HTAP."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].enable_htap : false
}

output "master_read_weight" {
  description = "The read weight of the master instance."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].master_read_weight : 50
}

output "storage_delay_threshold" {
  description = "The storage delay threshold."
  value       = var.enable_read_write_splitting ? alibabacloudstack_polardbx_read_write_splitting_config.default[0].storage_delay_threshold : 1000
}
