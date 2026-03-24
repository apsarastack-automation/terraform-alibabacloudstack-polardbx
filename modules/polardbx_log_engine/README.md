=====  
# PolarDBX Log Engine (CDC) Terraform Module  

This module configures the Log Engine (CDC) capability for an **existing Alibaba Cloud PolarDBX instance**, supporting both single-stream primary engine deployment and multi-stream (Multi-Stream) scalable deployments. The module does **not create** the PolarDBX instance itself—it manages only CDC-related resources.

## Features  

- ✅ Enable or disable the Log Engine (CDC) for an existing PolarDBX instance  
- ✅ Automatically detect and select an available CDC node instance type (prioritized by CPU count); manual specification is also supported  
- ✅ Flexibly configure the number of CDC nodes (default: `2` nodes)  
- ✅ Support for Multi-Stream topology: define multiple independent data-change subscription groups (`group`), each with its own instance type, node count, and hash routing strategy  
- ✅ Fully output key resource configuration details for easy reference by downstream modules  

> ⚠️ **Important Limitation**: This module **does not create a PolarDBX instance**. The `instance_id` must refer to an **already-existing PolarDBX instance that supports CDC** (e.g., a PolarDB-X 2.0 Cluster Edition instance). Ensure the target instance has been granted permissions to use the Log Engine service.

## Usage  

### Basic Usage: Enable Default Log Engine  

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id         = "pxc-xxxxxxxxxxxxxxx"  # Required: Existing PolarDBX instance ID
  enable_log_engine   = true                     # Enable CDC
}
```

### Advanced Usage: Customize CDC Node Instance Type and Count  

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id         = "pxc-xxxxxxxxxxxxxxx"
  enable_log_engine   = true
  cdc_node_class      = "polarx.cdc.large"     # Manually specify node instance type (optional)
  cdc_node_count      = 4                      # Specify node count (default: 2)
}
```

### Advanced Usage: Configure Multi-Stream Subscriptions  

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id       = "pxc-xxxxxxxxxxxxxxx"
  enable_log_engine = true

  multi_streams = [
    {
      group_name = "stream-a"
      comment    = "Core business order stream"
      hash_level = "TABLE"     # Valid values: TABLE / DATABASE / SHARD
      node_class = "polarx.cdc.medium"
      node_count = 2
    },
    {
      group_name = "stream-b"
      hash_level = "DATABASE"
      node_class = "polarx.cdc.small"
      node_count = 1
    }
  ]
}
```

## Environment Dependencies  

### Terraform Core  

| Name      | Version |
|-----------|---------|
| Terraform | >= 1.5.6 |

### Provider  

| Name              | Version               |
|-------------------|-----------------------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## Module Variables  

### Input Variables  

| Name                | Description                                                                                                                                                                                                                                                                     | Type                                                                                                                                                                                                                                                                                                 | Default | Required |
|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|----------|
| `instance_id`       | **(Required)** The ID of an existing PolarDBX instance. This module only manages the Log Engine configuration for this instance and does **not create** the instance.                                                                                                                                                                     | `string`                                                                                                                                                                                                                                                                                             | —       | Yes      |
| `enable_log_engine` | Whether to enable the Log Engine (CDC) functionality. When set to `false`, the module creates no resources.                                                                                                                                                                                                                               | `bool`                                                                                                                                                                                                                                                                                               | `false` | No       |
| `cdc_node_class`    | Instance type for the primary CDC engine node (e.g., `"polarx.cdc.large"`). If left empty, the module automatically selects the first available instance type (sorted by CPU count).                                                                                                                                                     | `string`                                                                                                                                                                                                                                                                                             | `""`    | No       |
| `cdc_node_count`    | Number of nodes for the primary CDC engine. Minimum value: `1`.                                                                                                                                                                                                                                                                         | `number`                                                                                                                                                                                                                                                                                             | `2`     | No       |
| `multi_streams`     | List of Multi-Stream configurations. Each element is an object containing: `group_name` (required), `comment` (optional), `hash_level` (required; one of `"TABLE"`, `"DATABASE"`, `"SHARD"`), `node_class` (required), and `node_count` (required). | `list(object({ group_name = string, comment = optional(string, ""), hash_level = string, node_class = string, node_count = number }))`                                                                                                                                                         | `[]`    | No       |

> 💡 **About `hash_level`**:  
> - `TABLE`: Hashes by table name—changes from the same table are routed to the same node.  
> - `DATABASE`: Hashes by database name—changes from all tables in the same database are routed to the same node.  
> - `SHARD`: Hashes by shard key (requires PolarDBX sharding rules), enabling finer-grained load balancing.

### Output Variables  

| Name                | Description                                                                                                                             |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `log_engine_id`     | Unique ID of the Log Engine configuration (valid only when `enable_log_engine = true`)                                               |
| `instance_id`       | Input PolarDBX instance ID (always output)                                                                                              |
| `cdc_node_class`    | Actual instance type used for the primary CDC engine (valid only when `enable_log_engine = true`)                                    |
| `cdc_node_count`    | Actual number of deployed primary CDC engine nodes (valid only when `enable_log_engine = true`)                                      |
| `multi_stream`      | Currently active Multi-Stream configuration list (same structure as input `multi_streams`; valid only when `enable_log_engine = true`) |

## Examples  

For more usage scenarios, see the [`examples/`](./examples) directory:  
- `enable-basic-cdc`: Enable basic Log Engine  
- `enable-multi-stream-cdc`: Configure Multi-Stream subscription groups  
- `custom-cdc-specs`: Specify node instance type and count  

## Notes  

- 🔒 **Prerequisites for Target Instance**: The target PolarDBX instance must have the Log Engine (CDC) service enabled and be in the `Running` state. We recommend verifying CDC availability via the Alibaba Cloud console or OpenAPI before applying this module.  
- 📏 **Instance Type Compatibility**: The `cdc_node_class` value must be a valid instance type returned by the `alibabacloudstack_polardbx_cdc_classes` data source. If omitted and the data source returns no results, the module will fail with an error due to an empty `local.cdc_node_class`.  
- 🔄 **Multi-Stream Constraints**: The `group_name` of each `multi_stream` entry must be globally unique. Changing a `group_name` triggers full resource recreation (the old group is deleted and a new one is created).  
- 🧩 **Resource Lifecycle**: When `enable_log_engine` changes from `true` to `false`, Terraform destroys the entire Log Engine—including all Multi-Stream groups. This operation is **irreversible**—proceed with caution.  
- 🌐 **Network Connectivity**: The Log Engine and PolarDBX instance are automatically deployed within the same VPC, requiring no additional network configuration. However, consumers must ensure network reachability to the PolarDBX instance’s CDC endpoint (typically an internal IP address).