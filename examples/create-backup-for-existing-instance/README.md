# Create Manual Backup for Existing PolarDBX Instance

This example demonstrates how to trigger a one-time manual backup for an existing PolarDBX instance.

## Important Note

**This example does NOT create a PolarDBX instance.** It only triggers a manual backup for an existing instance. You must provide a valid `db_instance_id`.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   db_instance_id = "pxc-xxxxxxxx"
   backup_type    = 0
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
| polardbx_backup | ../../modules/polardbx_instance | n/a |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| db_instance_id | ID of the existing PolarDBX instance | string | - | Yes |
| backup_type | Type of the manual backup (0 = physical backup) | number | 0 | No |

## Output Variables

| Name | Description |
|------|-------------|
| db_instance_id | ID of the PolarDBX instance |
| backup_set_id | ID of the backup set created by the manual backup |
| backup_status | Status of the manual backup (0 = creating, 1 = success, 2 = failed) |

## Notes

- This example requires an existing PolarDBX instance.
- The backup resource is trigger-style: it has no update operation and all arguments are ForceNew. Changing any argument initiates a new backup.
- The provider's delete operation for the backup resource is a no-op: `terraform destroy` removes it from state, but the backup set remains on the instance.
- For periodic backup policies, use the `create-backup-policy-for-existing-instance` example (backed by the `polardbx_backup_policy` module) instead.
