#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

# @todo: add global help

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Stop test VM
qm-destroy-vm.sh
   -clean-type|--destroy-type [full|clone-only|vm]
EOF
exit 1
fi

echo -e "VM_ID=$VM_ID, VM_CLONE_ID=$VM_CLONE_ID, VM_DESTROY=${VM_DESTROY}, VM_DESTROY_PLAN=${VM_DESTROY_PLAN} "

qm stop $VM_ID
qm destroy $VM_ID
