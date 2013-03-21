#!/bin/bash

rm -rf ModifierHistoriqueParDossier
mkdir ModifierHistoriqueParDossier
cd ModifierHistoriqueParDossier

git init

mkdir Dossier1
echo "Travail sur Dossier 1." >> Dossier1/fic
git add Dossier1/fic
git commit -m "Travail sur Dossier 1."

mkdir Dossier2
echo "Travail sur Dossier 2." >> Dossier2/fic
git add Dossier2/fic
git commit -m "Travail sur Dossier 2."

echo "Travail sur Dossier 1 et 2." >> Dossier1/fic
echo "Travail sur Dossier 1 et 2." >> Dossier2/fic
git commit -am "Travail sur Dossier 1 et 2."

mkdir Dossier3
echo "Travail sur Dossier 3." >> Dossier3/fic
git add Dossier3/fic
git commit -m "Travail sur Dossier 3."

echo "Travail sur Dossier 1, 2 et 3." >> Dossier1/fic
echo "Travail sur Dossier 1, 2 et 3." >> Dossier2/fic
echo "Travail sur Dossier 1, 2 et 3." >> Dossier3/fic
git commit -am "Travail sur Dossier 1, 2 et 3."

echo "Travail sur Dossier 1 et 2." >> Dossier1/fic
echo "Travail sur Dossier 1 et 2." >> Dossier2/fic
git commit -am "Travail sur Dossier 1 et 2."

echo "Travail sur Dossier 1 et 3." >> Dossier1/fic
echo "Travail sur Dossier 1 et 3." >> Dossier3/fic
git commit -am "Travail sur Dossier 1 et 3."

git log --oneline
