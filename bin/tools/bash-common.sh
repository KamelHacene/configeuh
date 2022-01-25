#! /bin/bash
# =============================================================================
# Title           :
# Description     :
# Author          :
# Version         : 1.0
# Bash_version    :
# Help            :
###############################################################################

if [ "${#BASH_SOURCE[@]}" -le 1 ]; then
  echo "This script must be sourced"
  exit 0
fi

# =============================================================================
#  CONFIGURATION
# =============================================================================
# Note   : This section serves as a configuration file for the following script.
#          It declares used tools and other kind-of constants.
#          The modification of those variables must change the behaviour of
#          the script without harm.
# Syntax : readonly CONSTANT_NAME="VALUE"
# =============================================================================

# -----------------------------------------------------------------------------
# Text syntax
# -----------------------------------------------------------------------------

# Bold
readonly TC_BOLD="\033[1m"

# Colors
readonly TC_STD="\\033[0;39m"
readonly TC_GRE="\\033[1;32m"
readonly TC_RED="\\033[1;31m"
readonly TC_BLU="\\033[1;96m"
readonly TC_WHI="\\033[1;97m"
readonly TC_YEL="\\033[1;33m"

readonly SCRIPT_NAME="$(basename $(realpath ${BASH_SOURCE[-1]}))"
readonly SCRIPT_DIRECTORY="$(dirname $(realpath ${BASH_SOURCE[-1]}))"

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Functional
# -----------------------------------------------------------------------------

# Exitcode: Catchall for general errors
readonly EXIT_OK=0

# Exitcode: Catchall for general errors
readonly EXIT_ERR_DEFAULT=1

# Exitcode: Command not found
readonly EXIT_ERR_EXE=127

# Default exitcode in case of fatal error
readonly DEFAULT_ERROR_EXIT_CODE="${EXIT_ERR_DEFAULT}"

# Global Debug level
readonly DEBUG_LEVEL="0"

# Informations on checked commands displayed if the command does not
# exists
declare -A CHECK_TOOLS_INSTALL_INFO
readonly CHECK_TOOLS_INSTALL_INFO

# =============================================================================
#  GLOBALS (Do not modify)
# =============================================================================
# Note   : This section declares the used globals and their initial values.
#          A modification of this section may cause unexpected behaviour in the
#          execution of the code.
# Syntax :
#          # Global variable
#          g_variable_name="value"
#
#          # Global constant
#          readonly CONSTANT_NAME="value"
#
#          # Later-on initialized constants
#          G_constant_name=""                 # < Initialize empty variable
#          (...)                              #
#          G_constant_name="initialization"   # < Value may change during
#          (...)                              # < a specific part of the code.
#          G_constant_name="otherValue"       # <
#          (...)                              #
#          readonly G_constant_name           # < Variable becomes constant
# =============================================================================

# -----------------------------------------------------------------------------
# Global constants
# -----------------------------------------------------------------------------

COMMON_SCRIPT_NAME="$(basename $(realpath ${BASH_SOURCE[0]}))"
COMMON_SCRIPT_DIRECTORY="$(dirname $(realpath ${BASH_SOURCE[0]}))"
PADDING_STR="| -- "
PADDING_REPLACE="-"

# -----------------------------------------------------------------------------
# Global variables
# -----------------------------------------------------------------------------

# Contains the script exit code in case of failure
g_exitcode="0"

# Padding
g_padding=""

# -----------------------------------------------------------------------------
# Later-on initialized constants
# -----------------------------------------------------------------------------

# Debug level (can be modified during code)
G_debuglevel="0"

# =============================================================================
#  FUNCTIONS
# =============================================================================
# Note   : This section declares local functions.
#          Functions must declare their local variables using the "local"
#          shell directive.
# Syntax : f_myfunctionname()
#          {
#            local l_exitcode="0"
#            local l_functionargument1="$1"
#            local l_functionargument2="$2"
#            local l_localvariablename1="initialvalue"
#            local l_localvariablename2=""
#            readonly local l_localconstantname="initialconstantvalue"
#
#            # Functional here
#            (...)
#
#            return ${l_exitcode}
#          }
# =============================================================================

