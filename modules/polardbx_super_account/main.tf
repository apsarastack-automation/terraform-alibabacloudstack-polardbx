# --- PolarDBX Super Account Resource ---
# This module manages the super account (with optional three-role rights
# separation: admin / security / audit) for an existing PolarDBX instance.
# The instance_id must be provided as a parameter - this module does NOT create instances.
#
# audit_account_description must stay null (not "") when the audit group is unset:
# the provider marks it RequiredWith audit_account_name, and the SDK rejects an
# explicitly-set empty string while audit_account_name is absent.

resource "alibabacloudstack_polardbx_super_account" "this" {
  count = var.super_account != null ? 1 : 0

  instance_id                  = var.instance_id
  admin_account_name           = var.super_account.admin_account_name
  admin_account_password       = var.super_account.admin_account_password
  admin_account_description    = var.super_account.admin_account_description
  security_account_name        = var.super_account.security_account_name
  security_account_password    = var.super_account.security_account_password
  security_account_description = var.super_account.security_account_description
  audit_account_name           = var.super_account.audit_account_name
  audit_account_password       = var.super_account.audit_account_password
  audit_account_description    = var.super_account.audit_account_description
}
