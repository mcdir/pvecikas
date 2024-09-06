#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Stop test VM
qm-stop.sh
EOF
exit 1
fi

echo -e "VM_ID=$VM_ID, VM_CLONE_ID=$VM_CLONE_ID"

qm stop $VM_ID || true
qm stop $VM_CLONE_ID || true
