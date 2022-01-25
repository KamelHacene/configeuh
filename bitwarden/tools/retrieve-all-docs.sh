#! /bin/bash

source $(dirname ${BASH_SOURCE[0]})/../../bin/tools/bash-common.sh

readonly DATA_DIR="${SCRIPT_DIRECTORY}/../output"
readonly OUT_DIR="${DATA_DIR}/Documents_SRV/"

f_installpackage "util-linux"

! mountpoint -q ${DATA_DIR} && f_fatal "Mount ${DATA_DIR} using mount.sh first"
[ -z "${BW_SESSION}" ] && f_fatal "Run login and unlock, then source BW_SESSION first"

f_notice "Retrieve to ${OUT_DIR}"
mkdir -p ${OUT_DIR}


