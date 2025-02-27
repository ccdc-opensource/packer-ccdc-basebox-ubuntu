bootcommand = ["<wait>c<wait>set gfxpayload=keep<enter><wait>linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;s=http://10.0.5.127:{{.HTTPPort}}/ ---<enter><wait>initrd /casper/initrd<wait><enter><wait>boot<enter><wait>"]
vmware_guest_os_type = "ubuntu-64"
vsphere_guest_os_type = "ubuntu64Guest"
vsphere_name = "ccdc-basebox-ubuntu-22.04"
output_directory = "output/ubuntu-22.04/"
iso_url = "http://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
box_basename = "ubuntu-22.04"
vagrant_box = "ccdc-basebox/ubuntu-22.04"
disk_size = 30000
cpus = 2
memory = 4096
vmx_remove_ethernet_interfaces = false