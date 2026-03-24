output "instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = module.polardbx_instance.instance_id
}

output "instance_name" {
  description = "The name of the PolarDBX instance."
  value       = module.polardbx_instance.instance_name
}

output "database_names" {
  description = "List of created database names."
  value       = module.polardbx_instance.database_names
}

output "account_names" {
  description = "List of created account names."
  value       = module.polardbx_instance.account_names
}

output "vswitch_id" {
  description = "The ID of the VSwitch used by the instance."
  value       = module.polardbx_instance.vswitch_id
}

output "cn_node_class" {
  description = "The class of computing nodes (CN)."
  value       = module.polardbx_instance.cn_node_class
}

output "dn_node_class" {
  description = "The class of storage nodes (DN)."
  value       = module.polardbx_instance.dn_node_class
}

# --- Log Engine (CDC) Outputs ---

output "log_engine_id" {
  description = "The ID of the log engine configuration."
  value       = module.polardbx_log_engine.log_engine_id
}

output "log_engine_cdc_node_class" {
  description = "The specification of CDC nodes."
  value       = module.polardbx_log_engine.cdc_node_class
}

output "log_engine_cdc_node_count" {
  description = "The number of CDC nodes."
  value       = module.polardbx_log_engine.cdc_node_count
}

output "log_engine_multi_stream" {
  description = "The multi-stream configuration."
  value       = module.polardbx_log_engine.multi_stream
}

# --- Read-Write Splitting Outputs ---

output "rw_splitting_id" {
  description = "The ID of the read-write splitting configuration."
  value       = module.polardbx_read_write_splitting.id
}

output "rw_splitting_attend_htap_list" {
  description = "List of HTAP instances to attend."
  value       = module.polardbx_read_write_splitting.attend_htap_list
}

output "rw_splitting_auto_attend_htap" {
  description = "Whether to automatically attend HTAP instances."
  value       = module.polardbx_read_write_splitting.auto_attend_htap
}

output "rw_splitting_delay_execution_strategy" {
  description = "Delay execution strategy."
  value       = module.polardbx_read_write_splitting.delay_execution_strategy
}

output "rw_splitting_enable_consistent_replica_read" {
  description = "Whether to enable consistent replica read."
  value       = module.polardbx_read_write_splitting.enable_consistent_replica_read
}

output "rw_splitting_enable_htap" {
  description = "Whether to enable HTAP."
  value       = module.polardbx_read_write_splitting.enable_htap
}

output "rw_splitting_master_read_weight" {
  description = "The read weight of the master instance."
  value       = module.polardbx_read_write_splitting.master_read_weight
}

output "rw_splitting_storage_delay_threshold" {
  description = "The storage delay threshold."
  value       = module.polardbx_read_write_splitting.storage_delay_threshold
}

# --- Read-Only Instance Outputs ---

output "readonly_instance_id" {
  description = "The ID of the read-only PolarDBX instance."
  value       = module.polardbx_readonly_instance.instance_id
}

output "readonly_instance_name" {
  description = "The name of the read-only PolarDBX instance."
  value       = module.polardbx_readonly_instance.instance_name
}

output "readonly_is_read_db_instance" {
  description = "Whether this is a read-only instance."
  value       = module.polardbx_readonly_instance.is_read_db_instance
}

output "readonly_cn_node_class" {
  description = "The class of computing nodes (CN) for the read-only instance."
  value       = module.polardbx_readonly_instance.cn_node_class
}

output "readonly_dn_node_class" {
  description = "The class of storage nodes (DN) for the read-only instance."
  value       = module.polardbx_readonly_instance.dn_node_class
}

output "readonly_connection_string" {
  description = "The connection string of the read-only instance."
  value       = module.polardbx_readonly_instance.connection_string
}

output "readonly_status" {
  description = "The status of the read-only instance."
  value       = module.polardbx_readonly_instance.status
}
