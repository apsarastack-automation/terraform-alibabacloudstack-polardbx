# PolarDBX 日志引擎（CDC）Terraform 模块

该模块用于为**已存在的阿里云 PolarDBX 实例**配置日志引擎（CDC）能力，支持单流主引擎与多流（Multi-Stream）扩展部署。模块不创建 PolarDBX 实例本身，仅管理其 CDC 相关资源。

## 功能特性

- ✅ 为现有 PolarDBX 实例启用/禁用日志引擎（CDC）
- ✅ 自动探测并选用可用的 CDC 节点规格（按 CPU 排序优先），支持手动指定
- ✅ 支持灵活配置 CDC 节点数量（默认 `2` 节点）
- ✅ 支持多流（Multi-Stream）拓扑：可定义多个独立的数据变更订阅组（group），每组支持独立规格、节点数与哈希策略
- ✅ 完整输出关键资源配置信息，便于下游模块引用

> ⚠️ **重要限制**：本模块**不创建 PolarDBX 实例**，`instance_id` 必须指向一个已存在且支持 CDC 功能的 PolarDBX 实例（如 PolarDB-X 2.0 集群版）。请确保目标实例已开通日志引擎服务权限。

## 使用方法

### 基础用法：启用默认日志引擎

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id         = "pxc-xxxxxxxxxxxxxxx"  # 必填：已有 PolarDBX 实例 ID
  enable_log_engine   = true                     # 启用 CDC
}
```

### 进阶用法：自定义 CDC 节点规格与数量

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id         = "pxc-xxxxxxxxxxxxxxx"
  enable_log_engine   = true
  cdc_node_class      = "polarx.cdc.large"     # 手动指定节点规格（可选）
  cdc_node_count      = 4                      # 指定节点数（默认 2）
}
```

### 高级用法：配置多流（Multi-Stream）订阅

```hcl
module "polardbx_log_engine" {
  source = "<Module Path>"

  instance_id       = "pxc-xxxxxxxxxxxxxxx"
  enable_log_engine = true

  multi_streams = [
    {
      group_name = "stream-a"
      comment    = "核心业务订单流"
      hash_level = "TABLE"     # 可选值：TABLE / DATABASE / SHARD
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
| `instance_id` | **（必需）** 已存在的 PolarDBX 实例 ID。本模块仅管理该实例的日志引擎配置，不创建实例。 | `string` | - | 是 |
| `enable_log_engine` | 是否启用日志引擎（CDC）功能。设为 `false` 时，模块不创建任何资源。 | `bool` | `false` | 否 |
| `cdc_node_class` | CDC 主引擎节点规格（如 `"polarx.cdc.large"`）。若为空，模块自动选取第一个可用规格（按 CPU 排序）。 | `string` | `""` | 否 |
| `cdc_node_count` | CDC 主引擎节点数量。最小值为 `1`。 | `number` | `2` | 否 |
| `multi_streams` | 多流（Multi-Stream）配置列表。每个元素为对象，包含 `group_name`（必填）、`comment`（可选）、`hash_level`（必填，取值 `"TABLE"`/`"DATABASE"`/`"SHARD"`）、`node_class`（必填）、`node_count`（必填）。 | `list(object({ group_name = string, comment = optional(string, ""), hash_level = string, node_class = string, node_count = number }))` | `[]` | 否 |

> 💡 **`hash_level` 说明**：<br>
> - `TABLE`: 按表名哈希，同一表的所有变更路由到同一节点<br>
> - `DATABASE`: 按库名哈希，同一库的所有表变更路由到同一节点<br>
> - `SHARD`: 按分片键哈希（需配合 PolarDBX 分片规则），实现更细粒度负载均衡

### 输出变量

| 名称 | 描述 |
|------|------|
| `log_engine_id` | 日志引擎配置的唯一 ID（仅当 `enable_log_engine = true` 时有效） |
| `instance_id` | 输入的 PolarDBX 实例 ID（始终输出） |
| `cdc_node_class` | 实际使用的 CDC 主引擎节点规格（仅当 `enable_log_engine = true` 时有效） |
| `cdc_node_count` | 实际部署的 CDC 主引擎节点数量（仅当 `enable_log_engine = true` 时有效） |
| `multi_stream` | 当前生效的多流配置列表（结构同输入 `multi_streams`，仅当 `enable_log_engine = true` 时有效） |

## 示例

更多使用场景请参见 [`examples/`](./examples) 目录：
- `enable-basic-cdc`：启用基础日志引擎
- `enable-multi-stream-cdc`：配置多流订阅组
- `custom-cdc-specs`：指定节点规格与数量

## 注意事项

- 🔒 **实例前置要求**：目标 PolarDBX 实例必须已开通日志引擎（CDC）服务，且处于运行中状态；建议在控制台或通过 OpenAPI 验证 CDC 功能可用性。
- 📏 **规格兼容性**：`cdc_node_class` 必须是 `alibabacloudstack_polardbx_cdc_classes` 数据源返回的有效规格；若未指定且数据源无结果，模块将因 `local.cdc_node_class` 为空而报错。
- 🔄 **多流约束**：每个 `multi_stream` 的 `group_name` 必须全局唯一；修改 `group_name` 将触发资源重建（旧组被删除，新组被创建）。
- 🧩 **资源生命周期**：当 `enable_log_engine` 从 `true` 改为 `false` 时，Terraform 将销毁整个日志引擎（含所有 Multi-Stream 组），**不可逆**，请谨慎操作。
- 🌐 **网络连通性**：日志引擎与 PolarDBX 实例自动部署在同一 VPC 内，无需额外网络配置；但消费端需确保能访问 PolarDBX 实例的 CDC 对接地址（通常为内网地址）。