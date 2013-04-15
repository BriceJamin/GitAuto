#!/bin/bash

name="BriceJamin"
email="brice.jamin@hotmail.fr"
oldestCommit="32a8eb5"
newestCommit="HEAD"

echo "Une réécriture de l'historique va être effectuée."
echo "Elle commencera après le commit suivant :"
git log -1 --pretty=fuller $oldestCommit
echo
echo "Et s'arrêtera après avoir traité le commit suivant :"
git log -1 --pretty=fuller $newestCommit
echo
echo "Chaque commit rencontré sera modifié si nécessaire afin que :"
echo " - Les noms de l'auteur et du commiteur soient : $name"
echo " - Les emails de l'auteur et du commiteur soient : $email"
echo " - La date de modif du commiteur soit la même que celle de l'auteur."
echo
echo "Il est recommendé d'effectuer au préalable la réécriture sur une branche de test..."
echo -n "Continuer ? ( Oui/Non : O/N ) > "
read answer

if [ $answer != "O" ];
then
	echo "Annulation."
	exit
else
	echo "Début de la réécriture de l'historique..."
fi

exit

git filter-branch -f --commit-filter '

modify="false";

if [ "$GIT_AUTHOR_NAME" != "$name" ];
then
	GIT_AUTHOR_NAME="$name";
	GIT_AUTHOR_EMAIL="$email";
	modify="true";
fi

if [ "$GIT_COMMITTER_NAME" != "$name" ];
then
	GIT_COMMITTER_NAME = "$name";
	GIT_COMMITTER_EMAIL = "$email";
	modify="true";
fi

if [ "$GIT_AUTHOR_DATE" != "$GIT_COMMITER_DATE" ];
then
	GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE";
	modify="true";
fi

if [ $modify = "true" ];
then
	git commit-tree "$@";
fi

' $oldestCommit..$newestCommit
