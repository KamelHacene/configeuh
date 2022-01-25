#! /bin/bash

source $(dirname ${BASH_SOURCE[0]})/../bin/tools/bash-common.sh

export BW_CLIENTID="@BW_CLIENTID@"
export BW_CLIENTSECRET="@BW_CLIENTSECRET@"

bw login --apikey

