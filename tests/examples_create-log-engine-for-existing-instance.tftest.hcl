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
    name           = "tfpolardbx-logengine"
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
    source = "../examples/create-log-engine-for-existing-instance"
  }
  variables {
    instance_id    = run.create_instance.instance_id
    cdc_node_count = 2
    multi_streams = [
      {
        group_name = "testtf"
        comment    = "Test stream group for CDC"
        hash_level = "RECORD"
        node_class = "polarx.x4.medium.2e"
        node_count = 2
      }
    ]
  }

  assert {
    condition     = output.log_engine_id != ""
    error_message = "Log engine ID should not be empty."
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "Instance ID should match the created instance."
  }

  assert {
    condition     = output.cdc_node_count == 2
    error_message = "CDC node count should be 2."
  }
}
