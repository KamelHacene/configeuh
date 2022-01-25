#! /bin/bash
# =============================================================================
# Title           :
# Description     :
# Author          :
# Version         : 1.0
# Bash_version    :
# Help            :
###############################################################################

# =============================================================================
#  CONFIGURATION
# =============================================================================

source $(dirname ${BASH_SOURCE[0]})/../../bin/tools/bash-common.sh ''

readonly MOUNT_DIR="${SCRIPT_DIRECTORY}/../output"
readonly DEFAULT_DATA_DIR="${SCRIPT_DIRECTORY}/../output/Documents"
readonly DOWNLOAD_DIR="${SCRIPT_DIRECTORY}/../output/Downloads"

G_inputs=""

g_basedir=""
g_folders=""
g_items=""

# =============================================================================
#  FUNCTIONS
# =============================================================================

f_usage()
{
    echo -e "\
${TC_BOLD}NAME${TC_STD}
    ${SCRIPT_NAME} - Send all docs given in parameters to vault

${TC_BOLD}SYNOPSIS${TC_STD}
    ${SCRIPT_NAME} [OPTIONS] SRC1 SRC2 ...

${TC_BOLD}DESCRIPTION${TC_STD}
    LONGER DESCRIPTION

${TC_BOLD}OPTIONS${TC_STD}
    --help|-h            : Print help
    --debug LEVEL        : Set debug level to LEVEL
    "
}

f_argsParse()
{
  while [ $# -gt 0 ]; do
    case $1 in
      --help|-h)
        f_usage
        exit ${EXIT_OK}
        ;;
      --debug)
        G_debuglevel="$2"
        shift 2
        ;;
      -*)
        f_fatal "Invalid parameter '$1'"
        shift 1
        ;;
      *)
        G_inputs="${G_inputs} $1"
        shift 1
        :;
    esac
  done
}

# -----------------------------------------------------------------------------
#  Core functions
# -----------------------------------------------------------------------------

f_sendfile()
{
  local l_item="$1"
  local l_itemremote=""
  local l_itemsha=""
  local l_itemremotesha=""
  local l_name="$(realpath --relative-to=${g_basedir} ${l_item})"
  local l_dir="$(dirname ${l_name})"
  local l_dirid="$(echo "${g_folders}" | jq --raw-output "select(.name==\"${l_dir}\") | .id")"
  local l_itemid=""
  local l_addbool
  local l_read
  local l_attachment
  local l_i

  # Compute item remote
  l_itemremote="$(realpath ${l_item} | sed "s;$(realpath ${g_basedir});${DOWNLOAD_DIR};g")"
  mkdir -p "$(dirname ${l_itemremote})"

  if [ -z "${l_dirid}" ]; then
    f_fatal "No id found for dir ${l_dir}."
  fi

  # Create item
  if [ -z "$(echo "${g_items}" | jq "select(.name==\"${l_name}\")")" ]; then
    # Create file
    f_notice "Send file ${l_name} (dir ${l_dir} ; id ${l_dirid})"
    bw get template item | jq ".name=\"${l_name}\" | .fields=[ {\"name\":\"generatedattachment\", \"value\":\"true\", \"type\":2} ] | .type=2 | .secureNote={type:0} | .folderId=\"${l_dirid}\"" | bw encode | bw create item
    g_items="$(bw list items | jq '.[] | select(.fields==[{"name":"generatedattachment","value":"true","type":2}])')"
  else
    f_debug 1 "File ${l_file} exists"
  fi

  # Get item ID
  echo "${g_items}" > /tmp/plop
  l_itemid="$(echo "${g_items}" | jq --raw-output "select(.name==\"${l_name}\") | .id")"
  if [ $? -ne 0 ] || [ -z "${l_itemid}" ]; then
    f_fatal "Failed to get ID of item ${l_name}"
  fi

  # Loop for each attachments
  l_i=0
  l_addbool=true
  for l_attachment in $(echo "${g_items}" | jq --raw-output "select(.name==\"${l_name}\") | .attachments[].id"); do
    f_debug 2 "Downloading ${l_item} attachment ${l_attachment} to ${l_itemremote}.${l_i}"
    l_i="$((${l_i}+1))"
    f_debug 3 "bw get attachment ${l_attachment} --itemid ${l_itemid} --output ${l_itemremote}.${l_i}"
    bw get attachment ${l_attachment} --itemid ${l_itemid} --output ${l_itemremote}.${l_i} &>/dev/null
    if [ -e "${l_itemremote}.${l_i}" ]; then
      # Compare checksums
      l_itemsha="$(sha512sum ${l_item} | cut -d' ' -f 1)"
      l_itemremotesha="$(sha512sum ${l_itemremote}.${l_i} | cut -d' ' -f 1)"

      if [ "${l_itemsha}" = "${l_itemremotesha}" ]; then
        # Same => ignore
        f_debug 1 "Already available in remote"
        l_addbool=false
        break
      fi
    fi
  done

  if ${l_addbool}; then
    f_notice "Adding attachment ${l_item}"
    bw create attachment --file ${l_item} --itemid ${l_itemid}
  fi
}

f_senddir()
{
  local l_item="$1"
  local l_name="$(realpath --relative-to=${g_basedir} ${l_item})"
  local l_json
  local l_sub

  if [ -z "$(echo "${g_folders}" | jq "select(.name==\"${l_name}\")")" ]; then
    # Create directory
    f_notice "Creating directory ${l_name}"
    bw get template folder | jq ".name=\"${l_name}\"" | bw encode | bw create folder
    if [ $? -ne 0 ]; then
      f_fatal "Failed to create directory ${l_name}"
    fi
    g_folders="$(bw list folders | jq .[])"
  else
    f_notice "Diectory ${l_name}"
  fi

  # Recursive call
  for l_sub in $(find ${l_item} -maxdepth 1 -mindepth 1); do
    f_debug 1 "Rec call for ${l_sub}"
    f_send ${l_sub}
  done
}

f_send()
{
  local l_item="$1"

  f_debug 1 "Sending item ${l_item}"
  f_paddup

  if ! [ -e "${l_item}" ]; then
    f_fatal "File ${l_item} does not exists"
  fi

  if [ -f "${l_item}" ]; then
    f_sendfile "${l_item}"
  elif [ -d "${l_item}" ]; then
    f_senddir "${l_item}"
  else
    f_fatal "Unsupported type for file ${l_item}"
  fi

  f_paddown
}

# =============================================================================
#  MAIN
# =============================================================================
# Note   : This section contains the script's main call.
# =============================================================================

f_installpackage "util-linux"

f_argsParse $@

! mountpoint -q ${MOUNT_DIR} && f_fatal "Mount ${DATA_DIR} using mount.sh first"
[ -z "${BW_SESSION}" ] && f_fatal "Run login and unlock, then source BW_SESSION first"
[ -z "${G_inputs}" ] && G_inputs="${DEFAULT_DATA_DIR}"

g_folders="$(bw list folders | jq .[])"
g_items="$(bw list items | jq '.[] | select(.fields==[{"name":"generatedattachment","value":"true","type":2}])')"

for item in ${G_inputs}; do
  g_basedir="$(dirname ${item})"
  f_send "${item}"
done

