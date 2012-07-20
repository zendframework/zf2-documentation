.. _zend.search.lucene.searching:

Chercher dans un index
======================

.. _zend.search.lucene.searching.query_building:

Construire des requêtes
-----------------------

Il y a deux manières de chercher dans un index. La première utilise le parseur de requête pour construire une
requête à partir d'une chaîne de caractères. La seconde consiste à créer vos propres requêtes par programme
à l'aide de l'*API* ``Zend_Search_Lucene``.

Avant de choisir d'utiliser le parseur de requête fourni, veuillez considérer ce qui suit :

   . Si vous créez par programme une chaîne et qu'ensuite vous la passez dans le parseur de requêtes, vous
     devriez considérer la possibilité de construire vos requêtes directement avec l'*API* de requêtes. En
     règle générale, le parseur est fait pour le texte saisi par un utilisateur, pas pour du texte généré par
     programme.

   . Les champs non "tokenizés" devraient de préférences être ajoutés directement aux requêtes et pas être
     passés dans le parseur. Si les valeurs d'un champ sont générées par programme, les clauses de requête
     pour ce champ devraient également être créées par programme. Un analyseur, utilisé par le parseur de
     requêtes, est modélisé pour convertir le texte saisi par l'utilisateur en des termes. Les valeurs
     générées par programme, telles que dates, mot-clés, etc. devraient être ajoutés avec l'*API* de
     requêtes.

   . Dans un formulaire de requête, les champs de texte général devraient utiliser le parseur de requêtes. Tous
     les autres, tels qu'intervalles de dates, mot-clés, etc., seront de préférence ajoutés directement dans
     l'*API* de requêtes. Un champ avec une somme limitée de valeurs qui peut être défini dans un menu
     déroulant ne devrait pas être ajouté à une chaîne de requête qui serait ensuite parsée, mais devrait
     être ajouté en tant que clause de type 'TermQuery'.

   . Les requêtes booléennes permettent au programmeur de combiner de manière logique deux ou plus requêtes en
     une seule. De fait, c'est le meilleur moyen d'ajouter des critères additionnels à une requête définie dans
     une chaîne (querystring).



Les deux manières utilisent la même méthode d'*API* pour chercher dans l'index :

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');
   $index->find($query);

La méthode ``Zend_Search_Lucene::find()`` détermine automatiquement le type de données entrantes et utilise le
parseur de requêtes ou construit un objet approprié à partir d''une donnée entrante de type chaîne de
caractères.

Il est important de noter que le parseur de requêtes utilise l'analyseur standard pour "tokenizer" les
différentes partie d'une chaîne. Ainsi, toutes les transformations qui sont appliquées aux textes indexés le
sont également aux chaînes de requête.

L'analyseur standard peut transformer la chaîne de requête en minuscules pour gérer l'insensibilité à la
casse, retirer les mots exclus (ou "stop-words"), et encapsuler les autres transformations.

La méthode de l'*API* ne transforme ni ne filtre les termes entrant d'aucune façon. Elle est ainsi plus pratique
pour les champs générés par le programme ou ceux qui ne sont pas "tokenizés".

.. _zend.search.lucene.searching.query_building.parsing:

Parsage de requêtes
^^^^^^^^^^^^^^^^^^^

La méthode ``Zend_Search_Lucene_Search_QueryParser::parse()`` peut être utilisée pour parser des chaînes de
requête en objets de requête.

Cet objet de requête peut être utilisé dans une méthode de construction de requête de l'*API* pour combiner
des requêtes entrées par l'utilisateur avec des requêtes générées par programme.

Pour l'instant, dans certains cas c'est le seul moyen de chercher des valeurs dans des champs "non-tokenizés" :
Actually, in some cases it's the only way to search for values within untokenized fields:

   .. code-block:: php
      :linenos:

      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);
      $pathTerm  = new Zend_Search_Lucene_Index_Term(
                           '/data/doc_dir/' . $filename, 'path'
                       );
      $pathQuery = new Zend_Search_Lucene_Search_Query_Term($pathTerm);
      $query = new Zend_Search_Lucene_Search_Query_Boolean();
      $query->addSubquery($userQuery, true /* required */);
      $query->addSubquery($pathQuery, true /* required */);
      $hits = $index->find($query);



