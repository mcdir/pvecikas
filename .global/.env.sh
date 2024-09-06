#!/bin/bash

#----- celan --------
## https://stackoverflow.com/questions/14700579/bash-converting-string-to-boolean-variable
function boolean() {
  case $1 in
    1) echo true ;;
    0) echo false ;;
    *) echo "Err: Unknown boolean value \"$1\"" 1>&2; exit 1 ;;
   esac
}

debug_cf(){
  if [[ -z ${DEBUG_CF_DISPLAYED} ]]; then
    echo "envs"
    echo "  VM_ID            = ${VM_ID}"
    echo "  OS_DISTR_NAME    = ${OS_DISTR_NAME}"

    echo " Images:"
    echo "  IMAGE_NAME                  = ${IMAGE_NAME}"
    echo "  IMAGE_URL                   = ${IMAGE_URL}"
    echo "  IMAGE_VIRT_CUSTOMIZE_NAME   = ${IMAGE_VIRT_CUSTOMIZE_NAME}"
    echo "  IMAGE_VIRT_CUSTOMIZE_PATH   = ${IMAGE_VIRT_CUSTOMIZE_PATH}"

    echo " PV local"
    echo "  PV_STORAGE_SNIPPETS_PATH    = ${PV_STORAGE_SNIPPETS_PATH}"
    echo "  PV_STORAGE_ID               = ${PV_STORAGE_ID}"
    echo "  PV_STORAGE_TYPE             = ${PV_STORAGE_TYPE}"

    echo " VM params:"
    echo "  VM_NAME                     = ${VM_NAME}"
    echo "  VM_CLONE_NAME               = ${VM_CLONE_NAME}"
    echo "  VM_ID                       = ${VM_ID}"
    echo "  VM_CLONE_ID                 = ${VM_CLONE_ID}"
    echo "  VM_MEM                      = ${VM_MEM}"
    echo "  VM_DISK_PLUS                = ${VM_DISK_PLUS}"
    echo "  VM_SETTINGS                 = ${VM_SETTINGS}"
    echo "  VM_DNS                      = ${VM_DNS}"
    echo "  VM_KEEP_DEFAULT_NET         = ${VM_KEEP_DEFAULT_NET}"
    echo "  VM_IPCONFIG0                = ${VM_IPCONFIG0}"
    echo "  CLOUD_INIT_TEMPLATE_NAME    = ${CLOUD_INIT_TEMPLATE_NAME}"
    echo "  VM_START                    = ${VM_START}"

    echo " Cloud init extra:"
    echo "  CLOUD_INIT_EXTRA            = ${CLOUD_INIT_EXTRA}"
    echo "  SERT_FOLDER_PATH            = ${SERT_FOLDER_PATH}"

    echo " Prepare:"
    echo "  PV_TEMPLATES_COPY_ALL       = ${PV_TEMPLATES_COPY_ALL}"

    # rename base image
    export DEBUG_CF_DISPLAYED="true"
  fi

  echo "___________________________________________________________________________________________________"
}


POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--debug)
      DISPLAY_DEBUG="true"
      shift # past argument
      # shift # past value
      ;;
    -ca|--copy-all)
      PV_TEMPLATES_COPY_ALL="all"
      shift # past argument
      ;;
    #
    -vm|--vm-name)
      VM_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-id|--vm-id)
      VM_ID="$2"
      shift # past argument
      shift # past value
      ;;
    -vm|--vm-clone-name)
      VM_CLONE_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-clone-id|--vm-clone-id)
      VM_CLONE_ID="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-mem|--vm-memory)
      VM_MEM="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-set|--vm-settings)
      VM_SETTINGS="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-keep-net|--vm-keep-network-setting)
      VM_KEEP_DEFAULT_NET="true"
      shift # past argument
      ;;
    -vm-dns|--vm-dns)
      VM_DNS="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-disk|--vm-disk-plus)
      VM_DISK_PLUS="$2"
      shift # past argument
      shift # past value
      ;;
    -vm-start|--vm-start)
      VM_START="true"
      shift # past argument
      ;;
    #
    -clean|--destroy-vm)
      VM_DESTROY="true"
      shift # past argument
      shift # past value
      ;;
    -clean-clone|--destroy-vm-clone)
      VM_DESTROY_CLONE="true"
      shift # past argument
      shift # past value
      ;;
    # full , clone-only, vm
    -clean-type|--destroy-type)
      VM_DESTROY_TYPE="$2" # default vm
      shift # past argument
      shift # past value
      ;;
    -cf-name|--cloud-init-template-name)
      CLOUD_INIT_TEMPLATE_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -img-base|--image-virt-base-name)
      IMAGE_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -img-custom|--image-virt-customize-name)
      IMAGE_VIRT_CUSTOMIZE_NAME="$2"
      shift # past argument
      shift # past value
      ;;
#    -*|--*)
#      echo "Unknown option $1"
#      exit 1
#      ;;
    -help|--help)
       DISPLAY_USAGE="true"
      shift # past argument
      ;;
#    -*|--*)
#      echo "Unknown option $1"
#      exit 1
#      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# local envs, secret path, etc.
if [  -f .envs/.env_local.sh ]; then
    source  .envs/.env_local.sh "$@"
else
    echo  "... .env_local.sh file  NOT exists"
fi

# custom envs, OS related
if [  -f .envs/.env_custom.sh ]; then
    source  .envs/.env_custom.sh "$@"
else
    echo  "... .env_custom.sh file  NOT exists"
fi

# init after OS vars
if [[ -z ${IMAGE_VIRT_CUSTOMIZE_PATH} ]]; then
  export IMAGE_VIRT_CUSTOMIZE_PATH="./.images/"
fi

if [[ -z ${IMAGE_VIRT_CUSTOMIZE_NAME} ]]; then
  # rename base image
  export IMAGE_VIRT_CUSTOMIZE_NAME=`echo "${IMAGE_NAME}" | sed -e "s/\.img/-custom.img/g" | sed -e "s/\.qcow2/-custom.qcow2/g"`
fi

# pve var
if [[ -z ${PV_STORAGE_SNIPPETS_PATH} ]]; then
  export PV_STORAGE_SNIPPETS_PATH="/var/lib/vz/snippets/"
fi
