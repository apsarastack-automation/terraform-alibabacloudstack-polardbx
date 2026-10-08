run "setup_dependencies" {
  command = apply
  module {
    source = "./setup_dependencies"
  }
  variables {
    name = "tfpolardbx"
  }
}

run "validate" {
  command = apply
  module {
    source = "../examples/create-polardbx-instance-complete"
  }
  variables {
    name       = "tfpolardbx-complete"
    vswitch_id = run.setup_dependencies.vswitch_id
    databases = {
      test_db = {
        encode      = "utf8mb4"
        mode        = "auto"
        description = "Test database for PolarDBX instance"
      }
    }
    accounts = {
      test_user = {
        password    = "TestPassword123!"
        description = "Test account for PolarDBX instance"
        account_privileges = {
          test_db = "ReadWrite"
        }
      }
    }
    super_account = {
      admin_account_name           = "admin_user"
      admin_account_password       = "TestPassword123!"
      admin_account_description    = "Super admin account"
      security_account_name        = "security_user"
      security_account_password    = "TestPassword123!"
      security_account_description = "Security admin account"
      audit_account_name           = "audit_user"
      audit_account_password       = "TestPassword123!"
      audit_account_description    = "Audit account"
    }
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "PolarDBX instance ID should not be empty."
  }

  assert {
    condition     = output.instance_name == "tfpolardbx-complete"
    error_message = "Instance name should match the provided name."
  }

  assert {
    condition     = output.super_account_three_roles == true
    error_message = "Super account should have three-role rights separation enabled."
  }

  assert {
    condition     = output.super_account_admin_name == "admin_user"
    error_message = "Super account admin name should be admin_user."
  }
}
