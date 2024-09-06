#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Stop test VM
qm-destroy-vm.sh
   -clean-type|--destroy-type [full|clone-only|vm]
EOF
exit 1
fi

echo -e "VM_ID=$VM_ID, VM_CLONE_ID=$VM_CLONE_ID, VM_DESTROY=${VM_DESTROY}, VM_DESTROY_TYPE=${VM_DESTROY_TYPE} "

qm stop $VM_ID
qm destroy $VM_ID
