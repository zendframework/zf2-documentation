.. EN-Revision: none
.. _learning.lucene.index-structure:

Structure d'index Lucene
========================

Afin d'utiliser l'intégralité des fonctionnalités de ``Zend_Search_Lucene`` avec un maximum de performances, il
est nécessaire que vous compreniez la structure interne d'un index.

Un **index** est stocké dans un ensemble de fichier au sein d'un seul répertoire.

Un **index** est un ensemble indépendant de **segments** dans lesquels sont stockées des informations au sujet
d'un sous-ensemble de documents indexés. Chaque **segment** a son propre **dictionnaire de terme**, son propre
index de dictionnaire de terme, et son propre stockage de document (valeur de champ stocké) [#]_. Toutes les
informations de segments sont stockées dans un fichier ``_xxxxx.cfs``, où **xxxxx** est le nom d'un segment.

Dès qu'un fichier de segment d'index est créé, il ne peut être mis à jour. De nouveaux documents sont ajoutés
à de nouveaux segments. Les documents supprimés sont seulement marqués comme supprimés dans un fichier
facultatif ``<segmentname>.del``.

La mise à jour de document est effectuée en tant qu'opérations distincts de suppression et d'ajout, même si
elle est effectuée en utilisant un appel à l'*API* ``update()`` [#]_. Ceci simplifie l'ajout de nouveaux
documents, et permet de mettre à jour simultanément à l'aide des opérations de recherche.

D'un autre coté, utiliser plusieurs segments (avoir un document par segment est un cas exceptionnel) augmente le
temps de recherche :

- La récupération d'un terme depuis le dictionnaire est effectué pour chaque segment ;

- Le dictionnaire de terme de l'index est préchargé pour chaque segment (ce processus occupe la plupart du temps
  de recherche pour de simples requêtes et nécessite aussi de la mémoire supplémentaire).

Si les termes du dictionnaires de recherche atteignent un point de saturation, la recherche à travers un segment
est **N** fois plus rapide que la recherche à travers **N** segments dans la plupart des cas.

**L'optimisation d'index** fusionne deux segments ou plus en un segment unique. Un nouveau segment est ajouté à
la liste des segments de l'index, et les anciens segments sont exclus.

La mise à jour de la liste de segments s'effectue de manière atomique. Ceci donne la capacité d'ajouter de
nouveaux documents simultanément, d'effectuer des optimisations d'index, et de chercher à travers l'index.

L'auto-optimisation d'index s'effectue après chaque génération de segment. Elle fusionne l'ensemble des plus
petits segments en des segments plus grands, et les segments plus grands en des segments encore plus grands, si
nous avons suffisamment de segments à fusionner.

L'auto optimisation d'index est contrôlé par trois options :

- **MaxBufferedDocs** (Le nombre minimal de documents requis avant que les documents mis en mémoire tampon soit
  écrits dans un nouveau segment) ;

- **MaxMergeDocs** (Le plus grand nombre de documents fusionnés par une opération d'optimisation) ; et

- **MergeFactor** (qui détermine la fréquence à laquelle les indices de segments sont fusionnés par les
  opérations d'auto-optimisation).

Si nous ajoutons un documents par exécution de script, **MaxBufferedDocs** n'est finalement pas utilisé (seul un
segment avec un seul document est créé à la fin de l'exécution du script, moment auquel démarre le processus
d'auto-optimisation).



.. [#] Depuis Lucene 2.3, les fichiers de stockage de document peuvent être partagés entre les segments;
       cependant, ``Zend_Search_Lucene`` n'utilise pas cette possibilité
.. [#] Cet appel est fourni uniquement par Java Lucene pour le moment, mais il est prévu d'étendre l'*API*
       ``Zend_Search_Lucene`` avec une fonctionnalité similaire