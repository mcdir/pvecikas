#!/bin/bash

# current version: 0.0.2
# OS dependent
## OS
export OS_DISTR_NAME="bookworm"

# images
if [[ -z ${IMAGE_NAME} ]]; then
    export IMAGE_NAME="debian-12-generic-amd64-daily.qcow2"
fi

if [[ -z ${IMAGE_URL} ]]; then
    export IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/daily/latest/"
fi

# VM
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

if [[ -z ${VM_MEM} ]]; then
  export VM_MEM=2048
fi

if [[ -z ${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  export CLOUD_INIT_TEMPLATE_NAME="cloud-init-debian-bookworm-default.yml"
fi

if [[ -z ${VM_SETTINGS} ]]; then
  export VM_SETTINGS="--net0 virtio,bridge=vmbr0 --agent enabled=1"
fi

if [[ -z ${VM_IPCONFIG0} ]]; then
  #export VM_IPCONFIG0="ip=dhcp --nameserver=${VM_DNS}"
  export VM_IPCONFIG0="ip=dhcp"
  #@todo ip=192.168.0.16${VM_CLONE_ID_INC}/24
fi

if [[ -z ${VM_DNS} ]]; then
  export VM_DNS="1.1.1.1"
fi

if [[ -z ${VM_DESTROY_TYPE} ]]; then
  export VM_DESTROY_TYPE="vm"
fi

if [[ -z ${SERT_FOLDER_PATH} ]]; then
  export SERT_FOLDER_PATH="./keys/ssl/k8s/xen-home"
fi
