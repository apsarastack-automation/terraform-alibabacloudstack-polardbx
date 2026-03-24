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
    name           = "tfpolardbx-backup"
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
    source = "../examples/create-backup-policy-for-existing-instance"
  }
  variables {
    db_instance_id       = run.create_instance.instance_id
    backup_period        = "Monday,Wednesday,Friday"
    backup_set_retention = 7
    backup_plan_begin    = "03:00Z"
    remove_log_retention = 7
  }

  assert {
    condition     = output.db_instance_id != ""
    error_message = "DB instance ID should not be empty."
  }

  assert {
    condition     = output.backup_policy_applied == true
    error_message = "Backup policy should be applied."
  }
}
