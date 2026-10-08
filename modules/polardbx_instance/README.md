# Alibaba Cloud PolarDBX Instance Terraform Module

This module manages Alibaba Cloud PolarDBX instances and related resources on Alibaba Cloud Stack, supporting:
- **Creating a new PolarDBX instance** and configuring databases
- **Creating databases and accounts for an existing PolarDBX instance**
- **Managing account database privileges** (via account_database_binding)

## Important Note

**Backup policy management has been moved to a separate module.** To configure backup policies, use the `polardbx_backup_policy` module instead. This separation allows you to manage backup policies independently from instance creation.

## Supported Resources

* [alibabacloudstack_polardbx_instance](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_instance)
* [alibabacloudstack_polardbx_database](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_database)
* [alibabacloudstack_polardbx_account](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_account)
* [alibabacloudstack_polardbx_account_database_binding](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_account_database_binding)
* [alibabacloudstack_polardbx_backup](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_backup)

## Usage Examples

### Scenario 1: Create a new PolarDBX instance with databases and accounts

```hcl
module "polardbx" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_instance"

  name           = "my-polardbx-instance"
  engine_version = "5.7"
  storage        = 50
  vpc_id         = "vpc-xxxxxxxx"
  vswitch_id     = "vsw-xxxxxxxx"
  cn_node_count  = 2
  dn_node_count  = 2
  
  databases = {
    mydb = {
      encode      = "utf8mb4"
      description = "My application database"
    }
  }
  
  accounts = {
    app_user = {
      password           = "SecurePassword123!"
      account_type       = "Normal"
      account_privileges = {
        mydb = "ReadWrite"
      }
    }
  }
}
```

### Scenario 2: Create databases and accounts for an existing PolarDBX instance

```hcl
module "polardbx" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_instance"

  instance_id = "pxc-xxxxxxxx"
  
  databases = {
    newdb = {
      encode = "utf8mb4"
    }
  }
  
  accounts = {
    newuser = {
      password     = "SecurePassword123!"
      account_type = "Normal"
    }
  }
}
```

### Scenario 3: Use account_database_binding for privileges

```hcl
module "polardbx" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_instance"

  name           = "my-polardbx-instance"
  engine_version = "5.7"
  storage        = 50
  vpc_id         = "vpc-xxxxxxxx"
  vswitch_id     = "vsw-xxxxxxxx"
  cn_node_count  = 2
  dn_node_count  = 2
  
  use_account_database_binding = true
  
  databases = {
    mydb = {
      encode = "utf8mb4"
    }
  }
  
  accounts = {
    app_user = {
      password     = "SecurePassword123!"
      account_type = "Normal"
      account_privileges = {
        mydb = "ReadWrite"
      }
    }
  }
}
```

### Scenario 4: Configure backup policy using separate module

```hcl
# First, create the instance
module "polardbx" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_instance"

  name           = "my-polardbx-instance"
  engine_version = "5.7"
  storage        = 50
  vpc_id         = "vpc-xxxxxxxx"
  vswitch_id     = "vsw-xxxxxxxx"
  cn_node_count  = 2
  dn_node_count  = 2
}

# Then, configure backup policy separately
module "backup_policy" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_backup_policy"

  db_instance_id = module.polardbx.instance_id

  backup_period        = "Monday,Wednesday,Friday"
  backup_set_retention = 7
  backup_plan_begin    = "03:00Z"
  remove_log_retention = 7
}
```

> ⚠️ **Key Constraints**:
> - `instance_id` and `name` are **mutually exclusive**: exactly one must be set.
> - When creating a new instance, `vpc_id` and `vswitch_id` are required.
> - When `instance_id` is provided, no new instance will be created.

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
| **name** | **Name for a new PolarDBX instance. Used only when `instance_id` is not set.** | `string` | `""` | No |
| **instance_id** | **ID of an existing PolarDBX instance. If set, no new instance will be created.** | `string` | `""` | No |
| engine_version | Database engine version | `string` | `"5.7"` | No |
| storage | Storage size in GB | `number` | `50` | No |
| network_type | Network type | `string` | `"vpc"` | No |
| vpc_id | VPC ID for network configuration | `string` | `""` | No |
| vswitch_id | VSwitch ID for network configuration | `string` | `""` | No |
| cn_node_class | Class of computing nodes (CN) | `string` | `""` | No |
| cn_node_count | Number of computing nodes (CN) | `number` | `2` | No |
| dn_node_class | Class of storage nodes (DN) | `string` | `""` | No |
| dn_node_count | Number of storage nodes (DN) | `number` | `2` | No |
| series | Series of PolarDB-X 2.0 instance | `string` | `""` | No |
| topology_type | Topology type | `string` | `""` | No |
| description | Instance description | `string` | `""` | No |
| databases | Map of databases to create | `map(object)` | `{}` | No |
| accounts | Map of accounts to create | `map(object)` | `{}` | No |
| use_account_database_binding | Use account_database_binding resource for privileges | `bool` | `false` | No |
| enable_backup | Trigger a one-time manual backup for the instance | `bool` | `false` | No |
| backup_type | Type of the manual backup (`0` = physical backup); only used when `enable_backup` is true | `number` | `0` | No |

> 💡 **Mutual Exclusion Rules**:
> - `instance_id` and `name`: choose exactly one.
> - When `instance_id` is set, `name` is ignored.

## Output Values

| Name | Description |
|------|-------------|
| instance_id | ID of the PolarDBX instance |
| instance_name | Name of the PolarDBX instance |
| database_names | List of created database names |
| account_names | List of created account names |
| vswitch_id | ID of the VSwitch used by the instance |
| vpc_id | ID of the VPC used by the instance |
| cn_node_class | Class of computing nodes (CN) |
| dn_node_class | Class of storage nodes (DN) |
| backup_set_id | ID of the backup set created by the manual backup (`null` when `enable_backup` is false) |
| backup_status | Status of the manual backup: `0` creating, `1` success, `2` failed (`null` when `enable_backup` is false) |

## Notes

* When `instance_id` is provided, the module will use the existing instance and not create a new one.
* Database and account management can be done independently of instance creation.
* **For backup policy configuration, use the separate `polardbx_backup_policy` module.**
* Set `use_account_database_binding = true` to use the `account_database_binding` resource for managing account privileges.
* Set `enable_backup = true` to trigger a one-time manual backup. The backup resource is trigger-style: it has no update operation, all arguments are ForceNew, and its delete is a no-op (the backup set remains on the instance after `terraform destroy`).

## Related Modules

* [polardbx_backup_policy](../polardbx_backup_policy/) - For managing backup policies separately

## Reporting Issues

If you encounter any issues while using this module, please open an issue in the [provider repository](https://github.com/aliyun/terraform-provider-alibabacloudstack/issues/new).

> **Note**: Please do **not** open issues in this module's repository.

## Authors

Created and maintained by the Alibaba Cloud Terraform Team.

## License

MIT License. See LICENSE for details.
