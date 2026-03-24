run "setup_instance" {
  command = apply
  module {
    source = "./setup_dependencies"
  }
  variables {
    name = "tfpolardbx"
  }
}

run "create_instance" {
  command = apply
  module {
    source = "../modules/polardbx_instance"
  }
  variables {
    name           = "tfpolardbx-existing"
    engine_version = "5.7"
    storage        = 50
    vswitch_id     = run.setup_instance.vswitch_id
    cn_node_count  = 2
    dn_node_count  = 2
  }
}

run "validate" {
  command = apply
  module {
    source = "../examples/use-existing-instance"
  }
  variables {
    instance_id = run.create_instance.instance_id
    databases   = {
      existing_db = {
        encode      = "utf8mb4"
        mode        = "auto"
        description = "Database on existing instance"
      }
    }
    accounts    = {
      existing_user = {
        password           = "ExistingPass123!"
        description        = "Account on existing instance"
        account_privileges = {
          existing_db = "ReadWrite"
        }
      }
    }
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "Instance ID should match the existing instance."
  }
}
