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
    source = "../examples/create-mysql-with-account-database-binding"
  }
  variables {
    name       = "tfpolardbx-binding"
    vswitch_id = run.setup_dependencies.vswitch_id
    databases  = {
      binding_db = {
        encode      = "utf8mb4"
        mode        = "auto"
        description = "Binding test database"
      }
    }
    accounts   = {
      binding_user = {
        password           = "BindingPass123!"
        description        = "Binding test account"
        account_privileges = {
          binding_db = "ReadWrite"
        }
      }
    }
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "PolarDBX instance ID should not be empty."
  }

  assert {
    condition     = output.instance_name == "tfpolardbx-binding"
    error_message = "Instance name should match the provided name."
  }
}
