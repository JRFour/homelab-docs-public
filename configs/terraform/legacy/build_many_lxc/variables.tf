variable "container" {
	type = map(object({
		hostname = string
		node = string 
		os_template = string 
		cpu = number 
		ram = number 
		swap = number
		storage_name = string
		storage_size = string 
		ip_addr = string 
		vlan_id = number
		vlan_name = string
		ssh_pubkey = string
	}))
	default = {
		"lxc" = {
			hostname = "DEV-LXC-01"
			node = "HOMELAB-03" 
			os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
			cpu = 2 
			ram = 512 
			swap = 512
			storage_name = "Backup"
			storage_size = "8G" 
			ip_addr = "10.10.90.101/24" 
			vlan_id = 90
			vlan_name = "dev"
			ssh_pubkey = "~/.ssh/id_ssh.pub"
		}
	}
}