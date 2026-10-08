# Alibaba Cloud PolarDBX Super Account Terraform Module

This module manages the super account (with optional three-role rights separation) for **existing** Alibaba Cloud PolarDBX instances on Alibaba Cloud Stack.

## Important Note

**This module does NOT create PolarDBX instances.** It only manages the super account for an existing instance. You must provide a valid `instance_id` of an existing PolarDBX instance.

## Supported Resources

* [alibabacloudstack_polardbx_super_account](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_super_account)

## Usage Examples

### Basic Usage (Admin Account Only)

```hcl
module "super_account" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_super_account"

  instance_id = "pxc-xxxxxxxx"

  super_account = {
    admin_account_name        = "admin_user"
    admin_account_password    = "SecurePassword123!"
    admin_account_description = "Super admin account"
  }
}
```

### Advanced Usage (Three-Role Rights Separation)

```hcl
module "super_account" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_super_account"

  instance_id = "pxc-xxxxxxxx"

  super_account = {
    admin_account_name             = "admin_user"
    admin_account_password         = "SecurePassword123!"
    admin_account_description      = "Super admin account"
    security_account_name          = "security_user"
    security_account_password      = "SecurePassword123!"
    security_account_description   = "Security admin account"
    audit_account_name             = "audit_user"
    audit_account_password         = "SecurePassword123!"
    audit_account_description      = "Audit account"
  }
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
| **instance_id** | **(Required) The ID of the existing PolarDBX instance.** | `string` | — | Yes |
| super_account | Super account configuration object; set to `null` to skip account creation. Fields: `admin_account_name` (string, required), `admin_account_password` (string, required), `admin_account_description` (optional string), `security_account_name` / `security_account_password` / `security_account_description` (optional), `audit_account_name` / `audit_account_password` / `audit_account_description` (optional). | `object` | `null` | No |

## Output Variables

| Name | Description |
|------|-------------|
| super_account_admin_name | The name of the super (admin) account; `null` when no super account is configured. Marked sensitive (derived from the sensitive `super_account` variable). |
| super_account_three_roles | Whether three-role rights separation (admin/security/audit) is enabled; `null` when no super account is configured. |

## Notes

- This module requires an existing PolarDBX instance. If `instance_id` is invalid or the instance does not exist, the module will fail.
- The security account group and the audit account group must be provided together; providing only one of them will be rejected by the provider (`RequiredWith` validation).
- `admin_account_name` supports 1-16 characters (letters, digits, underscores, hyphens); passwords must be 8-32 characters containing uppercase, lowercase, digits, and special characters.
- The `super_account` variable is marked sensitive; account passwords will not be displayed in plan/apply output.
- The provider's delete operation for this resource is a no-op: `terraform destroy` removes the resource from state, but the accounts remain on the instance.

## Reporting Issues

If you encounter any issues while using this module, please open an issue in the [provider repository](https://github.com/aliyun/terraform-provider-alibabacloudstack/issues/new).

> **Note**: Please do **not** open issues in this module's repository.

## Authors

Created and maintained by the Alibaba Cloud Terraform Team.

## License

MIT License. See LICENSE for details.
