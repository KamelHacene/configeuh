#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#==============================================================================
#   BIND
#==============================================================================

# vim bindings
set -o vi

bind '"\C-p":history-search-backward'
bind '"\C-l":clear'

#==============================================================================
#   ALIAS
#==============================================================================

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
alias wine_steam="sudo unshare -n primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"
alias wine_steam_n="primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"

#------------------------------------------------------------------------------
#   valgrind
#------------------------------------------------------------------------------

alias valgrind='valgrind --leak-check=full'


#------------------------------------------------------------------------------
#   Other/Funny
#------------------------------------------------------------------------------

alias fortune="fortune -a | cowthink -f $(shuf -n 1 -e $(find /usr/share/cows))"
supermeteo()
{
    curl -4 wttr.in/$1
}
alias meteo=supermeteo

#alias ycm_gen="~/personalwork/github/YCM-Generator/config_gen.py"
#alias tmux="TERM=screen-256color-bce tmux"
#alias tmuxa="tmux attach-session || tmux new-session -s main_session"

#export WINEDEBUG=warn+all,fixme-all,err+all
export WINEDEBUG=fixme-all,err+all

#==============================================================================
#   PROMPT
#==============================================================================

get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

get_git_is_stash_in_branch() {
    git stash list 2> /dev/null | sed -ne "0,/^stash@{[[:digit:]]\+}:\sWIP\son\s$(get_git_branch).*$/s//\/!\\\/p"
}

#PS1='[\u@\h \W]\$ '  # Default
PROMPT_DIRTRIM=5
PS1="\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]:\[\e[1;31m\]\$(get_git_is_stash_in_branch)\[\e[m\]:\[\e[0;33m\]\$(get_git_branch)\[\e[1;32m\]\$\[\e[m\] "
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;34m\]'
#PS1='[\u@\h \W]\$ '

#==============================================================================
#   EXPORTS
#==============================================================================

#------------------------------------------------------------------------------
#   Kernel
#------------------------------------------------------------------------------

export EDITOR="vim"
export TERM=xterm-256color

#------------------------------------------------------------------------------
#   Arch Linux
#------------------------------------------------------------------------------

export wiki_browser=firefox # needed by wiki-search command
export VISUAL="vim"         # yaourt PKGBUILD editor

#------------------------------------------------------------------------------
#   Chamow scripts
#------------------------------------------------------------------------------

export PATH=~/mybin:$PATH   # add to my binaries
#xset r rate 250 30

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


