# PPE_2526_ProjetFinal

#J'ai terminé les tableaux pour la langue japonaise. Ils se composent de 8 colonnes chacun: le numéro de ligne, le code HTTP, l'url, 
l'encodage, le nombre d'occurences, le HTML brut, le DUMP textuel ainsi que le concordancier HTML. Il y a 2 tableaux pour les
traductions japonaise du mot espoir: 希望(kibō) et 期待(kitai). Pour chaque tableau, il y a 30 urls, ce qui nous fait un total de 60 urls
pour la langue japonaise.(Vianney)

#J'ai réalisé une première version du site à l'aide de BULMA CSS. J'ai créé les différentes pages que je vais remplir au fur et à mesure.
J'y ai intégré les tableaux pour la langue japonaise.

#J'ai déployé le site via GitHub pour voir si tout fonctionne correctement.

#  Partie Arabe (ABDERRAHMANE Kaouther):

#  Construction du Corpus Arabe (Mot : أمل - Espoir)

Ma démarche a débuté par une phase de recherche intensive pour sélectionner des URLs arabes pertinentes (50) traitant du concept de l'espoir (أمل). En m'appuyant sur la méthodologie du projet, j'ai conçu un premier script Bash (script_arabe.sh)destiné à automatiser la génération d'un tableau HTML. Ce script devait initialement regrouper les métadonnées essentielles, comme le code HTTP et l'encodage, tout en effectuant les premiers traitements textuels tels que le comptage des occurrences et l'extraction de contextes.

Cependant, les premiers tests ont révélé des erreurs critiques qui empêchaient le bon fonctionnement du processus. Le tableau généré affichait systématiquement des messages de type No such file or directory ainsi que des codes HTTP 000. Après analyse, j'ai compris que ces échecs provenaient de deux lacunes majeures : d'une part, l'absence de création automatique de l'arborescence des dossiers (aspirations/, dumps-text/, etc.) directement dans le script, et d'autre part, le blocage des requêtes curl par certains serveurs. Ces derniers refusaient l'accès car ma commande ne précisait pas d'identifiant de navigateur (User-Agent), rendant toute aspiration ou analyse ultérieure impossible.

Pour stabiliser le traitement et fiabiliser les résultats, j'ai apporté des modifications structurelles importantes à mon script. J'ai d'abord intégré la commande mkdir -p pour garantir que l'environnement de travail et tous les répertoires nécessaires soient prêts avant le lancement de l'aspiration. Ensuite, j'ai configuré curl avec un User-Agent (Mozilla/5.0) afin de simuler une navigation humaine, ce qui a permis de transformer les erreurs en succès (codes 200) pour la quasi-totalité de mon corpus. Enfin, j'ai mis en place un traitement conditionnel pour que les outils linguistiques comme lynx ou grep ne s'exécutent que si le fichier a été correctement téléchargé, évitant ainsi de polluer le tableau avec des messages d'erreur.

Grâce à ces optimisations, j'ai obtenu un tableau final structuré et parfaitement fonctionnel "arabe.html ". Il se compose de 9 colonnes (N°, URL, Code HTTP, Encodage, Occurrences, Aspiration, Dump, Contexte et Concordancier), respectant ainsi scrupuleusement les consignes du projet tout en offrant une interface de navigation fluide pour l'analyse linguistique du mot "espoir" dans le web arabophone.

 # Analyse Quantitative et Textométrie (Scripts PALS):
 
#  Préparation du corpus pour PALS

Pour passer à l'analyse statistique, j'ai dû reformater l'ensemble de mon corpus (dumps et contextes) afin de le rendre lisible par les scripts PALS (Python Autonomous Lafon Specificity). J'ai conçu le script make_pals_corpus.sh qui automatise deux tâches essentielles :

L'unification des données: Le script itère sur chaque fichier (1 par URL) pour créer un fichier consolidé unique par langue dans le dossier pals.

La tokenisation : Conformément au format attendu par l'outil, j'ai programmé une segmentation du texte pour obtenir un mot par ligne, tout en nettoyant la ponctuation pour ne pas fausser les calculs de fréquence.
Exploration statistique et spécificité

Une fois les données préparées, j'ai utilisé l'outil cooccurrents.py pour effectuer une analyse de spécificité de Lafon. Cette méthode mesure la fréquence d'apparition d'un terme dans les contextes du mot pôle (أمل) par rapport à sa fréquence dans le corpus global.

Le résultat obtenu sous forme de tableau TSV (Tab-Separated Values) m'a permis d'identifier les termes les plus significatifs associés à l'espoir. Par exemple, le calcul de l'indice de spécificité a mis en avant des cooccurrents forts, révélant la richesse sémantique du mot dans le web arabophone. Cette étape technique, bien que chronophage, a été indispensable pour passer d'une simple lecture de textes à une véritable analyse scientifique de l'environnement lexical de mon mot cible.

# Synthèse Visuelle et Analyse Sémantique (Wordcloud):

La génération du nuage de mots via le script generer_wordcloud.py m'a permis de transformer mes données textuelles en une synthèse graphique immédiate. Ce n'est pas seulement une image, mais une véritable carte sémantique qui valide mes calculs de spécificité : la taille des mots confirme que pour le concept أمل (espoir), les thématiques de la vie (الحياة) et de la spiritualité (الله, الإيمان) sont statistiquement les plus dominantes dans mon corpus.

Linguistiquement, ce résultat démontre que l'espoir dans le web arabophone est perçu comme une force vitale indissociable de la foi et de l'action (العمل). Le nuage de mots sert ainsi de preuve visuelle pour conclure que le terme dépasse la simple émotion pour devenir un moteur de résilience face aux difficultés.



