packer {
  required_version = ">= 1.7.0"
  required_plugins {
    ansible = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/ansible"
    }
    vsphere = {
      version = ">= 2.4.0"
      source: "github.com/vmware/vsphere"
    }
  }
}

locals {
  http_directory  = "${path.root}/http"
}



source "vsphere-iso" "ubuntu" {
  boot_command         = var.boot_command
  vcenter_server       = var.vmware_center_host
  host                 = var.vmware_center_esxi_host
  username             = "${var.vmware_center_username}"
  password             = "${var.vmware_center_password}"
  insecure_connection  = false
  datacenter           = var.vmware_center_datacenter
  datastore            = var.vmware_center_datastore
  cluster              = var.vmware_center_cluster_name
  http_port_max        = 65535
  http_port_min        = 49152
  cd_files = [
    "./http/meta-data",
    "./http/user-data"]
  cd_label = "cidata"
  convert_to_template  = true
  CPUs                 = var.cpus
  disk_controller_type = ["pvscsi"]
  storage {
      disk_size = "${var.disk_size}"
      disk_thin_provisioned = true
  }
  guest_os_type        = "ubuntu64Guest"
  http_directory       = "${local.http_directory}"
  iso_checksum         = var.iso_checksum
  iso_url              = var.iso_url
  RAM                  = var.ram_mb
  shutdown_command     = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password         = "vagrant"
  ssh_port             = 22
  ssh_timeout          = "10000s"
  ssh_username         = "vagrant"
  vm_name              = var.vmware_center_vm_name
  network_adapters {
      network = "${var.vmware_center_vm_network}"
      network_card = "vmxnet3"
  }
}


# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = [
    "source.vsphere-iso.ubuntu"
  ]


  provisioner "ansible" {
    playbook_file = "${var.ansible_playbook_file}"
    galaxy_file = "${var.ansible_requirements_file}"
    roles_path = "${var.ansible_roles_path}"
    galaxy_force_install = true
    user            = "vagrant"
    use_proxy       = false
    extra_arguments = [
      "-v",
      "-e", "ansible_ssh_password=vagrant"
    ]
  }

  post-processors {

    post-processor "vagrant" {
      except = ["vsphere-iso.ubuntu"]
      output = "${var.output_directory}/${ var.vagrant_box }.${ replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop") }.box"
    }

    # Once box has been created, upload it to Artifactory
    post-processor "shell-local" {
      except = ["vsphere-iso.ubuntu"]
      command = join(" ", [
        "jf rt upload",
        "--target-props \"box_name=${ var.vagrant_box };box_provider=${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")};box_version=${ formatdate("YYYYMMDD", timestamp()) }.0\"",
        "--retries 10",
        "--access-token ${ var.artifactory_api_key }",
        "--user ${ var.artifactory_username }",
        "--url \"https://artifactory.ccdc.cam.ac.uk/artifactory\"",
        "${var.output_directory}/${var.vagrant_box}.${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")}.box",
        "ccdc-vagrant-repo/${var.vagrant_box}.${formatdate("YYYYMMDD", timestamp())}.0.${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")}.box"
      ])
    }
  }
}
