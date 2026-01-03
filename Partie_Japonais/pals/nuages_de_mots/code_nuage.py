import os
import requests
import zipfile
from janome.tokenizer import Tokenizer
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# -----------------------------
# 1️⃣ Paramètres
# -----------------------------
TEXT_FILE = "texte_japonais.txt"
FONT_DIR = "fonts"
FONT_ZIP_URL = "https://moji.or.jp/wp-content/ipafont/IPAexfont/ipaexg00401.zip"
FONT_ZIP_PATH = os.path.join(FONT_DIR, "ipaexg.zip")
FONT_PATH = os.path.join(FONT_DIR, "ipaexg00401", "ipaexg.ttf")


# -----------------------------
# 2️⃣ Télécharger la police si nécessaire
# -----------------------------
def download_font():
    if not os.path.exists(FONT_PATH):
        print("📥 Téléchargement de la police japonaise...")
        os.makedirs(FONT_DIR, exist_ok=True)

        response = requests.get(FONT_ZIP_URL)
        with open(FONT_ZIP_PATH, "wb") as f:
            f.write(response.content)

        with zipfile.ZipFile(FONT_ZIP_PATH, "r") as zip_ref:
            zip_ref.extractall(FONT_DIR)

        print("✅ Police téléchargée et extraite")
    else:
        print("✔ Police déjà disponible")

download_font()

# -----------------------------
# 3️⃣ Lire le fichier texte japonais
# -----------------------------
with open("contexte_nettoye.txt", "r", encoding="utf-8") as f:
    texte = f.read()
    
t = Tokenizer()

mots = [
    token.surface
    for token in t.tokenize(texte)
    if token.part_of_speech.startswith("名詞")
]

texte_segmente = " ".join(mots)

# -----------------------------
# 5️⃣ Générer le WordCloud
# -----------------------------
wordcloud = WordCloud(
    font_path=FONT_PATH,
    background_color="white",
    width=900,
    height=450,
    max_words=200
).generate(texte_segmente)

# -----------------------------
# 6️⃣ Affichage
# -----------------------------
plt.figure(figsize=(12, 6))
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.show()

# -----------------------------
# 7️⃣ Sauvegarde
# -----------------------------
wordcloud.to_file("nuage_japonais.png")
print("🖼 Nuage de mots sauvegardé : nuage_japonais.png")
