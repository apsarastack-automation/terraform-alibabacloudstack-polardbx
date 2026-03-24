output "rw_splitting_id" {
  description = "The ID of the read-write splitting configuration."
  value       = module.polardbx_read_write_splitting.id
}

output "db_instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = module.polardbx_read_write_splitting.db_instance_id
}

output "attend_htap_list" {
  description = "List of HTAP instances to attend."
  value       = module.polardbx_read_write_splitting.attend_htap_list
}

output "auto_attend_htap" {
  description = "Whether to automatically attend HTAP instances."
  value       = module.polardbx_read_write_splitting.auto_attend_htap
}

output "delay_execution_strategy" {
  description = "Delay execution strategy."
  value       = module.polardbx_read_write_splitting.delay_execution_strategy
}

output "enable_consistent_replica_read" {
  description = "Whether to enable consistent replica read."
  value       = module.polardbx_read_write_splitting.enable_consistent_replica_read
}

output "enable_htap" {
  description = "Whether to enable HTAP."
  value       = module.polardbx_read_write_splitting.enable_htap
}

output "master_read_weight" {
  description = "The read weight of the master instance."
  value       = module.polardbx_read_write_splitting.master_read_weight
}

output "storage_delay_threshold" {
  description = "The storage delay threshold."
  value       = module.polardbx_read_write_splitting.storage_delay_threshold
}
