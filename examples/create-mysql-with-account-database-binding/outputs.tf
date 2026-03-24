output "instance_id" {
  description = "The ID of the created PolarDBX instance."
  value       = module.polardbx.instance_id
}

output "instance_name" {
  description = "The name of the PolarDBX instance."
  value       = module.polardbx.instance_name
}

output "database_names" {
  description = "List of created database names."
  value       = module.polardbx.database_names
}

output "account_names" {
  description = "List of created account names."
  value       = module.polardbx.account_names
}
