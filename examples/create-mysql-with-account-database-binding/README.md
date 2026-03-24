# Create PolarDBX Instance with Account Database Binding

This example demonstrates how to create a PolarDBX instance and use the `account_database_binding` resource to manage account privileges.

## Important Note

This example uses `use_account_database_binding = true` to manage account privileges through the `alibabacloudstack_polardbx_account_database_binding` resource instead of the `account_privilege` attribute.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   name       = "my-polardbx-binding"
   vpc_id     = "vpc-xxxxxxxx"
   vswitch_id = "vsw-xxxxxxxx"
   databases = {
     app_db = {
       encode      = "utf8mb4"
       description = "Application database"
     }
   }
   accounts = {
     app_user = {
       password     = "SecurePassword123!"
       account_type = "Normal"
       account_privileges = {
         app_db = "ReadWrite"
       }
     }
   }
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
| polardbx | ../../modules/polardbx_instance | n/a |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the PolarDBX instance | string | - | Yes |
| vpc_id | ID of the VPC | string | - | Yes |
| vswitch_id | ID of the VSwitch | string | - | Yes |
| engine_version | Database engine version | string | "5.7" | No |
| storage | Storage size in GB | number | 50 | No |
| databases | Map of databases to create | map(object) | {} | No |
| accounts | Map of accounts to create | map(object) | {} | No |

## Output Variables

| Name | Description |
|------|-------------|
| instance_id | ID of the created PolarDBX instance |
| instance_name | Name of the PolarDBX instance |
| database_names | List of created database names |
| account_names | List of created account names |

## Notes

- This example uses `use_account_database_binding = true`.
- The `account_database_binding` resource provides more granular control over account privileges.
- This approach is recommended when you need to manage complex privilege configurations.
