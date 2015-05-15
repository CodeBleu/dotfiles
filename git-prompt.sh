#!/bin/bash


if [ -d ".git" ]; then
    branch="`git branch -a | awk '/\*/ {print $2 }'`"
    if [ `git status | grep -ic 'clean'` = 1 ]; then
        echo "("$branch" $(tput setaf 2)✔$(tput sgr0))"
    else if [ `git status | grep -ic 'unstage'` = 1 ]; then 
        echo "("$branch" $(tput setaf 3)⬖$(tput sgr0))"
        else
            echo "("$branch" $(tput setaf 1)✗$(tput sgr0))"
        fi
    fi
fi
