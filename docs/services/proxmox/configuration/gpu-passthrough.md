# GPU Passthrough Configuration

## Overview

The Proxmox environment supports GPU passthrough for performance-intensive applications, particularly media processing workloads like Plex transcoding.

## Hardware Requirements

### GPU Specifications
- NVIDIA GPU models (specific models mentioned)
- CUDA compute capability
- VRAM requirements
- PCIe slot requirements

### Server Support
- NVIDIA driver compatibility
- BIOS/UEFI requirements
- PCIe slot availability
- Power requirements

## Setup Process

### Prerequisites
1. Enable IOMMU in BIOS
2. Enable VT-d in kernel boot parameters:
   ```
   intel_iommu=on iommu=pt
   ```
3. Check hardware compatibility
4. Install NVIDIA drivers on host

### Host Configuration
```
# Check for IOMMU support
dmesg | grep -i iommu

# Verify GPU detection
lspci | grep -i nvidia

# Update initramfs for IOMMU
echo "intel_iommu=on iommu=pt" >> /etc/default/grub
update-grub
update-initramfs -u
```

### Device Binding
1. Unbind GPU from display driver
2. Bind GPU to vfio-pci driver
3. Verify device assignment

## VM Configuration

### VM Settings
- Add GPU device to VM
- Configure PCI passthrough
- Set appropriate VM resources
- Configure GPU drivers in VM

### Plex Example
Based on documentation, the setup includes:
- GPU passthrough to Docker container
- Connection to Media Storage
- 9p filesystem protocol for passthrough:

```
args: -virtfs local,id=faststore9p,path=/rpool/faststore,security_model=passthrough,mount_tag=faststore9p
```

### VM Filesystem Mount
```
faststore9p /faststore 9p trans=virtio,rw,_netdev 0 0
```

## Performance Considerations

### Benefits
- Direct hardware access for GPU applications
- Reduced overhead
- Improved performance for media processing
- Better resource utilization

### Limitations
- VM must be configured for passthrough
- Limited to specific hardware
- Resource sharing considerations
- Driver compatibility issues

## Troubleshooting

### Common Issues
1. IOMMU disabled
2. Driver conflicts
3. VM configuration errors
4. Resource allocation issues

### Verification Steps
- Check IOMMU status
- Verify device assignment
- Test GPU functionality in VM
- Monitor system logs

## Security Considerations

### Isolation
- Hardware-level isolation
- Reduced attack surface
- Secure device assignment

### Maintenance
- Driver updates
- Firmware checks
- Performance monitoring