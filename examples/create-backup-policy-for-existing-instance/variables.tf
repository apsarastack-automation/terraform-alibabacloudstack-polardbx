variable "db_instance_id" {
  description = "The ID of the existing PolarDBX instance."
  type        = string
}

variable "backup_period" {
  description = "The backup cycle."
  type        = string
  default     = "Monday,Wednesday,Friday"
}

variable "backup_set_retention" {
  description = "The retention period of the backup set."
  type        = number
  default     = 7
}

variable "backup_plan_begin" {
  description = "The start time of the backup."
  type        = string
  default     = "03:00Z"
}

variable "remove_log_retention" {
  description = "The retention period of transaction logs."
  type        = number
  default     = 7
}

variable "local_log_retention_number" {
  description = "The number of transaction logs retained locally."
  type        = number
  default     = 60
}

variable "force_clean_on_high_space_usage" {
  description = "Whether to forcibly delete backups when storage space is high."
  type        = number
  default     = 1
}

variable "local_log_retention" {
  description = "The retention period of transaction logs retained locally."
  type        = number
  default     = 7
}

variable "log_local_retention_space" {
  description = "The maximum space occupied by transaction logs retained locally."
  type        = number
  default     = 30
}

variable "backup_way" {
  description = "Backup method."
  type        = string
  default     = "P"
}

variable "backup_type" {
  description = "Backup type."
  type        = string
  default     = "0"
}
