output "container_info" {
	 value = {
		for k, inst in proxmox_lxc.lxc : k => {
			container_id = inst.id
			hostname = inst.hostname
			ip_address = length(inst.network) > 0 ? inst.network[0].ip
			mac_address = length(inst.network) > 0 ? inst.network[0].hwaddr
		}
	   }
}
