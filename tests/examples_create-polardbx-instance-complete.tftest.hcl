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
    name        = "tfpolardbx-complete"
    vswitch_id  = run.setup_dependencies.vswitch_id
    databases   = {
      test_db = {
        encode      = "utf8mb4"
        mode        = "auto"
        description = "Test database for PolarDBX instance"
      }
    }
    accounts    = {
      test_user = {
        password           = "TestPassword123!"
        description        = "Test account for PolarDBX instance"
        account_privileges = {
          test_db = "ReadWrite"
        }
      }
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
}
