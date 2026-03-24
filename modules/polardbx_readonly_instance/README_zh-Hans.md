# 阿里云 PolarDB-X 只读实例 Terraform 模块

该模块用于在阿里云 Stack 上创建 **PolarDB-X 只读实例**，作为主实例的高可用读扩展节点，支持自动选择最优规格、多可用区部署及灵活的计算/存储节点配置。

## 功能特性

- 创建 PolarDB-X 只读实例（`alibabacloudstack_polardbx_readonly_instance`）
- 自动探测并选用可用的计算节点（CN）与存储节点（DN）规格（基于 CPU 排序）
- 支持单可用区（`1azone`）或三可用区（`3azones`）拓扑部署
- 灵活定义 CN/DN 节点数量与规格，支持自定义或自动回退至默认机型
- 自动生成实例描述（若未显式指定），格式为 `${name}-readonly`
- 输出关键运行时信息：连接串、实例状态、节点规格等

> ⚠️ **注意**：本模块**仅创建只读实例**，不创建主实例；`primary_db_instance_id` 必须为已存在的 PolarDB-X 主实例 ID。

## 使用方法

### 基础用法：创建默认配置的只读实例

```hcl
module "polardbx_readonly" {
  source = "<Module Path>"

  name                    = "my-polardbx-ro"
  primary_db_instance_id  = "pxc-xxxxxxxxxxxxxx"  # 必填：已有主实例 ID
  vswitch_id              = "vsw-xxxxxxxxxxxxxxxxx"
}
```

### 高级用法：自定义引擎版本、节点规格与拓扑

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
  cn_node_class           = "polarx.cn.x4.large"   # 可选：显式指定 CN 规格
  dn_node_class           = "polarx.dn.x8.large"  # 可选：显式指定 DN 规格
  topology_type           = "3azones"             # 可选：启用三可用区容灾
  description             = "Production read-only replica for analytics"
}
```

### 条件化创建：按需启用只读实例

```hcl
module "polardbx_readonly" {
  source = "<Module Path>"

  name                    = "optional-ro"
  primary_db_instance_id  = "pxc-zzzzzzzzzzzzzz"
  vswitch_id              = "vsw-zzzzzzzzzzzzzz"
  create_readonly_instance = var.enable_readonly_replica  # 例如通过变量控制是否部署
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
| `name` | 只读 PolarDB-X 实例名称 | `string` | `""` | 是（建议设置） |
| `primary_db_instance_id` | **主 PolarDB-X 实例 ID**（必须为已存在实例） | `string` | - | 是 |
| `create_readonly_instance` | 是否实际创建只读实例（设为 `false` 时跳过资源创建） | `bool` | `true` | 否 |
| `engine_version` | 数据库引擎版本。有效值：`"5.7"`、`"8.0"` | `string` | `"5.7"` | 否 |
| `storage` | 实例存储容量（单位：GB） | `number` | `50` | 否 |
| `vswitch_id` | 所属 VSwitch ID（用于网络隔离） | `string` | `""` | 是（若 `create_readonly_instance = true`） |
| `cn_node_class` | 计算节点（CN）规格 ID（如 `polarx.cn.x2.large`）；留空则自动选用当前地域最低规格 | `string` | `""` | 否 |
| `cn_node_count` | 计算节点（CN）数量 | `number` | `2` | 否 |
| `dn_node_class` | 存储节点（DN）规格 ID（如 `polarx.dn.x4.large`）；留空则自动选用当前地域最低规格 | `string` | `""` | 否 |
| `dn_node_count` | 存储节点（DN）数量 | `number` | `2` | 否 |
| `topology_type` | 部署拓扑类型。有效值：`"1azone"`（单可用区）、`"3azones"`（三可用区）；留空则使用服务默认策略 | `string` | `""` | 否 |
| `description` | 实例描述信息；留空时自动设为 `"${name}-readonly"` | `string` | `""` | 否 |

> 💡 **规格自动选择说明**：当 `cn_node_class` 或 `dn_node_class` 为空时，模块将调用 `alibabacloudstack_polardbx_instance_types` 数据源，按 `CPU` 排序后取首个可用规格，确保部署成功。

### 输出变量

| 名称 | 描述 |
|------|------|
| `instance_id` | 创建的只读 PolarDB-X 实例 ID（仅当 `create_readonly_instance = true` 时有效） |
| `instance_name` | 实例名称（即输入变量 `name` 的值） |
| `primary_db_instance_id` | 关联的主实例 ID |
| `is_read_db_instance` | 是否为只读实例（恒为 `true`，当 `create_readonly_instance = true` 时） |
| `vswitch_id` | 所使用的 VSwitch ID |
| `cn_node_class` | 实际采用的计算节点（CN）规格（可能为自动选型结果） |
| `dn_node_class` | 实际采用的存储节点（DN）规格（可能为自动选型结果） |
| `engine_version` | 实例数据库引擎版本 |
| `connection_string` | 实例连接串（格式：`host:port`），用于客户端连接 |
| `status` | 实例当前状态（如 `Running`、`Creating` 等） |

## 示例

更多使用场景请参见 [`examples/`](./examples) 目录：
- `basic-read-only-instance`：最简只读实例部署
- `multi-zone-read-only`：三可用区高可用只读实例
- `custom-node-specs`：显式指定 CN/DN 节点规格与数量

## 注意事项

- ✅ **主实例前置要求**：`primary_db_instance_id` 必须指向一个**已成功创建且处于 `Running` 状态**的 PolarDB-X 主实例。
- ⚠️ **网络约束**：`vswitch_id` 必须与主实例位于**同一地域**，且其所属 VPC 应已授权 PolarDB-X 服务访问（通常由阿里云自动完成）。
- ⚠️ **规格兼容性**：所选 `cn_node_class` / `dn_node_class` 必须与 `engine_version` 兼容（例如部分 DN 规格不支持 8.0），建议参考 [阿里云 PolarDB-X 文档](https://help.aliyun.com/product/41907.html) 确认。
- ⚠️ **拓扑限制**：`topology_type = "3azones"` 要求所选 `zone_id`（自动取首个可用区）所在地域支持三可用区部署，且 `vswitch_id` 对应的交换机需跨至少 3 个可用区（通常需配合自定义 VPC/VSwitch 模块）。
- 🚫 **不可变更项**：PolarDB-X 只读实例创建后，`engine_version`、`topology_type`、`cn_node_count`、`dn_node_count` 等核心配置**不支持 Terraform 修改**（需重建），请谨慎规划初始配置。
- 🔄 **自动重试机制**：因规格数据源依赖实时 API，首次执行可能因地域暂无可用规格而失败；建议结合 `terraform apply -auto-approve` 与重试逻辑使用。