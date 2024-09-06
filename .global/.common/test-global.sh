#!/bin/bash

source ../.env.sh "$@"

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
usage: ...\n test;
EOF
exit 1
fi
