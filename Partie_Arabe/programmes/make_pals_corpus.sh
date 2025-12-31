#!/usr/bin/env bash

# Script pour formater le corpus selon la méthode PALS
# Supporte l'ordre numérique (1, 2, 3... 50)

if [ $# -ne 2 ]; then
  echo "Usage: $0 <dossier_source> <nom_base>"
  exit 1
fi

DOSSIER=$1 
NOM=$2     
FICHIER_SORTIE="pals/${DOSSIER}-${NOM}.txt"

# 1. Création du dossier pals si nécessaire
mkdir -p pals

# On vide le fichier final
> "$FICHIER_SORTIE"

echo "Traitement de $DOSSIER (Tri numérique en cours...)"

# 2. Itération avec tri naturel (sort -V) pour avoir l'ordre 1, 2, 3...
for f in $(ls "$DOSSIER"/${NOM}-*.txt | sort -V); do
  
  [ -e "$f" ] || continue
  
  # On récupère le numéro de l'URL
  num=$(echo "$f" | grep -oP '\d+')
  
  # 3. Écriture de la balise simplifiée pour PALS
  echo "<${NOM}_${num}>" >> "$FICHIER_SORTIE"
  
  # 4. Tokenisation (Exercice 1 : un mot par ligne)
  cat "$f" | tr -d '[:punct:]' | sed "s/ /\n/g" | sed '/^$/d' >> "$FICHIER_SORTIE"
  
  echo "" >> "$FICHIER_SORTIE"
done

echo "Terminé ! Fichier prêt : $FICHIER_SORTIE"
