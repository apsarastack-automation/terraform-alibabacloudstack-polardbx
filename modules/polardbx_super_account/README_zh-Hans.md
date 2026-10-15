# 阿里云 PolarDBX 高权限账号 Terraform 模块

该模块用于管理阿里云 Stack 上 **已有** PolarDBX 实例的高权限账号（可选启用三权分立）。

## 重要说明

**本模块不会创建 PolarDBX 实例。** 它仅管理已有实例的高权限账号。您必须提供已有 PolarDBX 实例的有效 `instance_id`。

## 支持资源

* [alibabacloudstack_polardbx_super_account](https://registry.terraform.io/providers/aliyun/alibabacloudstack/latest/docs/resources/polardbx_super_account)

## 使用方法

### 基础用法（仅管理员账号）

```hcl
module "super_account" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_super_account"

  instance_id = "pxc-xxxxxxxx"

  super_account = {
    admin_account_name        = "admin_user"
    admin_account_password    = "SecurePassword123!"
    admin_account_description = "Super admin account"
  }
}
```

### 高级用法（三权分立）

```hcl
module "super_account" {
  source = "./terraform-alibabacloudstack-polardbx/modules/polardbx_super_account"

  instance_id = "pxc-xxxxxxxx"

  super_account = {
    admin_account_name             = "admin_user"
    admin_account_password         = "SecurePassword123!"
    admin_account_description      = "Super admin account"
    security_account_name          = "security_user"
    security_account_password      = "SecurePassword123!"
    security_account_description   = "Security admin account"
    audit_account_name             = "audit_user"
    audit_account_password         = "SecurePassword123!"
    audit_account_description      = "Audit account"
  }
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
| **instance_id** | **（必需）已有 PolarDBX 实例的 ID。** | `string` | — | 是 |
| super_account | 高权限账号配置对象；设为 `null` 则跳过账号创建。字段：`admin_account_name`（string，必填）、`admin_account_password`（string，必填）、`admin_account_description`（可选 string）、`security_account_name` / `security_account_password` / `security_account_description`（可选）、`audit_account_name` / `audit_account_password` / `audit_account_description`（可选）。 | `object` | `null` | 否 |

## 输出变量

| 名称 | 描述 |
|------|------|
| super_account_admin_name | 高权限（管理员）账号的名称；未配置高权限账号时为 `null`。标记为敏感值（派生自敏感的 `super_account` 变量）。 |
| super_account_three_roles | 是否已启用三权分立（管理员/安全管理员/审计员）；未配置高权限账号时为 `null`。 |

## 注意事项

- 本模块需要已存在的 PolarDBX 实例。如果 `instance_id` 无效或实例不存在，模块将失败。
- 安全账号组与审计账号组必须同时提供；只提供其中一组会被 provider 拒绝（`RequiredWith` 校验）。
- `admin_account_name` 支持 1-16 个字符（字母、数字、下划线、连字符）；密码须为 8-32 位且包含大写字母、小写字母、数字和特殊字符。
- `super_account` 变量标记为敏感值，账号密码不会出现在 plan/apply 输出中。
- 该资源的 provider 删除操作为空操作：`terraform destroy` 仅将资源从状态中移除，实例上的账号仍会保留。

## 提交问题

如果您在使用此模块时遇到任何问题，请提交 [provider issue](https://github.com/aliyun/terraform-provider-alibabacloudstack/issues/new) 并告知我们。

**注意：** 不建议在此仓库上提交 issue。

## 作者

由阿里云 Terraform 团队创建和维护

## 许可证

MIT 许可证。详情请参见 LICENSE。
