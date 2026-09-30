packer {
  required_version = ">= 1.7.0"

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
  cores        = var.cpus
  memory       = var.ram_mb
  cpu_type     = "host"

  disks {
    disk_size         = var.disk_size
    storage_pool      = var.storage_pool
    storage_pool_type = "lvm"
    type              = "scsi"
  }

  efi_config {
    efi_storage_pool  = "local-lvm"
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  http_directory           = "../http"
  insecure_skip_tls_verify = true

  iso {
    iso_url      = var.iso_url
    iso_checksum = var.iso_checksum
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  node = var.node_name

  password    = var.password
  proxmox_url = var.proxmox_url
  username    = var.username

  ssh_password = var.password
  ssh_timeout  = "15m"
  ssh_username = "vagrant"

  template_description = "${var.proxmox_name}, generated on ${timestamp()}"
  template_name        = var.proxmox_name
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
