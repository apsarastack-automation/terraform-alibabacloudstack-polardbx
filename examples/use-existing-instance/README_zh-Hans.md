# 使用已有 PolarDBX 实例

本示例演示如何使用已有的 PolarDBX 实例来创建数据库和账号，而不创建新实例。

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或命令行）：
   ```hcl
   instance_id = "pxc-xxxxxxxx"
   databases = {
     new_db = {
       encode      = "utf8mb4"
       description = "New database"
     }
   }
   accounts = {
     new_user = {
       password     = "SecurePassword123!"
       account_type = "Normal"
       account_privileges = {
         new_db = "ReadWrite"
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
| instance_id | 已有 PolarDBX 实例的 ID | string | - | 是 |
| databases | 要创建的数据库映射 | map(object) | {} | 否 |
| accounts | 要创建的账号映射 | map(object) | {} | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| instance_id | 已有 PolarDBX 实例的 ID |
| database_names | 创建的数据库名称列表 |
| account_names | 创建的账号名称列表 |

## 注意事项

- 本示例不会创建新实例。
- `instance_id` 必须是有效的已有 PolarDBX 实例。
- 执行 `terraform destroy` 只会移除 Terraform 管理的数据库和账号，不会删除实例本身。
