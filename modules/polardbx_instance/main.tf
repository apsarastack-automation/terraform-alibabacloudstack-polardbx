# --- Data Sources ---

data "alibabacloudstack_polardbx_instances" "default" {
  ids = [coalesce(var.instance_id, "fake_id")]
}

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
  # Determine if we need to create a new instance
  create_instance = var.instance_id == ""

  # Get the zone ID
  zone_id = data.alibabacloudstack_zones.default.zones[0].id

  instance_id = local.create_instance ? alibabacloudstack_polardbx_instance.default[0].id : data.alibabacloudstack_polardbx_instances.default.ids[0]

  cn_node_class = var.cn_node_class != "" ? var.cn_node_class : data.alibabacloudstack_polardbx_instance_types.cn.instance_types[0].id
  dn_node_class = var.dn_node_class != "" ? var.dn_node_class : data.alibabacloudstack_polardbx_instance_types.dn.instance_types[0].id
}

# --- PolarDBX Instance Resource ---
# This module creates and manages PolarDBX instances.
# For backup policy management, use the polardbx_backup_policy module separately.
# For read-only instance management, use the polardbx_readonly_instance module separately.

resource "alibabacloudstack_polardbx_instance" "default" {
  count = local.create_instance ? 1 : 0

  description    = var.description != "" ? var.description : var.name
  zone_id        = local.zone_id
  engine_version = var.engine_version
  storage        = var.storage
  vswitch_id     = var.vswitch_id
  cn_node_class  = local.cn_node_class
  cn_node_count  = var.cn_node_count
  dn_node_class  = local.dn_node_class
  dn_node_count  = var.dn_node_count
  topology_type  = var.topology_type != "" ? var.topology_type : null
}

# --- PolarDBX Database Resources ---

resource "alibabacloudstack_polardbx_database" "default" {
  for_each = var.databases

  instance_id   = local.instance_id
  database_name = each.key
  encode        = each.value.encode
  mode          = each.value.mode
  description   = each.value.description

  depends_on = [alibabacloudstack_polardbx_instance.default]
}

# --- PolarDBX Account Resources ---

resource "alibabacloudstack_polardbx_account" "default" {
  for_each = var.accounts

  instance_id  = local.instance_id
  account_name = each.key
  password     = each.value.password
  description  = each.value.description

  depends_on = [alibabacloudstack_polardbx_instance.default]
}

# --- PolarDBX Account Database Binding Resources ---

resource "alibabacloudstack_polardbx_account_database_binding" "default" {
  for_each = var.use_account_database_binding ? var.accounts : {}

  instance_id  = local.instance_id
  account_name = each.key

  dynamic "db_privileges" {
    for_each = each.value.account_privileges
    content {
      db_name   = db_privileges.key
      privilege = db_privileges.value
    }
  }

  depends_on = [
    alibabacloudstack_polardbx_account.default,
    alibabacloudstack_polardbx_database.default
  ]
}

# --- PolarDBX Manual Backup Resource ---

resource "alibabacloudstack_polardbx_backup" "this" {
  count = var.enable_backup ? 1 : 0

  instance_id = local.instance_id
  backup_type = var.backup_type

  depends_on = [alibabacloudstack_polardbx_instance.default]
}


