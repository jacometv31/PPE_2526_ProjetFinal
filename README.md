# PPE_2526_ProjetFinal

#J'ai terminé les tableaux pour la langue japonaise. Ils se composent de 8 colonnes chacun: le numéro de ligne, le code HTTP, l'url, 
l'encodage, le nombre d'occurences, le HTML brut, le DUMP textuel ainsi que le concordancier HTML. Il y a 2 tableaux pour les
traductions japonaise du mot espoir: 希望(kibō) et 期待(kitai). Pour chaque tableau, il y a 30 urls, ce qui nous fait un total de 60 urls
pour la langue japonaise.(Vianney)

#J'ai réalisé une première version du site à l'aide de BULMA CSS. J'ai créé les différentes pages que je vais remplir au fur et à mesure.
J'y ai intégré les tableaux pour la langue japonaise.

#J'ai déployé le site via GitHub pour voir si tout fonctionne correctement.

#  Partie Arabe (ABDERRAHMANE Kaouther):

#  Avant-propos : Méthode de travail et organisation

  J'ai fait le choix de ne pas rédiger ce journal de bord au fur et à mesure de l'avancement du projet. En effet, j'ai préféré me concentrer pleinement sur le développement technique dans mon dossier local afin de m'assurer que l'intégralité du code et des analyses soit parfaitement fonctionnelle avant toute publication. Une fois le projet terminé et stabilisé, j'ai effectué un « push » global pour soumettre l'ensemble de mon travail. Ce journal a donc été rédigé a posteriori pour synthétiser avec recul les étapes clés de ma progression.

J'espère que ce travail reflète avec précision l'investissement fourni et la rigueur apportée à chaque étape. Je vous souhaite une excellente lecture.

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

# Analyse Textométrique avec iTrameur :

