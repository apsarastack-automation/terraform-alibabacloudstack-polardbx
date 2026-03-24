=====  
# Alibaba Cloud PolarDB-X Read-Only Instance Terraform Module  

This module creates a **PolarDB-X read-only instance** on Alibaba Cloud Stack, serving as a highly available read-scaling node for the primary instance. It supports automatic selection of optimal node specifications, multi-zone deployment, and flexible configuration of compute (CN) and storage (DN) nodes.  

## Features  

- Creates a PolarDB-X read-only instance (`alibabacloudstack_polardbx_readonly_instance`)  
- Automatically detects and selects available CN and DN instance types, prioritized by CPU count  
- Supports single-zone (`1azone`) or three-zone (`3azones`) topology deployments  
- Enables flexible definition of CN/DN node count and instance type — supports explicit specification or fallback to default types  
- Auto-generates instance description (if not explicitly provided), formatted as `${name}-readonly`  
- Exports key runtime information: connection string, instance status, node specifications, etc.  

> ⚠️ **Note**: This module **creates only the read-only instance**, *not* the primary instance. The `primary_db_instance_id` must be an *existing* PolarDB-X primary instance ID.  

## Usage  

### Basic Usage: Create a Read-Only Instance with Default Configuration  

```hcl  
module "polardbx_readonly" {  
  source = "<Module Path>"  

  name                    = "my-polardbx-ro"  
  primary_db_instance_id  = "pxc-xxxxxxxxxxxxxx"  # Required: existing primary instance ID  
  vswitch_id              = "vsw-xxxxxxxxxxxxxxxxx"  
}  
```  

### Advanced Usage: Customize Engine Version, Node Specifications, and Topology  

```hcl  
module "polardbx_readonly" {  
  source = "<Module Path>"  

  name                    = "prod-polardbx-ro"  
  primary_db_instance_id  = "pxc-yyyyyyyyyyyyyy"  
  vswitch_id              = "vsw-yyyyyyyyyyyyyyy"  
  engine_version          = "8.0"  
  storage                 = 200  
  cn_node_count           = 4  
  dn_node_count           = 4  
  cn_node_class           = "polarx.cn.x4.large"   # Optional: explicitly specify CN type  
  dn_node_class           = "polarx.dn.x8.large"   # Optional: explicitly specify DN type  
  topology_type           = "3azones"             # Optional: enable three-zone disaster recovery  
  description             = "Production read-only replica for analytics"  
}  
```  

### Conditional Creation: Enable Read-Only Instance On-Demand  

```hcl  
module "polardbx_readonly" {  
  source = "<Module Path>"  

  name                    = "optional-ro"  
  primary_db_instance_id  = "pxc-zzzzzzzzzzzzzz"  
  vswitch_id              = "vsw-zzzzzzzzzzzzzz"  
  create_readonly_instance = var.enable_readonly_replica  # e.g., controlled via variable to toggle deployment  
}  
```  

## Environment Dependencies  

### Terraform Core  

| Name      | Version     |  
|-----------|-------------|  
| Terraform | >= 1.5.6    |  

### Provider  

| Name              | Version                |  
|-------------------|------------------------|  
| alibabacloudstack | >= 3.18.24, < 3.19.0   |  

## Module Variables  

### Input Variables  

