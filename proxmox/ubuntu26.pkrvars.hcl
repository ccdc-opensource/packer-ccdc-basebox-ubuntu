# Packer variables for building Ubuntu 26.04 basebox on Proxmox (replace the placeholders with your actual Proxmox configuration)
boot_command = [
  "<wait3s>c<wait3s>",
  "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
  "<enter><wait>",
  "initrd /casper/initrd",
  "<enter><wait>",
  "boot",
  "<enter>"
]

proxmox_name = "ccdc-basebox-ubuntu-26.04"
node_name = ""
proxmox_url = ""
storage_pool = ""
iso_file = ""
iso_url = "https://releases.ubuntu.com/resolute/ubuntu-26.04.1-live-server-amd64.iso"
additional_iso_storage_pool = ""
iso_checksum = "sha256:cc8a95cde20f6ced61a322420de00f10cc3c90ced545daa46cb9c1a117f1d927"
disk_size = "30G"
cpus = 2
ram_mb = 4096
bridge = ""
vlan_tag = ""
model = ""
disk_format = "qcow2"
username = ""
ansible_playbook_file = "../ansible_provisioning/playbook.yaml"
ansible_requirements_file = "../ansible_provisioning/requirements.yaml"
ansible_roles_path = "../ansible_provisioning/roles"
