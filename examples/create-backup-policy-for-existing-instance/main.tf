module "backup_policy" {
  source = "../../modules/polardbx_backup_policy"

  db_instance_id                  = var.db_instance_id
  backup_period                   = var.backup_period
  backup_set_retention            = var.backup_set_retention
  backup_plan_begin               = var.backup_plan_begin
  remove_log_retention            = var.remove_log_retention
  local_log_retention_number      = var.local_log_retention_number
  force_clean_on_high_space_usage = var.force_clean_on_high_space_usage
  local_log_retention             = var.local_log_retention
  log_local_retention_space       = var.log_local_retention_space
  backup_way                      = var.backup_way
  backup_type                     = var.backup_type
}
