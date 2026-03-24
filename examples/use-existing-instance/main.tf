module "polardbx" {
  source = "../../modules/polardbx_instance"

  instance_id = var.instance_id
  databases   = var.databases
  accounts    = var.accounts
}
