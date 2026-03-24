module "polardbx" {
  source = "../../modules/polardbx_instance"

  name                         = var.name
  engine_version               = var.engine_version
  storage                      = var.storage
  vswitch_id                   = var.vswitch_id
  use_account_database_binding = true
  databases                    = var.databases
  accounts                     = var.accounts
}
