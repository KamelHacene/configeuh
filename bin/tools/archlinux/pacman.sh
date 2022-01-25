#! /bin/bash
# =============================================================================
# Title           :
# Description     :
# Author          :
# Version         : 1.0
# Bash_version    :
# Help            :
###############################################################################

f_installpackageaur()
{
  local l_packages="$@"
  local l_package

  for l_package in ${l_packages}; do
    if ! pacman -Qi ${l_package} &>/dev/null; then
      f_warn "Installing package ${l_package} (AUR)"
      pacaur -Sy ${l_package}
      if [ $? -ne 0 ]; then
        f_fatal "Failed to install package.
If error is :
  'failed to verify integrity or prepare (...) package'
Use :
  gpg --recv-keys <key>
"
      fi
    else
      f_debug 1 "Package ${l_package} is already installed"
    fi
  done
}

f_installpackage()
{
  local l_packages="$@"
  local l_package

  for l_package in ${l_packages}; do
    if ! pacman -Qi ${l_package} &>/dev/null; then
      f_notice "Installing package ${l_package}"
      sudo pacman -Sy ${l_package}
      if [ $? -ne 0 ]; then
        f_fatal "Failed to install package. Try to update keyring"
      fi
    else
      f_debug 1 "Package ${l_package} is already installed"
    fi
  done
}

