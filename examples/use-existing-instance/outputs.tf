output "instance_id" {
  description = "The ID of the existing PolarDBX instance."
  value       = module.polardbx.instance_id
}

output "database_names" {
  description = "List of created database names."
  value       = module.polardbx.database_names
}

output "account_names" {
  description = "List of created account names."
  value       = module.polardbx.account_names
}
