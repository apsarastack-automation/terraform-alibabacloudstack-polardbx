# 创建完整的 PolarDBX 实例

本示例创建完整的 PolarDBX 实例配置，包括：
- 指定配置的 PolarDBX 实例
- 多个不同字符集的数据库
- 带权限的数据库账号

## 使用方法

1. 配置变量（通过 `terraform.tfvars` 或命令行）：
   ```hcl
   name          = "my-polardbx-complete"
   vpc_id        = "vpc-xxxxxxxx"
   vswitch_id    = "vsw-xxxxxxxx"
   databases = {
     app_db = {
       encode      = "utf8mb4"
       description = "Application database"
     }
     log_db = {
       encode      = "utf8"
       description = "Log database"
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
     readonly_user = {
       password     = "ReadOnlyPass123!"
       account_type = "Normal"
       account_privileges = {
         app_db = "ReadOnly"
         log_db = "ReadOnly"
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
| cn_node_count | 计算节点（CN）数量 | number | 2 | 否 |
| dn_node_count | 存储节点（DN）数量 | number | 2 | 否 |
| databases | 要创建的数据库映射 | map(object) | {} | 否 |
| accounts | 要创建的账号映射 | map(object) | {} | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| instance_id | 创建的 PolarDBX 实例 ID |
| instance_name | PolarDBX 实例名称 |
| database_names | 创建的数据库名称列表 |
| account_names | 创建的账号名称列表 |
| vswitch_id | 实例使用的交换机 ID |
| vpc_id | 实例使用的 VPC ID |

## 注意事项

- 本示例假定 VPC 和 VSwitch 已存在。
- `cn_node_count` 和 `dn_node_count` 必须至少为 2。
- 账号密码应安全提供（例如，通过环境变量或密钥管理）。
