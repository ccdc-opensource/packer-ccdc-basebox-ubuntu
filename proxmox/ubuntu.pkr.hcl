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

source "proxmox-iso" "ubuntu-kickstart" {
  boot_command = var.boot_command
  boot_wait    = "10s"
  boot         = "order=scsi0;ide0;ide1;net0"
  cores        = var.cpus
  memory       = var.ram_mb
  vm_name      = var.proxmox_name
  cpu_type     = "host"
  node         = var.node_name
  proxmox_url  = var.proxmox_url
  username     = var.username
  token        = var.token
  ssh_password = "vagrant"
  ssh_timeout  = "15m"
  ssh_username = "vagrant"
  template_description = "${var.proxmox_name}, generated on ${timestamp()}"
  template_name        = var.proxmox_name
  disks {
    disk_size          = var.disk_size
    storage_pool       = var.storage_pool
    type               = "scsi"
    exclude_from_backup = true
    format             = var.disk_format
  }

  efi_config {
    efi_storage_pool  = var.storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  insecure_skip_tls_verify = true

  boot_iso {
    type             = "ide"
    index            = "0"
    iso_file         = var.iso_file
    iso_checksum     = var.iso_checksum
    iso_storage_pool = var.storage_pool
    unmount          = true
  }

  additional_iso_files {
    type              = "ide"
    index             = "1"
    iso_storage_pool  = var.storage_pool
    cd_files          = ["../http/proxmox/user-data", "../http/proxmox/meta-data"]
    cd_label          = "cidata"
    unmount           = true
  }

  network_adapters {
    bridge   = "vmbr1"
    model    = "virtio"
  }
}

build {
  sources = ["source.proxmox-iso.ubuntu-kickstart"]

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
    ]
  }
}
