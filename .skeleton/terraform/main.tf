module "homelab_project" {
  source  = "lsampaioweb/homelab-project/proxmox"
  version = "1.0.4"

  project     = var.project
  environment = var.environment

  vm_instance = var.vm_instance
}

module "dynamic_inventory" {
  source  = "lsampaioweb/dynamic-inventory/local"
  version = "1.0.1"

  hosts_list = [
    for key, value in var.vm_instance :
    {
      hostname    = module.homelab_project.vms[key].name
      public_ip   = module.homelab_project.vms[key].ipv4
      password_id = module.homelab_project.vms[key].clone

      state          = value.state
      priority       = value.priority
      unicast_src_ip = module.homelab_project.vms[key].ipv4

      unicast_peer_ip = join(",", [
        for key1, value1 in var.vm_instance :
        module.homelab_project.vms[key1].ipv4
        if module.homelab_project.vms[key].ipv4 !=
        module.homelab_project.vms[key1].ipv4
      ])
    }
  ]
}
