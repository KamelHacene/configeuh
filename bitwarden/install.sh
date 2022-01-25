#! /bin/bash

source $(dirname ${BASH_SOURCE[0]})/../bin/tools/bash-common.sh

SECRET_DIR="${SCRIPT_DIRECTORY}/.secret"
OUTPUT_DIR="${SCRIPT_DIRECTORY}/output"
DEFAULT_SEND="${OUTPUT_DIR}/Documents"

f_installpackage "bitwarden-cli" "ecryptfs-utils"
f_installpackageaur "ecryptfs-simple"

f_notice "Creating ${SCRIPT_DIRECTORY}/.secret "
mkdir -p ${SECRET_DIR}
mkdir -p ${OUTPUT_DIR}

f_notice "Mounting"
${SCRIPT_DIRECTORY}/mount.sh
if [ $? -ne 0 ]; then
  f_fatal "Failed to mount"
fi

f_notice "Install default login.sh"
cp ${SCRIPT_DIRECTORY}/tools/template-login.sh ${OUTPUT_DIR}/login.sh
chmod +x ${OUTPUT_DIR}/login.sh
read -p "Enter client_id : " client_id
read -p "Enter client_secret : " client_secret
sed -i "s/@BW_CLIENTID@/${client_id}/g" ${OUTPUT_DIR}/login.sh
sed -i "s/@BW_CLIENTSECRET@/${client_secret}/g" ${OUTPUT_DIR}/login.sh

f_notice "Default send directory"
mkdir -p ${DEFAULT_SEND}

f_notice "Umount"
${SCRIPT_DIRECTORY}/umount.sh
if [ $? -ne 0 ]; then
  f_warn "Failed to umount"
fi

