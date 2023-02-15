project     = "XXX"
environment = "Staging"

vm_instance = {
  "01" = {
    # VM
    startup = "order=2010"
    networks = {
      "01" = {
        tag = 5
      }
    }

    # Project
    state    = "MASTER"
    priority = 250
  },
  "02" = {
    # VM
    startup = "order=2011"
    networks = {
      "01" = {
        tag = 5
      }
    }

    # Project
    state    = "BACKUP"
    priority = 240
  }
}
