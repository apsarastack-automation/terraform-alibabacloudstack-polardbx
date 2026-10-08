# --- PolarDBX Instance Variables ---

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

# --- Manual Backup Variables ---

variable "enable_backup" {
  description = "Whether to trigger a one-time manual backup for the PolarDBX instance. When true, a single manual backup is initiated after the instance is available."
  type        = bool
  default     = false
}

variable "backup_type" {
  description = "The type of the manual backup. Valid values: 0 (physical backup). Only used when enable_backup is true."
  type        = number
  default     = 0
}

# --- Log Engine Variables ---

variable "enable_log_engine" {
  description = "Whether to enable log engine (CDC) configuration."
  type        = bool
  default     = false
}

variable "log_engine_cdc_node_class" {
  description = "The specification for log engine (CDC) nodes."
  type        = string
  default     = ""
}

variable "log_engine_cdc_node_count" {
  description = "The number of log engine (CDC) nodes."
  type        = number
  default     = 2
}

variable "log_engine_multi_streams" {
  description = "List of multi-stream configurations for CDC."
  type = list(object({
    group_name = string
    comment    = optional(string, "")
    hash_level = string
    node_class = string
    node_count = number
  }))
  default = []
}

# --- Read-Write Splitting Variables ---

variable "enable_read_write_splitting" {
  description = "Whether to enable read-write splitting configuration."
  type        = bool
  default     = false
}

variable "rw_splitting_attend_htap_list" {
  description = "List of HTAP instances to attend."
  type        = list(string)
  default     = []
}

variable "rw_splitting_auto_attend_htap" {
  description = "Whether to automatically attend HTAP instances."
  type        = bool
  default     = false
}

variable "rw_splitting_delay_execution_strategy" {
  description = "Delay execution strategy. Valid values are 0 and 1."
  type        = number
  default     = 0
}

variable "rw_splitting_enable_consistent_replica_read" {
  description = "Whether to enable consistent replica read."
  type        = bool
  default     = false
}

variable "rw_splitting_enable_htap" {
  description = "Whether to enable HTAP."
  type        = bool
  default     = false
}

variable "rw_splitting_master_read_weight" {
  description = "The read weight of the master instance. Valid values are 1 to 100."
  type        = number
  default     = 50
}

variable "rw_splitting_storage_delay_threshold" {
  description = "The storage delay threshold for read-write splitting."
  type        = number
  default     = 1000
}

# --- Read-Only Instance Variables ---

variable "enable_readonly_instance" {
  description = "Whether to create a read-only instance for the PolarDBX primary instance."
  type        = bool
  default     = false
}

variable "readonly_instance_name" {
  description = "The name of the read-only PolarDBX instance."
  type        = string
  default     = ""
}

variable "readonly_storage" {
  description = "The storage size of the read-only instance in GB."
  type        = number
  default     = 50
}

variable "readonly_cn_node_count" {
  description = "The number of computing nodes (CN) for the read-only instance."
  type        = number
  default     = 2
}

variable "readonly_dn_node_count" {
  description = "The number of storage nodes (DN) for the read-only instance."
  type        = number
  default     = 2
}

variable "readonly_cn_node_class" {
  description = "The class of computing nodes (CN) for the read-only instance."
  type        = string
  default     = ""
}

variable "readonly_dn_node_class" {
  description = "The class of storage nodes (DN) for the read-only instance."
  type        = string
  default     = ""
}

variable "readonly_description" {
  description = "The description of the read-only PolarDBX instance."
  type        = string
  default     = ""
}
