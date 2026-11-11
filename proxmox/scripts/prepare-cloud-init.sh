#!/usr/bin/env bash
set -euo pipefail

# Discard installer networking so each clone uses its Proxmox cloud-init drive.
rm -f /etc/cloud/cloud-init.disabled \
  /etc/cloud/cloud.cfg.d/99-installer.cfg \
  /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg \
  /etc/netplan/00-installer-config.yaml \
  /etc/netplan/50-cloud-init.yaml

install -m 0644 /dev/stdin /etc/cloud/cloud.cfg.d/99-packer-cloud-init.cfg <<'EOF'
datasource_list: [NoCloud, ConfigDrive, None]
preserve_hostname: false
EOF

systemctl enable qemu-guest-agent.service

# Leave instance initialization and machine identity to the clone's first boot.
cloud-init clean --logs --seed --machine-id
