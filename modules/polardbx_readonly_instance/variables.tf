variable "name" {
  description = "The name of the read-only PolarDBX instance."
  type        = string
  default     = ""
}

variable "primary_db_instance_id" {
  description = "(Required) The ID of the primary PolarDBX instance."
  type        = string
}

variable "create_readonly_instance" {
  description = "Whether to create the read-only instance."
  type        = bool
  default     = true
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
  description = "The description of the read-only PolarDBX instance."
  type        = string
  default     = ""
}
