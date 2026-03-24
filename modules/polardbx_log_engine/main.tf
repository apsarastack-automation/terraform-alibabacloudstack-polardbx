# --- PolarDBX Log Engine Resource ---
# This module manages log engine (CDC) configuration for an existing PolarDBX instance.
# The instance_id must be provided as a parameter - this module does NOT create instances.

# Data source for CDC instance types
data "alibabacloudstack_polardbx_cdc_classes" "default" {
  instance_id = var.instance_id
  sorted_by   = "CPU"
}

# Local variables for defaults
locals {
  cdc_node_class = var.cdc_node_class != "" ? var.cdc_node_class : (
    length(data.alibabacloudstack_polardbx_cdc_classes.default.cdc_classes) > 0 ?
    data.alibabacloudstack_polardbx_cdc_classes.default.cdc_classes[0].id : ""
  )
}

resource "alibabacloudstack_polardbx_log_engine" "default" {
  count = var.enable_log_engine ? 1 : 0

  instance_id    = var.instance_id
  cdc_node_class = local.cdc_node_class
  cdc_node_count = var.cdc_node_count

  dynamic "multi_stream" {
    for_each = var.multi_streams
    content {
      group_name = multi_stream.value.group_name
      comment    = lookup(multi_stream.value, "comment", "")
      hash_level = multi_stream.value.hash_level
      node_class = multi_stream.value.node_class
      node_count = multi_stream.value.node_count
    }
  }
}
