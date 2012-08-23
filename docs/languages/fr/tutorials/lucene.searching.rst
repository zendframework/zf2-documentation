.. EN-Revision: none
.. _learning.lucene.searching:

Recherche
=========

La recherche s'effectue en utilisant la méthode ``find()``\  :

.. _learning.lucene.searching.search-example:

.. rubric:: Recherche à travers l'index

.. code-block:: php
   :linenos:

   $hits = $index->find($query);
   foreach ($hits as $hit) {
       printf("%d %f %s\n", $hit->id, $hit->score, $hit->title);
   }

Cet exemple montre l'utilisation de deux propriétés particulières des résultats de recherche -  ``id`` et
``score``.

``id`` est un identifiant interne de document utilisé dans un index Lucene. Il peut être utilisé pour un
certains nombre d'opérations, tels que la suppression d'un document de l'index :

.. _learning.lucene.searching.delete-example:

.. rubric:: Suppression d'un document indexé

.. code-block:: php
   :linenos:

   $index->delete($id);

Ou récupération d'un document à partir de l'index :

.. _learning.lucene.searching.retrieve-example:

.. rubric:: Récupération d'un document indexé

.. code-block:: php
   :linenos:

   $doc = $index->getDocument($id);

.. note::

   **Identifiant interne de document**

   Note importante ! Les identifiants de documents internes peuvent changer suite à une optimisation de l'index
   ou au processus d'auto-optimisation, mais il ne sera jamais changé pendant l'exécution d'un script à moins
   que ne soient appellées les méthodes ``addDocument()`` (ce qui peut impliquer une procédure
   d'auto-optimisation) ou ``optimize()``.

Le champ ``score`` est un score de résultat. Les résultats de recherche sont triés par score (meilleurs
résultats en premier).

Il est aussi possible de trier l'ensemble de résultats en fonction d'une valeur de champ spécifique. Voir la
:ref:`documentation Zend_Search_Lucene <zend.search.lucene.searching.sorting>` pour plus de détails sur cette
possibilité.

Cette exemple montre aussi la possibilité d'accéder à des champs stockés (ex : ``$hit->title``). Les champs de
documents stockés sont chargés lors du premier accès à l'une des propriété du résultat autre que ``id`` ou
``score``, et la valeur du champ correspondant est retournée.

Ceci cause une ambiguïté car les documents ont leurs propres champs ``id`` ou ``score`` par conséquence, il
n'est pas recommendé d'utiliser ces noms de champs dans les documents stockés. Cependant, ils peuvent être
accédé via la méthode : ``getDocument()``

.. _learning.lucene.searching.id-score-fields:

.. rubric:: Accéder aux champs "id" et "score" original du documents

.. code-block:: php
   :linenos:

   $id    = $hit->getDocument()->id;
   $score = $hit->getDocument()->score;


