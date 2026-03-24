# Use Existing PolarDBX Instance

This example demonstrates how to use an existing PolarDBX instance to create databases and accounts without creating a new instance.

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   databases = {
     new_db = {
       encode      = "utf8mb4"
       description = "New database"
     }
   }
   accounts = {
     new_user = {
       password     = "SecurePassword123!"
       account_type = "Normal"
       account_privileges = {
         new_db = "ReadWrite"
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
| instance_id | ID of the existing PolarDBX instance | string | - | Yes |
| databases | Map of databases to create | map(object) | {} | No |
| accounts | Map of accounts to create | map(object) | {} | No |

## Output Variables

| Name | Description |
|------|-------------|
| instance_id | ID of the existing PolarDBX instance |
| database_names | List of created database names |
| account_names | List of created account names |

## Notes

- This example does NOT create a new instance.
- The `instance_id` must be a valid existing PolarDBX instance.
- Running `terraform destroy` will only remove the databases and accounts managed by Terraform, not the instance itself.