La méthode ``Zend_Search_Lucene_Search_QueryParser::parse()`` prend également un paramètre optionnel d'encodage,
qui permet de spécifier l'encodage de la chaîne de requête :

   .. code-block:: php
      :linenos:

      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr,
                                                                'iso-8859-5');



Si le paramètre d'encodage est omis, la locale courante est utilisée.

Il est également possible de spécifier l'encodage par défaut de la chaîne de requête avec la méthode
``Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding()``:

   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-5');
      ...
      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);



``Zend_Search_Lucene_Search_QueryParser::getDefaultEncoding()`` retourne la valeur actuelle de l'encodage par
défaut d'une chaîne de requête (une chaîne vide signifiant "locale courante").

.. _zend.search.lucene.searching.results:

Résultats de recherche
----------------------

Le résultat de recherche est un tableau d'objets ``Zend_Search_Lucene_Search_QueryHit``. Chacun d'eux a deux
propriétés : *$hit->id* est un identifiant numérique de document dans l'index et *$hit->score* est le score du
hit dans le résultat de recherche. Les résultats sont triés par score (descendant depuis le meilleur score).

L'objet ``Zend_Search_Lucene_Search_QueryHit`` expose également chaque champ du ``Zend_Search_Lucene_Document``
trouvé dans la recherche en tant que propriété du hit. Dans l'exemple suivant, un hit est retourné avec deux
champs du document correspondant : title et author.

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');
   $hits = $index->find($query);
   foreach ($hits as $hit) {
       echo $hit->score;
       echo $hit->title;
       echo $hit->author;
   }

Les champs stockés sont toujours retournés encodés en UTF-8.

Optionnellement, l'objet original ``Zend_Search_Lucene_Document`` peut être retourné depuis le
``Zend_Search_Lucene_Search_QueryHit``. Vous pouvez récupérer les parties stockées du document en utilisant la
méthode ``getDocument()`` de l'objet index, puis les obtenir avec la méthode ``getFieldValue()``:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');
   $hits = $index->find($query);
   foreach ($hits as $hit) {
       // return Zend_Search_Lucene_Document object for this hit
       echo $document = $hit->getDocument();
       // return a Zend_Search_Lucene_Field object
       // from the Zend_Search_Lucene_Document
       echo $document->getField('title');
       // return the string value of the Zend_Search_Lucene_Field object
       echo $document->getFieldValue('title');
       // same as getFieldValue()
       echo $document->title;
   }

Les champs disponibles dans l'objet ``Zend_Search_Lucene_Document`` sont déterminés lors de l'indexation. Les
champs sont soit indexés, soit indexés et stockés dans le document par l'application d'indexage (p. ex.
LuceneIndexCreation.jar).

Notez que l'identité du document ('path' dans notre exemple) est également stocké dans l'index et doit être
récupéré depuis l'index.

.. _zend.search.lucene.searching.results-limiting:

Limiter le nombre de résultats
------------------------------

L'opération la plus lourde au niveau du calcul dans une recherche est la calculation des scores. Cela peut prendre
plusieurs secondes pour un grand ensemble de résultats (dizaine de milliers de hits).

``Zend_Search_Lucene`` donne la possibilité de limiter la taille de l'ensemble de résultats avec les méthodes
``getResultSetLimit()`` et ``setResultSetLimit()``:

   .. code-block:: php
      :linenos:

      $currentResultSetLimit = Zend_Search_Lucene::getResultSetLimit();
      Zend_Search_Lucene::setResultSetLimit($newLimit);

La valeur par défaut de 0 signifie 'pas de limite'.

