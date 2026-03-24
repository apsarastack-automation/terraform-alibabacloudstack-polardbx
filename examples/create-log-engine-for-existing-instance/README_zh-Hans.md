# 为现有 PolarDBX 实例创建日志引擎

此示例为现有的 PolarDBX 实例创建日志引擎（CDC）配置。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或 CLI）：
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   cdc_node_class = "polarx.x4.medium.2e"
   cdc_node_count = 2
   multi_streams = [
     {
       group_name = "stream_group_1"
       comment    = "Primary stream group"
       hash_level = "RECORD"
       node_class = "polarx.x4.medium.2e"
       node_count = 2
     }
   ]
   ```

2. 运行：
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. 清理：
   ```bash
   terraform destroy
   ```

## 要求

| 名称 | 版本 |
|------|---------|
| terraform | >= 1.5.6 |

## 提供者

| 名称 | 版本 |
|------|---------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## 模块

| 名称 | 来源 | 版本 |
|------|--------|---------|
| polardbx_log_engine | ../../modules/polardbx_log_engine | n/a |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|-------------|------|---------|----------|
| instance_id | 现有 PolarDBX 实例的 ID | string | - | 是 |
| cdc_node_class | 日志引擎（CDC）节点的规格 | string | "" | 否 |
| cdc_node_count | 日志引擎（CDC）节点的数量 | number | 2 | 否 |
| multi_streams | 多流配置列表 | list(object) | [] | 否 |

## 输出变量

| 名称 | 描述 |
|------|-------------|
| log_engine_id | 日志引擎配置的 ID |
| instance_id | PolarDBX 实例的 ID |
| cdc_node_class | CDC 节点的规格 |
| cdc_node_count | CDC 节点的数量 |
| multi_stream | 多流配置 |

## 注意事项

- 此示例需要现有的 PolarDBX 实例。
- 如果未指定 `cdc_node_class`，将使用第一个可用的 CDC 类。
- 多流配置是可选的，可用于高级 CDC 场景。
