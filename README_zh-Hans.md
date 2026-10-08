# 阿里云 PolarDBX Terraform 模块

该模块用于在阿里云 Stack 上创建和管理 **PolarDBX 实例、一次性手动备份、日志引擎（CDC）、读写分离配置和只读实例**，提供一体化的 PolarDBX 基础设施编排能力。

## 功能特性

- 创建新的 PolarDBX 实例（或复用已有实例）
- 管理实例内的 PolarDBX 数据库和账号
- 为实例触发一次性手动备份（`enable_backup`）
- 配置日志引擎（CDC）服务，支持多流同步
- 启用和管理读写分离策略，支持 HTAP 场景
- 创建和管理 PolarDBX 只读实例，实现读写负载分离
- 支持使用已有 PolarDBX 实例进行扩展配置
- 备份策略管理已分离至独立模块（`polardbx_backup_policy`），本模块仅支持一次性手动备份，不包含周期性备份策略

> ⚠️ **重要说明**：
> - **备份策略管理已移至独立模块**。如需配置备份策略，请使用 `polardbx_backup_policy` 子模块。
> - 本模块是一个**组合封装模块**，内部调用 `polardbx_instance`、`polardbx_log_engine`、`polardbx_read_write_splitting` 和 `polardbx_readonly_instance` 四个子模块，各功能模块完全解耦、可独立启用。

## 使用方法

### 基础用法：创建 PolarDBX 实例并启用全部高级功能

```hcl
module "polardbx" {
  source = "<模块路径>"

  # 主实例配置
  name           = "my-polardbx-cluster"
  engine_version = "5.7"
  storage        = 100
  vswitch_id     = "vsw-xxxxxxxx"
  cn_node_count  = 4
  dn_node_count  = 4
  topology_type  = "3azones"
  description    = "Production PolarDBX cluster with CDC and RW splitting"

  # 数据库与账号
  databases = {
    app_db = {
      encode      = "utf8mb4"
      description = "Main application database"
    }
  }
  accounts = {
    app_user = {
      password = "SecurePassword123!"
      description = "Application database user"
    }
  }

  # 一次性手动备份
  enable_backup = true
  backup_type   = 0

  # 日志引擎（CDC）
  enable_log_engine                = true
  log_engine_cdc_node_class        = "polarx.cdc.2xlarge"
  log_engine_cdc_node_count        = 2
  log_engine_multi_streams         = []

  # 读写分离配置
  enable_read_write_splitting      = true
  rw_splitting_enable_htap         = true
  rw_splitting_master_read_weight  = 30
  rw_splitting_storage_delay_threshold = 500

  # 只读实例
  enable_readonly_instance         = true
  readonly_instance_name           = "my-polardbx-readonly"
  readonly_storage                 = 100
  readonly_cn_node_count           = 2
  readonly_dn_node_count           = 2
  readonly_cn_node_class           = "polarx.cn.2xlarge"
  readonly_dn_node_class           = "polarx.dn.2xlarge"
}
```

### 高级用法：复用已有 PolarDBX 实例并仅启用部分功能

```hcl
module "polardbx" {
  source = "<模块路径>"

  # 复用已有实例（不创建新实例）
  instance_id    = "pxc-xxxxxxxx"
  engine_version = "5.7"

  # 仅启用日志引擎（CDC）
  enable_log_engine                = true
  log_engine_cdc_node_class        = "polarx.cdc.large"
  log_engine_cdc_node_count        = 2

  # 仅启用读写分离（不创建只读实例）
  enable_read_write_splitting      = true
  rw_splitting_enable_consistent_replica_read = true

  # 不创建只读实例
  enable_readonly_instance = false
}
```

### 最小化用法：仅创建 PolarDBX 实例（禁用所有高级功能）

```hcl
module "polardbx" {
  source = "<模块路径>"

  name           = "simple-polardbx"
  engine_version = "5.7"
  storage        = 50
  vswitch_id     = "vsw-xxxxxxxx"
  cn_node_count  = 2
  dn_node_count  = 2

  # 所有高级功能均显式禁用
  enable_log_engine             = false
  enable_read_write_splitting   = false
  enable_readonly_instance      = false
}
```

## 环境依赖

### Terraform Core

| 名称 | 版本 |
|------|------|
| Terraform | >= 1.5.6 |

### 提供商

