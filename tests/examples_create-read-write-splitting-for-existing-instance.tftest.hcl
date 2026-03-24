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
    name           = "tfpolardbx-rw"
    engine_version = "5.7"
    storage        = 50
    vswitch_id     = run.setup_instance.vswitch_id
    cn_node_count  = 2
    dn_node_count  = 2
  }
}

run "create_readonly_instance" {
  command = apply
  module {
    source = "../modules/polardbx_readonly_instance"
  }
  variables {
    name                   = "tfpolardbx-rw"
    engine_version         = "5.7"
    storage                = 50
    primary_db_instance_id = run.create_instance.instance_id
    vswitch_id             = run.setup_instance.vswitch_id
    cn_node_count          = 2
    cn_node_class          = run.create_instance.cn_node_class
    dn_node_count          = 2
    dn_node_class          = run.create_instance.dn_node_class
  }
}

run "validate" {
  command = apply
  module {
    source = "../examples/create-read-write-splitting-for-existing-instance"
  }
  variables {
    db_instance_id                 = run.create_instance.instance_id
    attend_htap_list               = [run.create_instance.instance_id, run.create_readonly_instance.instance_id]
    auto_attend_htap               = true
    delay_execution_strategy       = 1
    enable_consistent_replica_read = true
    enable_htap                    = true
    master_read_weight             = 30
    storage_delay_threshold        = 3
  }

  assert {
    condition     = output.rw_splitting_id != ""
    error_message = "Read-write splitting ID should not be empty."
  }

  assert {
    condition     = output.master_read_weight == 30
    error_message = "Master read weight should be 30."
  }
}
