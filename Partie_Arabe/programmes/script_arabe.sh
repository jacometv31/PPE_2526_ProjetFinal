#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <fichier_urls.txt>"
    exit 1
fi

FICHIER_URLS=$1
FICHIER_TABLEAU="tableaux/arabe.html"

# Création des dossiers selon la structure demandée 
mkdir -p aspirations dumps-text contextes tableaux concordances

echo "<html><head><meta charset='UTF-8'><style>table{width:100%; border-collapse:collapse;} th,td{padding:8px; border:1px solid black; text-align:center;}</style></head><body>" > "$FICHIER_TABLEAU"
echo "<h2>Tableau du corpus Arabe - Mot : أمل</h2>" >> "$FICHIER_TABLEAU"
echo "<table>" >> "$FICHIER_TABLEAU"
echo "<tr><th>N°</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Occurrences</th><th>Aspiration</th><th>Dump</th><th>Contexte</th><th>Concordancier</th></tr>" >> "$FICHIER_TABLEAU"

lineno=1

while read -r line || [ -n "$line" ]; do
    URL=$(echo "$line" | tr -d '\r' | xargs)
    [[ -z "$URL" ]] && continue

    # Aspiration avec User-Agent pour éviter les erreurs 403/404 [cite: 108]
    code=$(curl -L -k -s -A "Mozilla/5.0" -w "%{http_code}" -o "aspirations/arabe-$lineno.html" "$URL")
    
    if [ "$code" -eq 200 ]; then
        charset=$(file -i "aspirations/arabe-$lineno.html" | cut -d= -f2)
        lynx -dump -nolist -display_charset=utf-8 -assume_charset=utf-8 "aspirations/arabe-$lineno.html" > "dumps-text/arabe-$lineno.txt"
        nb_occ=$(grep -o "أمل" "dumps-text/arabe-$lineno.txt" | wc -l)
        grep -C 2 "أمل" "dumps-text/arabe-$lineno.txt" > "contextes/arabe-$lineno.txt"
    else
        charset="Erreur"
        nb_occ=0
        echo "L'URL $lineno a échoué avec le code $code"
    fi
    
    # On crée un lien UNIQUE vers le concordancier de cette ligne
    echo "<tr>
        <td>$lineno</td>
        <td><a href='$URL'>Lien</a></td>
        <td>$code</td>
        <td>$charset</td>
        <td>$nb_occ</td>
        <td><a href='../aspirations/arabe-$lineno.html'>HTML</a></td>
        <td><a href='../dumps-text/arabe-$lineno.txt'>Texte</a></td>
        <td><a href='../contextes/arabe-$lineno.txt'>Extrait</a></td>
        <td><a href='../concordances/arabe-$lineno.html'>Concordancier</a></td>
    </tr>" >> "$FICHIER_TABLEAU"
    
    lineno=$((lineno+1))
done < "$FICHIER_URLS"

echo "</table></body></html>" >> "$FICHIER_TABLEAU"
