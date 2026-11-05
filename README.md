# Packer Ubuntu base box automation

This repository contains Packer templates for building Ubuntu base images on Proxmox and VMware vSphere. The builds create platform templates and provision them with the Ansible playbook in `ansible_provisioning/`.

## Supported builds

| Platform | Ubuntu versions | Packer files |
| --- | --- | --- |
| Proxmox | 24.04, 26.04 | `proxmox/ubuntu.pkr.hcl` and the matching `ubuntu*.pkrvars.hcl` |
| VMware vSphere | 22.04, 24.04 | `vsphere/ubuntu.pkr.hcl` and the matching `ubuntu*.pkrvars.hcl` |

## Requirements

- Packer
- Ansible and Ansible Galaxy, for provisioning
- Access to the target Proxmox or vSphere environment

Packer installs the required provider and Ansible plugins when you run `packer init`.

## Build a Proxmox template

1. Copy the appropriate variables file in `proxmox/` as needed, and set the Proxmox URL, node, storage pools, ISO file, network bridge/VLAN, and API token ID as the `username` (for example, `user@pve!token-name`). The ISO must already be available in Proxmox storage; set `iso_file` to its Proxmox storage path. Review the CPU, memory, disk, and network defaults for your environment.
2. Set the Proxmox API token secret in the `PROXMOX_TOKEN` environment variable. Keep the token secret out of the variables file and Git.
3. From the `proxmox/` directory, initialize the plugins and build the desired Ubuntu version:

   ```sh
   packer init ubuntu.pkr.hcl
   packer build -var-file=ubuntu24.pkrvars.hcl ubuntu.pkr.hcl
   ```

   For Ubuntu 26.04, use `ubuntu26.pkrvars.hcl` instead. The build creates a Proxmox VM template using the cloud-init files in `http/proxmox/`.

## Build a vSphere template

1. In `vsphere/`, copy `vsphere-environment-do-not-add-sample` to `vsphere-environment-do-not-add`. Fill in the vCenter, datacenter, cluster, ESXi host, datastore, network, VM name, and login values. This file is ignored by Git; keep credentials there and do not commit them.
2. Source the environment file in your shell, then initialize the plugins and build the desired version from the `vsphere/` directory:

   ```sh
   . ./vsphere-environment-do-not-add
   packer init ubuntu.pkr.hcl
   packer build -var-file=ubuntu24.pkrvars.hcl ubuntu.pkr.hcl
   ```

   For Ubuntu 22.04, use `ubuntu2204.pkrvars.hcl` instead. vSphere builds use the cloud-init files in `http/vsphere/` and convert the finished VM to a vSphere template.

Both platforms use the `vagrant` account during installation and Ansible provisioning. The vSphere build creates a vSphere template; its Vagrant box and Artifactory post-processors are disabled for that source.

## Further reading

- [Packer documentation](https://developer.hashicorp.com/packer/docs) for Packer templates and commands.
