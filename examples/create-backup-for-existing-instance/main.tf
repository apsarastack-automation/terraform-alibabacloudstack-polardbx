module "polardbx_backup" {
  source = "../../modules/polardbx_instance"

  instance_id   = var.db_instance_id
  enable_backup = true
  backup_type   = var.backup_type
}
