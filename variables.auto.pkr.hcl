variable "vagrant_box" { type = string }
variable "output_directory" { type = string }
variable "iso_url" { type = string }
variable "iso_checksum" { type = string }

// Ansible provisioning settings
variable "artifactory_api_key" {
  type = string
  default = env("ARTIFACTORY_API_KEY")
}
variable "artifactory_username" {
  type = string
  default =  env("USER")
}
variable "user_password" {
  type = string
  default = "vagrant"
}
variable "user_username" {
  type = string
  default = "vagrant"
}

// Basic hardware specs
variable "cpus" {
  type = number
  default =  "2"
}
variable "ram_mb" {
  type = number
  default =  4096
}
variable "disk_size" {
  type = string
  default =  "500000"
}

variable "boot_command" {}

variable "headless" {
  type    = bool
  default = false
}

// VSphere settings
variable "vmware_center_cluster_name" {
  type    = string
  default = "${env("VMWARECENTER_CLUSTER_NAME")}"
}
variable "vmware_center_datacenter" {
  type    = string
  default = "${env("VMWARECENTER_DATACENTER")}"
}
variable "vmware_center_datastore" {
  type    = string
  default = "${env("VMWARECENTER_DATASTORE")}"
}
variable "vmware_center_esxi_host" {
  type    = string
  default = "${env("VMWARECENTER_ESXI_HOST")}"
}
variable "vmware_center_host" {
  type    = string
  default = "${env("VMWARECENTER_HOST")}"
}
variable "vmware_center_password" {
  type      = string
  default   = env("VMWARECENTER_PASSWORD")
  sensitive = true
}
variable "vmware_center_username" {
  type    = string
  default = env("VMWARECENTER_USERNAME")
}
variable "vmware_center_vm_folder" {
  type    = string
  default = "${env("VMWARECENTER_VM_FOLDER")}"
}
variable "vmware_center_vm_name" {
  type    = string
  default = "${env("VMWARECENTER_VM_NAME")}"
}
variable "vmware_center_vm_network" {
  type    = string
  default = "${env("VMWARECENTER_VM_NETWORK")}"
}

// Hyper-V settings
variable "hyperv_generation" {
  type    = string
  default = "2"
}
variable "hyperv_switch" {
  type    = string
  default = "${env("hyperv_switch")}"
}

variable "preseed_path" {
  type    = string
  default = "autoinstall.yaml"
}
variable "vagrant_user_final_password" {
  type      = string
  default   = "${env("VAGRANT_USER_FINAL_PASSWORD")}"
  sensitive = true
}
variable "port_min" {
  type    = number
  default = 49152
}

variable "port_max" {
  type    = number
  default = 65535
}

variable "ipaddress" {
  type    = string
  default = "{{ .HTTPIP }}"
}
variable "ansible_playbook_file" {
  type    = string
  default = "ansible_provisioning/playbook.yaml"
}
variable "ansible_requirements_file" {
  type    = string
  default = "ansible_provisioning/requirements.yaml"
}
variable "ansible_roles_path" {
  type    = string
  default = "ansible_provisioning/roles"
}