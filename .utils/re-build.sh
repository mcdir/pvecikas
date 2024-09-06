#!/bin/bash

BASE_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

python3 "$BASE_PATH/prepare.py"
python3 cloud-init-default-gen.py
python3 env-custom-gen.py
python3 prepare-virt-customize-gen.py
