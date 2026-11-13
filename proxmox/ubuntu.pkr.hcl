packer {
  required_version = ">= 1.16.1"

  required_plugins {
    ansible = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/ansible"
    }
    proxmox = {
      version = ">= 1.2.4"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {
  boot_command            = var.boot_command
  boot_wait               = "10s"
  boot                    = "order=scsi0;ide0;ide1;net0"
  cores                   = var.cpus
  memory                  = var.ram_mb
  vm_name                 = var.proxmox_name
  cpu_type                = "host"
  node                    = var.node_name
  proxmox_url             = var.proxmox_url
  username                = var.username
  cloud_init              = true
  cloud_init_storage_pool = var.storage_pool
  cloud_init_disk_type    = "ide"
  ssh_password            = "vagrant"
  ssh_timeout             = "15m"
  ssh_username            = "vagrant"
  template_description    = "${var.proxmox_name}, generated on ${timestamp()}"
  template_name           = var.proxmox_name
  disks {
    disk_size           = var.disk_size
    storage_pool        = var.storage_pool
    type                = "scsi"
    exclude_from_backup = true
    format              = var.disk_format
  }

  efi_config {
    efi_storage_pool  = var.storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  insecure_skip_tls_verify = var.insecure_skip_tls_verify

  boot_iso {
    type             = "ide"
    index            = "0"
    iso_file         = var.iso_file
    iso_storage_pool = var.storage_pool
    iso_checksum     = var.iso_checksum
    unmount          = true
  }

  additional_iso_files {
    type             = "ide"
    index            = "1"
    iso_storage_pool = var.additional_iso_storage_pool
    cd_files         = ["../http/proxmox/user-data", "../http/proxmox/meta-data"]
    cd_label         = "cidata"
    unmount          = true
  }

  network_adapters {
    bridge   = var.bridge
    vlan_tag = var.vlan_tag
    model    = var.model
  }
}

build {
  sources = ["source.proxmox-iso.ubuntu"]
  provisioner "shell" {
    execute_command = "sudo bash '{{ .Path }}'"
    inline          = ["cloud-init status --wait"]
  }
  provisioner "ansible" {
    playbook_file        = var.ansible_playbook_file
    galaxy_file          = var.ansible_requirements_file
    roles_path           = var.ansible_roles_path
    galaxy_force_install = true
    user                 = "vagrant"
    use_proxy            = false

    extra_arguments = [
      "-v",
      "-e",
      "ansible_ssh_password=vagrant",
      "-e",
      "{\"packer_proxmox_cloud_init\":true}",
    ]
  }

  provisioner "shell" {
    execute_command = "sudo bash '{{ .Path }}'"
    script          = "${path.root}/scripts/prepare-cloud-init.sh"
  }
}
