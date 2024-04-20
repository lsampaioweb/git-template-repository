proxmox_url = "https://edge-pve-01.homelab:8006/api2/json"
node        = "edge-pve-01"

clone_vm = "ubuntu-22-04-server-raw"

vm_id                = 911
build_name           = "ubuntu"
vm_name              = "ubuntu-22-04-server-standard"
template_description = "Ubuntu server 22.04 template with the default configuration generated by Packer on {{ isotime `2006-01-02` }}."
