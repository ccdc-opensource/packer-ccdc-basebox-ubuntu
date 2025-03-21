#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

# if [[ -f /proc/version ]] && [[ "$( grep Microsoft /proc/version )" ]]; then
#   PACKER="packer.exe"
# else
  PACKER="packer"
# fi

if [[ ! -e ./vsphere-environment-do-not-add ]]
then
  echo "Please add a vsphere-environment-do-not-add file to set up the environment variables required to deploy"
  echo "These vary based on the target VMWare server. The list can be found at the bottom of the packer template."
  return 1
fi
source ./vsphere-environment-do-not-add

echo 'creating output directory'
mkdir -p output
rm -rf ./output/packer-ubuntu-22.04-amd64-vmware

echo 'building base images'
$PACKER build \
  -except=vagrant \
  -var-file=ubuntu2204.pkrvars.hcl \
  .

