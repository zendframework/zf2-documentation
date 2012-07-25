.. _zend.search.lucene.query-api:

API de construction de requêtes
===============================

En plus du parsage automatique d'une requête en chaîne de caractères, il est également possible de construire
cette requête à l'aide de l'*API* de requête.

Les requêtes utilisateur peuvent être combinées avec les requêtes créées à travers l'API de requêtes.
Utilisez simplement le parseur de requêtes pour construire une requête à partir d'une chaîne :

   .. code-block:: php
      :linenos:

      $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);



.. _zend.search.lucene.queries.exceptions:

Les Exceptions du parseur de requêtes
-------------------------------------

Le parseur de requêtes peut générer deux types d'exceptions :

   - Une ``Zend_Search_Lucene_Exception`` est levée si quelque-chose d'anormal se produit dans le parseur même.

   - Une ``Zend_Search_Lucene_Search_QueryParserException`` est levée s'il y a une erreur dans la syntaxe de la
     requête.

C'est une bonne idée d'attraper les ``Zend_Search_Lucene_Search_QueryParserException``\ s et de les traiter de
manière appropriée :

   .. code-block:: php
      :linenos:

      try {
          $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);
      } catch (Zend_Search_Lucene_Search_QueryParserException $e) {
          echo "Query syntax error: " . $e->getMessage() . "\n";
      }



La même technique devrait être utilisée pour la méthode find() d'un objet ``Zend_Search_Lucene``.

Depuis la version 1.5, les exceptions de parsage de requête sont supprimées par défaut. Si la requête ne
respecte pas le langage de requêtes, elle est "tokenizée" à l'aide de l'analyseur par défaut et tous les termes
"tokenizés" sont utilisés dans la recherche. Pour activer les exceptions, utilisez
``Zend_Search_Lucene_Search_QueryParser::dontSuppressQueryParsingExceptions()``. Les méthodes
``Zend_Search_Lucene_Search_QueryParser::suppressQueryParsingExceptions()`` et
``Zend_Search_Lucene_Search_QueryParser::queryParsingExceptionsSuppressed()`` sont également destinées à gérer
le comportement de gestion des exceptions.

.. _zend.search.lucene.queries.term-query:

Requête sur un terme
--------------------

Les requêtes de termes peuvent être utilisées pour une recherche sur un seul terme.

Requête par chaîne de caractères:

.. code-block:: text
   :linenos:

   word1

ou

Construction de la requête via l'*API*:

.. code-block:: php
   :linenos:

   $term  = new Zend_Search_Lucene_Index_Term('word1', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Term($term);
   $hits  = $index->find($query);

L'argument field est optionnel. ``Zend_Search_Lucene`` cherche dans tous les champs indexés si aucun champ n'a
été spécifié :

   .. code-block:: php
      :linenos:

      // Recherche de 'word1' dans tous les champs indexés.
      $term  = new Zend_Search_Lucene_Index_Term('word1');
      $query = new Zend_Search_Lucene_Search_Query_Term($term);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.multiterm-query:

Requête multi-termes
--------------------

Les requêtes multi-termes peuvent être utilisées pour chercher sur une collection de termes.

Chaque terme dans une collection peut être défini comme **requis**, **interdit**, ou **aucun des deux**.

   - **requis** signifie que les documents ne correspondant pas au terme ne correspondront pas à la requête;

   - **interdit** signifie que les documents correspondant au terme ne correspondront pas à la requête;

   - **aucun des deux**, dans ce cas les documents n'ont pas l'interdiction, ni l'obligation de correspondre au
     terme. Cela dit, un document devra correspondre au moins à l'un des termes pour correspondre à la requête.



Si des termes optionnels sont ajoutés à une requête possédant des termes requis, les deux requêtes auront les
mêmes résultats, mais les termes optionnels pourraient influer sur le score des documents retournés.

Les deux méthodes de recherche peuvent être utilisées pour les requêtes multi-termes.

Requête par chaîne de caractères:

.. code-block:: text
   :linenos:

   +word1 author:word2 -word3

- '+' est utilisé pour définir un terme requis.

- '-' est utilisé pour définir un terme interdit.

- Le préfixe 'field:' est utilisé pour indiqué un champ sur lequel on veut chercher. S'il est omis, la recherche
  se fera sur tous les champs.

or

Construction de la requête via l'*API*:

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word1'), true);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word2', 'author'),
                   null);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word3'), false);
   $hits  = $index->find($query);

