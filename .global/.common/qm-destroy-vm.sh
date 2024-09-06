#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Destroy test VM
qm-destroy-vm.sh
   -clean-type|--destroy-type [full|clone-only|vm]
EOF
exit 1
fi

echo -e "VM_ID=$VM_ID, VM_CLONE_ID=$VM_CLONE_ID, VM_DESTROY=${VM_DESTROY}, VM_DESTROY_TYPE=${VM_DESTROY_TYPE} "

# full , clone-only, vm
if [ "${VM_DESTROY_TYPE}" == "vm" ]; then
  echo -e "... qm stop $VM_ID "
  qm stop $VM_ID || true
  echo "clean up vm"
  qm destroy $VM_ID --destroy-unreferenced-disks 1 --purge 1
fi

if [ "${VM_DESTROY_TYPE}" == "clone-only" ]; then
  echo -e "... qm stop $VM_CLONE_ID"
  qm stop $VM_CLONE_ID || true
  echo "clean up clone"
  echo "... qm destroy $VM_CLONE_ID --destroy-unreferenced-disks 1 --purge 1"
  qm destroy $VM_CLONE_ID --destroy-unreferenced-disks 1 --purge 1
fi

if [ "${VM_DESTROY_TYPE}" == "full" ]; then
  echo -e "... qm stop $VM_ID "
  qm stop $VM_ID || true
  echo -e "... qm stop $VM_CLONE_ID"
  qm stop $VM_CLONE_ID || true

  echo "Full clean up"
  echo "... qm destroy $VM_CLONE_ID --destroy-unreferenced-disks 1 --purge 1"
  qm destroy $VM_CLONE_ID --destroy-unreferenced-disks 1 --purge 1

  echo "... qm destroy $VM_ID --destroy-unreferenced-disks 1 --purge 1"
  qm destroy $VM_ID --destroy-unreferenced-disks 1 --purge 1
fi
