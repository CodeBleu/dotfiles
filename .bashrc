#!/bin/bash
# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi
# enable vi mode in bash
set -o vi
# fix issue with ctrl-l not clearing screen in bash vi mode
bind -m vi-insert "\C-l":clear-screen
# If above doesn't work, try
# bind -m vi-command 'Control-l: clear-screen'
# bind -m vi-insert 'Control-l: clear-screen'

HISTCONTROL=ignoreboth:erasedups
export MAKEOPTS="--jobs 2 --load-average 5"
export GOSUMDB="sum.golang.org"
export GOROOT=/usr/lib/go
export GOPATH=~/go
PATH="$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"
PROMPT_DIRTRIM=2
export EDITOR=/usr/bin/vim
GPG_TTY=$(tty)
export GPG_TTY

# https://is.gd/suPdzP
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Put your fun stuff here.
# Fix long line wrapping issues: https://askubuntu.com/questions/111840/ps1-problem-messing-up-cli
#                                https://askubuntu.com/questions/251154/long-lines-overlap-in-bash-ps1-customized-prompt

txtcyn=$'\e[36m' #cyan
txtgrn=$'\e[32m' #green
txtylw=$'\e[33m' #yellow
txtred=$'\e[31m' #red
Iblu=$'\e[94m' #High Intensity Blu
Icyn=$'\e[96m' #High Intensity Cyan
txtdarkgrey=$'\e[90m'
reset=$'\e[m'

# . ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
# export POWERLINE_CONFIG_COMMAND=$HOME/.vim/bundle/powerline/scripts/powerline-config

if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/development/python
    # shellcheck disable=SC1094,SC1091
    source /usr/bin/virtualenvwrapper.sh
fi

if [[ -f /usr/bin/bat ]]; then
    alias cat="/usr/bin/bat --theme 'Solarized (dark)'"
fi


gitPrompt() {

    BASENAME=$(basename "$(pwd)")

    if [[ $BASENAME != '.git' ]]; then
        gitrepo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
    fi

    if [ "$gitrepo" ]; then

        branch="$(git branch -a | awk '/\*/ {print $2 }')"
        stats_ut="$(git status --porcelain 2>/dev/null | grep -c "^??" )"
        stats_fc="$(git diff --stat HEAD 2>/dev/null | tail -n-1 | sed -r 's/[[:alpha:] ()]+//g'| cut -d ',' -f1)"
        stats_fc="${stats_fc:-0}"
        stats_la="$(git diff --stat HEAD 2>/dev/null | tail -n-1 | grep -ioP '(\d+) insertion*' | cut -d ' ' -f1)"
        stats_la="${stats_la:-0}"
        stats_lr="$(git diff --stat HEAD 2>/dev/null | tail -n-1 | grep -ioP '(\d+) deletion*' | cut -d ' ' -f1)"
        stats_lr="${stats_lr:-0}"

        if [[ "${GIT_PROMPT_EMAIL}" != "disable" ]]; then
            domain="$(git config --get user.email)"
        fi

        # shellcheck disable=SC2059
        # If I follow the suggestion of the above SC, it will break PS1 and cause weird wrap arround
        # issues when going up and down in the bash history

        if (( $(tput -T "$TERM" colors) >= 8 )); then
            if [ "$(git status | grep -ic 'clean$')" = 1 ]; then
                printf "\001${reset}\002($branch \001${txtgrn}\002✔\001${reset}\002) \001${txtdarkgrey}\002$domain\001${reset}\002"
            else
                if [ "$(git status | grep -ic 'unstage')" = 1 ]; then
                    printf "\001${reset}\002(${stats_ut}:\001${txtylw}\002$stats_fc\001${reset}\002:\001${txtgrn}\002$stats_la\001${reset}\002:\001${txtred}\002$stats_lr\001${reset}\002 $branch \001${txtylw}\002⬖\001${reset}\002) \001${reset}\002\001${txtdarkgrey}\002$domain\001${reset}\002"
                else
                    printf "\001${reset}\002(${stats_ut}:\001${txtylw}\002$stats_fc\001${reset}\002:\001${txtgrn}\002$stats_la\001${reset}\002:\001${txtred}\002$stats_lr\001${reset}\002 $branch \001${txtred}\002✗\001${reset}\002) \001${reset}\002\001${txtdarkgrey}\002$domain\001${reset}\002"
                fi
            fi
        else
            if [ "$(git status | grep -ic 'clean$')" = 1 ]; then
                echo -en "$domain ($branch)"
            else
                if [ "$(git status | grep -ic 'unstage')" = 1 ]; then
                    echo -en "($stats_ut:$stats_fc:$stats_la:$stats_lr $branch !)"
                else
                    echo -en "($stats_ut:$stats_fc:$stats_la:$stats_lr $branch X)"
                fi
            fi

        fi

    fi
}

if (( $(tput -T "$TERM" colors) >= 8 )); then
    export PS1="⮦\[${Iblu}\][\[${txtcyn}\]\u\[${Iblu}\]@\[${txtgrn}\]\h\[${Icyn}\] \w\[${Iblu}\]]\[${reset}\]\\n⮡\$(gitPrompt)\[${Iblu}\] \\$ \[${reset}\]"
else
    export PS1="[\u@\h \w ]\$(gitPrompt) \\$ "
fi

if [[ $(grep -ioP '(?<=^id=)(\w*)' /etc/os-release) = 'gentoo' ]]; then

    alias nudav="sudo emerge -NuDav @world"
    alias nudavr="sudo emerge -NuDav @world || until sudo emerge --skipfirst; do :; done"
    alias nudv="sudo emerge -NuDv @world || until sudo emerge --resume --skipfirst; do :; done"

fi

alias gitbbd='for branch in `git branch -r | grep -iv head`; do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r'
alias ls='ls --color=auto'
alias k='kubecolor'
complete -o default -F __start_kubectl k
alias kc='kubectx'
complete -F _kube_context kubectx kc
alias kgp='k get pods -A'
alias kgn='k get nodes -A'
alias kgd='k get deployments -A'
alias kgs='k get svc -A'
alias kgr='k get rs -A'
alias kge='k get ev -A'
alias sudo='sudo -E '
alias vim='nvim'
alias mandom="man \`find /usr/share/man -type f | shuf | head -1\`"
alias mount="mount | column -t"

KERNEL=$(uname -a)

if [[ "$KERNEL" =~ "Microsoft" ]]; then

    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
    if [[ "$PATH" =~ "VirtualBox" ]]; then
        :
    else
        export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
    fi
fi

if [[ -f $HOME/.workrelated ]]; then
    #shellcheck disable=SC1091
    source "$HOME/.workrelated"
fi

eval "$(direnv hook bash)"
