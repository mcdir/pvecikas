#!/bin/bash

# ln -s ../../.global/init.sh .
mkdir -p ./.templates ./.envs .images/
touch ./.images/.gitkeep

ln -s ../../.global/.common/prepare-os.sh .
ln -s ../../.global/.common/prepare-pve.sh .

ln -s ../../.global/.common/qm-create-vm.sh .
ln -s ../../.global/.common/qm-clone-vm.sh .

ln -s ../../.global/.common/qm-stop-vm.sh .
ln -s ../../.global/.common/qm-destroy-vm.sh .

# from .envs
cd ./.envs
# envs
ln -s ../../../.global/.env.sh ./.env.sh

echo `pwd`

if [ ! -f ./.env_local.sh ]; then
    echo  "... create .env_local.sh"
    cat ../../../.global/.env_local_example.sh > ./.env_local.sh
else
    echo  "... .env_local_example.sh - file exists"
fi
cd ../

git add .