| 名称 | 版本 |
|------|------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## 模块变量

### 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| `name` | PolarDBX 实例名称（仅在 `instance_id` 未设置时生效） | `string` | `""` | 否（若 `instance_id` 已设置） |
| `instance_id` | 已有 PolarDBX 实例 ID（若设置，则跳过新实例创建） | `string` | `""` | 否（若 `name` 已设置） |
| `engine_version` | 数据库引擎版本，取值：`"5.7"` 或 `"8.0"` | `string` | `"5.7"` | 否 |
| `storage` | 主实例存储大小（GB） | `number` | `50` | 否 |
| `vswitch_id` | VSwitch ID，用于网络配置（创建新实例或只读实例时必需） | `string` | `""` | 否（但若创建实例则必需） |
| `cn_node_class` | 计算节点（CN）规格 | `string` | `""` | 否 |
| `cn_node_count` | 计算节点（CN）数量 | `number` | `2` | 否 |
| `dn_node_class` | 存储节点（DN）规格 | `string` | `""` | 否 |
| `dn_node_count` | 存储节点（DN）数量 | `number` | `2` | 否 |
| `topology_type` | 拓扑类型，取值：`"1azone"` 或 `"3azones"` | `string` | `""` | 否 |
| `description` | 主实例描述 | `string` | `""` | 否 |
| `databases` | 要创建的数据库映射（键为数据库名，值为配置对象） | `map(object({encode=optional(string,"utf8mb4"),mode=optional(string,"auto"),description=optional(string,"")}))` | `{}` | 否 |
| `accounts` | 要创建的账号映射（键为账号名，值为配置对象） | `map(object({password=string,description=optional(string,""),account_privileges=optional(map(string),{})}))` | `{}` | 否 |
| `use_account_database_binding` | 是否使用 `account_database_binding` 资源管理权限（推荐用于复杂权限场景） | `bool` | `false` | 否 |
| `enable_backup` | 是否为实例触发一次性手动备份 | `bool` | `false` | 否 |
| `backup_type` | 手动备份类型，取值：`0`（物理备份）；仅在 `enable_backup` 为 true 时生效 | `number` | `0` | 否 |
| `enable_log_engine` | 是否启用日志引擎（CDC）配置 | `bool` | `false` | 否 |
| `log_engine_cdc_node_class` | CDC 节点规格 | `string` | `""` | 否 |
| `log_engine_cdc_node_count` | CDC 节点数量 | `number` | `2` | 否 |
| `log_engine_multi_streams` | 多流同步配置列表 | `list(object({group_name=string,comment=optional(string,""),hash_level=string,node_class=string,node_count=number}))` | `[]` | 否 |
| `enable_read_write_splitting` | 是否启用读写分离配置 | `bool` | `false` | 否 |
| `rw_splitting_attend_htap_list` | 要加入读写分离的 HTAP 实例 ID 列表 | `list(string)` | `[]` | 否 |
| `rw_splitting_auto_attend_htap` | 是否自动加入 HTAP 实例 | `bool` | `false` | 否 |
| `rw_splitting_delay_execution_strategy` | 延迟执行策略（`0` 或 `1`） | `number` | `0` | 否 |
| `rw_splitting_enable_consistent_replica_read` | 是否启用一致性副本读 | `bool` | `false` | 否 |
| `rw_splitting_enable_htap` | 是否启用 HTAP 支持 | `bool` | `false` | 否 |
| `rw_splitting_master_read_weight` | 主实例读权重（1–100） | `number` | `50` | 否 |
| `rw_splitting_storage_delay_threshold` | 存储延迟阈值（毫秒） | `number` | `1000` | 否 |
| `enable_readonly_instance` | 是否创建只读实例 | `bool` | `false` | 否 |
| `readonly_instance_name` | 只读实例名称 | `string` | `""` | 否 |
| `readonly_storage` | 只读实例存储大小（GB） | `number` | `50` | 否 |
| `readonly_cn_node_count` | 只读实例 CN 节点数量 | `number` | `2` | 否 |
| `readonly_dn_node_count` | 只读实例 DN 节点数量 | `number` | `2` | 否 |
| `readonly_cn_node_class` | 只读实例 CN 节点规格 | `string` | `""` | 否 |
| `readonly_dn_node_class` | 只读实例 DN 节点规格 | `string` | `""` | 否 |
| `readonly_description` | 只读实例描述 | `string` | `""` | 否 |

