#!/usr/bin/env bash

mkdir -p concordances

# On boucle sur chaque fichier d'extrait pour créer une page par URL
for f in contextes/arabe-*.txt
do
    [ -e "$f" ] || continue
    
    # On extrait le numéro pour nommer le fichier de sortie
    num=$(echo "$f" | grep -oP '\d+')
    RESULTAT="concordances/arabe-$num.html"

    echo "<html><head><meta charset='utf-8'></head><body>" > "$RESULTAT"
    echo "<table border='1' style='width:100%; border-collapse:collapse;'>" >> "$RESULTAT"
    echo "<tr><th>Contexte Suivant (gauche)</th><th>Mot Pivot</th><th>Contexte Précédent (droite)</th></tr>" >> "$RESULTAT"

    if [ -s "$f" ]; then
        grep "أمل" "$f" | while read -r ligne
        do
            ligne=$(echo "$ligne" | xargs -d '\n')
            # Logique RTL pour l'arabe : début à droite, suite à gauche
            avant=$(echo "$ligne" | sed "s/أمل.*//")
            apres=$(echo "$ligne" | sed "s/.*أمل//")
            
            echo "<tr>
                <td align='left'>$apres</td>
                <td align='center'><b style='color:red;'>أمل</b></td>
                <td align='right'>$avant</td>
            </tr>" >> "$RESULTAT"
        done
    else
        echo "<tr><td colspan='3'>Aucune occurrence trouvée.</td></tr>" >> "$RESULTAT"
    fi

    echo "</table></body></html>" >> "$RESULTAT"
done
