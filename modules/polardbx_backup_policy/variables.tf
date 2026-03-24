variable "db_instance_id" {
  description = "(Required) The ID of the existing PolarDBX instance. This module does NOT create instances - only manages backup policy for existing ones."
  type        = string
}

variable "backup_period" {
  description = "The backup cycle. You can select multiple days in a week. Valid values: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. Multiple values are separated by commas."
  type        = string
  default     = "Monday,Wednesday,Friday"
}

variable "backup_set_retention" {
  description = "The retention period of the backup set. Valid values: 7 to 730 days."
  type        = number
  default     = 7
}

variable "backup_plan_begin" {
  description = "The start time of the backup. The time format is HH:mmZ, for example, 03:00Z."
  type        = string
  default     = "03:00Z"
}

variable "remove_log_retention" {
  description = "The retention period of transaction logs. Valid values: 7 to 730 days."
  type        = number
  default     = 7
}

variable "local_log_retention_number" {
  description = "The number of transaction logs retained locally. Valid values: 6 to 100."
  type        = number
  default     = 60
}

variable "force_clean_on_high_space_usage" {
  description = "Specifies whether to forcibly delete backups when the storage space usage is high. Valid values: 0 (no), 1 (yes)."
  type        = number
  default     = 1
}

variable "local_log_retention" {
  description = "The retention period of transaction logs that are retained locally. Unit: days."
  type        = number
  default     = 7
}

variable "log_local_retention_space" {
  description = "The maximum space occupied by transaction logs that are retained locally. Unit: %. Valid values: 0 to 100."
  type        = number
  default     = 30
}

variable "backup_way" {
  description = "Backup method. Default: P (physical backup)."
  type        = string
  default     = "P"
}

variable "backup_type" {
  description = "Backup type. Default: 0 (full backup)."
  type        = string
  default     = "0"
}
