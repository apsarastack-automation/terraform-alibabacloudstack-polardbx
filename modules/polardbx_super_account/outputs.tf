# Guards use length() of the resource tuple instead of var.super_account != null:
# referencing the sensitive variable directly in an output taints it for
# standalone validation, while the count-derived length check stays unmarked.
# admin_account_name is assigned from the sensitive variable, so its planned
# value carries the sensitive mark and the output must be declared sensitive.

output "super_account_admin_name" {
  description = "The name of the super (admin) account. Null when no super account is configured."
  value       = length(alibabacloudstack_polardbx_super_account.this) > 0 ? alibabacloudstack_polardbx_super_account.this[0].admin_account_name : null
  sensitive   = true
}

output "super_account_three_roles" {
  description = "Whether three-role rights separation (admin/security/audit) is enabled on the instance. Null when no super account is configured."
  value       = length(alibabacloudstack_polardbx_super_account.this) > 0 ? alibabacloudstack_polardbx_super_account.this[0].three_roles : null
}
