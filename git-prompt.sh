#!/bin/bash


if [ -d ".git" ]; then
    branch="`git branch -a | awk '/\*/ {print $2 }'`"
    if [ `git status | grep -ic 'untracked files\:'` = 1 ] || [ `git status | grep -ic 'no changes'` = 1 ] || [ `git status | grep -ic '^changes not'` = 1 ]; then 
        echo "("$branch" $(tput setaf 1)✗$(tput sgr0))"
    else if [ `git status | grep -ic '^changes to be'` = 1 ]; then
        echo "("$branch" $(tput setaf 3)⬖$(tput sgr0))"
        else
            echo "("$branch" $(tput setaf 2)✔$(tput sgr0))"
        fi
    fi
fi
