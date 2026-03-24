output "log_engine_id" {
  description = "The ID of the log engine configuration."
  value       = var.enable_log_engine ? alibabacloudstack_polardbx_log_engine.default[0].id : null
}

output "instance_id" {
  description = "The ID of the PolarDBX instance."
  value       = var.instance_id
}

output "cdc_node_class" {
  description = "The specification of CDC nodes."
  value       = var.enable_log_engine ? alibabacloudstack_polardbx_log_engine.default[0].cdc_node_class : null
}

output "cdc_node_count" {
  description = "The number of CDC nodes."
  value       = var.enable_log_engine ? alibabacloudstack_polardbx_log_engine.default[0].cdc_node_count : null
}

output "multi_stream" {
  description = "The multi-stream configuration."
  value       = var.enable_log_engine ? alibabacloudstack_polardbx_log_engine.default[0].multi_stream : []
}
