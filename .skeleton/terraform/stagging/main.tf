module "proxmox-ubuntu-22-04" {
  source = "../modules/proxmox-ubuntu-22-04"

  clone       = "ubuntu-22-04-server-standard"
  name        = "ubuntu-22-04-server-standard-vm-stagging"
  description = "Ubuntu 22.04 VM with the default applications and settings"
  pool        = ""
}
