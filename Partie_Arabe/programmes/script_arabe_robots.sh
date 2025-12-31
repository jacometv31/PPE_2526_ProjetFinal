#!/bin/bash

langue="arabe"
fichier_urls="URLs/${langue}.txt"
blacklist="URLs/${langue}.txt-blacklist"
tableau="tableaux/tableau_${langue}_robots.html"

# Début du tableau avec Bulma pour le design
echo "<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css'>
    <title>Conformité Robots.txt</title>
</head>
<body>
<section class='section'>
<div class='container'>
<h1 class='title'>Vérification de Conformité Robots.txt</h1>
<table class='table is-bordered is-striped is-narrow is-hoverable is-fullwidth'>
<thead>
    <tr class='is-link'>
        <th>Num</th>
        <th>URL</th>
        <th>Robots.txt</th>
        <th>Code HTTP</th>
    </tr>
</thead>
<tbody>" > $tableau

compteur=1
while read -r URL || [ -n "$URL" ]; do
    URL=$(echo "$URL" | tr -d '\r' | xargs)
    [[ -z "$URL" ]] && continue

    verif_robots="Autorisé"
    couleur_statut="has-text-success" # Vert par défaut
    classe_ligne=""

    # Vérification par préfixe dans la blacklist
    if [ -f "$blacklist" ]; then
        while IFS= read -r ligne_interdite; do
            if [[ "$URL" == "$ligne_interdite"* ]]; then
                verif_robots="Interdit"
                couleur_statut="has-text-danger" # Rouge si interdit
                classe_ligne="is-danger-light" # Fond rosé pour la ligne
                break
            fi
        done < "$blacklist"
    fi

    # Traitement du code HTTP
    if [ "$verif_robots" == "Interdit" ]; then
        code="000"
    else
        code=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
    fi

    # Écriture de la ligne avec les styles
    echo "<tr class='$classe_ligne'>
        <td>$compteur</td>
        <td><a href='$URL' style='word-break: break-all;'>$URL</a></td>
        <td><span class='$couleur_statut' style='font-weight: bold;'>$verif_robots</span></td>
        <td><code>$code</code></td>
    </tr>" >> $tableau
    
    compteur=$((compteur + 1))
done < "$fichier_urls"

echo "</tbody></table></div></section></body></html>" >> $tableau
