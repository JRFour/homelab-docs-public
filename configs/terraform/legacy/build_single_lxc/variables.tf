variable "os_template" {
  type   = string
  description = "A string containing the name of the lxc template to use"
  default = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
}

variable "ssh_pubkey" {
  type        = string
  description = "A string containing the name of the public key file to use for ssh"
  default     = "~/.ssh/id_ssh.pub"
  validation {
    condition     = endswith(".pub", var.ssh_pubkey)
    error_message = "File must be type .pub"
  }
}

variable "node" {
  type        = string
  description = "A string containing the cluster node name."
  default     = "HOMELAB-03"
  validation {
    condition     = contains(["HOMELAB-01","HOMELAB-02","HOMELAB-03"], var.node)
    error_message = "Node must be one of the ones in the cluster."
  }
}
variable "node_config"{
  type = map(object({
    host_name       = string
    storage_name = string
  }))
  default = {
    HOMELAB-01 = {
      host_name       = "HOMELAB-01"
      storage_name = "PRIM-ST02"
    }
    HOMELAB-02 = {
      host_name       = "HOMELAB-02"
      storage_name = "SECO-ST01"
    }
    HOMELAB-03 = {
      host_name       = "HOMELAB-03"
      storage_name = "Backup"
    }
}

variable "use" {
  type        = string
  description = "A string describing the use of the container for the hostname"
  default     = "LXC"
  validation {
    condition     = length(var.use) <= 10
    error_message = "variable 'use' name was too long"
  }
}

variable "environment" {
  type        = string
  description = "A string containing the vlan name. Also used in hostname"
  default     = "dev"
  validation {
    condition     = contains(["dev","mgmt","prod","media","iot","dmz","guest","bast","auto"], var.environment)
    error_message = "environment must exist on the network."
  }
}

variable "env_config" {
  type = map(object({
    vlan_name = string
    vlan_id        = number
  }))
  default = {
    mgmt = {
      vlan_name = "MGMT"
      vlan_id = "10"
    }
    prod = {
      vlan_name = "PROD"
      vlan_id = "20"
    }
    media = {
      vlan_name = "MEDIA"
      vlan_id = "30"
    }
    dev = {
      vlan_name = "DEV"
      vlan_id = "40"
    }
    iot = {
      vlan_name = "IOT"
      vlan_id = "50"
    }
    dmz = {
      vlan_name = "DMZ"
      vlan_id = "60"
    }
    guest = {
      vlan_name = "GUEST"
      vlan_id = "70"
    }
    bas = {
      vlan_name = "BASTION"
      vlan_id = "80"
    }
    auto = {
      vlan_name = "AUTO"
      vlan_id = "90"
    }
  }
}

variable "cpu" {
  type        = number
  description = "The number of cores assigned to the container."
  default     = 2
}
variable "ram" {
  type        = number
  description = "A number containing the amount of RAM to assign to the container (in MB)."
  default     = 512
}
variable "swap" {
  type        = number
  description = " A number that sets the amount of swap memory available to the container. Default is `512`."
  default     = "dev"
}
