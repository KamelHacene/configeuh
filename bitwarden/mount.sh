#! /bin/bash

source $(dirname ${BASH_SOURCE[0]})/../bin/tools/bash-common.sh

readonly SCRIPT_NAME="$(basename $(realpath ${BASH_SOURCE[0]}))"
readonly SCRIPT_DIRECTORY="$(dirname $(realpath ${BASH_SOURCE[0]}))"

f_insertmodule "ecryptfs"

ecryptfs-simple -a ${SCRIPT_DIRECTORY}/.secret ${SCRIPT_DIRECTORY}/output
