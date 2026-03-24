run "setup_instance" {
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
    source = "../"
  }
  variables {
    name             = "tfpolardbx"
    engine_version   = "5.7"
    storage          = 50
    vswitch_id       = run.setup_instance.vswitch_id
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
    enable_log_engine             = false
    enable_read_write_splitting   = false
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "PolarDBX instance ID should not be empty."
  }

  assert {
    condition     = output.instance_name == "tfpolardbx"
    error_message = "Instance name should match the provided name."
  }
}
