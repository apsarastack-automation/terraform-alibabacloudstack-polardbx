variable "db_instance_id" {
  description = "The ID of the existing PolarDBX instance."
  type        = string
}

variable "attend_htap_list" {
  description = "List of HTAP instances to attend."
  type        = list(string)
  default     = []
}

variable "auto_attend_htap" {
  description = "Whether to automatically attend HTAP instances."
  type        = bool
  default     = false
}

variable "delay_execution_strategy" {
  description = "Delay execution strategy. Valid values are 0 and 1."
  type        = number
  default     = 0
}

variable "enable_consistent_replica_read" {
  description = "Whether to enable consistent replica read."
  type        = bool
  default     = false
}

variable "enable_htap" {
  description = "Whether to enable HTAP."
  type        = bool
  default     = false
}

variable "master_read_weight" {
  description = "The read weight of the master instance. Valid values are 1 to 100."
  type        = number
  default     = 50
}

variable "storage_delay_threshold" {
  description = "The storage delay threshold."
  type        = number
  default     = 1000
}
