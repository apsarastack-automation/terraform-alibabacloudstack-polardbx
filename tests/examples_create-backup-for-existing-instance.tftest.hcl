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
    name           = "tfpolardbx-manualbackup"
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
    source = "../examples/create-backup-for-existing-instance"
  }
  variables {
    db_instance_id = run.create_instance.instance_id
    backup_type    = 0
  }

  assert {
    condition     = output.backup_set_id != null
    error_message = "Backup set ID should not be null after a manual backup is created."
  }

  assert {
    condition     = output.backup_status == 1
    error_message = "Manual backup should finish with status 1 (success)."
  }
}
