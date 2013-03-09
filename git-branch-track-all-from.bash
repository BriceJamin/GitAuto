#!/bin/bash

# A executer apres un clone, pour avoir en local
# les même branches que sur le dépôt distant.

function git-branch-track-all-from() # Alias du remote en paramètre
{
	for branch in `git branch -r | grep "^ *$1" | grep -v "HEAD\|master"`
	do 
		git branch ${branch##*/} --track $branch
	done
}
