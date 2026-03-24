# PolarDBX 读写分离配置 Terraform 模块

该模块用于在阿里云 Stack 上为**已存在的 PolarDBX 实例**配置读写分离策略，支持 HTAP 集成、一致性副本读、延迟执行控制等高级功能。模块不创建 PolarDBX 实例，仅管理其读写分离配置。

## 功能特性

- ✅ 为现有 PolarDBX 实例启用/禁用读写分离配置  
- ✅ 灵活配置主实例读权重（1–100），实现读流量按比例分发  
- ✅ 支持 HTAP（混合事务/分析处理）集成：手动指定或自动发现 HTAP 实例  
- ✅ 启用一致性副本读（Consistent Replica Read），保障强一致查询体验  
- ✅ 可配置存储延迟阈值与延迟执行策略，智能规避高延迟副本  
- ✅ 全参数化设计，支持完全声明式配置与安全的条件启用（`enable_read_write_splitting`）

> ⚠️ **重要前提**：本模块**不创建 PolarDBX 实例**，`db_instance_id` 必须指向一个已存在且处于运行状态的 PolarDBX 实例。

## 使用方法

### 基础用法：启用默认读写分离配置

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id = "pxc-xxxxxxxxxxxxxx" # 替换为实际实例ID
  enable_read_write_splitting = true
}
```

### 进阶用法：自定义 HTAP 与一致性读策略

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id                 = "pxc-xxxxxxxxxxxxxx"
  enable_read_write_splitting    = true
  attend_htap_list               = ["htap-abc123", "htap-def456"]
  auto_attend_htap               = false
  enable_consistent_replica_read = true
  master_read_weight             = 30  # 主库承担30%读流量
  storage_delay_threshold        = 500 # 延迟超500ms的副本不参与读负载
}
```

### 完全禁用读写分离（保留配置但不生效）

```hcl
module "polardbx_rws" {
  source = "<Module Path>"

  db_instance_id              = "pxc-xxxxxxxxxxxxxx"
  enable_read_write_splitting = false # 此时所有资源不创建，输出值为 null 或默认值
}
```

## 环境依赖

### Terraform Core

| 名称 | 版本 |
|------|------|
| Terraform | >= 1.5.6 |

### Provider

| 名称 | 版本 |
|------|------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## 模块变量

### 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| `db_instance_id` | **（必需）** 已存在的 PolarDBX 实例 ID。本模块仅配置，不创建实例。 | `string` | - | 是 |
| `enable_read_write_splitting` | 是否启用读写分离配置。设为 `false` 时，不创建任何资源，所有输出返回空值或默认值。 | `bool` | `false` | 否 |
| `attend_htap_list` | 手动指定需加入读写分离的 HTAP 实例 ID 列表（如 `["htap-xxx", "htap-yyy"]`）。仅当 `enable_htap = true` 时生效。 | `list(string)` | `[]` | 否 |
| `auto_attend_htap` | 是否自动发现并接入可用的 HTAP 实例（需实例已关联至同一 PolarDBX）。 | `bool` | `false` | 否 |
| `delay_execution_strategy` | 延迟执行策略：`0`（立即执行）、`1`（延迟执行，配合 `storage_delay_threshold` 使用）。 | `number` | `0` | 否 |
| `enable_consistent_replica_read` | 是否启用一致性副本读，确保读请求始终从最新同步的副本获取数据。 | `bool` | `false` | 否 |
| `enable_htap` | 是否启用 HTAP 功能，开启后可将 HTAP 实例纳入读负载分发。 | `bool` | `false` | 否 |
| `master_read_weight` | 主实例读权重（1–100），其余读流量由只读节点/HTAP 节点分担。例如设为 `50` 表示主库承担 50% 读流量。 | `number` | `50` | 否 |
| `storage_delay_threshold` | 存储延迟阈值（单位：毫秒）。当副本延迟超过此值时，若启用延迟策略，将暂不向其分发读请求。 | `number` | `1000` | 否 |

> 💡 **策略说明**：`delay_execution_strategy` 与 `storage_delay_threshold` 需配合使用；`attend_htap_list` 与 `auto_attend_htap` 互斥推荐——二者同时设置时，以 `attend_htap_list` 为准。

### 输出变量

| 名称 | 描述 |
|------|------|
| `id` | 读写分离配置 ID（与 `db_instance_id` 相同），仅当 `enable_read_write_splitting = true` 时有效；否则为 `null`。 |
| `db_instance_id` | 输入的 PolarDBX 实例 ID。 |
| `attend_htap_list` | 实际生效的 HTAP 实例列表（即模块创建的资源配置值），未启用时返回空列表 `[]`。 |
| `auto_attend_htap` | 实际生效的自动接入开关值，未启用时返回 `false`。 |
| `delay_execution_strategy` | 实际生效的延迟策略值，未启用时返回 `0`。 |
| `enable_consistent_replica_read` | 实际生效的一致性副本读开关值，未启用时返回 `false`。 |
| `enable_htap` | 实际生效的 HTAP 开关值，未启用时返回 `false`。 |
| `master_read_weight` | 实际生效的主库读权重值，未启用时返回 `50`。 |
| `storage_delay_threshold` | 实际生效的存储延迟阈值，未启用时返回 `1000`。 |

## 示例

更多使用场景请参见 [`examples/`](./examples) 目录：
- `enable-rws-with-htap`：启用读写分离并手动绑定 HTAP 实例  
- `enable-rws-consistent-read`：启用一致性副本读与自定义延迟阈值  
- `disable-rws`：安全禁用配置（零资源变更）

## 注意事项

- 🔒 **实例前置要求**：必须提前通过其他方式（如 `alibabacloudstack_polardbx_instance` 资源）创建好 PolarDBX 实例，并确保其状态为 `Running`。
- 🚫 **不可逆操作提示**：禁用读写分离（`enable_read_write_splitting = false`）将销毁对应配置，可能导致应用读写行为回退至单点，请谨慎执行。
- ⏱️ **延迟策略生效逻辑**：`delay_execution_strategy = 1` 时，系统依据 `storage_delay_threshold` 动态剔除高延迟节点；该策略不影响写入，仅调控读请求分发。
- 📏 **权重约束**：`master_read_weight` 取值范围严格为 `1–100`，超出将导致 Terraform 计划失败。
- 🌐 **网络兼容性**：HTAP 实例须与 PolarDBX 实例处于同一地域及可用区，且网络互通（建议部署于同一 VPC）。