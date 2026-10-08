module "polardbx" {
  source = "../../modules/polardbx_instance"

  name           = var.name
  engine_version = var.engine_version
  storage        = var.storage
  vswitch_id     = var.vswitch_id
  cn_node_count  = var.cn_node_count
  dn_node_count  = var.dn_node_count
  databases      = var.databases
  accounts       = var.accounts
}

module "polardbx_super_account" {
  source = "../../modules/polardbx_super_account"

  instance_id   = module.polardbx.instance_id
  super_account = var.super_account
}
