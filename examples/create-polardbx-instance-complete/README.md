# Create Complete PolarDBX Instance

This example creates a complete PolarDBX instance setup including:
- PolarDBX instance with specified configuration
- Multiple databases with different character sets
- Database accounts with privileges

## Usage

1. Configure variables (via `terraform.tfvars` or CLI):
   ```hcl
   name          = "my-polardbx-complete"
   vpc_id        = "vpc-xxxxxxxx"
   vswitch_id    = "vsw-xxxxxxxx"
   databases = {
     app_db = {
       encode      = "utf8mb4"
       description = "Application database"
     }
     log_db = {
       encode      = "utf8"
       description = "Log database"
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
     readonly_user = {
       password     = "ReadOnlyPass123!"
       account_type = "Normal"
       account_privileges = {
         app_db = "ReadOnly"
         log_db = "ReadOnly"
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
| cn_node_count | Number of computing nodes (CN) | number | 2 | No |
| dn_node_count | Number of storage nodes (DN) | number | 2 | No |
| databases | Map of databases to create | map(object) | {} | No |
| accounts | Map of accounts to create | map(object) | {} | No |

## Output Variables

| Name | Description |
|------|-------------|
| instance_id | ID of the created PolarDBX instance |
| instance_name | Name of the PolarDBX instance |
| database_names | List of created database names |
| account_names | List of created account names |
| vswitch_id | ID of the VSwitch used by the instance |
| vpc_id | ID of the VPC used by the instance |

## Notes

- This example assumes VPC and VSwitch already exist.
- `cn_node_count` and `dn_node_count` must be at least 2.
- Account passwords should be securely provided (e.g., via environment variables or secret management).
