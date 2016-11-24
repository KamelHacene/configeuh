#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#======================================
# BINDINGS

# vim bindings
set -o vi

bind '"\C-p":history-search-backward'
bind '"\C-l":clear'

#======================================
# ALIASES

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -l'
alias lla='ls -la'
alias lr='ls -1R'
alias lrr='ls -R'
#alias sl='ls'
alias l='ls'
alias la='ls -A'

alias vim='vim -p'
#alias vi='vim'

alias vbash='vim $HOME/.bashrc'
alias vvim='vim $HOME/.vimrc'


alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sl="sl -ale"
alias fortune="fortune | cowsay"
alias ycm_gen="~/personalwork/github/YCM-Generator/config_gen.py"

#export WINEDEBUG=warn+all,fixme-all,err+all
export WINEDEBUG=fixme-all,err+all
alias wine_steam="sudo unshare -n primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"
alias wine_steam_n="primusrun wine /data/Wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe"

alias nvidia-settings="primusrun nvidia-settings -c :8"

#alias tmux="TERM=screen-256color-bce tmux"
#alias tmuxa="tmux attach-session || tmux new-session -s main_session"

cdl(){
  cd "$@";
  ls ;
}

supermeteo()
{
    curl -4 wttr.in/$1
}

alias meteo=supermeteo
alias evince="echo use zathura"
alias grepr='grep -n -R --exclude-dir=.git --exclude-dir=.svn --exclude=cscope.out --exclude=tags --exclude=*.swp'
alias mouse_middle_click='xdotool click 2'

#======================================
# PROMPT

get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

get_git_is_stash_in_branch() {
    git stash list 2> /dev/null | sed -ne "0,/^stash@{[[:digit:]]\+}:\sWIP\son\s$(get_git_branch).*$/s//\/!\\\/p"
}

# Color prompt
#PS1='[\u@\h \W]\$ '  # Default
PROMPT_DIRTRIM=5
PS1="\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]:\[\e[1;31m\]\$(get_git_is_stash_in_branch)\[\e[m\]:\[\e[0;33m\]\$(get_git_branch)\[\e[1;32m\]\$\[\e[m\] "
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;34m\]'
#PS1='[\u@\h \W]\$ '

#======================================
# EXPORTS

export EDITOR="vim"

export wiki_browser=firefox # needed by wiki-search command
export PATH=~/mybin:$PATH   # add to my binaries
export VISUAL="vim"         # yaourt PKGBUILD editor

##### TRAMPOLINE #####
export TRAMPOLINE_PATH=$HOME/trampoline/trampoline
export VIPER_PATH=$TRAMPOLINE_PATH/viper
export GOIL_TEMPLATES=$TRAMPOLINE_PATH/goil/templates
export COSMIC_PATH=$HOME/mybin/wine/cosmic
export COSMIC_CXPPC="wine $COSMIC_PATH/cxvle.exe"
export COSMIC_CPPPC="wine $COSMIC_PATH/cpvle.exe"
export COSMIC_CAPPC="wine $COSMIC_PATH/cavle.exe"
export COSMIC_CLNK="wine $COSMIC_PATH/clnk.exe"
export COSMIC_CVDWARF="wine $COSMIC_PATH/cvdwarf.exe"
alias cxvle='wine "$COSMIC_PATH/cxvle"'
alias cavle='wine "$COSMIC_PATH/cavle"'
alias clnk='wine "$COSMIC_PATH/clnk"'
alias cvdwarf='wine "$COSMIC_PATH/cvdwarf"'
#cxppc -l +debug +modv +rev -co. -i.. bam.c main.c timer.c mmu.c swt.c vec56el.c
#cappc -l -dVLE crtsiz4.s
#clnk -o xpc56el.ppc -m xpc56el.map xpc56el.lkf 
#cvdwarf xpc56el.ppc

export TERM=xterm-256color
#xset r rate 250 30

export T32SYS=$HOME/Lautherbach/files
export T32TMP=$HOME/tmp
export T32ID=T32

export ADOBE_PATH=$HOME/fakeadobe
export ACROBAT_PATH=$HOME/fakeadobe

export PATH=$PATH:$HOME/Lautherbach/files/bin/pc_linux64


