project     = "XXX"
environment = "Production"

vm_instance = {
  "01" = {
    # VM
    startup = "order=10"
    networks = {
      "01" = {
        tag = 2005
      }
    }

    # Project
    state    = "MASTER"
    priority = 250
  },
  "02" = {
    # VM
    startup = "order=11"
    networks = {
      "01" = {
        tag = 2005
      }
    }

    # Project
    state    = "BACKUP"
    priority = 240
  }
}
