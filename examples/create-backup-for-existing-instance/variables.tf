variable "db_instance_id" {
  description = "The ID of the existing PolarDBX instance."
  type        = string
}

variable "backup_type" {
  description = "The type of the manual backup. Valid values: 0 (physical backup)."
  type        = number
  default     = 0
}
