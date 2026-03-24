=====
# Alibaba Cloud PolarDB-X Read-Only Instance Terraform Module (Root Module)

This module enables **easy creation of PolarDB-X read-only instances** on Alibaba Cloud Stack, serving as read-scaling nodes for existing primary instances. It wraps the underlying `polardbx_readonly_instance` submodule, providing a clean, standardized interface that abstracts away implementation details—such as automatic specification selection and zone discovery—while focusing exclusively on core business configuration.

## Features

- One-click creation of a PolarDB-X read-only instance, automatically establishing a read-replica relationship with a specified primary instance  
- Supports mainstream database engine versions: `5.7` and `8.0`  
- Flexible configuration of compute node (CN) and storage node (DN) count and specifications  
- Automatic inheritance of network environment (via specified `vswitch_id`)  
- Outputs key runtime information: instance ID, name, connection string, status, etc.  
- Compliant with Terraform best practices—ensuring reproducibility and auditability in production environments  

> ⚠️ **Note**: This module **does not create the primary PolarDB-X instance**—it creates *only* read-only replicas. The `primary_db_instance_id` must be an *existing* primary instance ID in `Running` state.

## Usage

### Basic Usage: Create a Read-Only Instance with Default Configuration

```hcl
module "polardbx_readonly" {
  source = "../../modules/polardbx_readonly_instance"

  name                    = "my-app-ro"
  primary_db_instance_id  = "pxc-xxxxxxxxxxxxxx"  # Existing primary instance ID
  vswitch_id              = "vsw-xxxxxxxxxxxxxxxxx"
}
```

### Advanced Usage: Customize Node Scale and Specifications

```hcl
module "polardbx_readonly" {
  source = "../../modules/polardbx_readonly_instance"

  name                    = "prod-analytics-ro"
  primary_db_instance_id  = "pxc-yyyyyyyyyyyyyy"
  vswitch_id              = "vsw-yyyyyyyyyyyyyyy"
  engine_version          = "8.0"
  storage                 = 200
  cn_node_count           = 4
  dn_node_count           = 4
  cn_node_class           = "polarx.cn.x4.large"   # Optional: explicitly specify CN instance type
  dn_node_class           = "polarx.dn.x8.large"    # Optional: explicitly specify DN instance type
  description             = "Read-only replica: used for real-time reporting and analytical queries"
}
```

## Environment Dependencies

### Terraform Core

| Name      | Version     |
|-----------|-------------|
| Terraform | `>= 1.5.6`  |

### Provider

| Name              | Version                     |
|-------------------|-----------------------------|
| alibabacloudstack | `>= 3.18.24, < 3.19.0`      |

## Module Variables

### Input Variables

| Name                      | Description                                                                 | Type     | Default | Required |
|---------------------------|-----------------------------------------------------------------------------|----------|---------|----------|
| `name`                    | Name of the read-only PolarDB-X instance                                    | `string` | —       | Yes      |
| `primary_db_instance_id`  | **Primary PolarDB-X instance ID** (must exist and be in `Running` state)   | `string` | —       | Yes      |
| `vswitch_id`              | VSwitch ID (for network isolation; must reside in the same region as the primary instance) | `string` | —       | Yes      |
| `engine_version`          | Database engine version. Valid values: `"5.7"`, `"8.0"`                     | `string` | `"5.7"` | No       |
| `storage`                 | Instance storage capacity (unit: GB)                                        | `number` | `50`    | No       |
| `cn_node_count`           | Number of compute nodes (CNs)                                                 | `number` | `2`     | No       |
| `dn_node_count`           | Number of storage nodes (DNs)                                                 | `number` | `2`     | No       |
| `cn_node_class`           | Compute node (CN) instance type (e.g., `polarx.cn.x2.large`); empty value uses service default | `string` | `""`    | No       |
| `dn_node_class`           | Storage node (DN) instance type (e.g., `polarx.dn.x4.large`); empty value uses service default | `string` | `""`    | No       |
| `description`             | Instance description; if left empty, defaults to `"${name}-readonly"`        | `string` | `""`    | No       |

> 💡 **Note**: This module **does not expose internal parameters** of the underlying submodule (e.g., `create_readonly_instance`, `topology_type`). All instances are created unconditionally, and topology type is automatically selected by the underlying submodule using its optimal strategy—*explicit user configuration is not supported*.

### Output Variables

| Name                      | Description                                                  |
|---------------------------|--------------------------------------------------------------|
| `instance_id`             | ID of the created read-only PolarDB-X instance               |
| `instance_name`           | Instance name (i.e., the value of input variable `name`)     |
| `primary_db_instance_id`  | ID of the associated primary PolarDB-X instance              |
| `connection_string`       | Connection string (`host:port`) for client connectivity      |
| `status`                  | Current instance status (e.g., `Running`, `Creating`, etc.)  |

## Examples

For more usage scenarios, see the [`examples/`](./examples) directory (adjust path as needed):  
- `basic-read-only-instance`: Minimal read-only instance deployment  
- `custom-storage-and-nodes`: Customized storage size and CN/DN node counts  

## Important Notes

- ✅ **Prerequisite – Primary Instance**: `primary_db_instance_id` must reference a PolarDB-X primary instance that has been **successfully created and is currently in `Running` state**.  
- ⚠️ **Network Constraint**: `vswitch_id` must reside in the **same region** as the primary instance, and its associated VPC must have granted PolarDB-X service access permissions.  
- ⚠️ **Specification Compatibility**: Selected `cn_node_class` / `dn_node_class` must be compatible with `engine_version` (e.g., some DN instance types do not support 8.0). Consult the [Alibaba Cloud PolarDB-X documentation](https://help.aliyun.com/product/41907.html) for verification.  
- 🚫 **Immutable Configurations**: After creation, core configurations—including `engine_version`, `cn_node_count`, and `dn_node_count`—**cannot be modified via Terraform** (recreation is required). Plan initial configuration carefully.  
- 🔄 **Automatic Specification Fallback**: When `cn_node_class` or `dn_node_class` is unspecified, the module automatically selects the *lowest available specification* in the current region to maximize deployment success rate.