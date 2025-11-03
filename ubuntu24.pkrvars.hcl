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
iso_url = "https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.iso"
iso_checksum = "sha256:c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
box_basename = "ubuntu-24.04"
vagrant_box = "ccdc-basebox/ubuntu-24.04"
