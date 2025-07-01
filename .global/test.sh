#!/bin/bash

source ./.env.sh "$@"

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Prepare os
- install dependents
EOF
fi