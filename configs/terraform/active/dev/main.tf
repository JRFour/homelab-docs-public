resource "proxmox_lxc" "lxc" {  
  for_each = var.container
  
  hostname     =  each.value.hostname
  target_node  = each.value.node
  ostemplate   = "local:vztmpl/${each.value.os_template}"
  unprivileged = true

  cores  = each.value.cpu
  memory = each.value.ram
  swap   = each.value.swap

  rootfs {
    storage = each.value.storage_name
    size    = each.value.storage_size
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = each.value.ip_addr
    tag = each.value.vlan_id
  }

  ssh_public_keys = file(each.value.ssh_pubkey)

  tags = each.value.vlan_name
}