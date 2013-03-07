git fetch -v --prune origin | \
grep "\[new branch\]"  | \
	185 sed -r 's/^.*\] +([^ ]+) +->/\1/' | \
	186  while read line; do git branch ${line% *} --track ${line#* }; done


# Tracker la branche distante master pour pouvoir  la pull
###############
# Version 1.7.0
git branch --set-upstream master origin/master
###############
# Version 1.8.0
# Si master n'est pas la branche courante
#git branch --set-upstream-to origin/master master
#git branch -u origin/master master
# Si master est la branche courante 
#git branch --set-upstream-to origin/master
#git branch -u origin/master
###############
:
