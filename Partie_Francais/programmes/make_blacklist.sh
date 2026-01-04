#!/usr/bin/env bash

URL_FILE="$1"
BLACKLIST="${URL_FILE}-blacklist"

> "$BLACKLIST"

# Extraire les serveurs uniques
cut -d/ -f1-3 "$URL_FILE" | sort | uniq | while read -r SERVER; do

  ROBOTS="/tmp/robots.txt"
  curl -s "$SERVER/robots.txt" -o "$ROBOTS"


  [ ! -s "$ROBOTS" ] && continue

  IN_GLOBAL_AGENT=0

  while read -r LINE; do
    LINE=$(echo "$LINE" | tr -d '\r')

    if echo "$LINE" | grep -qi '^User-Agent:[[:space:]]*\*$'; then
      IN_GLOBAL_AGENT=1
      continue
    fi

    if echo "$LINE" | grep -qi '^User-Agent:'; then
      IN_GLOBAL_AGENT=0
    fi

    if [ "$IN_GLOBAL_AGENT" -eq 1 ] && echo "$LINE" | grep -qi '^Disallow:'; then
      PATH_DISALLOW=$(echo "$LINE" | cut -d: -f2 | tr -d ' ')
      [ -n "$PATH_DISALLOW" ] && echo "$SERVER$PATH_DISALLOW" >> "$BLACKLIST"
    fi

  done < "$ROBOTS"

done

sort -u "$BLACKLIST" -o "$BLACKLIST"

echo "Blacklist créée : $BLACKLIST"

