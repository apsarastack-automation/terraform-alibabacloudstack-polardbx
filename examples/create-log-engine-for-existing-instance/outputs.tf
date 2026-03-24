output "log_engine_id" {
  description = "The ID of the log engine configuration."
  value       = module.polardbx_log_engine.log_engine_id
}

output "instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = module.polardbx_log_engine.instance_id
}

output "cdc_node_class" {
  description = "The specification of CDC nodes."
  value       = module.polardbx_log_engine.cdc_node_class
}

output "cdc_node_count" {
  description = "The number of CDC nodes."
  value       = module.polardbx_log_engine.cdc_node_count
}

output "multi_stream" {
  description = "The multi-stream configuration."
  value       = module.polardbx_log_engine.multi_stream
}
