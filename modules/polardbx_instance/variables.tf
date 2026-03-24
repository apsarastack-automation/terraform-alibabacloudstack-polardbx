variable "name" {
  description = "The name of the PolarDBX instance."
  type        = string
  default     = ""
}

variable "instance_id" {
  description = "The ID of an existing PolarDBX instance. If set, no new instance will be created."
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "The database engine version. Valid values: 5.7, 8.0."
  type        = string
  default     = "5.7"
}

variable "storage" {
  description = "The storage size of the instance in GB."
  type        = number
  default     = 50
}

variable "vswitch_id" {
  description = "The ID of the VSwitch for network configuration."
  type        = string
  default     = ""
}

variable "cn_node_class" {
  description = "The class of computing nodes (CN)."
  type        = string
  default     = ""
}

variable "cn_node_count" {
  description = "The number of computing nodes (CN)."
  type        = number
  default     = 2
}

variable "dn_node_class" {
  description = "The class of storage nodes (DN)."
  type        = string
  default     = ""
}

variable "dn_node_count" {
  description = "The number of storage nodes (DN)."
  type        = number
  default     = 2
}

variable "topology_type" {
  description = "The topology type. Valid values: 1azone, 3azones."
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the PolarDBX instance."
  type        = string
  default     = ""
}

variable "databases" {
  description = "Map of databases to create. Key is database name, value is database configuration."
  type = map(object({
    encode      = optional(string, "utf8mb4")
    mode        = optional(string, "auto")
    description = optional(string, "")
  }))
  default = {}
}

variable "accounts" {
  description = "Map of accounts to create. Key is account name, value is account configuration."
  type = map(object({
    password           = string
    description        = optional(string, "")
    account_privileges = optional(map(string), {})
  }))
  default = {}
}

variable "use_account_database_binding" {
  description = "Whether to use alibabacloudstack_polardbx_account_database_binding resource for account privileges."
  type        = bool
  default     = false
}
