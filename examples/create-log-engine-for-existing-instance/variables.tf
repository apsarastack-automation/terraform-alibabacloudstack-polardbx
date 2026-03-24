variable "instance_id" {
  description = "The ID of the existing PolarDBX instance."
  type        = string
}

variable "cdc_node_class" {
  description = "The specification for log engine (CDC) nodes. If not specified, the first available CDC class will be used."
  type        = string
  default     = ""
}

variable "cdc_node_count" {
  description = "The number of log engine (CDC) nodes."
  type        = number
  default     = 2
}

variable "multi_streams" {
  description = "List of multi-stream configurations for CDC log engine."
  type = list(object({
    group_name = string
    comment    = optional(string, "")
    hash_level = string
    node_class = string
    node_count = number
  }))
  default = []
}
