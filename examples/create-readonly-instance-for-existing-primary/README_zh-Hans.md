# 阿里云 PolarDB-X 只读实例 Terraform 模块（主模块）

该模块用于在阿里云 Stack 上**便捷创建 PolarDB-X 只读实例**，作为已有主实例的读扩展节点。本模块是对底层 `polardbx_readonly_instance` 子模块的封装，提供简洁、标准化的接口，屏蔽了规格自动选择、可用区探测等细节，聚焦于核心业务配置。

## 功能特性

- 一键创建 PolarDB-X 只读实例，与指定主实例建立只读复制关系
- 支持主流数据库引擎版本：`5.7` 和 `8.0`
- 灵活配置计算节点（CN）与存储节点（DN）数量及规格
- 自动继承网络环境（通过指定 `vswitch_id`）
- 输出关键运行时信息：实例 ID、名称、连接串、状态等
- 兼容 Terraform 最佳实践，满足生产环境可复现、可审计要求

> ⚠️ **注意**：本模块**不创建主 PolarDB-X 实例**，仅创建只读副本；`primary_db_instance_id` 必须为已存在且处于 `Running` 状态的主实例 ID。

## 使用方法

### 基础用法：创建默认配置的只读实例

```hcl
module "polardbx_readonly" {
  source = "../../modules/polardbx_readonly_instance"

  name                    = "my-app-ro"
  primary_db_instance_id  = "pxc-xxxxxxxxxxxxxx"  # 已存在的主实例 ID
  vswitch_id              = "vsw-xxxxxxxxxxxxxxxxx"
}
```

### 高级用法：自定义节点规模与规格

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
  cn_node_class           = "polarx.cn.x4.large"   # 可选：显式指定 CN 规格
  dn_node_class           = "polarx.dn.x8.large"    # 可选：显式指定 DN 规格
  description             = "只读副本：用于实时报表与分析查询"
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
| `name` | 只读 PolarDB-X 实例名称 | `string` | - | 是 |
| `primary_db_instance_id` | **主 PolarDB-X 实例 ID**（必须为已存在且运行中的实例） | `string` | - | 是 |
| `vswitch_id` | 所属 VSwitch ID（用于网络隔离，需与主实例同地域） | `string` | - | 是 |
| `engine_version` | 数据库引擎版本。有效值：`"5.7"`、`"8.0"` | `string` | `"5.7"` | 否 |
| `storage` | 实例存储容量（单位：GB） | `number` | `50` | 否 |
| `cn_node_count` | 计算节点（CN）数量 | `number` | `2` | 否 |
| `dn_node_count` | 存储节点（DN）数量 | `number` | `2` | 否 |
| `cn_node_class` | 计算节点（CN）规格 ID（如 `polarx.cn.x2.large`）；留空则使用服务默认规格 | `string` | `""` | 否 |
| `dn_node_class` | 存储节点（DN）规格 ID（如 `polarx.dn.x4.large`）；留空则使用服务默认规格 | `string` | `""` | 否 |
| `description` | 实例描述信息；留空时自动设为 `"${name}-readonly"` | `string` | `""` | 否 |

> 💡 **说明**：本模块**不暴露 `create_readonly_instance`、`topology_type` 等子模块内部参数**，所有实例均强制创建，拓扑类型由底层子模块按最优策略自动选择（不支持用户显式配置）。

### 输出变量

| 名称 | 描述 |
|------|------|
| `instance_id` | 创建的只读 PolarDB-X 实例 ID |
| `instance_name` | 实例名称（即输入变量 `name` 的值） |
| `primary_db_instance_id` | 关联的主 PolarDB-X 实例 ID |
| `connection_string` | 实例连接串（格式：`host:port`），用于客户端连接 |
| `status` | 实例当前状态（如 `Running`、`Creating` 等） |

## 示例

更多使用场景请参见 [`examples/`](./examples) 目录（需根据实际路径补充）：
- `basic-read-only-instance`：最简只读实例部署
- `custom-storage-and-nodes`：自定义存储大小与 CN/DN 节点数

## 注意事项

- ✅ **主实例前置要求**：`primary_db_instance_id` 必须指向一个**已成功创建、处于 `Running` 状态**的 PolarDB-X 主实例。
- ⚠️ **网络约束**：`vswitch_id` 必须与主实例位于**同一地域**，且其所属 VPC 应已授权 PolarDB-X 服务访问。
- ⚠️ **规格兼容性**：所选 `cn_node_class` / `dn_node_class` 必须与 `engine_version` 兼容（例如部分 DN 规格不支持 8.0），建议参考 [阿里云 PolarDB-X 文档](https://help.aliyun.com/product/41907.html) 确认。
- 🚫 **不可变更项**：PolarDB-X 只读实例创建后，`engine_version`、`cn_node_count`、`dn_node_count` 等核心配置**不支持 Terraform 修改**（需重建），请谨慎规划初始配置。
- 🔄 **自动规格回退**：当未指定 `cn_node_class` 或 `dn_node_class` 时，模块将自动选用当前地域最低可用规格，确保部署成功率。