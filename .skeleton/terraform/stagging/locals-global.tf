locals {
  path_ansible_scripts          = "../../ansible"
  path_inventory_hosts          = "${local.path_ansible_scripts}/inventory/hosts"
  path_inventory_hosts_template = "${local.path_inventory_hosts}.tpl"
}
