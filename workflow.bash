#!/bin/bash

###########################################################################
# Ce fichier est un script bash.
# Il automatise les actions courantes lors de l'utilisation de Git
# pour suivre un dépôt personnel, servant de sauvegarde.
#
# Ce script suit un véritable scénario dont les étapes clefs sont :
# 1. Création d'un dépôt à la maison
# 2. Copie de sauvegarde maison vers clef USB
# 3. Récupération de la sauvegarde au Lycée
# 4. Mise à jour depuis le Lycee de la sauvegarde Clef USB
# 5. Mise à jour depuis la clef USB du dépôt maison
#
# Il peut être lu et servir de documentation.
# 
# Il peut également être exécuté et servir à effectuer des tests.
# Pour cela :
# 1. Copier ce fichier dans un répertoire. 
#    /!\ Si ce répertoire contient des dossiers nommés 
#    /!\ Lycee, Clef, et Maison, ils seront irrémédiablement supprimés
#    /!\  tout comme leur contenu.
# 2. Le rendre exécutable avec la commande :
#       chmod +x workflow.bash
# 3. L'exécuter avec la commande :
#       ./workflow
# Note :
# Pour stopper le script à un endroit en particulier,
# il peut être utile de l'éditer et d'ajouter à la ligne voulue
# l'instruction suivante :
#       exit
###########################################################################


# Je travaille depuis la maison et le lycée
# Je vais me servir d'une clef USB pour synchroniser mon travail

rm -rf Lycee
rm -rf Clef 
rm -rf Maison
mkdir Lycee 
mkdir Clef
mkdir Maison
depotLycee=`pwd`/Lycee
depotClef=`pwd`/Clef
depotMaison=`pwd`/Maison

# Je suis chez moi
cd $depotMaison

# Je travaille
echo "Travail maison master." > travail.txt

# Je souhaite suivre mes infos avec Git
git init # Crée un nouveau dépôt
git add travail.txt # Ajoute à l'index le fichier travail.txt
git commit -m "Travail maison master" # Commit le fichier travail.txt avec ( -m ) un intitulé
git log # Liste tous les commits de la branche courante
 # git log -3 # Liste les 3 derniers commits
 # git log --oneline # Affiche chaque commit sur une seule ligne

# Je travaille sur deux nouvelles branches
git checkout -b branche1 # Equivalent de :
 # git branch branche1 # Creation de la branche branche1
 # git checkout branche1 # Changement de branche courante pour branche1
git branch # Liste les branches locales
 # git branch -r # Liste les branches distantes
 # git branch -a # Liste toutes les branches (locales et distantes)
 git branch --v # Dernier commit de chaque branche (-v : verbose)
echo "Travail maison branche1." >> travail.txt
git commit -am "Travail maison branche1" # Commit tout ce qui a déjà été suivi

git checkout master
git checkout -b branche2
echo "Travail maison branche2." >> travail.txt
git commit -am "Travail maison branche2"

# J'enregistre mon travail sur la clef avant de partir au Lycee
git init --bare $depotClef # Crée un dépôt nu sur la clef
                           # Equivalent des commandes :
                           # cd $depotClef ; git init --bare . ; cd $depotMaison ;

git remote add origin $depotClef # Ajoute la clef comme dépôt distant d'alias origin
 # git remote rm origin # Supprime le depot distant
 # git remote rename origin neworigin # Renomme le depot distant origin en neworigin 
git remote show origin # Affiches les interactions possibles (pull, push) sur les branches d'un dépôt distant

 # git push origin master # Pousse vers origin la branche locale master, 
		       # et permettra de push depuis cette branche
		       # sans aucun paramètres.
 # git push -u origin branche1 # Idem, et permettra ( -u ) de pull depuis cette branche
			    # sans aucun paramètre
git push -u --all # Idem, et cela pour toutes les branches locales

# J'arrive au Lycee
cd $depotLycee

# Je veux récupérer mon travail
git clone $depotClef .

git branch branche1 --track origin/branche1  # Crée la branche branche1, copie de origin/branche1, et la suit
  # git checkout -b branche1 origin/branche1 # Idem, en plus de se positionner dessus
 # Pour toutes les branches distantes :
 # Crée une nouvelle branche locale, copie de la branche distante
for branch in `git branch -r | grep -v "HEAD\|master"`; do git branch ${branch##*/} --track $branch; done


# Je travaille 

echo "Travail lycee master" > travail.txt
git commit -am "Travail lycee master"

git branch -d branche1 # Supprime la branche branche1

git branch -m branche2 newbranche2 # Renomme la branche branche2 en branche2new
 # git branch -M branche2 branche3 # Ecrase branche3 en renommant branche2 en branche3
echo "Travail lycee newbranche2" >> travail.txt
git commit -am "Travail lycee newbranche2"

git checkout -b branche3
echo "Travail lycee branche3." > travail.txt
git commit -am "Travail lycee branche3"

# Avant de partir à la maison, j'enregistre mon travail sur la clef

############
# METHODE 1 : Branche par branche
#git push origin :branche1 # Supprime la branche distante branche1
 # git push --delete origin branche1 # Idem
 # git push --prune origin # Supprime toutes les branches distantes qui n'existent pas en local
                                # Le renommage d'une branche distante n'existe pas.
#git push origin :branche2      # 1: Il faut supprimer l'ancienne
#git push -u origin newbranche2 # 2: Puis pousser la nouvelle

#git push -u origin branche3

############
# METHODE 2 : Toutes les branches d'un seul coup.
git push -u --all --prune origin # -u : Suivre la branche distante
                                 # --all : pousse toutes les branches locales sur le dépôt distant
			         # --prune : supprime sur le depoôt distant les branches qui n'existent pas en local
# J'arrive à la maison
cd $depotMaison

# Je veux récupérer mon travail
 # git fetch origin      # Télécharge toutes les infos du dépôt distant
git fetch --prune origin # Idem, en supprimant les infos des branches distantes qui n'existent plus
                         # Affiche également des informations sur :
			 # - les nouvelles branches distantes téléchargées
			 # - les branches distantes supprimées
			 # - les branches distantes mises à jour
 # Exemple :
 #remote: Counting objects: 11, done.
 #remote: Compressing objects: 100% (3/3), done.
 #remote: Total 9 (delta 0), reused 0 (delta 0)
 #Unpacking objects: 100% (9/9), done.
 #From /chemin/vers/la/clef
 # * [new branch]      branche3   -> origin/branche3
 #   f21209c..5879157  master     -> origin/master
 # * [new branch]      newbranche2 -> origin/newbranche2
 # x [deleted]         (none)     -> origin/branche1
 # x [deleted]         (none)     -> origin/branche2

git branch branche3 --track origin/branche3 # Crée la nouvelle branche branche3, copie de origin/branche3, et la suit
 
git checkout master
 # git merge origin/master # Fusionne origin/master sur master, ce qui met à jour master
 # Equivalent :
git pull # N'est possible que parce que master suivait origin/master (push -u avait été fait)
git branch newbranche2 --track origin/newbranche2

 # git branch -d branche1 # Supprime la branche 1. Impossible si elle n'est pas mergée.
git branch -D branche1 # Dans ce cas, utiliser -D pour forcer la suppression
git branch -D branche2
