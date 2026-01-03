#!/usr/bin/env bash

export LC_ALL=C.UTF-8

input_file="$1"
output_file="$2"

if [[ -z "$input_file" || -z "$output_file" ]]; then
  echo "Usage: $0 fichier_entree.txt fichier_sortie.txt"
  exit 1
fi

if [[ ! -f "$input_file" ]]; then
  echo "Erreur : $input_file n'est pas un fichier"
  exit 1
fi

perl -0777 -CSD -pe '
  s/[^\p{Hiragana}\p{Katakana}\p{Han}ー]//g;
  s/(.{2})/$1\n/g;
  s/\n$//;
' "$input_file" > "$output_file"

echo "Fichier traité : $output_file"
