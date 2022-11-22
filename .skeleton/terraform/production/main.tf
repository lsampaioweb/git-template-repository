variable "vm_object" {
  type = map(object({
    onboot = optional(bool)
    vcpus  = optional(number)
  }))
  default = {
    "01" = {
      onboot = true
      vcpus  = 3
    },
    "02" = {
      onboot = true
      vcpus  = 3
    }
  }
}

resource "random_integer" "target_node" {
  min      = 1
  max      = 7
  for_each = var.vm_object
}

module "proxmox-ubuntu-22-04" {
  source = "../modules/proxmox-ubuntu-22-04"
  clone  = "ubuntu-22-04-server-standard"

  for_each = var.vm_object

  target_node = "kvm-0${random_integer.target_node[each.key].result}"
  name        = "prd-${each.key}"
  onboot      = each.value.onboot
  vcpus       = each.value.vcpus

  description = "Ubuntu 22.04 VM with the default applications and settings"
  pool        = "Production"
}
