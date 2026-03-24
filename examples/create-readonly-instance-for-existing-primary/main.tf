module "polardbx_readonly" {
  source = "../../modules/polardbx_readonly_instance"

  name                     = var.name
  primary_db_instance_id   = var.primary_db_instance_id
  vswitch_id               = var.vswitch_id
  create_readonly_instance = true

  engine_version = var.engine_version
  storage        = var.storage
  cn_node_count  = var.cn_node_count
  dn_node_count  = var.dn_node_count
  cn_node_class  = var.cn_node_class
  dn_node_class  = var.dn_node_class
  description    = var.description
}
