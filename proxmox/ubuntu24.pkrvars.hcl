// vmware settings
  boot_command = [
    "<wait3s>c<wait3s>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
proxmox_name = "ccdc-basebox-ubuntu-24.04"
iso_url = "https://releases.ubuntu.com/noble/ubuntu-24.04.4-live-server-amd64.iso"
iso_checksum = "sha256:e907d92eeec9df64163a7e454cbc8d7755e8ddc7ed42f99dbc80c40f1a138433"
disk_size = 30000
cpus = 2
ram_mb = 4096

