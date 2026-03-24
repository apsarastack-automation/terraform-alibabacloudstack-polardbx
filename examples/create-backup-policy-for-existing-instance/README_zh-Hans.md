# 为已有 PolarDBX 实例创建备份策略

本示例演示如何为已有的 PolarDBX 实例配置备份策略。

## 重要说明

**本示例不会创建 PolarDBX 实例。** 它仅为已有实例配置备份策略。您必须提供有效的 `db_instance_id`。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或命令行）：
   ```hcl
   db_instance_id       = "pxc-xxxxxxxx"
   backup_period        = "Monday,Wednesday,Friday"
   backup_set_retention = 7
   backup_plan_begin    = "03:00Z"
   remove_log_retention = 7
   ```

2. 执行：
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
|------|------|
| terraform | >= 1.5.6 |

## 提供商

| 名称 | 版本 |
|------|------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## 模块

| 名称 | 来源 | 版本 |
|------|------|------|
| backup_policy | ../../modules/polardbx_backup_policy | n/a |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| db_instance_id | 已有 PolarDBX 实例的 ID | string | - | 是 |
| backup_period | 备份周期 | string | "Monday,Wednesday,Friday" | 否 |
| backup_set_retention | 备份集保留期（天） | number | 7 | 否 |
| backup_plan_begin | 备份开始时间（HH:mmZ） | string | "03:00Z" | 否 |
| remove_log_retention | 事务日志保留期（天） | number | 7 | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| db_instance_id | PolarDBX 实例的 ID |
| backup_policy_applied | 是否已应用备份策略 |
| backup_period | 配置的备份周期 |
| backup_set_retention | 配置的保留期 |

## 注意事项

- 本示例需要已存在的 PolarDBX 实例。
- 执行 `terraform destroy` 会从 Terraform 状态中移除备份策略配置。
- 销毁后，实例上的实际备份策略可能会保留。
