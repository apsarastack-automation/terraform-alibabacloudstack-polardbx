module "polardbx_log_engine" {
  source = "../../modules/polardbx_log_engine"

  instance_id       = var.instance_id
  enable_log_engine = true
  cdc_node_class    = var.cdc_node_class
  cdc_node_count    = var.cdc_node_count
  multi_streams     = var.multi_streams
}
