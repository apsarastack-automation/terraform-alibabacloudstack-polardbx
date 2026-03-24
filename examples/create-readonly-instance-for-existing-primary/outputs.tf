output "instance_id" {
  description = "The ID of the created read-only PolarDBX instance."
  value       = module.polardbx_readonly.instance_id
}

output "instance_name" {
  description = "The name of the read-only PolarDBX instance."
  value       = module.polardbx_readonly.instance_name
}

output "primary_db_instance_id" {
  description = "The ID of the primary PolarDBX instance."
  value       = module.polardbx_readonly.primary_db_instance_id
}

output "connection_string" {
  description = "The connection string of the read-only instance."
  value       = module.polardbx_readonly.connection_string
}

output "status" {
  description = "The status of the read-only instance."
  value       = module.polardbx_readonly.status
}
