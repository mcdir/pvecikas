#!/bin/bash

# current version: 0.0.6
## OS dependent
export OS_DISTR_NAME="bookworm"

## images
if [[ -z ${IMAGE_NAME} ]]; then
    export IMAGE_NAME="debian-12-generic-amd64-daily.qcow2"
fi

if [[ -z ${IMAGE_URL} ]]; then
    export IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/daily/latest/"
fi

## VM
if [[ -z ${VM_NAME} ]]; then
    export VM_NAME="debian-bookworm-test"
fi

if [[ -z ${VM_ID} ]]; then
    export VM_ID=9823
fi

if [[ -z ${VM_CLONE_ID} ]]; then
  export VM_CLONE_ID=2123
fi

if [[ -z ${VM_CLONE_NAME} ]]; then
  export VM_CLONE_NAME="debian-bookworm-clone"
fi

if [[ -z ${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  export CLOUD_INIT_TEMPLATE_NAME="cloud-init-debian-bookworm-default.yml"
fi

### VM resource
if [[ -z ${VM_MEM} ]]; then
  export VM_MEM=2048
fi

if [[ -z ${VM_SETTINGS} ]]; then
  export VM_SETTINGS="--net0 virtio,bridge=vmbr0 --agent enabled=1"
fi

if [[ -z ${VM_IPCONFIG0} ]]; then
  export VM_IPCONFIG0="ip=dhcp"
fi

if [[ -z ${VM_DNS} ]]; then
  export VM_DNS="1.1.1.1"
fi

## full , clone-only, vm
if [[ -z ${VM_DESTROY_PLAN} ]]; then
  export VM_DESTROY_PLAN="vm"
fi

if [[ -z ${CERTIFICATE_FROM_FOLDER_PATH} ]]; then
  export CERTIFICATE_FROM_FOLDER_PATH="/usr/share/ca-certificates/self/"
fi