Il est également possible de spécifier des listes de termes dans le contructeur de la requête multi-termes :

   .. code-block:: php
      :linenos:

      $terms = array(new Zend_Search_Lucene_Index_Term('word1'),
                     new Zend_Search_Lucene_Index_Term('word2', 'author'),
                     new Zend_Search_Lucene_Index_Term('word3'));
      $signs = array(true, null, false);
      $query = new Zend_Search_Lucene_Search_Query_MultiTerm($terms, $signs);
      $hits  = $index->find($query);



Le tableau ``$signs`` contient des informations sur le type de chaque terme :

   - ``TRUE`` est utilisé pour définir un terme requis.

   - ``FALSE`` est utilisé pour définir un terme interdit.

   - ``NULL`` est utilisé pour définir un terme qui n'est ni requis, ni interdit.



.. _zend.search.lucene.queries.boolean-query:

Requête booléene
----------------

Les requêtes booléenes permettent de construire une requête qui utilise d'autres requêtes et des opérateurs
booléens.

Chaque sous-requête dans une collection peut être définie comme **requis**, **interdit**, ou **optionnel**.

   - **requis** signifie que les documents ne correspondant pas à la sous-requête ne correspondront pas à la
     requête;

   - **interdit** signifie que les documents correspondant à la sous-requête ne correspondront pas à la
     requête;

   - **optionel**, dans ce cas les documents n'ont pas l'interdiction, ni l'obligation de correspondre à la
     sous-requête. Cela dit, un document devra correspondre au moins à l'une des sous-requêtes pour correspondre
     à la requête.



Si des sous-requêtes optionnelles sont ajoutées à une requête possédant des sous-requêtes requises, les deux
requêtes auront les mêmes résultats, mais les sous-requêtes optionnelles pourraient influer sur le score des
documents retournés.

Les deux méthodes de recherche peuvent être utilisées pour les requêtes booléenes.

Requête par chaîne de caractères:

.. code-block:: text
   :linenos:

   +(word1 word2 word3) (author:word4 author:word5) -(word6)

- '+' est utilisé pour définir une sous-requêtes requise.

- '-' est utilisé pour définir une sous-requêtes interdite.

- Le préfixe 'field:' est utilisé pour indiqué un champ sur lequel on veut chercher. S'il est omis, la recherche
  se fera sur tous les champs.

or

Construction de la requête via l'*API*:

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Boolean();
   $subquery1 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word3'));
   $subquery2 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word4', 'author'));
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word5', 'author'));
   $term6 = new Zend_Search_Lucene_Index_Term('word6');
   $subquery3 = new Zend_Search_Lucene_Search_Query_Term($term6);
   $query->addSubquery($subquery1, true  /* required */);
   $query->addSubquery($subquery2, null  /* optional */);
   $query->addSubquery($subquery3, false /* prohibited */);
   $hits  = $index->find($query);

Il est également possible de spécifier des listes de sous-requêtes dans le constructeur d'une requêtes
booléene :

   .. code-block:: php
      :linenos:

      ...
      $subqueries = array($subquery1, $subquery2, $subquery3);
      $signs = array(true, null, false);
      $query = new Zend_Search_Lucene_Search_Query_Boolean($subqueries, $signs);
      $hits  = $index->find($query);



Le tableau ``$signs`` contient des informations sur le type de chaque sous-requête :

   - ``TRUE`` est utilisé pour définir une sous-requête requise.

   - ``FALSE`` est utilisé pour définir une sous-requête interdite.

   - ``NULL`` est utilisé pour définir une sous-requête qui n'est ni requise, ni interdite.



Chaque requête qui utilise des opérateurs booléens peut être réécrite en utilisant les notations de signes et
construites à l'aide de l'API. Par exemple :

   .. code-block:: text
      :linenos:

      word1 AND (word2 AND word3 AND NOT word4) OR word5

