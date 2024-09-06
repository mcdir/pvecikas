#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

echo -e "... Info ..."
echo -e "VM_ID $VM_ID"
echo -e "VM_CLONE_ID $VM_CLONE_ID"

echo -e "... Create ..."
qm clone ${VM_ID} ${VM_CLONE_ID} --full --name ${VM_CLONE_NAME} > /dev/null

echo -e "... Setup, copy cloud-init template  to local folder /var/lib/vz/snippets/ ..."
echo -e "... qm set ${VM_CLONE_ID} --cicustom user=local:snippets/${VM_ID}-${OS_DISTR_NAME}${CLOUD_INIT_EXTRA:--}cloud-init.yml"
qm set ${VM_CLONE_ID} --cicustom "user=local:snippets/${VM_ID}-${OS_DISTR_NAME}${CLOUD_INIT_EXTRA:--}cloud-init.yml"
qm set ${VM_CLONE_ID} --ipconfig0 "${VM_IPCONFIG0}"

# run first time, no image provide
if [ -z "$1" ]; then
  echo -e "... skip resize..."
else
  echo -e "... resize vm to ${1}GB..."
  echo -e "... qm resize ${VM_CLONE_ID} scsi0 \"+${1}G\"..."
  sleep 5
  qm resize ${VM_CLONE_ID} scsi0 "+${1}G"
fi

echo -e "Example:"
echo -e "... qm set ${VM_CLONE_ID} --ipconfig0 \"ip=192.168.0.161/24,gw=192.168.0.189\""
#qm start ${VM_CLONE_ID}
echo -e "... qm start ${VM_CLONE_ID}"