> 💡 **互斥规则**：
> - `instance_id` 和 `name`：二者必须且仅能设置一个
> - 当 `instance_id` 设置时，`name`、`storage`、`vswitch_id`、`cn_node_*`、`dn_node_*`、`topology_type` 等实例创建参数将被忽略（仅用于 `databases`/`accounts` 等资源管理）

### 输出变量

| 名称 | 描述 |
|------|------|
| `instance_id` | 主 PolarDBX 实例 ID |
| `instance_name` | 主 PolarDBX 实例名称 |
| `database_names` | 创建的数据库名称列表 |
| `account_names` | 创建的账号名称列表 |
| `vswitch_id` | 主实例使用的 VSwitch ID |
| `cn_node_class` | 主实例计算节点（CN）规格 |
| `dn_node_class` | 主实例存储节点（DN）规格 |
| `backup_set_id` | 手动备份创建的备份集 ID（`enable_backup` 为 false 时为 `null`） |
| `backup_status` | 手动备份状态：`0` 创建中、`1` 成功、`2` 失败（`enable_backup` 为 false 时为 `null`） |
| `log_engine_id` | 日志引擎（CDC）配置 ID（启用时返回） |
| `log_engine_cdc_node_class` | CDC 节点规格 |
| `log_engine_cdc_node_count` | CDC 节点数量 |
| `log_engine_multi_stream` | 多流同步配置（启用时返回） |
| `rw_splitting_id` | 读写分离配置 ID（启用时返回） |
| `rw_splitting_attend_htap_list` | 加入的 HTAP 实例列表 |
| `rw_splitting_auto_attend_htap` | 是否自动加入 HTAP 实例 |
| `rw_splitting_delay_execution_strategy` | 延迟执行策略 |
| `rw_splitting_enable_consistent_replica_read` | 是否启用一致性副本读 |
| `rw_splitting_enable_htap` | 是否启用 HTAP |
| `rw_splitting_master_read_weight` | 主实例读权重 |
| `rw_splitting_storage_delay_threshold` | 存储延迟阈值 |
| `readonly_instance_id` | 只读实例 ID（启用时返回） |
| `readonly_instance_name` | 只读实例名称 |
| `readonly_is_read_db_instance` | 是否为只读实例（恒为 `true`） |
| `readonly_cn_node_class` | 只读实例 CN 节点规格 |
| `readonly_dn_node_class` | 只读实例 DN 节点规格 |
| `readonly_connection_string` | 只读实例连接字符串（启用时返回） |
| `readonly_status` | 只读实例状态（启用时返回） |

## 示例

更多使用场景请参见 [`examples/`](./examples) 目录：
- `create-polardbx-full-feature` — 启用实例、CDC、读写分离和只读实例的完整示例
- `use-existing-instance-with-cdc` — 复用已有实例并仅启用日志引擎（CDC）的示例
- `enable-rw-splitting-only` — 仅启用读写分离策略的轻量示例
- `create-readonly-instance` — 单独创建只读实例的示例

## 注意事项

- 本模块是**组合封装模块**，其行为完全由所引用的子模块（`polardbx_instance`、`polardbx_log_engine`、`polardbx_read_write_splitting`、`polardbx_readonly_instance`）决定。
- **备份策略不在本模块范围内**，请务必使用独立的 `polardbx_backup_policy` 子模块进行配置。`enable_backup` 仅触发**一次性手动备份**；备份资源为触发型资源（无更新操作、所有参数 ForceNew），其删除为空操作（destroy 后备份集仍保留在实例上）。
- 当 `instance_id` 被指定时，主实例相关资源（如 `alibabacloudstack_polardbx_instance`）不会被创建，仅管理数据库、账号及高级功能（CDC/RW/RO）。
- 日志引擎（CDC）、读写分离、只读实例均**强依赖主实例 ID**，因此 `instance_id` 或成功创建的主实例输出必须可用。
- `use_account_database_binding = true` 推荐用于需要精细控制账号-数据库权限绑定的生产环境。
- 所有高级功能（CDC、RW 分离、只读实例、手动备份）默认关闭，按需启用以避免非预期资源创建。
- 若需管理多个只读实例或复杂 CDC 多流拓扑，建议直接调用对应子模块以获得更细粒度控制。