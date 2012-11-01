.. EN-Revision: none
.. _learning.lucene.queries:

Requêtes supportées
===================

``Zend\Search\Lucene`` et Lucene Java supportent un langage de requête puissant. Il permet de rechercher des
termes individuels, des phrases, des ensembles de termes ; en utilisant des jokers ou des recherches floues ; en
combinant des requêtes à l'aide d'opérateurs booléens et ainsi de suite.

Une description détaillée du langage de requête peut être trouvé dans la documentation du composant
:ref:`Zend\Search\Lucene <zend.search.lucene.query-language>`.

Ci-dessous, des exemples de quelques requêtes types communes et de stratégies.

.. _learning.lucene.queries.keyword:

.. rubric:: Effectuer une requête pour un mot seul

.. code-block:: text
   :linenos:

   hello

Recherche le mot "hello" à travers les champs de tous les documents.

.. note::

   **Champ de recherche par défaut**

   Note importante ! Lucene Java recherche uniquement dans les champs de "contenu" par défaut, mais
   ``Zend\Search\Lucene`` recherche à travers **tous** les champs. Ce comportement peut être modifié en
   utilisant la méthode ``Zend\Search\Lucene::setDefaultSearchField($fieldName)``.

.. _learning.lucene.queries.multiple-words:

.. rubric:: Effectuer une recherche de mots multiples

.. code-block:: text
   :linenos:

   hello dolly

Recherche deux mots. Les deux mots sont facultatifs, au moins l'un des deux doit être présent dans le résultat

.. _learning.lucene.queries.required-words:

.. rubric:: Mots requis dans une requête

.. code-block:: text
   :linenos:

   +hello dolly

Recherche deux mots ; "hello" est requis, "dolly" est facultatif.

.. _learning.lucene.queries.prohibited-words:

.. rubric:: Interdire des mots dans les documents recherchés

.. code-block:: text
   :linenos:

   +hello -dolly

Recherche avec deux mots ; "hello" est requis, 'dolly' est interdit. En d'autres termes, si le document contient
"hello", mais contient aussi le mot "dolly", il ne sera pas retourné dans l'ensemble de résultats.

.. _learning.lucene.queries.phrases:

.. rubric:: Rechercher des phrases

.. code-block:: text
   :linenos:

   "hello dolly"

Recherche de la phrases "hello dolly" ; un document correspond uniquement si la chaine exacte est présente.

.. _learning.lucene.queries.fields:

.. rubric:: Effectuer des recherches dans des champs en particulier

.. code-block:: text
   :linenos:

   title:"The Right Way" AND text:go

Recherche la phrase "The Right Way" au sein du champ ``title`` et le mot "go" dans la propriété ``text``.

.. _learning.lucene.queries.fields-and-document:

.. rubric:: Effectuer des recherches dans des champs en particulier aussi bien que dans le document complet

.. code-block:: text
   :linenos:

   title:"The Right Way" AND  go

Recherche la phrase "The Right Way" dans la propriété ``title`` et le mot "go" dans tous les champs du document.

.. _learning.lucene.queries.fields-and-document-alt:

.. rubric:: Effectuer des recherches dans des champs en particulier aussi bien que dans le document complet (Alternatif)

.. code-block:: text
   :linenos:

   title:Do it right

Recherche le mot "Do" dans la propriété ``title`` et les mots "it" and "right" dans tous les champs ; si l'un
d'entre eux correspond, le document correspondra à un résultat de recherche.

.. _learning.lucene.queries.wildcard-question:

.. rubric:: Faire des requêtes avec le joker "?"

.. code-block:: text
   :linenos:

   te?t

Recherche les mots correspondants au motif "te?t", où "?" est n'importe quel caractère unique.

.. _learning.lucene.queries.wildcard-asterisk:

.. rubric:: Faire des requêtes avec le joker "\*"

.. code-block:: text
   :linenos:

   test*

Recherche les mots correspondants au motif "test*", où "\*" est n'importe quelle séquence de 0 caractère ou
plus.

.. _learning.lucene.queries.range-inclusive:

.. rubric:: Rechercher une gamme inclusive de termes

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]

Recherche la gamme de termes (inclusif).

.. _learning.lucene.queries.range-exclusive:

.. rubric:: Rechercher une gamme exclusive de termes

.. code-block:: text
   :linenos:

   title:{Aida to Carmen}

Recherche la gamme de termes (exculsif).

.. _learning.lucene.queries.fuzzy:

.. rubric:: Recherches floues

.. code-block:: text
   :linenos:

   roam~

Recherche foue pour le mot "roam".

.. _learning.lucene.queries.boolean:

.. rubric:: Recherches booléennes

.. code-block:: text
   :linenos:

   (framework OR library) AND php

Requête booléenne.

Toutes les requêtes supportées peuvent être construites via l':ref:`API de construction de requêtes
<zend.search.lucene.query-api>` de ``Zend\Search\Lucene``. De plus l'analyse et la construction de requêtes
peuvent être combinées :

.. _learning.lucene.queries.combining:

.. rubric:: Combinaison d'analyse et de construction de requêtes

.. code-block:: php
   :linenos:

   $userQuery = Zend\Search\Lucene\Search\QueryParser::parse($queryStr);
   $query = new Zend\Search\Lucene\Search\Query\Boolean();
   $query->addSubquery($userQuery, true  /* required */);
   $query->addSubquery($constructedQuery, true  /* required */);


