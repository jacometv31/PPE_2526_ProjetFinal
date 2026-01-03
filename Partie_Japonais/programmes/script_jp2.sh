#!/bin/bash

# Vérification des arguments
if [ $# -ne 2 ]; then
    echo "Erreur: il faut deux arguments pour exécuter le script"
    exit 1
fi

URL_FILE="$1"
OUTPUT_FILE="$2"

# Début du HTML
echo "<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<title>Résultat URLs</title> <!-- Le nom de la page est Résultat URLs -->
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"
>
</head>
<body>
<section class="section">
<h1 class="title is-1">Tableau des URLS pour le mot 期待</h1>
<table class="table">
<tr>
<th>#</th>
<th>Code HTTP</th>
<th>URL</th>
<th>Encodage</th>
<th>Nombre d'occurrences</th>
<th>HTML Brut</th>
<th>DUMP Textuel</th>
<th>Contexte</th>
<th>Concordancier HTML</th>

</tr>" > "$OUTPUT_FILE" #permet de créer le tableau

# Parcours des URLs
i=1
while read -r line; do
    code=$(curl -o /dev/null -s -w "%{http_code}" "$line")
    encodage=$(curl -s -I "$line" | grep -oE "charset=[^; ]+" | cut -d= -f2)
    occurrence=$(curl -s "$line" | grep -o -i "期待" | wc -l)
    lynx -source "$line" > "../html_brut/mot2/page_$i.html"
    lynx -dump "$line" > "../dump/mot2/dump_$i.txt"

    if [ ! -s "../dump/mot2/dump_$i.txt" ]; then
    echo "ERREUR: dump_$i.txt non créé (URL = '$line')" >&2
    continue
    fi

    grep -C 3 --no-group-separator "期待" \
    "../dump/mot2/dump_$i.txt" \
    > "../contexte/mot2/contexte_$i.txt"

    CONCORD_FILE="../concordances/mot2/concord_$i.html"

    echo "<!DOCTYPE html>
    <html lang='fr'>
    <head>
    <meta charset='UTF-8'>
    <title>Concordances pour 期待</title>
    <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"
    >
    </head>
    <body>
    <section class="section">
    <h1 class="title is-1">Concordances pour le mot 期待</h1>
    <table class="table">
    <tr>
        <th>Contexte gauche</th>
        <th>Mot</th>
        <th>Contexte droit</th>
    </tr>" > "$CONCORD_FILE"


    sed -n "
    /期待/{
      s/^\(.*\)\(期待\)\(.*\)$/<tr><td class=\"gauche\">\1<\/td><td class=\"mot\">\2<\/td><td class=\"droite\">\3<\/td><\/tr>/
      p
    }" "../dump/mot2/dump_$i.txt" >> "$CONCORD_FILE"



    echo "</ul></body></html>" >> "$CONCORD_FILE"

    echo "<tr>
<td>${i}</td>
<td>${code}</td>
<td><a href=\"$line\">$line</a></td>
<td>${encodage}</td>
<td>${occurrence}</td>
<td> <a href="../html_brut/mot2/page_$i.html">Voir le html</a> </td>
<td> <a href="../dump/mot2/dump_$i.txt">Voir le dump</a> </td>
<td> <a href="../contexte/mot2/contexte_$i.txt">Voir le contexte</a> </td>
<td><a href="../concordances/mot2/concord_$i.html">Voir concordancier</a></td>

</tr>" >> "$OUTPUT_FILE" #permet de rajouter des lignes dans le tableau
    ((i++))
done < "$URL_FILE"

# Fin du HTML
echo "</table> <!-- table permet de créer un tableau -->
</section>
</body>
</html>" >> "$OUTPUT_FILE" #permet la fermeture du fichier HTML
