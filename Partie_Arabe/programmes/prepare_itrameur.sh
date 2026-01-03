#!/usr/bin/env bash

# On définit les chemins par rapport au dossier 'programmes'
# On remonte d'un niveau (../) pour atteindre la racine de Partie_Arabe
DUMP_DIR="../dumps-text"
OUT_DIR="../itrameur"
OUTPUT="$OUT_DIR/corpus_arabe.txt"

# Créer le dossier itrameur à côté de 'programmes', 'dumps-text', etc.
mkdir -p "$OUT_DIR"

# Début du fichier avec la balise racine [cite: 19]
echo "<lang=\"ar\">" > "$OUTPUT"

# Utilisation de 'ls -v' pour trier numériquement : 1, 2, ... 10
for f in $(ls -v "$DUMP_DIR"/arabe-*.txt)
do
    # Vérifier si le fichier existe pour éviter les erreurs de boucle
    [ -e "$f" ] || continue
    
    # Extraire le numéro pour la balise page
    num=$(echo "$f" | grep -oP '\d+')
    
    # Ajouter les balises attendues par iTrameur [cite: 19, 133]
    echo "<page=\"arabe-$num\">" >> "$OUTPUT"
    echo "<text>" >> "$OUTPUT"
    
    # Insérer le contenu du dump textuel [cite: 133]
    cat "$f" >> "$OUTPUT"
    
    echo "</text>" >> "$OUTPUT"
    echo "</page>" >> "$OUTPUT"
done

echo "</lang>" >> "$OUTPUT"

echo "Fichier iTrameur généré avec succès dans : $OUTPUT"
