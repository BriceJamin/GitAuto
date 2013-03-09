#!/bin/bash

# Met à jour les scripts dans le dossier personnel
# ainsi que dans le bashrc pour pouvoir utiliser 
# leurs fonctions dans le shell.

bashrcModifie=0
for script in git-recup-all-from.bash git-branch-track-all-from.bash
do
	if [[ ! -f "$script" ]]; then
		echo "Erreur d'argument : $script"
		exit 1
	fi

	if [[ ! -f ~/".$script" ]]; then
		echo -n "Création du script ~/.$script..."
		cp "$script" ~/".$script"

		if (( $? == 0 )); then
			echo " Terminée."
		fi

		echo "Ajout d'un appel à ce script depuis le ~/.bashrc."
		echo "source ~/.$script" >> ~/.bashrc
		bashrcModifie=1
	else
		echo -n "Mise à jour du script ~/.$script..."
		cp "$script" ~/".$script"

		if (( $? == 0 )); then
			echo " Terminée."
		fi
	fi
done

if (( 1 == $bashrcModifie )); then
	echo
	echo "Le ~/.bashrc a été modifié, peut être devriez vous le recharger."
	echo
fi
