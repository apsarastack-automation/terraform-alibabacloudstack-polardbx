# 为已有 PolarDBX 实例创建手动备份

本示例演示如何为已有的 PolarDBX 实例触发一次手动备份。

## 重要说明

**本示例不会创建 PolarDBX 实例。** 它仅为已有实例触发一次手动备份。您必须提供有效的 `db_instance_id`。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或命令行）：
   ```hcl
   db_instance_id = "pxc-xxxxxxxx"
   backup_type    = 0
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
| polardbx_backup | ../../modules/polardbx_instance | n/a |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| db_instance_id | 已有 PolarDBX 实例的 ID | string | - | 是 |
| backup_type | 手动备份的类型（0 = 物理备份） | number | 0 | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| db_instance_id | PolarDBX 实例的 ID |
| backup_set_id | 手动备份创建的备份集 ID |
| backup_status | 手动备份的状态（0 = 创建中，1 = 成功，2 = 失败） |

## 注意事项

- 本示例需要已存在的 PolarDBX 实例。
- 备份资源为触发型资源：不支持更新操作，所有参数均为 ForceNew，修改任何参数都会发起一次新的备份。
- 该备份资源的 provider 删除操作为空操作：`terraform destroy` 仅将其从状态中移除，实例上的备份集仍会保留。
- 如需配置周期性备份策略，请改用 `create-backup-policy-for-existing-instance` 示例（基于 `polardbx_backup_policy` 模块）。
