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
HISTCONTROL=ignoreboth:erasedups
PROMPT_DIRTRIM=2
export EDITOR=/usr/bin/vim

# Put your fun stuff here.
# Fix long line wrapping issues: https://askubuntu.com/questions/111840/ps1-problem-messing-up-cli
#                                https://askubuntu.com/questions/251154/long-lines-overlap-in-bash-ps1-customized-prompt

txtcyn='\[\e[36m\]' #cyan
txtblu='\[\e[34m\]' #blue
txtgrn='\[\e[32m\]' #green
txtwht='\[\e[37m\]' #white
Iblu='\[\e[94m\]' #High Intensity Blu
Icyn='\[\e[96m\]' #High Intensity Cyan
Iwht='\[\e[97m\]' #High Intensity White
reset='\[\e[m\]'

# . ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
# export POWERLINE_CONFIG_COMMAND=$HOME/.vim/bundle/powerline/scripts/powerline-config

if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/development/python
    source /usr/bin/virtualenvwrapper.sh
fi

alias mandom="man \`find /usr/share/man -type f | shuf | head -1\`"
alias mount="mount | column -t"

GP_FILE=~/development/bash/git-prompt.sh
gitprompt='$GP_FILE'

if [[ `tput -T $TERM colors` = 256 ]]; then
    if [ -f "$GP_FILE" ]; then
        export PS1="${Iblu}[${txtcyn}\u${Iblu}@${txtgrn}\h${Icyn} \w${Iblu} ]\$($gitprompt)${Iblu} \\$ ${reset}"
    else
        export PS1="${Iblu}[${txtcyn}\u${Iblu}@${txtgrn}\h${Icyn} \w${Iblu} ] \\$ ${reset}"
    fi
fi

if [[ `lsb_release -i | grep -ioP '(?<=distributor\sid\:\s)(\w*)'` = 'Gentoo' ]]; then
    
    alias nudav="sudo emerge -NuDav @world"
    export NUMCPUS=$(nproc)
    export NUMCPUSPLUSONE=$((NUMCPUS + 1 ))
    export MAKEOPTS="-j${NUMCPUSPLUSONE} -l${NUMCPUS}"
    export EMERGE_DEFAULT_OPTS="--jobs=${NUMCPUSPLUSONE} --load-average=${NUMCPUS}"


fi
