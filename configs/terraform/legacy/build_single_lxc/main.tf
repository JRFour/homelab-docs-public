resource "proxmox_lxc" "lxc" {  
  hostname     = "${var.env_config[var.environment].vlan_name}-${var.use}-01"
  target_node  = var.node
  ostemplate   = "local:vztmpl/${var.os_template}"
  unprivileged = true

  cores  = var.cpu
  memory = var.ram
  swap   = var.swap

  rootfs {
    storage = var.node_config[var.node].storage_name
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.10.${var.env_config[var.environment].vlan_id}.101/24"
    tag = var.env_config[var.environment].vlan_id
  }

  ssh_public_keys = file(var.ssh_pubkey)

  tags = var.env_config[var.environment].vlan_name
}