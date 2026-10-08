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

output "vswitch_id" {
  description = "The ID of the VSwitch used by the instance."
  value       = module.polardbx.vswitch_id
}

output "super_account_admin_name" {
  description = "The name of the super (admin) account. Null when no super account is configured."
  value       = module.polardbx_super_account.super_account_admin_name
  sensitive   = true
}

output "super_account_three_roles" {
  description = "Whether three-role rights separation (admin/security/audit) is enabled on the instance. Null when no super account is configured."
  value       = module.polardbx_super_account.super_account_three_roles
}

