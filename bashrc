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

PROMPT_DIRTRIM=2

# Put your fun stuff here.

txtcyn='\e[0;36m' #cyan
txtblu='\e[0;34m' #blue
txtgrn='\e[0;32m' #green
txtwht='\e[0;37m' #white
Iblu='\e[0;94m' #High Intensity Blu
Icyn='\e[0;96m' #High Intensity Cyan
Iwht='\e[0;97m' #High Intensity White


export POWERLINE_CONFIG_COMMAND=$HOME/.vim/bundle/powerline/scripts/powerline-config
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/development/python
source /usr/bin/virtualenvwrapper.sh

alias git="hub"

gitprompt='~/development/bash/git-prompt.sh'
if [ `tput -T $TERM colors` = 256 ]; then
    export PS1="\[${Iblu}\][\[${txtcyn}\]\u\[${Iblu}\]@\[${txtgrn}\]\h\[${Icyn}\] \w\[${Iblu}\] ]\[${txtwht}\$($gitprompt) \[${Iblu}\]\\$ \[${txtwht}\]"
fi

if [ `lsb_release -i | grep -ioP '(?<=distributor\sid\:\s)(\w*)'` = 'Gentoo' ]; then
    
    alias nudav="sudo emerge -NuDav world"
fi

