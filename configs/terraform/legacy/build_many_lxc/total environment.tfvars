# HOMELAB-01 (Primary Production Server)
dns = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "PROD-DNS-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 20
	vlan_name = "prod"
}

auth = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "PROD-AUTH-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "80G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 20
	vlan_name = "prod"
}

proxy = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "PROD-PROXY-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 20
	vlan_name = "prod"
}

vault = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "PROD-VAULT-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 20
	vlan_name = "prod"
}

media_core = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "MEDIA-CORE-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 8
	ram = 16324
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "100G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 30
	vlan_name = "media"
}

media_mgmt = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "MEDIA-MGMT-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "80G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 30
	vlan_name = "media"
}

web_primary = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "WEB-PRIMARY-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "100G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 70
	vlan_name = "dmz"
}

web_db = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "WEB-DB-01"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 16324
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 70
	vlan_name = "dmz"
}

docker_swarm = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "DOCKER-SWARM-MANAGER"
	node = "HOMELAB-01"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "PRIM-ST02"
	storage_size = "100G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 20
	vlan_name = "prod"
}

# HOMELAB-02 (Secondary Development Server)
k8s_master = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "K8S-MASTER-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "80G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

k8s_worker_01 = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "K8S-WORKER-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 8
	ram = 16324
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

k8s_worker_02 = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "K8S-WORKER-02"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 8
	ram = 16324
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

dev_gitlab = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "DEV-GITLAB-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 6
	ram = 12258
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "300G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

dev_jenkins = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "DEV-JENKINS-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

dev_nexus = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "DEV-NEXUS-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "500G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

auto_n8n = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "AUTO-N8N-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "100G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 90
	vlan_name = "auto"
}

auto_queue = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "AUTO-QUEUE-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "80G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 90
	vlan_name = "auto"
}

sandbox = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "SANDBOX-01"
	node = "HOMELAB-02"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 8
	ram = 16324
	swap = 512
	storage_name = "SECO-ST01"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 40
	vlan_name = "dev"
}

# HOMELAB-03 (Utility/Backup Server)
monitor_prometheus = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "MONITOR-PROMETHEUS"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "Backup"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 10
	vlan_name = "mgmt"
}

monitor_grafana = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "MONITOR-GRAFANA"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "Backup"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 10
	vlan_name = "mgmt"
}

log_elk = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "LOG-ELK-01"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 6
	ram = 16324
	swap = 512
	storage_name = "Backup"
	storage_size = "500G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 10
	vlan_name = "mgmt"
}

bastion_primary = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "BASTION-PRIMARY"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "Backup"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 80
	vlan_name = "bastion"
}

bastion_vpn = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "BASTION-VPN"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 2048
	swap = 512
	storage_name = "Backup"
	storage_size = "20G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 80
	vlan_name = "bastion"
}

backup_veeam = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "BACKUP-VEEAM"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "Backup"
	storage_size = "100G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 10
	vlan_name = "mgmt"
}

backup_offsite = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "BACKUP-OFFSITE"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "Backup"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 10
	vlan_name = "mgmt"
}

security_wazuh = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "SECURITY-WAZUH"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 4
	ram = 8192
	swap = 512
	storage_name = "Backup"
	storage_size = "200G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 80
	vlan_name = "bastion"
}

media_download = {
	ssh_pubkey = "~/.ssh/id_ssh.pub"
	hostname = "MEDIA-DOWNLOAD"
	node = "HOMELAB-03"
	os_template = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst" 
	cpu = 2
	ram = 4096
	swap = 512
	storage_name = "Backup"
	storage_size = "40G"
	ip_addr = "10.10.90.101/24" 
	vlan_id = 30
	vlan_name = "media"
}