| Name                      | Description                                                                                         | Type     | Default     | Required |  
|---------------------------|-----------------------------------------------------------------------------------------------------|----------|-------------|----------|  
| `name`                    | Name of the read-only PolarDB-X instance                                                            | `string` | `""`        | Yes (recommended) |  
| `primary_db_instance_id`  | **Primary PolarDB-X instance ID** (must reference an existing instance)                           | `string` | —           | Yes      |  
| `create_readonly_instance`| Whether to actually create the read-only instance (`false` skips resource creation)              | `bool`   | `true`      | No       |  
| `engine_version`          | Database engine version. Valid values: `"5.7"`, `"8.0"`                                           | `string` | `"5.7"`     | No       |  
| `storage`                 | Instance storage capacity (unit: GB)                                                              | `number` | `50`        | No       |  
| `vswitch_id`              | VSwitch ID (used for network isolation)                                                           | `string` | `""`        | Yes (if `create_readonly_instance = true`) |  
| `cn_node_class`           | Compute node (CN) instance type ID (e.g., `polarx.cn.x2.large`); empty → auto-selects lowest available in region | `string` | `""`        | No       |  
| `cn_node_count`           | Number of compute nodes (CN)                                                                      | `number` | `2`         | No       |  
| `dn_node_class`           | Storage node (DN) instance type ID (e.g., `polarx.dn.x4.large`); empty → auto-selects lowest available in region | `string` | `""`        | No       |  
| `dn_node_count`           | Number of storage nodes (DN)                                                                      | `number` | `2`         | No       |  
| `topology_type`           | Deployment topology type. Valid values: `"1azone"` (single zone), `"3azones"` (three zones); empty → uses service default policy | `string` | `""`        | No       |  
| `description`             | Instance description; if empty, automatically set to `"${name}-readonly"`                         | `string` | `""`        | No       |  

> 💡 **Automatic Specification Selection**: When `cn_node_class` or `dn_node_class` is left empty, the module invokes the `alibabacloudstack_polardbx_instance_types` data source, sorts available types by `CPU`, and selects the first valid option — ensuring deployment success.  

### Output Variables  

| Name                      | Description                                                                                          |  
|---------------------------|------------------------------------------------------------------------------------------------------|  
| `instance_id`             | ID of the created read-only PolarDB-X instance (valid only when `create_readonly_instance = true`) |  
| `instance_name`           | Instance name (i.e., value of input variable `name`)                                               |  
| `primary_db_instance_id`  | Associated primary instance ID                                                                     |  
| `is_read_db_instance`     | Whether this is a read-only instance (always `true` when `create_readonly_instance = true`)        |  
| `vswitch_id`              | VSwitch ID used for deployment                                                                     |  
| `cn_node_class`           | Actual compute node (CN) instance type used (may reflect auto-selection)                         |  
| `dn_node_class`           | Actual storage node (DN) instance type used (may reflect auto-selection)                         |  
| `engine_version`          | Database engine version of the instance                                                            |  
| `connection_string`       | Connection string (`host:port`) for client connectivity                                          |  
| `status`                  | Current instance status (e.g., `"Running"`, `"Creating"`, etc.)                                   |  

## Examples  

For more usage scenarios, see the [`examples/`](./examples) directory:  
- `basic-read-only-instance`: Minimal read-only instance deployment  
- `multi-zone-read-only`: Highly available read-only instance across three zones  
- `custom-node-specs`: Explicitly specify CN/DN node counts and instance types  

## Notes  

- ✅ **Prerequisite – Primary Instance**: `primary_db_instance_id` must point to a PolarDB-X primary instance that has been **successfully created and is in `Running` state**.  
- ⚠️ **Network Constraint**: `vswitch_id` must reside in the **same region** as the primary instance, and its associated VPC must grant access permission to the PolarDB-X service (typically handled automatically by Alibaba Cloud).  
- ⚠️ **Specification Compatibility**: Selected `cn_node_class` / `dn_node_class` must be compatible with `engine_version` (e.g., certain DN types do not support version 8.0). Refer to the [Alibaba Cloud PolarDB-X documentation](https://help.aliyun.com/product/41907.html) for details.  
- ⚠️ **Topology Limitation**: `topology_type = "3azones"` requires the selected `zone_id` (auto-determined as the first available zone) to be in a region supporting three-zone deployments, and the VSwitch referenced by `vswitch_id` must span **at least three availability zones** (typically requires custom VPC/VSwitch provisioning).  
- 🚫 **Immutable Properties**: After creation, core configurations such as `engine_version`, `topology_type`, `cn_node_count`, and `dn_node_count` **cannot be modified via Terraform** (recreation required). Plan initial configuration carefully.  
- 🔄 **Automatic Retry Mechanism**: Because the instance-type data source relies on real-time APIs, the first `terraform apply` may fail if no suitable instance types are temporarily available in the target region. We recommend combining `terraform apply -auto-approve` with retry logic in your CI/CD pipeline.