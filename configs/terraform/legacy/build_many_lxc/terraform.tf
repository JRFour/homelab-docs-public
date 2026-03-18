terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://homelab-01.hogwarts.home:8006/api2/json"
  pm_tls_insecure = true
}
