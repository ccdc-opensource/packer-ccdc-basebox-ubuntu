# Packer Ubuntu base box automation

This repository contains the Packer definitions for building Ubuntu base boxes for both 22.04 and 24.04.
Each image is built with a predefined `vagrant` administrator account and larger default disk sizing to support the build environments used by the team.

The scripts are date-based and produce versioned images in the format `(current date).0`.

## Supported versions

- Ubuntu 22.04: `ubuntu2204.pkrvars.hcl`
- Ubuntu 24.04: `ubuntu24.pkrvars.hcl`

## How do I use this?

You need the following software installed:

- Packer
- VirtualBox for VirtualBox builds
- VMware Fusion / Workstation for VMware builds

Once installed, open a terminal in this repo and run the relevant build script for the version you need:

- `build-virtualbox.sh` for the VirtualBox build flow
- `build-vmware.sh` for the VMware build flow
- `build-vsphere.sh` for the vSphere build flow

## Ubuntu 22.04

The 22.04 definition uses:

- `ubuntu2204.pkrvars.hcl`
- `http/user-data`
- `ubuntu.pkr.hcl` with the 22.04 ISO and VM settings

## Ubuntu 24.04

The 24.04 definition uses:

- `ubuntu24.pkrvars.hcl`
- `http/user-data`
- `ubuntu.pkr.hcl` with the Noble 24.04 ISO and VM settings

## How do I deploy the template to vSphere?

- Copy `vsphere-environment-do-not-add-sample` to `vsphere-environment-do-not-add`
- Add your vSphere login details
- Run `build-vsphere.sh`

## How do I make the boxes available to developers?

To publish an updated box to the Artifactory repository:

1. Retrieve the Artifactory API key from the project repository page.
2. Export it as `ARTIFACTORY_API_KEY`.
3. Run the upload script for the relevant provider.

Example:

  export ARTIFACTORY_API_KEY='key'

Then run the upload scripts for the desired provider(s).

## Where do I begin studying this?

The [documentation on the Bento repository](https://github.com/chef/bento) provides useful guidance for the base image process.
This repository adapts that pattern to our needs, including larger disks and provider-specific builds.

You should be familiar with git submodules and the Packer template workflow.

Why Packer? https://www.packer.io/intro/why.html

Packer documentation: https://www.packer.io/docs/index.html
