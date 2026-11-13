# Packer Ubuntu base box automation

This repository contains Packer templates for building Ubuntu base images on Proxmox and VMware vSphere.
The builds create platform templates and provision them with the Ansible playbook in
`ansible_provisioning/`.

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

1. Copy the appropriate variables file in `proxmox/` as needed, and set the Proxmox URL, node, storage pools,
   ISO file, network bridge/VLAN, and API token ID as the `username` (for example, `user@pve!token-name`).
   The ISO must already be available in Proxmox storage; set `iso_file` to its Proxmox storage path.
   Review the CPU, memory, disk, and network defaults for your environment.
2. Set the Proxmox API token secret in the `PROXMOX_TOKEN` environment variable. Keep the token secret out of the variables file and Git.
3. From the `proxmox/` directory, initialize the plugins and build the desired Ubuntu version:

   ```sh
   packer init .
   packer build -var-file=ubuntu24.pkrvars.hcl .
   ```

   For Ubuntu 26.04, use `ubuntu26.pkrvars.hcl` instead. The build creates a Proxmox VM template using the cloud-init files in `http/proxmox/`.
   Target the directory (`.`), not just `ubuntu.pkr.hcl`, so Packer also loads the variable declarations.

### Cloud-init handoff to Terraform

The Proxmox build waits for the installer's first-boot cloud-init to finish before Ansible runs.
After provisioning, it removes installer network overrides and cached cloud-init seed/instance data,
resets the machine ID, and allows cloud-init to set the clone's hostname. Cloud-init regenerates SSH
host keys on the clone's first boot; the vSphere-only `rc.local` fallback is not installed on Proxmox.
Do not boot the finished template before cloning it.

Packer adds an IDE cloud-init drive on `storage_pool`; this pool must support VM disk images.
The installer and seed ISOs are unmounted when the build finishes. Terraform should clone the
template and configure the inherited cloud-init drive before starting each VM, supplying the
hostname, network/DNS settings, and any user account or SSH keys. Do not bake those per-VM settings
into the Packer installer data.

With `terraform-proxmox-vm`, use `vm_mode = "legacy"` and set `cloud_init = {}` for native hostname
configuration, or supply the module's account and network settings as needed. Set the cloud-init
datastore to your actual storage pool. The module detects the inherited drive's interface; if
overriding it explicitly, use the template's actual slot rather than adding a second cloud-init drive.

For compatibility, the `vagrant` account, its password, passwordless sudo, and Vagrant SSH key remain
in the template. SSH authentication is explicitly limited to `publickey password` on both platforms;
your internal roles can provision passwords and authorized keys. The space-separated methods allow
either a key or a password. Creating another account through Terraform does not remove
the Vagrant account; keep these templates on trusted networks or remove that access in your
deployment configuration. vSphere provisioning is unchanged.

## Build a vSphere template

1. In `vsphere/`, copy `vsphere-environment-do-not-add-sample` to
   `vsphere-environment-do-not-add`. Fill in the vCenter, datacenter, cluster, ESXi host, datastore,
   network, VM name, and login values. This file is ignored by Git; keep credentials there and do not
   commit them.
2. Source the environment file in your shell, then initialize the plugins and build the desired version from the `vsphere/` directory:

   ```sh
   . ./vsphere-environment-do-not-add
   packer init ubuntu.pkr.hcl
   packer build -var-file=ubuntu24.pkrvars.hcl ubuntu.pkr.hcl
   ```

   For Ubuntu 22.04, use `ubuntu2204.pkrvars.hcl` instead. vSphere builds use the cloud-init files in `http/vsphere/` and convert the finished VM to a vSphere template.

Both platforms use the `vagrant` account during installation and Ansible provisioning. The vSphere build
creates a vSphere template; its Vagrant box and Artifactory post-processors are disabled for that source.

## Further reading

- [Packer documentation](https://developer.hashicorp.com/packer/docs) for Packer templates and commands.
