import os
from wordcloud import WordCloud
from arabic_reshaper import reshape

racine = "/home/habib/PPE_2526_ProjetFinal"

source = os.path.join(racine, "pals", "contextes-arabe.txt")
police = os.path.join(racine, "noto.ttf")
dossier_sortie = os.path.join(racine, "pals", "wordcloud")
image_sortie = os.path.join(dossier_sortie, "arabe.png")

os.makedirs(dossier_sortie, exist_ok=True)

with open(source, "r", encoding="utf-8") as f:
    texte_brut = " ".join(
        ligne.strip()
        for ligne in f
        if not ligne.startswith("<page")
    )

mots = texte_brut.split()
mots_reshaped = [reshape(mot) for mot in mots]
texte_final = " ".join(mots_reshaped)

mots_vides = {
    "من", "في", "على", "إلى", "عن", "مع", "أن", "كان",
    "هذا", "هذه", "تم", "هو", "هي", "ذلك", "تلك"
}

wc = WordCloud(
    width=1200,
    height=700,
    background_color="white",
    font_path=police,
    stopwords=mots_vides,
    collocations=False,
    prefer_horizontal=1.0
)

wc.generate(texte_final)
wc.to_file(image_sortie)

