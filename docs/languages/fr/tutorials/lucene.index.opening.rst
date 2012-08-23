.. EN-Revision: none
.. _learning.lucene.index-opening:

Ouverture et création d'index
=============================

Toutes les opérations sur l'index (ex: créer un nouvel index, ajouter un document à l'index, supprimer un
document, chercher dans l'index) nécessite un objet index. Il peut être obtenu avec l'une des méthodes
suivantes.

.. _learning.lucene.index-opening.creation:

.. rubric:: Création d'index Lucene

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::create($indexPath);

.. _learning.lucene.index-opening.opening:

.. rubric:: Ouverture d'index Lucene

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open($indexPath);


