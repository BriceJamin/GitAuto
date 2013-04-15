#!/bin/bash

export NAME="BriceJamin"
export EMAIL="brice.jamin@hotmail.fr"
oldestCommit=""
newestCommit=""

if [ "$oldestCommit" = "" ];
then
	oldestCommit=`git log | tail -n 1 | cut -d\  -f 1`
fi

if [ "$newestCommit" = "" ];
then
	newestCommit="HEAD"
fi

echo "Une réécriture de l'historique va être effectuée."
echo "Elle commencera après le commit suivant :"
git log -1 --pretty=fuller $oldestCommit 2> /dev/null

if [ ! $? -eq 0 ];
then
	echo "Commit inconnu."
	echo "Abandon."
	exit
fi

echo
echo "Et s'arrêtera après avoir traité le commit suivant :"
git log -1 --pretty=fuller $newestCommit

if [ ! $? -eq 0 ];
then
	echo "Commit inconnu."
	echo "Abandon."
	exit
fi

echo
echo "Chaque commit rencontré sera modifié si nécessaire afin que :"
echo " - Les noms de l'auteur et du commiteur soient : $NAME"
echo " - Les emails de l'auteur et du commiteur soient : $EMAIL"
echo " - La date de modif du commiteur soit la même que celle de l'auteur."
echo
echo "Il est recommendé d'effectuer au préalable la réécriture sur une branche de test..."
echo -n "Continuer ? ( Oui/Non : O/N ) > "
read answer

if [ $answer != "O" ];
then
	echo "Abandon."
	exit
else
	echo "Réécriture de l'historique..."
fi

git filter-branch -f --commit-filter '

author_name="$GIT_AUTHOR_NAME"
author_email="$GIT_AUTHOR_EMAIL"
author_date="$GIT_AUTHOR_DATE"

if [ "$GIT_AUTHOR_NAME" != "$NAME" ]; then
	author_name="$NAME";
fi

if [ "$GIT_AUTHOR_EMAIL" != "$EMAIL" ]; then
	author_email="$EMAIL";
fi

export GIT_AUTHOR_NAME="$author_name"
export GIT_AUTHOR_EMAIL="$author_email"

export GIT_COMMITTER_NAME="$author_name"
export GIT_COMMITTER_EMAIL="$author_email"
export GIT_COMMITTER_DATE="$author_date"

' $oldestCommit..$newestCommit
