#!/bin/zsh

export TERM="xterm-256color"
source $HOME/.antigen.zsh

export EDITOR="/usr/bin/vim"
export POWERLINE_CONFIG_COMMAND=$HOME/.vim/bundle/powerline/scripts/powerline-config

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle vundle
antigen bundle vi-mode
antigen bundle jump
antigen bundle virtualenvwrapper
antigen bundle nojhan/liquidprompt

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# Load the theme.

# antigen theme robbyrussell
# antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
# antigen theme codebleu/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply

# BulletTrain Theme config
BULLETTRAIN_PROMPT_ADD_NEWLINE=false
BULLETTRAIN_PROMPT_SEPARATE_LINE=false
BULLETTRAIN_DIR_BG="cyan"
BULLETTRAIN_DIR_FG="black"
BULLETTRAIN_VIRTUALENV_FG="black"
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
# BULLETTRAIN_GIT_COLORIZE_DIRTY_FG_COLOR="red"
BULLETTRAIN_IS_SSH_CLIENT=true
BULLETTRAIN_TIME_SHOW=false


autoload -U compinit promptinit
compinit
# promptinit; prompt gentoo
zstyle ':completion::complete:*' use-cache 1
bindkey '^R' history-incremental-search-backward

# Set Options
setopt CORRECT

# Set Aliases
alias .="source"

if [ `lsb_release -i | grep -ioP '(?<=distributor\sid\:\s)(\w*)'`='Gentoo' ]; then

    alias nudav="sudo emerge -NuDav world"
fi

#Bind Keys
#
#vi-mode
bindkey -v
