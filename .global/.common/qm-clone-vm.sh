#!/bin/bash
set -e # exit on first error
source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
usage: ...\n ./qm-clone-vm.sh --size 15 --net 1 --start 1';
EOF
exit 1
fi

echo -e "... Check, that cloud-init template in local folder, like /var/lib/vz/snippets/ and exist of the file"
./prepare-pve.sh $@

echo -e "... clone VM ${VM_ID} to VM_CLONE_ID ${VM_CLONE_ID}"
if [ ! -z "${DISPLAY_DEBUG}" ]; then
  echo -e "... qm clone ${VM_ID} ${VM_CLONE_ID} --full --name ${VM_CLONE_NAME}"
  qm clone "${VM_ID}" "${VM_CLONE_ID}" --full --name ${VM_CLONE_NAME}
else
  echo -e "... qm clone ${VM_ID} ${VM_CLONE_ID} --full --name ${VM_CLONE_NAME} > /dev/null"
  qm clone "${VM_ID}" "${VM_CLONE_ID}" --full --name ${VM_CLONE_NAME} > /dev/null
fi

echo -e "... qm set ${VM_ID} --cicustom user=local:snippets/${CLOUD_INIT_TEMPLATE_NAME}"
qm set ${VM_ID} --cicustom "user=local:snippets/${CLOUD_INIT_TEMPLATE_NAME}"
qm set ${VM_ID} --ipconfig0 "${VM_IPCONFIG0}"

if [ -z "$VM_DISK_PLUS" ]; then
  echo -e "... skip resize..."
else
  echo -e "... resize vm to ${VM_DISK_PLUS}GB..."
  echo -e "... qm resize ${VM_ID} scsi0 \"+${VM_DISK_PLUS}G\"..."
  sleep 5
  qm resize ${VM_ID} scsi0 "+${VM_DISK_PLUS}G"
fi

if [ -z "$VM_KEEP_DEFAULT_NET" ]; then
  qm set "${VM_CLONE_ID}" --ipconfig0 "${VM_IPCONFIG0}"
else
  echo -e "... skip set default net"
fi

echo -e "... qm start ${VM_CLONE_ID} (VM_START is $VM_START)"

if [ -z $VM_START ]; then
  echo -e "...skip start..."
else
  qm start "${VM_CLONE_ID}"
fi
