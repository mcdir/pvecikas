#!/bin/bash

source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

cat <<EOF
Run test:
  qm-create-vm.sh with +5GB disk
  qm-start-test-vm.sh with test vm $VM_CLONE_ID
...
EOF

./qm-create-vm.sh 5
./qm-start-test-vm.sh

echo -e "...done"
