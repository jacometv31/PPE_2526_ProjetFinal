
# Nuage de mots à partir des cooccurrents.py (le tableau tsv dans pals) 

import csv
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# -------- PARAMÈTRES --------
INPUT_FILE = "pals/espoir-cooccurrents.tsv"
OUTPUT_IMAGE = "pals/nuage_espoir.png"
MAX_WORDS = 100

# Lecture du tsv
frequencies = {}

with open(INPUT_FILE, encoding="utf-8") as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        token = row["token"]
        specificity = float(row["specificity"])

        # On ne garde que les spécificités positives
        if specificity > 0:
            frequencies[token] = specificity

wordcloud = WordCloud(
    width=1000,
    height=600,
    background_color="white",
    max_words=MAX_WORDS,
    colormap="viridis"
).generate_from_frequencies(frequencies)

plt.figure(figsize=(12, 7))
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.title("Nuage de mots – cooccurrents de « espoir »", fontsize=16)

plt.savefig(OUTPUT_IMAGE)
plt.show()

print(f"Nuage de mots enregistré dans : {OUTPUT_IMAGE}")
