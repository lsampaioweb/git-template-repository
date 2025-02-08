terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://kvm.lan.homelab:8006/api2/json"
  pm_api_token_id = "terraform@pve!terraform"
}
