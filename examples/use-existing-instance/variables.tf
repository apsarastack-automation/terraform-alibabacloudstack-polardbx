variable "instance_id" {
  description = "The ID of the existing PolarDBX instance."
  type        = string
}

variable "databases" {
  description = "Map of databases to create on the existing instance."
  type = map(object({
    encode      = optional(string, "utf8mb4")
    mode        = optional(string, "auto")
    description = optional(string, "")
  }))
  default = {}
}

variable "accounts" {
  description = "Map of accounts to create on the existing instance."
  type = map(object({
    password           = string
    account_type       = optional(string, "Normal")
    description        = optional(string, "")
    account_privileges = optional(map(string), {})
  }))
  default = {}
}
