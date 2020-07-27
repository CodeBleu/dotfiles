#!/bin/bash
gitrepo=`git rev-parse --is-inside-work-tree 2>/dev/null`

txtgrn='\e[32m'
txtylw='\e[33m'
txtred='\e[31m'
reset='\e[m'

# if [ -d ".git" ]; then
if [ $gitrepo ]; then
    branch="`git branch -a | awk '/\*/ {print $2 }'`"
    if [ `git status | grep -ic 'clean$'` = 1 ]; then
        echo -e "${reset}("$branch" ${txtgrn}✔${reset})"
    else if [ `git status | grep -ic 'unstage'` = 1 ]; then 
        echo -e "${reset}("$branch" ${txtylw}⬖${reset})"
        else
            echo -e "${reset}("$branch" ${txtred}✗${reset})"
        fi
    fi
fi
