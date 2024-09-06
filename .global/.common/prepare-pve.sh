#!/bin/bash
set -e # exit on first error
source ./.envs/.env.sh $@

if [ ! -z "${DISPLAY_DEBUG}" ]; then
  debug_cf
fi

if [ ! -z "${DISPLAY_USAGE}" ]; then
cat << EOF
Prepare pve
- check vm
- check templates

  -ca|--copy-all)
    PV_TEMPLATES_COPY_ALL="all"

  -cf-name|--cloud-init-template-name      : set env  CLOUD_INIT_TEMPLATE_NAME
  -img-base|--image-virt-base-name         : set env  IMAGE_NAME
  -img-custom|--image-virt-customize-name  : set env  IMAGE_VIRT_CUSTOMIZE_NAME

EOF
exit 1
fi

if [[ -z ${PV_TEMPLATES_COPY_ALL} ]]; then
    export PV_TEMPLATES_COPY_ALL=""
fi

echo "Prepare pve:"
echo "  CLOUD_INIT_TEMPLATE_NAME    = ${CLOUD_INIT_TEMPLATE_NAME}"
echo "  PV_TEMPLATES_COPY_ALL       = ${PV_TEMPLATES_COPY_ALL}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

if [[ ${PV_TEMPLATES_COPY_ALL} == "all" ]]; then
    echo -e "\nCopy all templates from folder"
    cp -f ./.templates/*.yml "${PV_STORAGE_SNIPPETS_PATH}"
    exit 0
fi

echo -e "\nCopy templates to local ${PV_STORAGE_SNIPPETS_PATH} ..."

# check
if [[ -z ${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  echo -e "\nPlease set CLOUD_INIT_TEMPLATE_NAME via -cf-name|--cloud-init-template-name options\n\n"
  exit 1
fi

if [[ ! -f ./.templates/${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  echo -e "\nTemplates ./.templates/${CLOUD_INIT_TEMPLATE_NAME} not exists"
  exit 1
fi

if [[ ! -f ${PV_STORAGE_SNIPPETS_PATH}${CLOUD_INIT_TEMPLATE_NAME} ]]; then
  cp ./.templates/${CLOUD_INIT_TEMPLATE_NAME} /var/lib/vz/snippets/
else
  echo -e "\nCLOUD_INIT_TEMPLATE_NAME is: [${CLOUD_INIT_TEMPLATE_NAME}], ${PV_STORAGE_SNIPPETS_PATH}${CLOUD_INIT_TEMPLATE_NAME} - exit ..."
  exit 0
fi
