data "alibabacloudstack_zones" "default" {
  available_resource_creation = "VSwitch"
}

data "alibabacloudstack_polardbx_instance_types" "cn" {
  spec_type = "CN"
  sorted_by = "CPU"
}

data "alibabacloudstack_polardbx_instance_types" "dn" {
  spec_type = "DN"
  sorted_by = "CPU"
}

# --- Locals ---

locals {
  zone_id       = data.alibabacloudstack_zones.default.zones[0].id
  cn_node_class = var.cn_node_class != "" ? var.cn_node_class : data.alibabacloudstack_polardbx_instance_types.cn.instance_types[0].id
  dn_node_class = var.dn_node_class != "" ? var.dn_node_class : data.alibabacloudstack_polardbx_instance_types.dn.instance_types[0].id
}

resource "alibabacloudstack_polardbx_readonly_instance" "default" {
  count = var.create_readonly_instance ? 1 : 0

  description            = var.description != "" ? var.description : "${var.name}-readonly"
  engine_version         = var.engine_version
  storage                = var.storage
  vswitch_id             = var.vswitch_id
  cn_node_class          = local.cn_node_class
  cn_node_count          = var.cn_node_count
  dn_node_class          = local.dn_node_class
  dn_node_count          = var.dn_node_count
  topology_type          = var.topology_type != "" ? var.topology_type : null
  zone_id                = local.zone_id
  primary_db_instance_id = var.primary_db_instance_id
}
