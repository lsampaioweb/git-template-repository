vm_instance = {
  "01" = {
    onboot   = true
    vcpus    = 3
    state    = "MASTER"
    priority = 250
  },
  "02" = {
    onboot   = true
    vcpus    = 3
    state    = "BACKUP"
    priority = 240
  }
}