Cela ne retournera pas les 'N meilleurs' résultats, mais seulement les 'N premiers'. [#]_.

.. _zend.search.lucene.searching.results-scoring:

Etablissement des scores des résultats de recherche
---------------------------------------------------

``Zend_Search_Lucene`` utilise le même algorithme de scoring que Java Lucene. Par défaut, tous les hits dans
l'ensemble de résultats sont triés par score. Les hits avec le plus grand score viennent en premier, et les
documents avec des hauts scores devraient mieux correspondre à la requête que ceux avec des scores moins
élevés.

En gros, les hits qui contiennent le terme ou la phrase cherché plus fréquemment auront un score plus élevé.

Le score d'un hit peut être récupéré en accédant à la propriété *score* du hit :

.. code-block:: php
   :linenos:

   $hits = $index->find($query);
   foreach ($hits as $hit) {
       echo $hit->id;
       echo $hit->score;
   }

La classe ``Zend_Search_Lucene_Search_Similarity`` est utilisée pour calculer le score pour chaque hit. Consultez
la section :ref:`Extensibility. Scoring Algorithms <zend.search.lucene.extending.scoring>` pour des détails.

.. _zend.search.lucene.searching.sorting:

Tri des résultats de recherche
------------------------------

Par défaut, les résultats de recherche sont triés par score. Le programmeur peut changer ce comportement en
définissant des paramètres pour le champ de tri (ou une liste de champs), le type de tri et le sens de tri.

L'appel à *$index->find()* peut prendre plusieurs paramètres optionnels :

   .. code-block:: php
      :linenos:

      $index->find($query [, $sortField [, $sortType [, $sortOrder]]]
                          [, $sortField2 [, $sortType [, $sortOrder]]]
                   ...);



Le nom d'un champ stocké par lequel on veut trier les résultats devrait être passé comme paramètre
``$sortField``.

``$sortType`` peut être omis ou prendre l'une des valeurs suivantes : ``SORT_REGULAR`` (compare les éléments
normalement- valeur par défaut), ``SORT_NUMERIC`` (compare les éléments comme des valeurs numériques),
``SORT_STRING`` (compare les éléments comme des chaînes de caractères).

