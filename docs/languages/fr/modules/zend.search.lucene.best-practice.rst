.. _zend.search.lucene.best-practice:

Bonnes pratiques
================

.. _zend.search.lucene.best-practice.field-names:

Nommage des champs
------------------

Il n'y a pas de limitation pour les noms de champs dans ``Zend_Search_Lucene``.

Cependant, il est préférable de ne pas utiliser les noms '**id**' et '**score**' afin d'éviter toute ambiguïté
dans les propriétés de *QueryHit*.

Les propriétés *id* et *score* de ``Zend_Search_Lucene_Search_QueryHit`` font toujours référence à
l'identifiant interne du document Lucene et au :ref:`score <zend.search.lucene.searching.results-scoring>` de hit.
Si le document indexé possède les mêmes champs stockés, vous devrez utiliser la méthode ``getDocument()`` pour
y accéder :

   .. code-block:: php
      :linenos:

      $hits = $index->find($query);

      foreach ($hits as $hit) {
          // Récupérer le champ de document 'title'
          $title = $hit->title;

          // Récupérer le champ de document 'contents'
          $contents = $hit->contents;

          // Récupérer l'id interne du document Lucene
          $id = $hit->id;

          // Récupérer le score de hit
          $score = $hit->score;

          // Récupérer le champ de document 'id'
          $docId = $hit->getDocument()->id;

          // Récupérer le champ de document 'score'
          $docId = $hit->getDocument()->score;

          // Un autre moyen de récupérer le champ 'title'
          $title = $hit->getDocument()->title;
      }



.. _zend.search.lucene.best-practice.indexing-performance:

Performance de l'indexation
---------------------------

La performance de l'indexation est un compromis entre les ressources utilisées, le temps d'indexation et la
qualité de l'index.

La qualité de l'index est complètement déterminée par le nombre de segments de l'index.

Chaque segment d'index et une portion de données entièrement indépendante. Ainsi plus un index contient de
segments, plus il sera gourmand en mémoire et en temps de calcul lors de la recherche.

L'optimisation d'index est un processus consistant à fusionner plusieurs segments en un seul nouveau segment. Un
index totalement optimisé ne contient qu'un seul segment.

L'optimisation complète de l'index peut être effectuée avec la méthode ``optimize()``:

   .. code-block:: php
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      $index->optimize();



L'optimisation d'index fonctionne avec des "data streams" et ne consomme pas pas une grande quantité de mémoire,
mais nécessite des ressources de processeur et du temps.

Par nature, les segments d'index de Lucene ne peuvent pas être mis à jour (l'opération de mise à jour
nécessite une réécriture complète du segment). Ainsi, l'ajout de nouveau(x) document(s) à un index implique
toujours la génération d'un nouveau segment. De fait, cela dégrade la qualité de l'index.

Une optimisation automatique d'un index est effectuée après chaque génération de segment et consiste en la
fusion des segments partiels.

Il y a trois options pour contrôler le comportement de l'auto-optimisation (voir la section :ref:`Optimisation
d'index <zend.search.lucene.index-creation.optimization>`) :

   - **MaxBufferedDocs** représente le nombre maximum de documents qui peuvent être mis en mémoire tampon avant
     qu'un nouveau segment soit généré et écrit sur le disque dur.

   - **MaxMergeDocs** représente le nombre maximum de documents qui seront fusionnés dans un nouveau segment lors
     du processus d'auto-optimisation.

   - **MergeFactor** détermine à quelle fréquence l'auto-optimisation est effectuée.



   .. note::

      Toutes ces options sont des propriétés de la classe ``Zend_Search_Lucene``, pas des propriétés d'index.
      Elles n'affectent que les instances de ``Zend_Search_Lucene`` et peuvent varier selon les scripts.



**MaxBufferedDocs** n'a aucun effet si vous n'indexez qu'un seul document par exécution de script. En revanche, il
est très important pour les indexations massives ("batch indexing"). Plus sa valeur est élevée, meilleures
seront les performances d'indexation, mais plus la consommation de mémoire sera importante.

