#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

#----- celan --------
echo -e "... Info ..."
echo -e "VM_ID $VM_ID"

echo -e "... Create ..."
# ./qm-clone-vm-multi.sh --size 15 --net 1 --start 1 --vm 1 2 3 4

usage(){ echo 'usage: ...'; exit 2; }
while [ "$#" -gt 1 ]; do
        case $1 in
        --size) VM_SIZE=$2; shift 2;;
        --net) VM_SET_DEFAULT_NET=$2; shift 2;;
        --start) VM_START=$2; shift 2;;
        --vm)
                shift
                while [ "$#" -gt 0 ]; do
                        case $1 in
                        --vm*) break;;
                        *) vm+=("$1"); shift;;
                        esac
                done
                ;;
        *) usage ;;
        esac
done
[ "$#" -gt 0 ] && usage

echo "... will increace disk size to +${VM_SIZE}Gb"

for p in "${vm[@]}"; do
    echo "... will create next vm -- ${VM_CLONE_ID}$p"
done
echo "... will vm set default net: ${VM_SET_DEFAULT_NET}"
echo "... will vm start 0/1: ${VM_START}"

#
for VM_CLONE_ID_INC in "${vm[@]}"; do

  echo "${VM_CLONE_ID}${VM_CLONE_ID_INC}"
  qm clone ${VM_ID} "${VM_CLONE_ID}${VM_CLONE_ID_INC}" --full --name ${VM_CLONE_NAME} > /dev/null

  echo -e "... Setup, copy cloud-init template  to local folder /var/lib/vz/snippets/ ..."
  echo -e "... qm set ${VM_CLONE_ID}${VM_CLONE_ID_INC} --cicustom user=local:snippets/${VM_ID}-${OS_DISTR_NAME}${CLOUD_INIT_EXTRA:--}cloud-init.yml"
  qm set ${VM_CLONE_ID}${VM_CLONE_ID_INC} --cicustom "user=local:snippets/${VM_ID}-${OS_DISTR_NAME}${CLOUD_INIT_EXTRA:--}cloud-init.yml"
  qm set ${VM_CLONE_ID}${VM_CLONE_ID_INC} --ipconfig0 "${VM_IPCONFIG0}"

  # run first time, no image provide
  if [ -z "$VM_SIZE" ]; then
    echo -e "... skip resize..."
  else
    echo -e "... resize vm to ${1}GB..."
    echo -e "... qm resize ${VM_CLONE_ID}${VM_CLONE_ID_INC} scsi0 \"+${VM_SIZE}G\"..."
    sleep 5
    qm resize "${VM_CLONE_ID}${VM_CLONE_ID_INC}" scsi0 "+${VM_SIZE}G"
  fi

  #echo -e "... qm set "${VM_CLONE_ID}${VM_CLONE_ID_INC}" --ipconfig0 \"ip=192.168.0.16${VM_CLONE_ID_INC}/24,gw=192.168.0.189\""
  echo -e "... qm set "${VM_CLONE_ID}${VM_CLONE_ID_INC}" --ipconfig0 ${VM_IPCONFIG0}"
  if [ -z "$VM_SET_DEFAULT_NET" ]; then
    echo -e "... skip net default net..."
  else
    #qm set "${VM_CLONE_ID}${VM_CLONE_ID_INC}" --ipconfig0 "ip=192.168.0.16${VM_CLONE_ID_INC}/24,gw=192.168.0.189"
    qm set "${VM_CLONE_ID}${VM_CLONE_ID_INC}" --ipconfig0 "${VM_IPCONFIG0}"
  fi

  echo -e "... qm start "${VM_CLONE_ID}${VM_CLONE_ID_INC}""
  if [ -z "$VM_START" ]; then
    echo -e "...skip start..."
  else
    qm start "${VM_CLONE_ID}${VM_CLONE_ID_INC}"
  fi

done
