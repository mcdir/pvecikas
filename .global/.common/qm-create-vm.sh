#!/bin/bash
set -e # exit on first error
source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Clone VM based on cloud image
  -vm-start|--vm-start
  -vm-disk|--vm-disk-plus
  -img-custom|--image-virt-customize-name         IMAGE_VIRT_CUSTOMIZE_NAME
EOF
exit 1
fi

echo -e "... Check, that cloud-init template in local folder /var/lib/vz/snippets/ ..."
./prepare-pve.sh $@
# ...

echo -e "... Create ..."
# Create RAW VM templates, without disk
echo "    qm create ${VM_ID} --name ${VM_NAME} --memory ${VM_MEM} ${VM_SETTINGS}"
qm create ${VM_ID} --name ${VM_NAME} --memory ${VM_MEM} ${VM_SETTINGS}

echo -e "\nqm importdisk disk ..."
echo -e "\nqm importdisk ${VM_ID} ${IMAGE_VIRT_CUSTOMIZE_PATH}${IMAGE_VIRT_CUSTOMIZE_NAME} ${PV_STORAGE_ID}"
qm importdisk ${VM_ID} ${IMAGE_VIRT_CUSTOMIZE_PATH}${IMAGE_VIRT_CUSTOMIZE_NAME} ${PV_STORAGE_ID} > /dev/null

# Attache on exist VM, old syntax is buggy
# unused0:local-lvm:vm-9031-disk-0
if [ "$PV_STORAGE_TYPE" == "lvm" ]; then
  echo "import LVM disk"
  qm set ${VM_ID} --scsihw virtio-scsi-pci --scsi0 ${PV_STORAGE_ID}:vm-${VM_ID}-disk-0 # no RAW in LVM
else
  echo "import RAW disk"
  qm set ${VM_ID} --scsihw virtio-scsi-pci --scsi0 ${PV_STORAGE_ID}:${VM_ID}/vm-${VM_ID}-disk-0.raw # no RAW in LVM
fi

# Connect Cloud-init disk
qm set ${VM_ID} --ide2 ${PV_STORAGE_ID}:cloudinit
# Make boot from scsi0
qm set ${VM_ID} --boot c --bootdisk scsi0
# Set VGA to std
qm set ${VM_ID} --serial0 socket --vga std

#
echo -e "... qm set ${VM_ID} --cicustom user=local:snippets/${CLOUD_INIT_TEMPLATE_NAME}"
qm set ${VM_ID} --cicustom "user=local:snippets/${CLOUD_INIT_TEMPLATE_NAME}"
qm set ${VM_ID} --ipconfig0 "${VM_IPCONFIG0}"

# run first time, no image provide
if [ -z "$VM_DISK_PLUS" ]; then
  echo -e "... skip resize..."
else
  echo -e "... resize vm to ${VM_DISK_PLUS}GB..."
  echo -e "... qm resize ${VM_ID} scsi0 \"+${VM_DISK_PLUS}G\"..."
  sleep 5
  qm resize ${VM_ID} scsi0 "+${VM_DISK_PLUS}G"
fi

echo -e "Example:"
echo -e "... qm set ${VM_ID} --ipconfig0 \"ip=192.168.0.161/24,gw=192.168.0.189\""
echo -e "... qm start ${VM_ID}"
