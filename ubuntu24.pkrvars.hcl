// vmware settings
bootcommand = ["<wait>c<wait>set gfxpayload=keep<enter><wait>linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;s={{.HTTPIP}}:{{.HTTPPort}}/ ---<enter><wait>initrd /casper/initrd<wait><enter><wait>boot<enter><wait>"]
vmware_guest_os_type = "ubuntu-64"
vsphere_guest_os_type = "ubuntu64Guest"
vsphere_name = "ccdc-basebox-ubuntu-24.04"

output_directory = "output/ubuntu-24.04/"
iso_url = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
iso_checksum = "sha256:d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
box_basename = "ubuntu-24.04"
vagrant_box = "ccdc-basebox/ubuntu-24.04"
