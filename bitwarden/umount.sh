#! /bin/bash

source $(dirname ${BASH_SOURCE[0]})/../bin/tools/bash-common.sh

ecryptfs-simple -u ${SCRIPT_DIRECTORY}/output

