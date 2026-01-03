#!/bin/bash

# make_pals_corpus.sh
# Usage: ./make_pals_corpus.sh <dossier_fichiers> <nom_base>
# Ex: ./make_pals_corpus.sh ./japonais_data mon_fichier

# Vérification des arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dossier_fichiers> <nom_base>"
    exit 1
fi

INPUT_DIR="$1"
BASENAME="$2"
OUTPUT_FILE="${BASENAME}_corpus.txt"

# Vérifie que MeCab est installé
if ! command -v mecab >/dev/null 2>&1; then
    echo "Erreur: MeCab n'est pas installé. Installez-le avant d'exécuter ce script."
    exit 1
fi

# Vide le fichier de sortie s'il existe déjà
> "$OUTPUT_FILE"

# Parcours des fichiers dans le dossier
for file in "$INPUT_DIR"/*; do
    # Vérifie que c'est bien un fichier
    if [ -f "$file" ]; then
        # Segmentation avec MeCab et ajout au fichier de sortie
        mecab -Owakati "$file" | tr ' ' '\n' >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"  # ajoute une ligne vide entre fichiers si nécessaire
    fi
done

echo "Corpus créé dans : $OUTPUT_FILE"