``$sortOrder`` peut être omis ou prendre l'une des valeurs suivantes : ``SORT_ASC`` (trie dans l'ordre croissant-
valeur par défaut), ``SORT_DESC`` (trie dans l'ordre décroissant).

Exemples:

   .. code-block:: php
      :linenos:

      $index->find($query, 'quantity', SORT_NUMERIC, SORT_DESC);



   .. code-block:: php
      :linenos:

      $index->find($query, 'fname', SORT_STRING, 'lname', SORT_STRING);



   .. code-block:: php
      :linenos:

      $index->find($query, 'name', SORT_STRING, 'quantity', SORT_NUMERIC, SORT_DESC);



Soyez prudents en personnalisant vos clés de tri; la requête aura besoin de récupérer tous les documents
correspondant de l'index, ce qui peut réduire considérablement les performances de recherche.

.. _zend.search.lucene.searching.highlighting:

Mise en évidence des résultats de recherche
-------------------------------------------

``Zend_Search_Lucene`` propose deux options pour mettre en évidence les résultats de recherche.

La première consiste à utiliser la classe ``Zend_Search_Lucene_Document_Html`` (voyez :ref:`la section Documents
HTML <zend.search.lucene.index-creation.html-documents>` pour des détails) en utilisant les méthodes suivantes :

   .. code-block:: php
      :linenos:

      /**
       * Mise en évidence de texte avec la couleur spécifiée
       *
       * @param string|array $words
       * @param string $colour
       * @return string
       */
      public function highlight($words, $colour = '#66ffff');



   .. code-block:: php
      :linenos:

      /**
       * Mise en évidence du texte en utilisant le View helper spécifié ou une
       * fonction callback.
       *
       * @param string|array $words  Les mots à mettre en évidence. Ils peuvent être organisés
                                     dans un tableau ou une chaîne de caractères.
       * @param callback $callback   La méthode callback, utilisée pour transformer
                                     (mettre en évidence) le texte.
       * @param array    $params     Un tableau de paramètres additionnels passés à la fonction
                                     callback (le premier paramètre non optionnel est un fragment
                                     de code HTML pour la mise en évidence).
       * @return string
       * @throws Zend_Search_Lucene_Exception
       */
      public function highlightExtended($words, $callback, $params = array())



Pour personnaliser le comportement de mise en évidence, utilisez la méthode ``highlightExtended()`` avec le
callback spécifié qui prendra un ou plusieurs paramètres. [#]_, ou étendez la classe
``Zend_Search_Lucene_Document_Html`` et redéfinissez la méthode ``applyColour($stringToHighlight, $colour)`` qui
est utilisée comme le callback de mise en évidence par défaut. [#]_

Les :ref:`View helpers <zend.view.helpers>` peuvent également être utilisés comme des callbacks dans un contexte
d'affichage du script :

   .. code-block:: php
      :linenos:

      $doc->highlightExtended('word1 word2 word3...', array($this, 'myViewHelper'));



Le résultat de l'opération de mise en évidence est récupéré avec la méthode
*Zend_Search_Lucene_Document_Html->getHTML()*.

.. note::

   La mise en évidence est exécutée dans les termes de l'analyseur courant. Donc toutes les formes de mot(s)
   reconnues par l'analyseur seront mises en évidence.

   Ex.: Si l'analyseur courant est insensible à la casse et que l'on demande à mettre en évidence le mot 'text',
   alors 'text', 'Text', 'TEXT' ou toute autre combinaison de casse seront mis en évidence.

   Dans le même ordre d'idées, si l'analyseur courant supporte les requêtes proches (stemming) et que l'on
   souhaite mettre en évidence 'indexed', alors 'index', 'indexing', 'indices' et d'autres mots proches seront mis
   en évidences.

   A l'inverse, si un mot est ignoré par l'analyseur courant (ex. si un filtre pour ignorer les mots trop courts
   est appliqué à l'analyseur), alors rien ne sera mis en évidence.

La seconde option est d'utiliser la méthode *Zend_Search_Lucene_Search_Query->highlightMatches(string $inputHTML[,
$defaultEncoding = 'UTF-8'[, Zend_Search_Lucene_Search_Highlighter_Interface $highlighter]])*:

   .. code-block:: php
      :linenos:

      $query = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);
      $highlightedHTML = $query->highlightMatches($sourceHTML);



Le second paramètre optionnel est l'encodage par défaut du document HTML. Il est utilisé si l'encodage n'est pas
spécifié dans le metatag HTTP-EQUIV Content-Type.

Le troisième paramètre optionnel est un objet de mise en évidence qui doit implémenter l'interface
``Zend_Search_Lucene_Search_Highlighter_Interface``:

   .. code-block:: php
      :linenos:

      interface Zend_Search_Lucene_Search_Highlighter_Interface
      {
          /**
           * Définit le document pour la mise en évidence
           *
           * @param Zend_Search_Lucene_Document_Html $document
           */
          public function setDocument(Zend_Search_Lucene_Document_Html $document);
          /**
           * Récupère le document pour la mise en évidence
           *
           * @return Zend_Search_Lucene_Document_Html $document
           */
          public function getDocument();
          /**
           * Mise en évidence des mots spécifiés (appelée une fois par sous-requête)
           *
           * @param string|array $words  Les mots à mettre en évidence. Ils peuvent être organisés
           *                             dans un tableau ou une chaîne de caractères.
           */
          public function highlight($words);
      }

Où l'objet ``Zend_Search_Lucene_Document_Html`` est un objet construit à partir de la source HTML fournie par la
méthode ``Zend_Search_Lucene_Search_Query->highlightMatches()``

Si le paramètre ``$highlighter`` est omis, un objet ``Zend_Search_Lucene_Search_Highlighter_Default`` est
instancié et utilisé.

La méthode de mise en évidence ``highlight()`` est invoquée une fois par sous-requête, ainsi elle a la
possibilité de différencier la mise en évidence pour chacune.

La mise en évidence par défaut le fait en parcourant une table prédéfinie de couleurs. Vous pouvez implémenter
votre propre classe de mise en évidence ou juste étendre la classe par défaut et redéfinir la table de
couleurs.

*Zend_Search_Lucene_Search_Query->htmlFragmentHighlightMatches()* a un comportement similaire. La seule différence
est qu'il prend en entrée et retourne un fragment HTML sans les balises <>HTML>, <HEAD>, <BODY>. Néanmoins, le
fragment est automatiquement transformé en *XHTML* valide.



.. [#] Les hits retournés demeurent triés par score ou par l'ordre spécifié, s'il est spécifié.
.. [#] Le premier paramètre est un fragment de code HTML pour la mise en évidence et les suivants sont
       dépendants du comportement du callback. La valeur de retour est un fragment HTML mise en évidence.
.. [#] Dans les deux cas, le HTML retourné est automatiquement transformé en *XHTML* valide.