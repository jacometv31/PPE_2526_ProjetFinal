#!/bin/bash

# Verification du dossier URLs
if [ ! -d "URLs" ]; then
    exit 1
fi

for fichier in URLs/*.txt; do
    if [[ $fichier == *"-blacklist" ]]; then
        continue
    fi
    
    blacklist="${fichier}-blacklist"
    > "$blacklist"

    # Extraction des serveurs
    serveurs=$(grep -E '^https?://' "$fichier" | cut -d'/' -f1-3 | sort | uniq)

    for serveur in $serveurs; do
        curl -s -L "$serveur/robots.txt" > /tmp/robots.txt
        
        autorise=0
        while IFS= read -r ligne; do
            ligne=$(echo "$ligne" | tr -d '\r')
            
            # Debut de la zone User-agent: *
            if [[ "$ligne" == "User-agent: *" ]]; then
                autorise=1
                continue
            fi
            
            # Fin de la zone concernée
            if [[ "$ligne" == "User-agent:"* ]]; then
                autorise=0
            fi
            
            # Stockage de l'URL interdite
            if [[ $autorise -eq 1 ]] && [[ "$ligne" == "Disallow:"* ]]; then
                chemin=$(echo "$ligne" | cut -d' ' -f2)
                if [ -n "$chemin" ] && [ "$chemin" != "/" ]; then
                    echo "${serveur}${chemin}" >> "$blacklist"
                fi
            fi
        done < /tmp/robots.txt
    done
done
