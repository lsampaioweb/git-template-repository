module "random_target_node" {
  source = "github.com/lsampaioweb/terraform-random-target-node.git?ref=v1.0"

  for_each = var.vm_instance
}

module "proxmox_vm" {
  source = "github.com/lsampaioweb/terraform-proxmox-vm-qemu.git?ref=v1.4"

  for_each = var.vm_instance

  target_node = "kvm-0${module.random_target_node[each.key].result}"
  clone       = "ubuntu-22-04-server-std-docker"
  name        = "stg-${each.key}"
  onboot      = each.value.onboot
  vcpus       = each.value.vcpus

  description = "."
  pool        = "Staging"
}

resource "local_file" "ansible_hosts" {
  content = templatefile(local.path_inventory_hosts_template,
    {
      host_list = [
        for key, value in var.vm_instance :
        {
          hostname    = module.proxmox_vm[key].vm_name
          public_ip   = module.proxmox_vm[key].vm_ipv4
          password_id = module.proxmox_vm[key].vm_cloned_from

          state          = value.state
          priority       = value.priority
          unicast_src_ip = module.proxmox_vm[key].vm_ipv4

          unicast_peer_ip = join(",", [
            for key1, value1 in var.vm_instance :
            module.proxmox_vm[key1].vm_ipv4
            if module.proxmox_vm[key].vm_ipv4 !=
            module.proxmox_vm[key1].vm_ipv4
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
