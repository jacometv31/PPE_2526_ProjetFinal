python3 ./cooccurrents.py contexte_corpus.txt --target "希望" > ../tableaux/tableau_contexte1.tsv

python3 ./cooccurrents.py contexte2_corpus.txt --target "期待" > ../tableaux/tableau_contexte2.tsv

python3 ./partition.py -i contexte_corpus.txt -i contexte2_corpus.txt > ../tableaux/tableau_comparaison.tsv