Il n'existe pas de manière simple de calculer la meilleure valeur pour le paramètre **MaxBufferedDocs** car cela
dépend de la taille moyenne des documents, de l'analyseur utilisé et de la mémoire disponible.

Une bonne méthode pour trouver une valeur correcte consiste à effectuer plusieurs tests avec les documents les
plus volumineux que vous vous attendez à voir figurer dans l'index. [#]_. Une bonne pratique consiste à ne pas
utiliser plus de la moitié de la mémoire allouée.

**MaxMergeDocs** limite la taille d'un segment (en termes de nombre de documents). De ce fait, il limite également
la durée de l'auto-optimisation en garantissant que la méthode ``addDocument()`` ne sera pas exécutée plus d'un
certain nombre de fois. C'est très important dans le cadre d'applications interactives.

Diminuer la valeur du paramètre **MaxMergeDocs** peut aussi améliorer les performances lors de l'indexation en
masse ("batch indexing"). L'auto-optimisation est un processus itératif et utilise une technique ascendante. Les
petits segments sont fusionnés vers de plus gros segments qui sont eux-mêmes fusionnés vers des segments encore
plus gros, etc. L'optimisation complète est achevée lorsqu'il ne reste qu'un seul gros segment.

De petits segments détériore généralement la qualité de l'index. Un grand nombre de petits segments peut aussi
déclencher l'erreur "Too many open files" déterminée par les limitations du système d'exploitation [#]_.

En général, l'optimisation d'index en arrière-plan devrait être effectuée pour les modes d'indexation
interactifs et la valeur de **MaxMergeDocs** ne devrait pas être trop faible pour les indexations de masse ("batch
indexing").

**MergeFactor** affecte la fréquence d'auto-optimisation. De faibles valeurs augmenteront la qualité des index
non-optimisés. Des valeurs plus importantes amélioreront les performances de l'indexation, mais également le
nombre de segments fusionnés. Ce qui peut également déclencher l'erreur "Too many open files".

**MergeFactor** groupe les segments d'index par leur taille :

   . Pas plus grand que **MaxBufferedDocs**.

   . Plus grand que **MaxBufferedDocs**, mais pas plus grand que **MaxBufferedDocs**\ * **MergeFactor**.

   . Plus grand que **MaxBufferedDocs**\ * **MergeFactor**, mais pas plus grand que **MaxBufferedDocs**\ *
     **MergeFactor**\ * **MergeFactor**.

   . ...



``Zend_Search_Lucene`` vérifie à chaque appel de ``addDocument()`` si la fusion de n'importe quel segment pour
déplacer le segment nouvellement créé dans le groupe suivant. Si c'est le cas, la fusion est effectuée.

Ainsi, un index avec N groupes peut contenir **MaxBufferedDocs** + (N-1)* **MergeFactor** segments et contient au
moins **MaxBufferedDocs**\ * **MergeFactor** :sup:`(N-1)`  documents.

La formule ci-dessous donne une bonne approximation du nombre de segments dans un index :

**Nombre de segments** <= **MaxBufferedDocs** + **MergeFactor**\ *log **MergeFactor** (**Nombre de
documents**/**MaxBufferedDocs**)

**MaxBufferedDocs** est déterminé par la mémoire allouée. Cela permet pour le facteur de fusion (MergeFactor)
approprié d'avoir un nombre raisonnable de segments.

L'optimisation du paramètre **MergeFactor** est plus efficace pour les performances de l'indexation de masse
(batch indexing) que **MaxMergeDocs**. Mais cette méthode manque un peu de finesse. Le mieux est d'utiliser
l'estimation ci-dessus pour optimiser **MergeFactor**, puis de jouer avec **MaxMergeDocs** pour obtenir les
meilleures performances d'indexation de masse (batch indexing).

.. _zend.search.lucene.best-practice.shutting-down:

Indexation à l'arrêt du programme
---------------------------------

L'instance de ``Zend_Search_Lucene`` effectue quelques tâches à la sortie du programme si des documents ont été
ajoutés à l'index mais pas écrits dans un nouveau segment.

Elle peut également déclencher le processus d'auto-optimisation.

L'objet qui représente l'index est automatiquement fermé lorsque lui, ainsi que tous les objets de résultats de
requête qui lui sont associés, sont hors de portée du script principal.

Si l'objet d'index est stocké dans une variable globale, il ne sera fermé qu'à la fin de l'exécution du script
[#]_.

Le processus d'exception de *PHP* est également fermé à ce moment.

Cela n'empêche pas la fermeture normale du processus de l'index, mais cela peut empêcher un diagnostic d'erreur
précis si une erreur survient durant la fermeture.

Il y a deux moyens qui peuvent permettre d'éviter ce problème.

Le premier est de forcer l'index à sortir de la portée (du scope) :

   .. code-block::
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      ...

      unset($index);



Le second est d'effectuer une opération de commit avant la fin du script exécution :

   .. code-block:: php
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      $index->commit();

Cette possibilité est également décrite dans la section ":ref:`Avancé - Utiliser les propriétés statiques de
l'index <zend.search.lucene.advanced.static>`".

.. _zend.search.lucene.best-practice.unique-id:

Récupération de documents par leur id unique
--------------------------------------------

C'est une pratique commune de stocker un identifiant unique de document dans l'index. Par exemple, une url, un
chemin ou un identifiant tiré d'une base de données.

``Zend_Search_Lucene`` fournit une méthode ``termDocs()`` pour récupérer des documents contenant les termes
spécifiés.

C'est plus efficace que d'utiliser la méthode ``find()``:

   .. code-block::
      :linenos:

      // Récupération de documents avec la méthode find()
      // en utilisant une querystring
      $query = $idFieldName . ':' . $docId;
      $hits  = $index->find($query);
      foreach ($hits as $hit) {
          $title    = $hit->title;
          $contents = $hit->contents;
          ...
      }
      ...

      // Récupération de documents avec la méthode find()
      // en utilisant l'API de requête.
      $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
      $query = new Zend_Search_Lucene_Search_Query_Term($term);
      $hits  = $index->find($query);
      foreach ($hits as $hit) {
          $title    = $hit->title;
          $contents = $hit->contents;
          ...
      }

      ...

      // Récupération de documents avec la méthode termDocs()
      $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
      $docIds  = $index->termDocs($term);
      foreach ($docIds as $id) {
          $doc = $index->getDocument($id);
          $title    = $doc->title;
          $contents = $doc->contents;
          ...
      }



.. _zend.search.lucene.best-practice.memory-usage:

Utilisation de la mémoire
-------------------------

``Zend_Search_Lucene`` est un module relativement gourmand en mémoire.

Il utilise la mémoire pour mettre en cache certaines informations et optimiser la recherche, ainsi que les
performances de l'indexation.

La mémoire requise diffère selon les modes.

L'index du dictionnaire des termes est chargé durant la recherche. Il s'agit de chaque 128\ :sup:`ème`  [#]_
terme du dictionnaire complet.

De fait, la consommation de mémoire augmente si vous avez un grand nombre de termes uniques. Cela peut arriver si
vous utilisez des phrases non "tokenizées" comme champ de recherche ou que vous indexez un large volume
d'informations non-textuelles.

Un index non-optimisé consiste en plusieurs segments. Cela augmente également l'utilisation de mémoire. Les
segments étant indépendants, chacun possède son propre dictionnaire de termes et index de dictionnaire de
termes. Si un index consiste en **N** segments, il risque, dans le pire des cas, de multiplier par **N** la
consommation de mémoire. Lancez l'optimisation de l'index en fusionnant tous les segments afin d'éviter de telles
consommations de mémoire.

L'indexation utilise la même quantité de mémoire que la recherche, plus de la mémoire pour mettre les documents
en tampon. La quantité de mémoire peut être gérée par le paramètre **MaxBufferedDocs**.

L'optimisation d'index (complète ou partielle) utilise un processus de type flux ("streaming") et ne requiert pas
une grosse quantité de mémoire.

.. _zend.search.lucene.best-practice.encoding:

Encodage
--------

``Zend_Search_Lucene`` travaille avec des chaînes en UTF-8 en interne. Ainsi toutes les chaînes de caractères
retournée par ``Zend_Search_Lucene`` sont encodées en UTF-8.

Vous ne devriez pas être concernés par l'encodage si vous travaillez avec des chaîne purement *ASCII*, mais vous
devez être prudent si ce n'est pas le cas.

Un mauvais encodage peut causer des notices (erreur) durant la conversation d'encodage, voire la perte de données.

``Zend_Search_Lucene`` offre un large éventail de possibilités d'encodage pour les documents indexés et les
requêtes analysées.

L'encodage peut être explicitement spécifié en passant un paramètre optionnel à la méthode de création d'un
champ :

   .. code-block:: php
      :linenos:

      $doc = new Zend_Search_Lucene_Document();
      $doc->addField(Zend_Search_Lucene_Field::Text('title',
                                                    $title,
                                                    'iso-8859-1'));
      $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                        $contents,
                                                        'utf-8'));

C'est le meilleur moyen d'éviter toute ambiguïté dans les encodages utilisés.

Si le paramètre optionnel de l'encodage est omis, la locale courante est utilisée. La locale courante peut
contenir des données d'encodage en plus des spécification de langue :

   .. code-block:: php
      :linenos:

      setlocale(LC_ALL, 'fr_FR');
      ...

      setlocale(LC_ALL, 'de_DE.iso-8859-1');
      ...

      setlocale(LC_ALL, 'ru_RU.UTF-8');
      ...



La même approche est utilisée pour définir l'encodage des chaînes de requête.

Si l'encodage n'est pas spécifié, la locale courante est utilisée pour le déterminer.

L'encodage peut être passée comme paramètre optionnel si la requête est analysée explicitement avant la
recherche :

   .. code-block:: php
      :linenos:

      $query =
          Zend_Search_Lucene_Search_QueryParser::parse($queryStr, 'iso-8859-5');
      $hits = $index->find($query);
      ...



L'encodage par défaut peut également être spécifié avec la méthode ``setDefaultEncoding()``:

   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-1');
      $hits = $index->find($queryStr);
      ...
       chaîne vide sous-entend "locale courante".



Si l'encodage correct est spécifié, il pourra être correctement interprété par l'analyseur. Le comportement
dépend de quel analyseur est utilisé. Consultez la section sur les :ref:`Jeu de caractères
<zend.search.lucene.charset>` pour plus de détails.

.. _zend.search.lucene.best-practice.maintenance:

Maintenance de l'index
----------------------

Il devrait être clair que ``Zend_Search_Lucene`` comme toute autre implémentation de Lucene ne comporte pas de
"base de données".

Les index ne devrait pas être utilisés pour du stockage de données. Ils ne fournissent pas de fonctionnalités
de backup/restauration partiel, journalisation, logs, transactions et beaucoup d'autres fonctionnalités
assimilées aux systèmes de gestion de bases de données.

Cependant, ``Zend_Search_Lucene`` tente de garder ses index dans un état constant en tout temps.

Le backup et la restauration d'un index devrait être effectué en copiant le contenu du répertoire de l'index.

Si pour une raison quelconque, un index devait être corrompu, il devrait être restauré ou complètement
reconstruit.

C'est donc une bonne idée de faire des backups des gros index et de stocker les logs de modifications pour pouvoir
effectuer des restaurations manuelles et des opérations de "roll-forward" si nécessaire. Cette pratique réduit
considérablement le temps de restauration.



.. [#] ``memory_get_usage()`` et ``memory_get_peak_usage()`` peuvent être utilisées pour contrôler l'utilisation
       de la mémoire.
.. [#] ``Zend_Search_Lucene`` maintient chaque segment ouvert pour améliorer les performances de recherche.
.. [#] Cela peut aussi se produire s'il y a une référence à l'index ou à l'un de ses résultats de recherche
       dans une structure de données cyclique, car le ramasse-miettes de *PHP* ne récupère les objets avec des
       références cycliques qu'en fin d'exécution de script
.. [#] Le format de fichier Lucene permet de configurer ce nombre, mais ``Zend_Search_Lucene`` n'expose pas cette
       possibilité dans l'API. Cependant vous pouvez toujours configurer ce nombre si l'index est géré par une
       autre implémentation de Lucene.