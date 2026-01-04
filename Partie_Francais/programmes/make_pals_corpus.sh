#!/bin/bash

DOSSIER="$1"
LANG="$2"

# Vérification des arguments
if [ $# -ne 2 ]; then
    echo "Usage : bash make_pals_corpus.sh <dossier> <langue>" >&2
    exit 1
fi

mkdir -p pals

for FILE in "$DOSSIER"/"$LANG"-*.txt
do
    echo "Traitement de $FILE" >&2

    sed 's/[^[:alpha:]]/ /g' "$FILE" \
    | tr '[:upper:]' '[:lower:]' \
    | awk '
        NF {
            for (i = 1; i <= NF; i++)
                print $i
            print ""
        }
    '
done
