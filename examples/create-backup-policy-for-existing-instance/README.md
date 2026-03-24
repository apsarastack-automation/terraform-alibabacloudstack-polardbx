# Create Backup Policy for Existing PolarDBX Instance

This example demonstrates how to configure a backup policy for an existing PolarDBX instance.

## Important Note

**This example does NOT create a PolarDBX instance.** It only configures the backup policy for an existing instance. You must provide a valid `db_instance_id`.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   db_instance_id       = "pxc-xxxxxxxx"
   backup_period        = "Monday,Wednesday,Friday"
   backup_set_retention = 7
   backup_plan_begin    = "03:00Z"
   remove_log_retention = 7
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
| backup_policy | ../../modules/polardbx_backup_policy | n/a |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| db_instance_id | ID of the existing PolarDBX instance | string | - | Yes |
| backup_period | Backup cycle | string | "Monday,Wednesday,Friday" | No |
| backup_set_retention | Retention period of the backup set (days) | number | 7 | No |
| backup_plan_begin | Start time of the backup (HH:mmZ) | string | "03:00Z" | No |
| remove_log_retention | Retention period of transaction logs (days) | number | 7 | No |

## Output Variables

| Name | Description |
|------|-------------|
| db_instance_id | ID of the PolarDBX instance |
| backup_policy_applied | Whether the backup policy was applied |
| backup_period | The configured backup cycle |
| backup_set_retention | The configured retention period |

## Notes

- This example requires an existing PolarDBX instance.
- Running `terraform destroy` will remove the backup policy configuration from Terraform state.
- The actual backup policy on the instance may remain after destroy.
