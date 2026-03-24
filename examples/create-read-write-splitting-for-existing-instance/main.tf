module "polardbx_read_write_splitting" {
  source = "../../modules/polardbx_read_write_splitting"

  db_instance_id                 = var.db_instance_id
  enable_read_write_splitting    = true
  attend_htap_list               = var.attend_htap_list
  auto_attend_htap               = var.auto_attend_htap
  delay_execution_strategy       = var.delay_execution_strategy
  enable_consistent_replica_read = var.enable_consistent_replica_read
  enable_htap                    = var.enable_htap
  master_read_weight             = var.master_read_weight
  storage_delay_threshold        = var.storage_delay_threshold
}
