# --- PolarDBX Read-Write Splitting Configuration Resource ---
# This module manages read-write splitting configuration for an existing PolarDBX instance.
# The db_instance_id must be provided as a parameter - this module does NOT create instances.

resource "alibabacloudstack_polardbx_read_write_splitting_config" "default" {
  count = var.enable_read_write_splitting ? 1 : 0

  db_instance_id                 = var.db_instance_id
  attend_htap_list               = var.attend_htap_list
  auto_attend_htap               = var.auto_attend_htap
  delay_execution_strategy       = var.delay_execution_strategy
  enable_consistent_replica_read = var.enable_consistent_replica_read
  enable_htap                    = var.enable_htap
  master_read_weight             = var.master_read_weight
  storage_delay_threshold        = var.storage_delay_threshold
}
