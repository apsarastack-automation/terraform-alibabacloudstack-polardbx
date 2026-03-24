variable "name" {
  description = "The name prefix for resources."
  type        = string
  default     = "tfpolardbx"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "172.16.0.0/16"
}

variable "vswitch_cidr" {
  description = "The CIDR block for the VSwitch."
  type        = string
  default     = "172.16.1.0/24"
}

variable "zone_id" {
  description = "The zone ID for the VSwitch."
  type        = string
  default     = ""
}

# Data source for zones
data "alibabacloudstack_zones" "default" {
  available_resource_creation = "VSwitch"
}

# Local variables
locals {
  zone_id = var.zone_id != "" ? var.zone_id : data.alibabacloudstack_zones.default.zones[0].id
}

# VPC Resource
resource "alibabacloudstack_vpc_vpc" "default" {
  vpc_name   = "${var.name}_vpc"
  cidr_block = var.vpc_cidr
}

# VSwitch Resource
resource "alibabacloudstack_vpc_vswitch" "default" {
  vswitch_name = "${var.name}_vsw"
  vpc_id       = alibabacloudstack_vpc_vpc.default.id
  cidr_block   = var.vswitch_cidr
  zone_id      = local.zone_id
}
