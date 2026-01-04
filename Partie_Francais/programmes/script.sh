#!/bin/bash

URL_FILE="$1"     
LANG="$2"         
MOT_REGEX="espoir[s]?"

# BLACKLIST ROBOTS 
BLACKLIST="$URL_FILE-blacklist"

url_interdite() {
    local url="$1"
    while read -r interdit; do
        [ -z "$interdit" ] && continue
        interdit_regex=$(echo "$interdit" | sed 's/[\/&]/\\&/g; s/\*/.*/g')
        if [[ "$url" =~ ^$interdit_regex ]]; then
            return 0
        fi
    done < "$BLACKLIST"
    return 1
}

ASPIRATIONS="aspirations"
DUMPS="dumps-text"
CONTEXTES="contextes"
CONCORDANCES="concordances"
TABLEAUX="tableaux"

mkdir -p "$ASPIRATIONS" "$DUMPS" "$CONTEXTES" "$CONCORDANCES" "$TABLEAUX"

# Tableau html
TABLE="$TABLEAUX/$LANG.html"

echo "<!DOCTYPE html>" > "$TABLE"
echo "<html lang='fr'><head><meta charset='UTF-8'></head><body>" >> "$TABLE"
echo "<h2>Tableau du mot « espoir »</h2>" >> "$TABLE"
echo "<table border='1'>" >> "$TABLE"

echo "<tr>
<th>#</th>
<th>URL</th>
<th>robots.txt</th>
<th>Code HTTP</th>
<th>Encodage</th>
<th>Occurrences</th>
<th>aspirations</th>
<th>dumps-text</th>
<th>contextes</th>
<th>concordances</th>
</tr>" >> "$TABLE"

i=1
while read -r URL
do
    [ -z "$URL" ] && continue
    echo "Traitement : $URL"

    ROBOTS_STATUS="AUTORISÉ (robots.txt)"

    if [ -f "$BLACKLIST" ] && url_interdite "$URL"; then
        ROBOTS_STATUS="INTERDIT (robots.txt)"

        echo "<tr>
<td>$i</td>
<td><a href=\"$URL\">$URL</a></td>
<td>$ROBOTS_STATUS</td>
<td>-</td>
<td>-</td>
<td>0</td>
<td>-</td>
<td>-</td>
<td>-</td>
<td>-</td>
</tr>" >> "$TABLE"

        i=$((i+1))
        continue
    fi

    HTML_FILE="$ASPIRATIONS/$LANG-$i.html"
    TEXT_FILE="$DUMPS/$LANG-$i.txt"
    CONTEXT_FILE="$CONTEXTES/$LANG-$i.txt"
    CONCORD_FILE="$CONCORDANCES/$LANG-$i.html"

    HTTP_CODE=$(curl -L -s -w "%{http_code}" -o "$HTML_FILE" "$URL")

    if [ "$HTTP_CODE" = "200" ]; then

        ENCODING=$(file -bi "$HTML_FILE" | sed 's/.*charset=//')

        if [ "$ENCODING" = "utf-8" ] || [ "$ENCODING" = "utf8" ]; then
            lynx -dump -nolist "$HTML_FILE" > "$TEXT_FILE"
        else
            if iconv -f "$ENCODING" -t UTF-8 "$HTML_FILE" > /dev/null 2>&1; then
                iconv -f "$ENCODING" -t UTF-8 "$HTML_FILE" | lynx -dump -nolist -stdin > "$TEXT_FILE"
                ENCODING="$ENCODING → UTF-8"
            else
                i=$((i+1))
                continue
            fi
        fi

        egrep -i -C 5 "([ld]['’])?$MOT_REGEX" "$TEXT_FILE" > "$CONTEXT_FILE"

        echo "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body>
<table border='1'><tr><th>Contexte gauche</th><th>Mot</th><th>Contexte droit</th></tr>" > "$CONCORD_FILE"

        awk -v motif="$MOT_REGEX" '
        {
            for(i=1;i<=NF;i++){
                if(tolower($i) ~ tolower(motif)){
                    left=""; right=""
                    for(j=i-5;j<i;j++) if(j>0) left=left $j " "
                    for(j=i+1;j<=i+5 && j<=NF;j++) right=right $j " "
                    printf "<tr><td>%s</td><td><b>%s</b></td><td>%s</td></tr>\n", left, $i, right
                }
            }
        }' "$TEXT_FILE" >> "$CONCORD_FILE"

        echo "</table></body></html>" >> "$CONCORD_FILE"

        OCC=$(egrep -oi "([ld]['’])?$MOT_REGEX" "$TEXT_FILE" | wc -l)

        echo "<tr>
<td>$i</td>
<td><a href=\"$URL\">$URL</a></td>
<td>$ROBOTS_STATUS</td>
<td>$HTTP_CODE</td>
<td>$ENCODING</td>
<td>$OCC</td>
<td><a href=\"../$HTML_FILE\">aspirations</a></td>
<td><a href=\"../$TEXT_FILE\">dumps-text</a></td>
<td><a href=\"../$CONTEXT_FILE\">contextes</a></td>
<td><a href=\"../$CONCORD_FILE\">concordances</a></td>
</tr>" >> "$TABLE"
    fi

    i=$((i+1))
done < "$URL_FILE"

echo "</table></body></html>" >> "$TABLE"
echo "Traitement terminé (robots.txt respecté)."

