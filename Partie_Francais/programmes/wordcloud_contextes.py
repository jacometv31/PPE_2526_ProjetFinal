#!/usr/bin/env python3


from collections import Counter
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from pathlib import Path


INPUT_FILE = Path("pals/contextes-fr.txt")
OUTPUT_IMAGE = Path("pals/nuage-espoir-contextes.png")

TARGET = "espoir"


tokens = []

with open(INPUT_FILE, encoding="utf-8") as f:
    for line in f:
        token = line.strip().lower()
        if not token:
            continue
        tokens.append(token)


frequencies = Counter(tokens)

if TARGET in frequencies:
    frequencies[TARGET] *= 3  
else:
    print(f"Attention : le mot '{TARGET}' n'apparaît pas dans le corpus.")

wordcloud = WordCloud(
    width=1200,
    height=800,
    background_color="white",
    max_words=150,
    colormap="plasma"
).generate_from_frequencies(frequencies)


plt.figure(figsize=(12, 8))
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")

OUTPUT_IMAGE.parent.mkdir(exist_ok=True)
plt.savefig(OUTPUT_IMAGE, dpi=300, bbox_inches="tight")
plt.close()

print(f" Nuage de mots généré : {OUTPUT_IMAGE}")

