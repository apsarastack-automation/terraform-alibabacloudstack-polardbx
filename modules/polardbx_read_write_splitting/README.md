=====
# PolarDBX Read-Write Splitting Configuration Terraform Module

This module configures read-write splitting policies for an **existing PolarDBX instance** on Alibaba Cloud Stack, supporting advanced capabilities such as HTAP integration, consistent replica reads, and latency-aware execution control. The module does *not* create the PolarDBX instance itself—it manages only its read-write splitting configuration.

## Features

- ✅ Enable or disable read-write splitting for an existing PolarDBX instance  
- ✅ Flexibly configure the primary instance’s read weight (1–100) to distribute read traffic proportionally  
- ✅ Support HTAP (Hybrid Transactional/Analytical Processing) integration: manually specify or automatically discover HTAP instances  
- ✅ Enable Consistent Replica Read to ensure strongly consistent query results  
- ✅ Configure storage replication delay threshold and delay-aware execution policy to intelligently avoid high-latency replicas  
- ✅ Fully parameterized design, supporting fully declarative configuration and safe conditional enablement (`enable_read_write_splitting`)

> ⚠️ **Critical Prerequisite**: This module **does not create a PolarDBX instance**. The `db_instance_id` must reference an *already-existing* PolarDBX instance in `Running` status.

## Usage

### Basic Usage: Enable Default Read-Write Splitting

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id = "pxc-xxxxxxxxxxxxxx" # Replace with your actual instance ID
  enable_read_write_splitting = true
}
```

### Advanced Usage: Custom HTAP & Consistent Read Policies

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id                 = "pxc-xxxxxxxxxxxxxx"
  enable_read_write_splitting    = true
  attend_htap_list               = ["htap-abc123", "htap-def456"]
  auto_attend_htap               = false
  enable_consistent_replica_read = true
  master_read_weight             = 30  # Primary handles 30% of read traffic
  storage_delay_threshold        = 500 # Replicas with >500ms delay excluded from read load
}
```

### Fully Disable Read-Write Splitting (Preserve config but deactivate)

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id              = "pxc-xxxxxxxxxxxxxx"
  enable_read_write_splitting = false # No resources created; outputs are null or default values
}
```

## Environment Dependencies

### Terraform Core

| Name      | Version     |
|-----------|-------------|
| Terraform | >= 1.5.6    |

### Provider

| Name              | Version                   |
|-------------------|---------------------------|
| alibabacloudstack | >= 3.18.24, < 3.19.0      |

## Module Variables

### Input Variables

| Name                         | Description                                                                                                                 | Type         | Default | Required |
|------------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------|---------|----------|
| `db_instance_id`             | **(Required)** ID of an existing PolarDBX instance. This module configures only—it does *not* create the instance.           | `string`     | —       | Yes      |
| `enable_read_write_splitting`| Whether to enable read-write splitting. When set to `false`, no resources are created; all outputs return `null` or defaults. | `bool`       | `false` | No       |
| `attend_htap_list`           | List of HTAP instance IDs to manually include in read-write splitting (e.g., `["htap-xxx", "htap-yyy"]`). Effective only when `enable_htap = true`. | `list(string)` | `[]`    | No       |
| `auto_attend_htap`           | Whether to automatically discover and attach available HTAP instances (requires those instances to be associated with the same PolarDBX). | `bool`       | `false` | No       |
| `delay_execution_strategy`   | Delay execution strategy: `0` (execute immediately), `1` (delayed execution—used together with `storage_delay_threshold`). | `number`     | `0`     | No       |
| `enable_consistent_replica_read` | Whether to enable Consistent Replica Read, ensuring read requests always retrieve data from the most recently synchronized replica. | `bool`       | `false` | No       |
| `enable_htap`                | Whether to enable HTAP functionality, allowing HTAP instances to participate in read traffic distribution.                      | `bool`       | `false` | No       |
| `master_read_weight`         | Read weight assigned to the primary instance (1–100); remaining read traffic is distributed across read-only nodes and/or HTAP nodes. E.g., `50` means the primary handles 50% of read traffic. | `number`     | `50`    | No       |
| `storage_delay_threshold`    | Storage replication delay threshold (in milliseconds). When a replica’s delay exceeds this value *and* delayed execution is enabled, read requests will temporarily bypass that replica. | `number`     | `1000`  | No       |

> 💡 **Policy Notes**:  
> - `delay_execution_strategy` and `storage_delay_threshold` must be used together.  
> - `attend_htap_list` and `auto_attend_htap` are mutually exclusive and *not recommended* to set simultaneously; if both are provided, `attend_htap_list` takes precedence.

### Output Variables

| Name                         | Description                                                                                                                               |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `id`                         | Read-write splitting configuration ID (same as `db_instance_id`), valid only when `enable_read_write_splitting = true`; otherwise `null`. |
| `db_instance_id`             | Input PolarDBX instance ID.                                                                                                               |
| `attend_htap_list`           | Actual HTAP instance list applied (i.e., the value used in the configured resource); returns empty list `[]` when disabled.              |
| `auto_attend_htap`           | Actual effective value of the auto-attach flag; returns `false` when disabled.                                                           |
| `delay_execution_strategy`   | Actual effective delay execution strategy value; returns `0` when disabled.                                                              |
| `enable_consistent_replica_read` | Actual effective Consistent Replica Read flag; returns `false` when disabled.                                                         |
| `enable_htap`                | Actual effective HTAP flag; returns `false` when disabled.                                                                               |
| `master_read_weight`         | Actual effective primary read weight; returns `50` when disabled.                                                                        |
| `storage_delay_threshold`    | Actual effective storage delay threshold; returns `1000` when disabled.                                                                  |

## Examples

For more usage scenarios, see the [`examples/`](./examples) directory:
- `enable-rws-with-htap`: Enable read-write splitting and manually bind HTAP instances  
- `enable-rws-consistent-read`: Enable Consistent Replica Read with a custom delay threshold  
- `disable-rws`: Safely disable configuration (zero-resource change)

## Important Notes

- 🔒 **Instance Prerequisites**: The PolarDBX instance must be pre-created (e.g., via `alibabacloudstack_polardbx_instance`) and confirmed to be in `Running` status.  
- 🚫 **Irreversible Operation Warning**: Disabling read-write splitting (`enable_read_write_splitting = false`) destroys the corresponding configuration—potentially reverting application read/write behavior to a single point of failure. Use with caution.  
- ⏱️ **Delay Policy Logic**: When `delay_execution_strategy = 1`, the system dynamically excludes replicas exceeding `storage_delay_threshold` from read load distribution. This policy affects *reads only* and has no impact on write operations.  
- 📏 **Weight Constraint**: `master_read_weight` must be strictly within `1–100`. Values outside this range will cause Terraform plan validation to fail.  
- 🌐 **Network Compatibility**: HTAP instances must reside in the *same region and zone* as the PolarDBX instance and have network connectivity (ideally deployed in the same VPC).