est équivalent à

   .. code-block:: text
      :linenos:

      (+(word1) +(+word2 +word3 -word4)) (word5)



.. _zend.search.lucene.queries.wildcard:

Requête Joker (wildcard)
------------------------

Les requêtes Joker peuvent être utilisées pour chercher des documents contenant des chaînes de caractères qui
correspondent aux modèles (pattern) spécifiés.

Le symbole '?' est utilisé comme un joker d'un seul caractère.

Le symbole '\*' est utilisé comme un joker pour plusieurs caractères.

Requête par chaîne de caractères:

   .. code-block:: text
      :linenos:

      field1:test*



ou

Construction de la requête via l'*API*:

   .. code-block:: php
      :linenos:

      $pattern = new Zend_Search_Lucene_Index_Term('test*', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
      $hits  = $index->find($query);



L'argument field est optionnel. ``Zend_Search_Lucene`` cherche dans tous les champs indexés si aucun champ n'a
été spécifié :

   .. code-block:: php
      :linenos:

      $pattern = new Zend_Search_Lucene_Index_Term('test*');
      $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.fuzzy:

Requête floue (fuzzy query)
---------------------------

Les requêtes floues peuvent être utilisées pour chercher des documents contenant des chaînes de caractères qui
correspondent à des termes similaires au terme cherché.

Requête par chaîne de caractères:

   .. code-block:: text
      :linenos:

      field1:test~

Cette requête va correspondre à des documents contenant 'test', 'text', 'best' ou d'autres mots similaires.

ou

Construction de la requête via l'*API*:

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
      $hits  = $index->find($query);



Un indice de similarité (optional similarity) peut être spécifié après le signe "~".

Requête par chaîne de caractères:

   .. code-block:: text
      :linenos:

      field1:test~0.4



ou

Construction de la requête via l'*API*:

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term, 0.4);
      $hits  = $index->find($query);



L'argument field est optionnel. ``Zend_Search_Lucene`` cherche dans tous les champs indexés si aucun champ n'a
été spécifié :

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.phrase-query:

Requête de phrase
-----------------

Les requêtes de phrase peuvent être utilisées pour chercher une phrase dans des documents.

Les requêtes de phrase sont très flexible et permettent à l'utilisateur ou au développeur de chercher des
phrases exactes aussi bien que des phrases 'imprécises'.

Les phrases peuvent aussi contenir des trous ou des termes aux mêmes places; elles peuvent être générées par
l'analyseur dans différents buts. Par exemple, un terme peut être dupliqué pour augmenter son poids, ou
plusieurs synonymes peuvent être placés sur une seule et unique position.

.. code-block:: php
   :linenos:

   $query1 = new Zend_Search_Lucene_Search_Query_Phrase();
   // Ajoute 'word1' à la position relative 0.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));
   // Ajoute 'word2' à la position relative 1.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));
   // Ajoute 'word3' à la position relative 3.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word3'), 3);
   ...
   $query2 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));
   ...
   // Requête sans trou.
   $query3 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'));
   ...
   $query4 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

Une requête de phrase peut être construite en une seule étape à l'aide du constructeur ou étape par étape
avec des appels à la méthode ``Zend_Search_Lucene_Search_Query_Phrase::addTerm()``.

Le constructeur de la classe ``Zend_Search_Lucene_Search_Query_Phrase`` prends trois arguments optionnels :

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase(
       [array $terms[, array $offsets[, string $field]]]
   );

Le paramètre ``$terms`` est un tableau de chaînes de caractères qui contient une collection de termes pour une
phrase. S'il est omis ou égal à ``NULL``, une requête vide sera construite.

Le paramètre ``$offsets`` est un tableau d'entiers qui contient les positions des termes dans la phrase. S'il est
omis ou égale à ``NULL``, les positions des termes seront implicitement séquentielles sans trou.

Le paramètre ``$field`` est un chaîne de caractères qui indique le champ dans lequel chercher. S'il est omis ou
égal à ``NULL``, la recherche se fera dans le champ par défaut.

Ainsi :

.. code-block:: php
   :linenos:

   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'));

