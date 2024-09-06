#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Prepare os
- install dependens
EOF
fi

echo "prepare-pve:"
echo "  CLOUD_INIT_TEMPLATE_NAME    = ${CLOUD_INIT_TEMPLATE_NAME}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# prepare, install libguestfs-tools
if dpkg -l | grep libguestfs-tools; then
  echo "libguestfs-tools exists..."
else
  echo not found
  # All commands will be executed on a Proxmox host !!!
  sudo apt update -y && sudo apt install libguestfs-tools -y
fi
if dpkg -l | grep wget; then
  echo "wget exists..."
else
  echo "not found"
  # All commands will be executed on a Proxmox host !!!
  sudo apt update -y && sudo apt install wget -y
fi
