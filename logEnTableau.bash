git log -2 --pretty=format:"%h | %s | %ad | %cd" --date=short | sed '1iHash | Intitulé | Auteur | Commit\n  |   |   |  ' | sed 's/ | /#|#/g' | sed '$ s/$/\n/' | column -ts '#'
