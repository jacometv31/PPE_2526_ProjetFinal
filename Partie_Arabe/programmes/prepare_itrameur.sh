#!/usr/bin/env bash

# Dossier de sortie pour iTrameur
mkdir -p itrameur

# Fichier final
OUTPUT="itrameur/corpus_arabe.txt"

# On commence le fichier avec la balise racine (optionnel mais propre)
echo "<lang=\"ar\">" > "$OUTPUT"

# On boucle sur chaque dump textuel pour les fusionner
for f in dumps-text/arabe-*.txt
do
    [ -e "$f" ] || continue
    
    # On récupère le numéro pour l'identifiant de la page
    num=$(echo "$f" | grep -oP '\d+')
    
    # On ajoute les balises XML attendues par iTrameur
    echo "<page=\"arabe-$num\">" >> "$OUTPUT"
    echo "<text>" >> "$OUTPUT"
    
    # On insère le contenu du dump en nettoyant les caractères spéciaux HTML si besoin
    # On utilise 'cat' pour lire le fichier
    cat "$f" >> "$OUTPUT"
    
    echo "</text>" >> "$OUTPUT"
    echo "</page>" >> "$OUTPUT"
done

echo "</lang>" >> "$OUTPUT"

echo "Fichier iTrameur généré : $OUTPUT"
