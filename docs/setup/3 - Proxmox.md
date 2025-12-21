# Initial OS Install

> **📖 Related Documentation:** [Setup Guide](0%20-%20Setup%20Guide.md) | [Device Separation Guide](0.1%20-%20Device%20Separation%20Guide.md) | [Network Summary](../network/Network%20Summary.md)


* [GPU Passthrough](https://www.firsttiger.com/blogs/setup-proxmox-with-nvidia-pass-through-to-vms/)
* [VM VLANs](https://www.virtualizationhowto.com/2023/12/proxmox-vlan-configuration-management-ip-bridge-and-virtual-machines/)
* [Expand LVM](https://packetpushers.net/blog/ubuntu-extend-your-default-lvm-space/)

# First Boot Steps

1. Reconfigure System Network
- from:

```bash 
   auto lo
   iface lo inet loopback

   iface enp7s0 inet manual

   auto vmbr0
   iface vmbr0 inet manual
           address 10.10.X.X/24
           gateway 10.10.X.X
           bridge-ports enp7s0
           bridge-stp off
           bridge-fd 0
```

- to:

```bash
   auto lo
   iface lo inet loopback

   iface enp7s0 inet manual

   auto vmbr0
   iface vmbr0 inet manual
           bridge-ports enp7s0
           bridge-stp off
           bridge-fd 0
           bridge-vlan-aware yes    ## Changes ##
           bridge-vids 2-4094       #

   auto vmbr0.10                    # MANAGEMENT VLAN 
   iface vmbr0.10 inet static       #
           address 10.10.X.X/24     #
           gateway 10.10.X.X        #
```
* Ensure the Switch is configured for trunking on that port as well



2. Local-lvm removal
- Delete local-lvm from Datacenter --> storage
- Delete "local-lvm" space and give to "local"

```bash
   lvremove /dev/pve/data
   lvresize -1 +100%FREE /dev/pve/root
   resize2fs /dev/mapper/pve-root
```

# Setup GPU Passthrough

https://harryvasanth.com/posts/proxmox-gpu-passthrough/


# Import TrueNAS ZFS Pool


# Plex
- Setup GPU Passthrough to Docker container
- Connect to Media Storage
	To attach a folder from the Proxmox host to a virtual machine (VM), the most direct method involves using the 9p filesystem protocol for passthrough, which allows direct access to a host directory from within the VM. This method is particularly useful for avoiding the overhead of network-based protocols like NFS or SMB.
	
	To set this up, first ensure the 9p kernel modules are loaded on the Proxmox host by adding the following lines to `/etc/initramfs-tools/modules`:
	
	```
	9p
	9pnet
	9pnet_virtio
	```
	
	Then update the initial ramdisk with `sudo update-initramfs -u`.
	
	Next, edit the VM's configuration file located at `/etc/pve/qemu-server/<vmid>.conf` and add the following line at the top of the file, replacing the placeholders with your specific path and mount tag:
	
	```
	args: -virtfs local,id=faststore9p,path=/rpool/faststore,security_model=passthrough,mount_tag=faststore9p
	```
	
	This line specifies the host directory (`path`), a unique identifier (`id`), and a mount tag (`mount_tag`) used in the VM's fstab.
	
	After configuring the VM, add an entry to the VM's `/etc/fstab` file to ensure the directory is mounted at boot:
	
	```
	faststore9p /faststore 9p trans=virtio,rw,_netdev 0 0
	```
	
	This mounts the host directory to `/faststore` inside the VM with read-write permissions.
	
	Finally, a reboot of the Proxmox host is recommended to ensure all configurations are applied correctly.

# SMB
- Setup conntainer with access to storage


mv /etc/pve/nodes/primary/qemu-server/*.conf /etc/pve/nodes/HOMELAB-01/qemu-server/
mv /etc/pve/nodes/primary/lxc/*.conf /etc/pve/nodes/HOMELAB-01/lxc/   
---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
