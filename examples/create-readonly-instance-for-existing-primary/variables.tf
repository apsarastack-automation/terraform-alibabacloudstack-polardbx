variable "name" {
  description = "The name of the read-only PolarDBX instance."
  type        = string
}

variable "primary_db_instance_id" {
  description = "The ID of the primary PolarDBX instance."
  type        = string
}

variable "vswitch_id" {
  description = "The ID of the VSwitch for network configuration."
  type        = string
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

variable "cn_node_class" {
  description = "The class of computing nodes (CN)."
  type        = string
  default     = ""
}

variable "dn_node_class" {
  description = "The class of storage nodes (DN)."
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the read-only PolarDBX instance."
  type        = string
  default     = ""
}
