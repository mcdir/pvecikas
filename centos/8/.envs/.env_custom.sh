#!/bin/bash

# current version: 0.0.5
## OS dependent
export OS_DISTR_NAME="8"

## images
if [[ -z ${IMAGE_NAME} ]]; then
    export IMAGE_NAME="CentOS-8-x86_64-GenericCloud-2211.qcow2"
fi

if [[ -z ${IMAGE_URL} ]]; then
    export IMAGE_URL="https://cloud.centos.org/centos/8/images/"
fi

## VM
if [[ -z ${VM_NAME} ]]; then
    export VM_NAME="centos-8-test"
fi

if [[ -z ${VM_ID} ]]; then
    export VM_ID=9740
fi

if [[ -z ${VM_CLONE_ID} ]]; then
  export VM_CLONE_ID=2040
fi

if [[ -z ${VM_CLONE_NAME} ]]; then
  export VM_CLONE_NAME="centos-8-clone"
fi

if [[ -z ${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  export CLOUD_INIT_TEMPLATE_NAME="cloud-init-centos-8-default.yml"
fi

### VM resource
if [[ -z ${VM_MEM} ]]; then
  export VM_MEM=2048
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

## full , clone-only, vm
if [[ -z ${VM_DESTROY_PLAN} ]]; then
  export VM_DESTROY_PLAN="vm"
fi

if [[ -z ${CERTIFICATE_FOLDER_PATH} ]]; then
  export CERTIFICATE_FOLDER_PATH="./keys/ssl/"
fi
