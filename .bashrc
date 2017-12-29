#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#==============================================================================
#   BASH
#==============================================================================

# Remove rx rights to any other users by defaults
umask 0077

# Set cursor rate (Arch Linux : Done in xinitrc)
#xset r rate 250 30

# Set vim bindings
#set -o vi

# Disable XON/XOFF (Ctrl+s Ctrl+q)
stty -ixon

#==============================================================================
#   BIND
#==============================================================================

bind '"\C-p":history-search-backward'
bind '"\C-l":clear'

#==============================================================================
#   ALIAS
#==============================================================================

#------------------------------------------------------------------------------
#   Qemu
#------------------------------------------------------------------------------

alias qemukvm='qemu-system-x86_64 -enable-kvm -m 512M'

#------------------------------------------------------------------------------
#   Sway
#------------------------------------------------------------------------------

# Start in azerty
alias sway='export XKB_DEFAULT_LAYOUT=fr-latin9; export XKB_DEFAULT_MODEL=latitude; sway'

#------------------------------------------------------------------------------
#   commands that i always forget
#------------------------------------------------------------------------------
alias camconfig='guvcview'

#------------------------------------------------------------------------------
#   man
#------------------------------------------------------------------------------
mansections()
{
  man -k $1 | grep "^$1\s*("
}

#------------------------------------------------------------------------------
#   rm
#------------------------------------------------------------------------------
saferm()
{
  rmCommand=$@
  correct=$(echo $rmCommand | sed -n -E "s,(\s|^)./, ,gp")

  # Safety check
  if [ ! -z "$correct" ]; then
    echo -e "\033[0;31m SAFE-RM WARNING ! \033[0m Given :"
    echo "# ===== Given"
    echo "$@"
    echo "# ===== Corrected to"
    echo "$correct"
    echo "# ===== What to do ?"
    select yn in "Correct" "Continue" "Stop"; do
      case $yn in
        Correct  ) rmCommand=$correct; break;;
        Continue ) break;;
        Stop ) return 1;;
        esac
    done
  fi

  # Blacklist verification done by safe-rm
  safe-rm $rmCommand
}
#alias rm='saferm'

#------------------------------------------------------------------------------
#   dd
#------------------------------------------------------------------------------
#alias dd='pv'

#------------------------------------------------------------------------------
#   time
#------------------------------------------------------------------------------
alias time='/usr/bin/time'

#------------------------------------------------------------------------------
#   pacman
#------------------------------------------------------------------------------
alias pacman-refreshmirrors='sudo reflector --verbose --latest 20 --sort score --save /etc/pacman.d/mirrorlist'

#------------------------------------------------------------------------------
#   ctags
#------------------------------------------------------------------------------
alias ctags='ctags --langmap=c++:+.ino'

#------------------------------------------------------------------------------
#   cal
#------------------------------------------------------------------------------
alias pal='rem -m -clc+4 -b2'
alias paldyn='wyrd'

#------------------------------------------------------------------------------
#   grep
#------------------------------------------------------------------------------

alias grep='grep --color=auto'
alias grepr='grep -n -R --exclude-dir=.git --exclude-dir=.svn --exclude=cscope.out --exclude=tags --exclude=*.swp'

#------------------------------------------------------------------------------
#   ls
#------------------------------------------------------------------------------

alias ls='ls --color=auto'
alias ll='ls -l'
alias lla='ls -la'
alias lr='ls -1R'
alias lrr='ls -R'
alias l='ls'
alias la='ls -A'
alias sl="sl -ale"

#------------------------------------------------------------------------------
#   vim
#------------------------------------------------------------------------------

alias vim='vim -p'
alias vbash='vim $HOME/.bashrc'
alias vvim='vim $HOME/.vimrc'

#------------------------------------------------------------------------------
#   cd
#------------------------------------------------------------------------------

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

#------------------------------------------------------------------------------
#   graphic
#------------------------------------------------------------------------------

alias nvidia-settings="primusrun nvidia-settings -c :8"

#------------------------------------------------------------------------------
#   wine
#------------------------------------------------------------------------------
alias winecfg32="WINEARCH=win32 WINEPREFIX=~/win32 winecfg"
alias wine32="WINEARCH=win32 WINEPREFIX=~/win32 wine"
alias wine_steam="sudo unshare -n primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"
alias wine_steam_n="primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"

#export WINEDEBUG=warn+all,fixme-all,err+all
export WINEDEBUG=fixme-all,err+all

