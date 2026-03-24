# Create Read-Write Splitting for Existing PolarDBX Instance

This example creates a read-write splitting configuration for an existing PolarDBX instance.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   attend_htap_list = ["pxc-yyyyyyyy"]
   auto_attend_htap = true
   delay_execution_strategy = 1
   enable_consistent_replica_read = true
   enable_htap = true
   master_read_weight = 50
   storage_delay_threshold = 1000
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
| polardbx_read_write_splitting | ../../modules/polardbx_read_write_splitting | n/a |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| instance_id | ID of the existing PolarDBX instance | string | - | Yes |
| attend_htap_list | List of HTAP instances to attend | list(string) | [] | No |
| auto_attend_htap | Whether to automatically attend HTAP instances | bool | false | No |
| delay_execution_strategy | Delay execution strategy (0 or 1) | number | 0 | No |
| enable_consistent_replica_read | Whether to enable consistent replica read | bool | false | No |
| enable_htap | Whether to enable HTAP | bool | false | No |
| master_read_weight | Read weight of the master instance (1-100) | number | 50 | No |
| storage_delay_threshold | Storage delay threshold | number | 1000 | No |

## Output Variables

| Name | Description |
|------|-------------|
| rw_splitting_id | ID of the read-write splitting configuration |
| db_instance_id | ID of the PolarDBX instance |
| attend_htap_list | List of HTAP instances to attend |
| auto_attend_htap | Whether to automatically attend HTAP instances |
| delay_execution_strategy | Delay execution strategy |
| enable_consistent_replica_read | Whether to enable consistent replica read |
| enable_htap | Whether to enable HTAP |
| master_read_weight | Read weight of the master instance |
| storage_delay_threshold | Storage delay threshold |

## Notes

- This example requires an existing PolarDBX instance.
- `master_read_weight` must be between 1 and 100.
- HTAP-related settings are optional and depend on your specific use case.
