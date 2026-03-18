output "container_id" {
  value = proxmox_lxc.lxc.id 
} 

output "hostname" { 
  value = proxmox_lxc.lxc.hostname 
} 

output "ip_address" { 
  value = proxmox_lxc.lxc.network[0].ip 
}

output "mac_address" { 
  value = proxmox_lxc.lxc.network[0].hwaddr
}