#------------------------------------------------------------------------------
#   valgrind
#------------------------------------------------------------------------------

#alias valgrind='valgrind --leak-check=full'

#------------------------------------------------------------------------------
#   git
#------------------------------------------------------------------------------

alias gitmodified='git status -uno | sed -n "s/^\s\+modified:\s*//p"'
alias gitdeleted='git status -uno | sed -n "s/^\s\+deleted:\s*//p"'

#------------------------------------------------------------------------------
#   Other/Funny
#------------------------------------------------------------------------------

#alias fortune="fortune -a | cowthink -f $(shuf -n 1 -e $(find /usr/share/cows))"

fortune()
{
  local cowfile=$(shuf -n 1 -e $(find /usr/share/cows))
  /usr/bin/fortune -a | cowthink -f ${cowfile}
}

supermeteo()
{
    curl -4 wttr.in/$1
}
alias meteo=supermeteo

#alias ycm_gen="~/personalwork/github/YCM-Generator/config_gen.py"
#alias tmux="TERM=screen-256color-bce tmux"
#alias tmuxa="tmux attach-session || tmux new-session -s main_session"

#==============================================================================
#   PROMPT
#==============================================================================

PROMPT_DIRTRIM=2
GIT_PS1_SHOWDIRTYSTATE="enable"
GIT_PS1_SHOWSTASHSTATE="enable"
GIT_PS1_SHOWUPSTREAM="auto"

#PS1='[\u@\h \W]\$ '  # Default
source /usr/share/git/completion/git-prompt.sh
PS1=''
PS1+='\[\e[0;32m\]\u\[\e[m\]'
PS1+=' '
PS1+='\[\e[1;34m\]\w\[\e[m\]'
PS1+='$(__git_ps1 ":\[\e[0;33m\]%s")\[\e[m\]'
PS1+='\[\e[0;32m\]$\[\e[m\] '

#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
#PS1="\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]:\[\e[0;33m\] [\u@\h \W$(__git_ps1 " (%s)")]\$ \[\e[1;32m\]\$\[\e[m\] "
#get_git_branch() {
#    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
#}
#get_git_is_stash_in_branch() {
#    git stash list 2> /dev/null | sed -ne "0,/^stash@{[[:digit:]]\+}:\sWIP\son\s$(get_git_branch).*$/s//\/!\\\/p"
#}
#PS1="\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]:\[\e[1;31m\]\$(get_git_is_stash_in_branch)\[\e[m\]:\[\e[0;33m\]\$(get_git_branch)\[\e[1;32m\]\$\[\e[m\] "
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;34m\]'
#PS1='[\u@\h \W]\$ '

#==============================================================================
#   EXPORTS
#==============================================================================

#------------------------------------------------------------------------------
#   Arch Linux
#------------------------------------------------------------------------------

export INPUTRC="$HOME/.config/inputrc"
export EDITOR="vim"
export TERM=xterm-256color
#export TERM=rxvt-unicode

export wiki_browser=firefox # needed by wiki-search command
export VISUAL="vim"         # yaourt PKGBUILD editor
if [ -n "$DISPLAY" ]; then
  export BROWSER=firefox
else
  export BROWSER=links
fi

#------------------------------------------------------------------------------
#   Weechat
#------------------------------------------------------------------------------
export WEECHAT_HOME=$HOME/.config/weechat

#------------------------------------------------------------------------------
#   Chamow scripts
#------------------------------------------------------------------------------

export PATH=~/bin:$PATH   # add to my binaries
export PATH=~/.gem/ruby/2.4.0/bin:$PATH
#------------------------------------------------------------------------------
#   TrampolineOS
#------------------------------------------------------------------------------

export TRAMPOLINE_PATH=$HOME/trampoline/trampoline
export VIPER_PATH=$TRAMPOLINE_PATH/viper
export GOIL_TEMPLATES=$TRAMPOLINE_PATH/goil/templates

#------------------------------------------------------------------------------
#   Lauterbach
#------------------------------------------------------------------------------

#export T32SYS=$HOME/Lautherbach/files
#export T32TMP=$HOME/tmp
#export T32ID=T32
#export ADOBE_PATH=$HOME/fakeadobe
#export ACROBAT_PATH=$HOME/fakeadobe
#export PATH=$PATH:$HOME/Lautherbach/files/bin/pc_linux64

#==============================================================================
#   COMMANDS
#==============================================================================

#command fortune -a | cowthink -f $(shuf -n 1 -e $(find /usr/share/cows))

