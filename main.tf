# --- Root Module: terraform-alibabacloudstack-polardbx ---
# This is a wrapper module that delegates to the polardbx_instance submodule.
# For backup policy management, use the polardbx_backup_policy submodule separately.
# For log engine (CDC) management, use the polardbx_log_engine submodule separately.
# For read-write splitting configuration, use the polardbx_read_write_splitting submodule separately.
# For read-only instance management, use the polardbx_readonly_instance submodule separately.
# For super account (three-role rights separation) management, use the polardbx_super_account submodule.

module "polardbx_instance" {
  source = "./modules/polardbx_instance"

  name                         = var.name
  instance_id                  = var.instance_id
  engine_version               = var.engine_version
  storage                      = var.storage
  vswitch_id                   = var.vswitch_id
  cn_node_class                = var.cn_node_class
  cn_node_count                = var.cn_node_count
  dn_node_class                = var.dn_node_class
  dn_node_count                = var.dn_node_count
  topology_type                = var.topology_type
  description                  = var.description
  databases                    = var.databases
  accounts                     = var.accounts
  use_account_database_binding = var.use_account_database_binding
  enable_backup                = var.enable_backup
  backup_type                  = var.backup_type
}

module "polardbx_super_account" {
  source = "./modules/polardbx_super_account"

  instance_id   = module.polardbx_instance.instance_id
  super_account = var.super_account

  # Enabling three-role rights separation transiently flips the instance out
  # of Running; it must be serialized AFTER the instance module finishes all
  # database/account resources, otherwise a concurrent CreateDB races with the
  # separation change and fails with DBInstance.NotRunning. Destroy order is
  # reversed too: separation is disabled before normal accounts are deleted.
  depends_on = [module.polardbx_instance]
}

module "polardbx_log_engine" {
  source = "./modules/polardbx_log_engine"

  instance_id       = module.polardbx_instance.instance_id
  enable_log_engine = var.enable_log_engine
  cdc_node_class    = var.log_engine_cdc_node_class
  cdc_node_count    = var.log_engine_cdc_node_count
  multi_streams     = var.log_engine_multi_streams
}

module "polardbx_read_write_splitting" {
  source = "./modules/polardbx_read_write_splitting"

  db_instance_id                 = module.polardbx_instance.instance_id
  enable_read_write_splitting    = var.enable_read_write_splitting
  attend_htap_list               = var.rw_splitting_attend_htap_list
  auto_attend_htap               = var.rw_splitting_auto_attend_htap
  delay_execution_strategy       = var.rw_splitting_delay_execution_strategy
  enable_consistent_replica_read = var.rw_splitting_enable_consistent_replica_read
  enable_htap                    = var.rw_splitting_enable_htap
  master_read_weight             = var.rw_splitting_master_read_weight
  storage_delay_threshold        = var.rw_splitting_storage_delay_threshold
}

module "polardbx_readonly_instance" {
  source = "./modules/polardbx_readonly_instance"

  name                     = var.readonly_instance_name
  primary_db_instance_id   = module.polardbx_instance.instance_id
  vswitch_id               = var.vswitch_id
  create_readonly_instance = var.enable_readonly_instance

  engine_version = var.engine_version
  storage        = var.readonly_storage
  cn_node_count  = var.readonly_cn_node_count
  dn_node_count  = var.readonly_dn_node_count
  cn_node_class  = var.readonly_cn_node_class
  dn_node_class  = var.readonly_dn_node_class
  description    = var.readonly_description
}
