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
vmware_guest_os_type = "ubuntu-64"
vsphere_guest_os_type = "ubuntu64Guest"
vsphere_name = "ccdc-basebox-ubuntu-24.04"

output_directory = "output/ubuntu-24.04/"
iso_url = "https://releases.ubuntu.com/noble/ubuntu-24.04.4-live-server-amd64.iso"
iso_checksum = "sha256:e907d92eeec9df64163a7e454cbc8d7755e8ddc7ed42f99dbc80c40f1a138433"
box_basename = "ubuntu-24.04"
vagrant_box = "ccdc-basebox/ubuntu-24.04"
disk_size = 300000
cpus = 2
ram_mb = 4096

