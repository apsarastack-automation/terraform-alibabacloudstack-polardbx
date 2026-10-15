variable "name" {
  description = "The name of the PolarDBX instance."
  type        = string
}

variable "vswitch_id" {
  description = "The ID of the VSwitch."
  type        = string
}

variable "engine_version" {
  description = "The database engine version."
  type        = string
  default     = "5.7"
}

variable "storage" {
  description = "The storage size in GB."
  type        = number
  default     = 50
}

variable "cn_node_count" {
  description = "The number of computing nodes (CN)."
  type        = number
  default     = 2
}

variable "dn_node_count" {
  description = "The number of storage nodes (DN)."
  type        = number
  default     = 2
}

variable "databases" {
  description = "Map of databases to create."
  type = map(object({
    encode      = optional(string, "utf8mb4")
    mode        = optional(string, "auto")
    description = optional(string, "")
  }))
  default = {}
}

variable "accounts" {
  description = "Map of accounts to create."
  type = map(object({
    password           = string
    account_type       = optional(string, "Normal")
    description        = optional(string, "")
    account_privileges = optional(map(string), {})
  }))
  default = {}
}

variable "super_account" {
  description = "Super account configuration. Set to null to skip creating the super account. The security account group and the audit account group must be provided together - either both or neither."
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
