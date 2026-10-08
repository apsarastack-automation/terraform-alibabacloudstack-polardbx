variable "instance_id" {
  description = "(Required) The ID of the existing PolarDBX instance on which the super account will be created. This module does NOT create instances - only manages the super account for existing ones."
  type        = string
}

variable "super_account" {
  description = "Super account configuration. Set to null to skip creating the super account. The security account group (name/password) and the audit account group (name/password) must be provided together - either both or neither."
  type = object({
    admin_account_name           = string
    admin_account_password       = string
    admin_account_description    = optional(string, "")
    security_account_name        = optional(string)
    security_account_password    = optional(string)
    security_account_description = optional(string, "")
    audit_account_name           = optional(string)
    audit_account_password       = optional(string)
    audit_account_description    = optional(string)
  })
  default   = null
  sensitive = true
}
