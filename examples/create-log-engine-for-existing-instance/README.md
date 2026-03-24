# Create Log Engine for Existing PolarDBX Instance

This example creates a log engine (CDC) configuration for an existing PolarDBX instance.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   cdc_node_class = "polarx.x4.medium.2e"
   cdc_node_count = 2
   multi_streams = [
     {
       group_name = "stream_group_1"
       comment    = "Primary stream group"
       hash_level = "RECORD"
       node_class = "polarx.x4.medium.2e"
       node_count = 2
     }
   ]
   ```

2. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Clean up:
   ```bash
   terraform destroy
   ```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.6 |

## Provider

| Name | Version |
|------|---------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## Module

| Name | Source | Version |
|------|--------|---------|
| polardbx_log_engine | ../../modules/polardbx_log_engine | n/a |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| instance_id | ID of the existing PolarDBX instance | string | - | Yes |
| cdc_node_class | Specification for log engine (CDC) nodes | string | "" | No |
| cdc_node_count | Number of log engine (CDC) nodes | number | 2 | No |
| multi_streams | List of multi-stream configurations | list(object) | [] | No |

## Output Variables

| Name | Description |
|------|-------------|
| log_engine_id | ID of the log engine configuration |
| instance_id | ID of the PolarDBX instance |
| cdc_node_class | Specification of CDC nodes |
| cdc_node_count | Number of CDC nodes |
| multi_stream | Multi-stream configuration |

## Notes

- This example requires an existing PolarDBX instance.
- If `cdc_node_class` is not specified, the first available CDC class will be used.
- Multi-stream configuration is optional and can be used for advanced CDC scenarios.
