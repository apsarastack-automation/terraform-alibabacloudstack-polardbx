# 阿里云 PolarDBX 备份策略 Terraform 模块

该模块用于管理阿里云 Stack 上 **已有** PolarDBX 实例的备份策略。

## 重要说明

**本模块不会创建 PolarDBX 实例。** 它仅管理已有实例的备份策略。您必须提供已有 PolarDBX 实例的有效 `db_instance_id`。

## 支持资源

* [alibabacloudstack_polardbx_backup_policy](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_backup_policy)

## 使用方法

### 基础用法

```hcl
module "backup_policy" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_backup_policy"

  db_instance_id = "pxc-xxxxxxxx"
}
```

### 高级用法（所有参数）

```hcl
module "backup_policy" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_backup_policy"

  db_instance_id                  = "pxc-xxxxxxxx"
  backup_period                   = "Monday,Tuesday,Wednesday,Thursday,Friday"
  backup_set_retention            = 30
  backup_plan_begin               = "03:00Z"
  remove_log_retention            = 7
  local_log_retention_number      = 60
  force_clean_on_high_space_usage = 1
  local_log_retention             = 7
  log_local_retention_space       = 30
}
```

## 要求

| 名称 | 版本 |
|------|------|
| terraform | >= 1.5.6 |

## 提供商

| 名称 | 版本 |
|------|------|
| alibabacloudstack | >= 3.18.24, < 3.19.0 |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| **db_instance_id** | **（必需）已有 PolarDBX 实例的 ID。** | `string` | — | 是 |
| backup_period | 备份周期。您可以选择一周中的多天。有效值：Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday。多个值用逗号分隔。 | `string` | `"Monday,Wednesday,Friday"` | 否 |
| backup_set_retention | 备份集的保留期。有效值：7 到 730 天。 | `number` | `7` | 否 |
| backup_plan_begin | 备份开始时间。时间格式为 HH:mmZ，例如 03:00Z。 | `string` | `"03:00Z"` | 否 |
| remove_log_retention | 事务日志的保留期。有效值：7 到 730 天。 | `number` | `7` | 否 |
| local_log_retention_number | 本地保留的事务日志数量。有效值：6 到 100。 | `number` | `60` | 否 |
| force_clean_on_high_space_usage | 当存储空间使用率较高时，是否强制删除备份。有效值：0（否），1（是）。 | `number` | `1` | 否 |
| local_log_retention | 本地保留的事务日志保留期。单位：天。 | `number` | `7` | 否 |
| log_local_retention_space | 本地保留的事务日志占用的最大空间。单位：%。有效值：0 到 100。 | `number` | `30` | 否 |
| backup_way | 备份方法。默认值：P（物理备份）。 | `string` | `"P"` | 否 |
| backup_type | 备份类型。默认值：0（完整备份）。 | `string` | `"0"` | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| db_instance_id | 已配置备份策略的 PolarDBX 实例 ID。 |
| backup_policy_applied | 是否已应用备份策略。 |
| backup_period | 配置的备份周期。 |
| backup_set_retention | 配置的备份集保留期。 |
| backup_plan_begin | 配置的备份开始时间。 |
| remove_log_retention | 配置的事务日志保留期。 |

## 注意事项

- 本模块需要已存在的 PolarDBX 实例。如果 `db_instance_id` 无效或实例不存在，模块将失败。
- 执行 `terraform destroy` 会从 Terraform 状态中移除备份策略配置，但实例上的实际备份策略可能会保留。

## 提交问题

如果您在使用此模块时遇到任何问题，请提交 [provider issue](https://github.com/aliyun/terraform-provider-alibabacloudstack/issues/new) 并告知我们。

**注意：** 不建议在此仓库上提交 issue。

## 作者

由阿里云 Terraform 团队创建和维护

## 许可证

MIT 许可证。详情请参见 LICENSE。
