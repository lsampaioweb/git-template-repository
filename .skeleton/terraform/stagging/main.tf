module "random-target-node" {
  source = "../modules/random-target-node"

  for_each = var.vm_instance
}

module "proxmox-ubuntu-22-04" {
  source = "../modules/proxmox-ubuntu-22-04"

  for_each = var.vm_instance

  target_node = "kvm-0${module.random-target-node[each.key].result}"
  clone       = "ubuntu-22-04-server-std-docker"
  name        = "stg-${each.key}"
  onboot      = each.value.onboot
  vcpus       = each.value.vcpus

  description = "."
  pool        = "Stagging"
}

resource "local_file" "ansible_hosts" {
  content = templatefile(local.path_inventory_hosts_template,
    {
      master_list = [
        for key, value in var.vm_instance :
        {
          hostname    = module.proxmox-ubuntu-22-04[key].vm_name
          public_ip   = module.proxmox-ubuntu-22-04[key].vm_ipv4
          password_id = module.proxmox-ubuntu-22-04[key].vm_cloned_from

          state          = value.state
          priority       = value.priority
          unicast_src_ip = module.proxmox-ubuntu-22-04[key].vm_ipv4

          unicast_peer_ip = join(",", [
            for key1, value1 in var.vm_instance :
            module.proxmox-ubuntu-22-04[key1].vm_ipv4
            if module.proxmox-ubuntu-22-04[key].vm_ipv4 !=
            module.proxmox-ubuntu-22-04[key1].vm_ipv4
          ])
        } if value.state == "MASTER"
      ]
      backup_list = [
        for key, value in var.vm_instance :
        {
          hostname    = module.proxmox-ubuntu-22-04[key].vm_name
          public_ip   = module.proxmox-ubuntu-22-04[key].vm_ipv4
          password_id = module.proxmox-ubuntu-22-04[key].vm_cloned_from

          state          = value.state
          priority       = value.priority
          unicast_src_ip = module.proxmox-ubuntu-22-04[key].vm_ipv4

          unicast_peer_ip = join(",", [
            for key1, value1 in var.vm_instance :
            module.proxmox-ubuntu-22-04[key1].vm_ipv4
            if module.proxmox-ubuntu-22-04[key].vm_ipv4 !=
            module.proxmox-ubuntu-22-04[key1].vm_ipv4
          ])
        } if value.state == "BACKUP"
      ]
    }
  )
  filename = local.path_inventory_hosts

  directory_permission = "0644"
  file_permission      = "0644"

  provisioner "local-exec" {
    working_dir = local.path_ansible_scripts

    command = "ansible-playbook provision.yml"
  }

  # provisioner "local-exec" {
  #   when = destroy

  #   working_dir = local.path_ansible_scripts

  #   command = "ansible-playbook destroy.yml"
  # }
}
