module "random-target-node" {
  source = "../modules/random-target-node"

  for_each = var.vm_instance
}

module "proxmox-vm" {
  source = "../modules/proxmox-vm"

  for_each = var.vm_instance

  target_node = "kvm-0${module.random-target-node[each.key].result}"
  clone       = "ubuntu-22-04-server-std-docker"
  name        = "prd-${each.key}"
  onboot      = each.value.onboot
  vcpus       = each.value.vcpus

  description = "."
  pool        = "Production"
}

resource "local_file" "ansible_hosts" {
  content = templatefile(local.path_inventory_hosts_template,
    {
      host_list = [
        for key, value in var.vm_instance :
        {
          hostname    = module.proxmox-vm[key].vm_name
          public_ip   = module.proxmox-vm[key].vm_ipv4
          password_id = module.proxmox-vm[key].vm_cloned_from

          state          = value.state
          priority       = value.priority
          unicast_src_ip = module.proxmox-vm[key].vm_ipv4

          unicast_peer_ip = join(",", [
            for key1, value1 in var.vm_instance :
            module.proxmox-vm[key1].vm_ipv4
            if module.proxmox-vm[key].vm_ipv4 !=
            module.proxmox-vm[key1].vm_ipv4
          ])
        } 
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
