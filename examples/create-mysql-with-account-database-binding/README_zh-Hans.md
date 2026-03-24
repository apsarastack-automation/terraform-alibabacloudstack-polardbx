# 使用 Account Database Binding 创建 PolarDBX 实例

本示例演示如何创建 PolarDBX 实例并使用 `account_database_binding` 资源来管理账号权限。

## 重要说明

本示例使用 `use_account_database_binding = true` 通过 `alibabacloudstack_polardbx_account_database_binding` 资源管理账号权限，而不是使用 `account_privilege` 属性。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或命令行）：
   ```hcl
   name       = "my-polardbx-binding"
   vpc_id     = "vpc-xxxxxxxx"
   vswitch_id = "vsw-xxxxxxxx"
   databases = {
     app_db = {
       encode      = "utf8mb4"
       description = "Application database"
     }
   }
   accounts = {
     app_user = {
       password     = "SecurePassword123!"
       account_type = "Normal"
       account_privileges = {
         app_db = "ReadWrite"
       }
     }
   }
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
| polardbx | ../../modules/polardbx_instance | n/a |

## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|------|------|--------|------|
| name | PolarDBX 实例名称 | string | - | 是 |
| vpc_id | VPC 的 ID | string | - | 是 |
| vswitch_id | 交换机的 ID | string | - | 是 |
| engine_version | 数据库引擎版本 | string | "5.7" | 否 |
| storage | 存储大小（GB） | number | 50 | 否 |
| databases | 要创建的数据库映射 | map(object) | {} | 否 |
| accounts | 要创建的账号映射 | map(object) | {} | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| instance_id | 创建的 PolarDBX 实例 ID |
| instance_name | PolarDBX 实例名称 |
| database_names | 创建的数据库名称列表 |
| account_names | 创建的账号名称列表 |

## 注意事项

- 本示例使用 `use_account_database_binding = true`。
- `account_database_binding` 资源提供更细粒度的账号权限控制。
- 当您需要管理复杂的权限配置时，建议使用此方法。
