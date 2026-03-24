# Alibaba Cloud PolarDBX Backup Policy Terraform Module

This module manages backup policies for **existing** Alibaba Cloud PolarDBX instances on Alibaba Cloud Stack.

## Important Note

**This module does NOT create PolarDBX instances.** It only manages backup policies for existing instances. You must provide a valid `db_instance_id` of an existing PolarDBX instance.

## Supported Resources

* [alibabacloudstack_polardbx_backup_policy](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_backup_policy)

## Usage Examples

### Basic Usage

```hcl
module "backup_policy" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_backup_policy"

  db_instance_id = "pxc-xxxxxxxx"
}
```

### Advanced Usage (All Parameters)

```hcl
module "backup_policy" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_backup_policy"

  db_instance_id                  = "pxc-xxxxxxxx"
  backup_period                   = "Monday,Tuesday,Wednesday,Thursday,Friday"
  backup_set_retention            = 30
  backup_plan_begin               = "03:00Z"
  remove_log_retention            = 7
  local_log_retention_number      = 60
  force_clean_on_high_space_usage = 1
  local_log_retention             = 7
  log_local_retention_space       = 30
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.6 |

## Providers

| Name | Version |
|------|---------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| **db_instance_id** | **(Required) The ID of the existing PolarDBX instance.** | `string` | — | Yes |
| backup_period | Backup cycle. You can select multiple days in a week. Valid values: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. Multiple values are separated by commas. | `string` | `"Monday,Wednesday,Friday"` | No |
| backup_set_retention | The retention period of the backup set. Valid values: 7 to 730 days. | `number` | `7` | No |
| backup_plan_begin | The start time of the backup. The time format is HH:mmZ, for example, 03:00Z. | `string` | `"03:00Z"` | No |
| remove_log_retention | The retention period of transaction logs. Valid values: 7 to 730 days. | `number` | `7` | No |
| local_log_retention_number | The number of transaction logs retained locally. Valid values: 6 to 100. | `number` | `60` | No |
| force_clean_on_high_space_usage | Specifies whether to forcibly delete backups when the storage space usage is high. Valid values: 0 (no), 1 (yes). | `number` | `1` | No |
| local_log_retention | The retention period of transaction logs that are retained locally. Unit: days. | `number` | `7` | No |
| log_local_retention_space | The maximum space occupied by transaction logs that are retained locally. Unit: %. Valid values: 0 to 100. | `number` | `30` | No |
| backup_way | Backup method. Default: P (physical backup). | `string` | `"P"` | No |
| backup_type | Backup type. Default: 0 (full backup). | `string` | `"0"` | No |

## Output Variables

| Name | Description |
|------|-------------|
| db_instance_id | The ID of the PolarDBX instance for which the backup policy is configured. |
| backup_policy_applied | Whether the backup policy was applied. |
| backup_period | The configured backup cycle. |
| backup_set_retention | The configured retention period of the backup set. |
| backup_plan_begin | The configured start time of the backup. |
| remove_log_retention | The configured retention period of transaction logs. |

## Notes

- This module requires an existing PolarDBX instance. If `db_instance_id` is invalid or the instance does not exist, the module will fail.
- Running `terraform destroy` will remove the backup policy configuration from Terraform state, but the actual backup policy on the instance may remain.

## Reporting Issues

If you encounter any issues while using this module, please open an issue in the [provider repository](https://github.com/aliyun/terraform-provider-alibabacloudstack/issues/new).

> **Note**: Please do **not** open issues in this module's repository.

## Authors

Created and maintained by the Alibaba Cloud Terraform Team.

## License

MIT License. See LICENSE for details.
