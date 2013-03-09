#!/bin/bash

# Utilité :
# Met à jour toutes les branches d'un dépôt en prenant comme référence le
# dépôt distant fourni en paramètre.
# Ce qui :
# * Supprime les branches locales non présentes sur le dépôt distant
# * Crée des copies des branches qui existent sur le dépôt distant mais pas en local.
# * Met à jour les branches locales dont les branches distantes ont été modifiées.
#####################################################################################

# Utilisation :
# ./git-recup-all-from.bash nomDuDepotDistant
#############################################


# Conseils :
# * Toujours donner l'alias du dépôt distant.
# * Ne jamais utiliser la commande fetch soi-même, le script deviendrait inutile.
# * Ajouter ce script au ~/.bashrc pour accéder à cette fonction.
#################################################################################

# TODO : Vérifier le nombre d'arguments
# TODO : Vérifier la validité des arguments
# TODO : Si fetch n'affiche rien, utiliser git remote show $1

# Algo :
# Rediriger git fetch --prune $1
# Pour chaque ligne
#  Si elle contient [new branch]
#    Creer nouvelle branche
#  Sinon si elle contient [deleted]
#    Supprimer branche
#  Sinon si elle contient ..
#    Mettre à jour la branche
# FinPour
###################################

function git-recup-all-from() # Reçoit en argument l'alias du dépôt distant
{
	git checkout master
	git fetch --prune $1 2>&1 |
	while read line; do
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
	done
}
