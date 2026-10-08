# Create Complete PolarDBX Instance

This example creates a complete PolarDBX instance setup including:
- PolarDBX instance with specified configuration
- Multiple databases with different character sets
- Database accounts with privileges
- Optional super account with three-role rights separation (admin/security/audit)

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
    super_account = {
      admin_account_name           = "admin_user"
      admin_account_password       = "SecurePassword123!"
      admin_account_description    = "Super admin account"
      security_account_name        = "security_user"
      security_account_password    = "SecurePassword123!"
      security_account_description = "Security admin account"
      audit_account_name           = "audit_user"
      audit_account_password       = "SecurePassword123!"
      audit_account_description    = "Audit account"
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
| polardbx_super_account | ../../modules/polardbx_super_account | n/a |

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
| super_account | Super account configuration (sensitive); set to null to skip. Security and audit account groups must be provided together. | object | null | No |

## Output Variables

| Name | Description |
|------|-------------|
| instance_id | ID of the created PolarDBX instance |
| instance_name | Name of the PolarDBX instance |
| database_names | List of created database names |
| account_names | List of created account names |
| vswitch_id | ID of the VSwitch used by the instance |
| vpc_id | ID of the VPC used by the instance |
| super_account_admin_name | Name of the super (admin) account, marked sensitive (null when not configured) |
| super_account_three_roles | Whether three-role rights separation is enabled (null when not configured) |

## Notes

- This example assumes VPC and VSwitch already exist.
- `cn_node_count` and `dn_node_count` must be at least 2.
- Account passwords should be securely provided (e.g., via environment variables or secret management).
- When configuring the super account, the security account group and the audit account group must be provided together; providing only one of them is rejected by the provider.
