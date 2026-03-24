# 为现有 PolarDBX 实例创建读写分离配置

此示例为现有的 PolarDBX 实例创建读写分离配置。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或 CLI）：
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   attend_htap_list = ["pxc-yyyyyyyy"]
   auto_attend_htap = true
   delay_execution_strategy = 1
   enable_consistent_replica_read = true
   enable_htap = true
   master_read_weight = 50
   storage_delay_threshold = 1000
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
| polardbx_read_write_splitting | ../../modules/polardbx_read_write_splitting | n/a |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|-------------|------|---------|----------|
| instance_id | 现有 PolarDBX 实例的 ID | string | - | 是 |
| attend_htap_list | 要参与的 HTAP 实例列表 | list(string) | [] | 否 |
| auto_attend_htap | 是否自动参与 HTAP 实例 | bool | false | 否 |
| delay_execution_strategy | 延迟执行策略（0 或 1） | number | 0 | 否 |
| enable_consistent_replica_read | 是否启用一致副本读 | bool | false | 否 |
| enable_htap | 是否启用 HTAP | bool | false | 否 |
| master_read_weight | 主实例的读权重（1-100） | number | 50 | 否 |
| storage_delay_threshold | 存储延迟阈值 | number | 1000 | 否 |

## 输出变量

| 名称 | 描述 |
|------|-------------|
| rw_splitting_id | 读写分离配置的 ID |
| db_instance_id | PolarDBX 实例的 ID |
| attend_htap_list | 要参与的 HTAP 实例列表 |
| auto_attend_htap | 是否自动参与 HTAP 实例 |
| delay_execution_strategy | 延迟执行策略 |
| enable_consistent_replica_read | 是否启用一致副本读 |
| enable_htap | 是否启用 HTAP |
| master_read_weight | 主实例的读权重 |
| storage_delay_threshold | 存储延迟阈值 |

## 注意事项

- 此示例需要现有的 PolarDBX 实例。
- `master_read_weight` 必须在 1 到 100 之间。
- HTAP 相关设置是可选的，取决于您的具体用例。
