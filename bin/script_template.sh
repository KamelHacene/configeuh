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

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------

# Asciidoc
readonly ASCIIDOC="asciidoctor"
readonly ASCIIDOCPDF="asciidoctor-pdf"

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
CHECK_TOOLS_INSTALL_INFO["${ASCIIDOC}"]="Installation command: sudo apt-get\
  install asciidoctor"
CHECK_TOOLS_INSTALL_INFO["${ASCIIDOCPDF}"]="Installation command: sudo gem\
  install --http-proxy http://PROXYADDR:PROXYPORT asciidoctor-pdf --pre"
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

readonly SCRIPT_NAME="$(basename $0)"
readonly SCRIPT_DIRECTORY="$(dirname $(realpath $0))"

# -----------------------------------------------------------------------------
# Global variables
# -----------------------------------------------------------------------------

# Contains the script exit code in case of failure
g_exitcode="0"

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
  echo -e "${TC_RED}FATAL: $@${TC_STD}"

  # Set default error exit code
  if [ "${g_exitcode}" = "0" ]; then
    g_exitcode="${DEFAULT_ERROR_EXIT_CODE}"
  fi

  exit ${g_exitcode}
}

# Display an error message
f_error()
{
  echo -e "${TC_RED}ERROR: $@${TC_STD}"
}

# Display a warning message
f_warn()
{
  echo -e "${TC_YEL}WARN: $@${TC_STD}"
}

# Display a notice message
f_notice()
{
  echo -e "${TC_BLU}NOTE: $@${TC_STD}"
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
    echo -e "${TC_WHI}DEBUG: $@${TC_STD}"
  fi
}

# Display a green message
f_ok()
{
  echo -e "${TC_GRE}$@${TC_STD}"
}

# Display a red message
f_ko()
{
  echo -e "${TC_RED}$@${TC_STD}"
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
      -*)
        f_fatal "Unsupported operation: $1"
        shift
        ;;
      *)
        f_fatal "Unexpected argument: $1"
        shift
        ;;
    esac
  done

  readonly G_debuglevel
}

# -----------------------------------------------------------------------------
#  Core functions
# -----------------------------------------------------------------------------

# =============================================================================
#  MAIN
# =============================================================================
# Note   : This section contains the script's main call.
# =============================================================================

# Initiate the arguments parsing
f_argsParse "$@"

# Check tools
f_checktools ${ASCIIDOC} ${ASCIIDOCPDF}

exit ${g_exitcode}