# -----------------------------------------------------------------------------
#  Tools
# -----------------------------------------------------------------------------

# Display a fatal error message and exit process
f_fatal()
{
  echo -e "${g_padding}${TC_RED}FATAL[${SCRIPT_NAME}:${BASH_LINENO}]: $@${TC_STD}"

  # Set default error exit code
  if [ "${g_exitcode}" = "0" ]; then
    g_exitcode="${DEFAULT_ERROR_EXIT_CODE}"
  fi

  exit ${g_exitcode}
}

# Display an error message
f_error()
{
  echo -e "${g_padding}${TC_RED}ERROR: $@${TC_STD}"
}

# Display a warning message
f_warn()
{
  echo -e "${g_padding}${TC_YEL}WARN: $@${TC_STD}"
}

# Display a notice message
f_notice()
{
  echo -e "${g_padding}${TC_WHI}NOTE: $@${TC_STD}"
}

# Display a debug message
f_debug()
{
  local l_level="$1"
  shift

  # Check if the first value is a number
  if ! [[ ${l_level} =~ ^[0-9]+$ ]] ; then
    f_fatal "The first argument of f_debug must be a number"
  fi

  if [ ${l_level} -le ${DEBUG_LEVEL} ] || [ ${l_level} -le ${G_debuglevel} ]; then
    echo -e "${g_padding}${TC_BLU}DEBUG: $@${TC_STD}"
  fi
}

# Add padding
f_paddup()
{
  g_padding="$(echo -n "${g_padding}" | sed "s/${PADDING_REPLACE}/ /g")${PADDING_STR}"
}

f_paddown()
{
  local l_nr="$(echo -n "${PADDING_STR}" | wc -c)"
  g_padding="$(echo -n "${g_padding}" | sed "s/^.\{${l_nr}\}//")"
}

# -----------------------------------------------------------------------------
#  Init: usage, tools check and argument parsing
# -----------------------------------------------------------------------------

# Display the script's usage
f_usage()
{
    echo -e "\
${TC_BOLD}NAME${TC_STD}
    ${SCRIPT_NAME} - SHORT DESCRIPTION

${TC_BOLD}SYNOPSIS${TC_STD}
    ${SCRIPT_NAME} [OPTIONS] ARGUMENT1 ARGUMENT2

${TC_BOLD}DESCRIPTION${TC_STD}
    LONGER DESCRIPTION

${TC_BOLD}OPTIONS${TC_STD}
    --help|-h            : Print help
    --debug LEVEL        : Set debug level to LEVEL
    "
}

f_checktools()
{
  local l_tools="$@"
  local l_tool=""
  local l_path=""

  for l_tool in ${l_tools}; do
    if l_path=$(command -v ${l_tool}); then
      f_debug 3 "Tool ${l_tool} path: ${l_path}"
    else
      l_info="${CHECK_TOOLS_INSTALL_INFO[${l_tool}]}"
      g_exitcode=${EXIT_ERR_EXE}
      f_fatal "Tool ${l_tool} is required but cannot be found in path. ${l_info}"
    fi
  done
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
      *)
        shift
        ;;
    esac
  done

  readonly G_debuglevel
}

# -----------------------------------------------------------------------------
#  Core functions
# -----------------------------------------------------------------------------

f_insertmodule()
{
  local l_modules="$@"
  local l_module

  for l_module in ${l_modules}; do

    if ! lsmod | grep -q "\b${l_module}\b"; then
      f_notice "Inserting ${l_module}"
      sudo modprobe ${l_module}
      if [ $? -ne 0 ]; then
        f_fatal "Could not insert module ${l_module}"
      fi
    else
      f_debug 1 "Module ${l_module} is already inserted"
    fi
  done
}

# =============================================================================
#  MAIN
# =============================================================================
# Note   : This section contains the script's main call.
# =============================================================================

# Initiate the arguments parsing
[ -n "$@" ] && f_argsParse "$@"

source ${COMMON_SCRIPT_DIRECTORY}/archlinux/pacman.sh

