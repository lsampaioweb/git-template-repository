locals {
  path_ansible_scripts          = "${path.root}/../ansible"
  path_inventory_hosts          = "${local.path_ansible_scripts}/inventory/hosts"
  path_inventory_hosts_template = "${local.path_inventory_hosts}.tpl"
}
