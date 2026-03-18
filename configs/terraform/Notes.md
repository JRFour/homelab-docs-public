If Terraform installation on Debian is failing, the most common issue is using an incorrect or unsupported distribution codename in the APT repository configuration. The `$(lsb_release -cs)` command may return an invalid or unsupported codename (like `debbie` for Linux Mint Debian Edition), which causes a **404 Not Found** error when trying to fetch packages. 
##### **Fix: Manually Specify the Correct Debian Codename**
Replace `$(lsb_release -cs)` with the actual Debian version codename:
- **Debian 12 (Bookworm)** → Use `bookworm`


1st project was simple test build of an lxc container on the new proxmox cluster
2nd project was taking that simple build but seeing how to replicate it without re-coding each resource
3rd project - take the 2nd project and figure out how to separate the environments, either by duplicating code in separate directories, managing workspaces, or something else
	- decided to use separate directories for each environment, but the VLANs are not being separated, they are in one .tfvars file

Need to setup backed for state file storage - likely use MinIO (s3 compatible) or HTTP self host

4th project - Created all servers not currently running, imported running servers into the configuration and statefile.

5th project - figuring out automating adding static IPs to router. - REST API key is 98c23e7c0b69bdb7f782cc621e4b6d68