L'importation de mon corpus dans iTrameur a permis de valider une base de données solide de 96 269 occurrences et 25 897 formes uniques. L'examen du dictionnaire a révélé la place centrale du mot pivot الأمل (l'espoir) avec 1 429 occurrences, tout en mettant en lumière une grande richesse morphologique à travers ses variantes préfixées comme والأمل ou بالأمل. Cette étape confirme que le concept d'espoir est au cœur de structures syntaxiques variées dans le web arabophone.

L'étude des cooccurrences et du réseau sémantique a ensuite démontré un lien statistique très fort entre l'espoir et l'optimisme (والتفاؤل), ainsi qu'une proximité avec les concepts de vie (الحياة) et de foi (بالله). Ces associations, validées par un retour direct au texte via le concordancier, montrent que l'espoir est systématiquement intégré à une dynamique positive. Enfin, l'analyse de la ventilation a révélé que, bien que la première section soit la plus fournie, c'est la section s6 qui présente l'indice de spécificité le plus élevé, désignant cette source comme la plus thématique pour mon étude.

# Conformité Éthique et Respect du fichier Robots.txt

L'étape finale de mon projet a consisté à intégrer une dimension éthique au moissonnage en veillant au respect des directives émises par les serveurs distants via leurs fichiers robots.txt respectifs. Pour automatiser ce contrôle, j'ai utilisé un premier script, generer_blacklist.sh, qui parcourt les serveurs de mon corpus pour identifier les zones interdites aux robots (directive Disallow sous le User-Agent: *). Les résultats de cette analyse sont consignés dans un fichier de référence locale nommé arabe.txt-blacklist.

Pour mettre en évidence cette vérification, j'ai créé un second tableau de bord dédié grâce au script script_arabe_robots.sh. Ce dernier consulte systématiquement le fichier arabe.txt-blacklist pour chaque URL : les adresses autorisées apparaissent en vert, tandis que celles figurant dans la blacklist sont marquées en rouge avec le statut "Interdit" et un code HTTP 000. Afin de valider la fiabilité de mon système, j'ai inclus un test avec une URL sciemment choisie dans une zone interdite, confirmant ainsi que le script bloque correctement l'accès conformément aux règles du web.

Cette double approche illustre la transition entre un moissonnage brut et un moissonnage responsable. Elle démontre ma capacité à adapter mes outils techniques aux contraintes éthiques et légales, garantissant que le corpus final est non seulement riche linguistiquement, mais aussi constitué dans le respect total des volontés des administrateurs des sites sources.

# Finalisation et Design de l'Interface Web

La présentation finale de nos résultats a été l'occasion pour moi de prendre en charge l'aspect visuel et l'ergonomie de notre site web. Mon objectif principal était de transformer la structure existante pour en faire une plateforme élégante, moderne et parfaitement lisible. Pour y parvenir, j'ai intégré le framework CSS Bulma, ce qui m'a permis de structurer les contenus avec des composants réactifs, des boutons stylisés et des cartes de présentation claires pour chaque langue.

J'ai personnellement conçu et organisé les nouvelles sections du site afin d'y intégrer mes propres travaux de manière fluide. J'ai notamment créé des espaces dédiés pour l'affichage des nuages de mots ainsi que pour les tableaux de conformité éthique, assurant une navigation intuitive entre les données brutes et les visualisations. Ce travail sur l'interface permet de valoriser la rigueur de nos analyses textométriques à travers un design professionnel, offrant ainsi une expérience utilisateur soignée qui facilite la compréhension globale du projet.




#### Partie Français

Mot étudié : espoir 

1. Au début du projet, l’objectif principal était d’étudier un mot sur le Web à travers une approche combinant la récolte des pages web, extraction linguistique et visualisation des résultats. 

2. Constitution du corpus d’URLs

La première étape a consisté à constituer une liste d’URLs pertinentes contenant le mot espoir. J’ai sélectionné environ cinquante pages issues de sources variées (articles de presse, sites institutionnels, revues académiques, sites religieux et culturels). Cette diversité permettait d’obtenir un corpus représentatif de différents usages discursifs du mot. Les URLS ont été regroupées dans un fichier texte servant d’entrée au script principal. je tiens à signaler que la récolte a été basée sur le fait que chaque page doit contenir au moins 2 occurences du mot espoir 

3. Aspiration des pages web 

Une fois les URLS identifiées j’ai procédé au téléchargement des pages HTML à l’aide de la commande curl ou chaque page a été sauvegardée localement dans un dossier dédié aux aspirations. Pour chaque URL, le code HTTP retourné par le serveur a été enregistré afin de vérifier le succès du téléchargement et de documenter les éventuelles erreurs.
Par contre je veux signaler que lors de la récolte et prés la première aspiration je suis tombé sur plus de 5 URLS qui que le scrit ne pouvait pas traiter puisq'il affiche "erreur" , j'ai du les changer pour pouvoir continuer le reste du travail.

4. Gestion de l’encodage et extraction du texte

Les pages HTML récupérées présentaient des encodages variés, jai donc intégré une détection automatique de l’encodage à l’aide de la commande file, suivie d’une conversion en UTF-8 lorsque cela était nécessaire grâce à iconv. Le texte brut a ensuite été extrait à partir du HTML avec lynx, en supprimant les liens inutiles. Cette étape était essentielle pour garantir l’homogénéité du corpus textuel et permettre les traitements linguistiques ultérieurs. Le fait de rajouter l'option de conversion a été utile comme le montre l'url  numéro 4 ou l'encodage de base était asci ensuite il a été converti grace à iconv en utf8.

5. Comptage des occurrences du mot espoir

À partir des fichiers texte nettoyés j’ai procédé au comptage des occurrences du mot espoir et de ses variantes morphologiques à l’aide d’expressions régulières ( pour pouvoir matcher les différentes variantes du mmot espoir) . Ce comptage a permis d’obtenir une première mesure quantitative de la présence du mot dans chaque document, puis les résultats ont été intégrés au tableau HTML final, offrant une vue synthétique du poids du mot dans chaque source.

6. Extraction des contextes

Pour analyser le mot étudié dans son environneemnt, j’ai extrait les contextes d’apparition de espoir en conservant plusieurs lignes avant et après chaque occurrence. Ces contextes ont été stockés dans des fichiers spécifiques (contextes). Cette étape m’a permis d’observer les usages discursifs du mot, les thèmes récurrents et les constructions syntaxiques associées.

7. Création des concordances

À partir des textes complets, j’ai construit des concordances. Chaque occurrence de espoir a été affichée dans un tableau avec un contexte gauche et un contexte droit de taille fixe. Les concordances ont été mises en forme dans des fichiers HTM facilitant leur lecture et leur exploitation. 

8. Analyse des cooccurrences et spécificité de Lafon

J’ai ensuite travaillé sur les cooccurrences du mot espoir en analysant les mots apparaissant fréquemment dans son voisinage, pour dépasser une simple liste de fréquences, j’ai utilisé la mesure de spécificité de Lafon, il s'agit du script python (cooccurents.py) qui nous a été recomandé, je l'ai récupéré pui je l'ai lancé sur mon corpus , le résultat était sous forme de tableau tsv ce qui a permis de mette en évidence les mots statistiquement sur-représentés autour du terme étudié. Cette analyse a permis d’identifier des associations lexicales fortes et de dégager le champ sémantique dominant lié à espoir.

9. Génération du nuage de mots
Concernant le nuage de mots je tiens à signaler que j'ai eu l'dée de faire deux nuages de mots, le premier à partir du tableau tsv 'spécificité de Lafon puisque il me parait plus plausible pour éviter les mots insensés autour du mot central "espoir" 
Le second nuage de mot a été fait à partir des contextes, ce qui a donné un résultat moins précis, je trouve, par rapport au premier 

10. Construction du tableau HTML récapitulatif

L’ensemble des résultats (URL, autorisation robots.txt, code HTTP, encodage, nombre d’occurrences, liens vers les fichiers générés) a été regroupé dans un tableau HTML automatiquement généré par le script principal. Ce tableau sert de point d’entrée vers l’ensemble des données produites et garantit la traçabilité du traitement pour chaque URL.

11. Mise en ligne et intégration au site du projet

Enfin, les résultats (tableaux, nuages de mots, analyses) ont été intégrés au site web du projet commun avec mes collègues. Une section spécifique a été consacrée à mon travail sur le mot espoir en français, permettant de présenter de manière claire et structurée les différentes analyses réalisées.
