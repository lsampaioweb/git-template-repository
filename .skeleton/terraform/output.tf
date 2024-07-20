output "virtual_machines" {
  value = module.homelab_project.vms
}

output "app_url" {
  description = "URL of the application"
  value       = ["https://XXX.lan.homelab", "https://XXX-01.lan.homelab", "https://XXX-02.lan.homelab"]
}
