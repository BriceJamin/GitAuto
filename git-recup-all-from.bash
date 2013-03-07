#!/bin/bash

# Memo de la passphrase dans l'agent ssh
# ssh-add ~/.ssh/id_rsa_github_BriceJamin

#remote: Counting objects: 11, done.
#remote: Compressing objects: 100% (3/3), done.
#remote: Total 9 (delta 0), reused 0 (delta 0)
#Unpacking objects: 100% (9/9), done.
#From /home/smallfitz/Documents/GitTests/GitAuto/Clef
# * [new branch]      branche3   -> origin/branche3
#   1daeeab..9788254  master     -> origin/master
# * [new branch]      newbranche2 -> origin/newbranche2
# x [deleted]         (none)     -> origin/branche1
# x [deleted]         (none)     -> origin/branche2

# Utilisation : ./script remote
# Si nbArg != 1 quitter
# remote=$1
# git fetch $1
# Pour la premiere ligne
# Si elle commence par "fetching" c'est qu'il y a des choses à dl.
# Sinon, il n'y a rien à dl : quitter ou employer git remote show.

# Pour chaque ligne suivante
# Si elle commence par * [new branch]
#   Creer nouvelle branche
# Sinon si elle commence par x [deleted]
#   Supprimer branche
# Sinon si elle commence par 2 sha1 séparé de 2 points
#   Mettre à jour la branche
# Fin

function git-recup-all-from()
{
	git checkout master
	#declare -x iLigne=0
	git fetch --prune $1 2>&1 |
	while read line; do
		declare -x iLigne;
		line=$(echo "$line" | sed -r "s/ +/ /g")
		#	echo "$line";

		if [[ "$line" =~ "[new branch]" ]]; then
			branch=$(echo "$line" | cut -d" " -f4)
			remoteBranch=$(echo "$line" | cut -d" " -f6)
			#		echo "Creer branche $branch, copie de $remoteBranch"
			git branch $branch --track $remoteBranch

		elif [[ "$line" =~ "[deleted]" ]]; then
			remoteBranch=$(echo "$line" | cut -d" " -f5)
			branch=${remoteBranch#*/}
			#		echo "Supprimer branche $branch"
			git branch -D $branch

		elif [[ "$line" =~ ".." ]]; then
			branch=$(echo "$line" | cut -d" " -f2)
			remoteBranch=$(echo "$line" | cut -d" " -f4)
			#		echo "Mettre à jour branche $branch via $remoteBranch"
			git checkout $branch
			git merge $remoteBranch
		fi

		((iLigne++))
		#	echo $iLigne
	done
	#echo "Fin:$iLigne"
	#if (( 0 < "$iLigne" )); then
	#	echo "Récupération terminée."
	#else
	#	echo "Aucune donnée récupérée."
	#fi
}