va chercher la phrase 'zend framework' dans tous les champs.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'download'), array(0, 2)
                );

va chercher la phrase 'zend ????? download' et correspondra à 'zend platform download', 'zend studio download',
'zend core download', 'zend framework download', etc.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'framework'), null, 'title'
                );

va chercher la phrase 'zend framework' dans le champ 'title'.

La méthode ``Zend_Search_Lucene_Search_Query_Phrase::addTerm()`` prends deux arguments, un
``Zend_Search_Lucene_Index_Term`` requis et une position optionnelle :

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase::addTerm(
       Zend_Search_Lucene_Index_Term $term[, integer $position]
   );

Le paramètre ``$term`` décrit le prochain terme dans la phrase. Il doit indiquer le même champ que les termes
précédents, sinon une exception sera levée.

Le paramètre ``$position`` indique la position du terme dans la phrase.

Ainsi :

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'));

va chercher la phrase 'zend framework'.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'), 0);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'), 2);

va chercher la phrase 'zend ????? download' et correspondra à 'zend platform download', 'zend studio download',
'zend core download', 'zend framework download', etc.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend', 'title'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework', 'title'));

va chercher la phrase 'zend framework' dans le champ 'title'.

Le 'slop factor' établit le nombre d'autres mots autorisés entre les mots spécifiés dans la requête de phrase.
S'il est défini à zéro, la requête correspondante sera une recherche d'une phrase exacte. Pour des valeurs
supérieures à zéro, cela fonctionne comme les opérateurs WITHIN ou NEAR.

Le 'slop factor' est en fait une distance d'édition, où les éditions consistent à déplacer les termes dans la
phrase recherchée. Par exemple, inverser l'ordre de deux mots requiert deux déplacements (le premier déplacement
positionne les mots l'un sur l'autre), donc pour permettre le réarrangement de phrase, le 'slop factor' doit être
d'au moins deux.

Les correspondances les plus exactes possèdent un meilleur score que celles ayant eu recours au 'slop factor';
ainsi les résultats de recherche sont classés par exactitude. Le 'slop factor' est à zéro par défaut,
requérant des correspondances exactes.

Le 'slop factor' peut être assigné après la création de la requête :

.. code-block:: php
   :linenos:

   // Requêtes sans trou.
   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('word1', 'word2'));
   // Search for 'word1 word2', 'word1 ... word2'
   $query->setSlop(1);
   $hits1 = $index->find($query);
   // Recherche pour 'word1 word2', 'word1 ... word2',
   // 'word1 ... ... word2', 'word2 word1'
   $query->setSlop(2);
   $hits2 = $index->find($query);

.. _zend.search.lucene.queries.range:

Requête d'intervalle
--------------------

Les :ref:`requêtes d'intervalle <zend.search.lucene.query-language.range>` sont dédiées à la recherche de
termes dans un intervalle spécifié.

Requête par chaîne de caractères:

   .. code-block:: text
      :linenos:

      mod_date:[20020101 TO 20030101]
      title:{Aida TO Carmen}



ou

Construction de la requête via l'*API*:

   .. code-block:: php
      :linenos:

      $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
      $to   = new Zend_Search_Lucene_Index_Term('20030101', 'mod_date');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, $to, true // inclusive
                   );
      $hits  = $index->find($query);



L'argument field est optionnel. ``Zend_Search_Lucene`` cherche dans tous les champs indexés si aucun champ n'a
été spécifié :

   .. code-block:: php
      :linenos:

      $from = new Zend_Search_Lucene_Index_Term('Aida');
      $to   = new Zend_Search_Lucene_Index_Term('Carmen');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, $to, false // non-inclusive
                   );
      $hits  = $index->find($query);



L'une ou l'autre (mais pas les deux) des bornes peut être définie à ``NULL``. Dans ce cas,
``Zend_Search_Lucene`` cherche depuis le début ou jusqu'à la fin du dictionnaire pour le(s) champs spécifié(s)
:

   .. code-block:: php
      :linenos:

      // recherche pour ['20020101' TO ...]
      $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, null, true // inclusive
                   );
      $hits  = $index->find($query);




