.. EN-Revision: none
.. _performance.database:

Performance de Zend_Db
======================

``Zend_Db`` est une couche d'abstraction pour les bases de données, et a pour but de fournir une *API* commune
pour les opérations *SQL*. ``Zend\Db\Table`` est un Table Data Gateway, dont le but est d'abstraire les
opérations communes de niveau table. A cause de cette nature abstraite et de la manière suivant laquelle sont
réalisées ces opérations, ces composants peuvent introduire des pertes de performances.

.. _performance.database.tableMetadata:

Comment réduire la surcharge introduite par Zend\Db\Table lors de la récupération des métadonnées de table ?
------------------------------------------------------------------------------------------------------------

Dans le but de maintenir une utilisation la plus simple possible, et aussi de supporter un changement de schéma
permanent au cours du développement, ``Zend\Db\Table`` réalise une série d'action en arrière-plan  à la
première utilisation, il analyse le schéma de la table et le stocke dans les propriétés de l'objet. Cette
opération est typiquement coûteuse, indépendamment de la base de données -- ce qui peut contribuer à des
goulots en production.

Toutefois, ils existent des techniques permettant d'améliorer ceci.

.. _performance.database.tableMetadata.cache:

Utiliser le cache des métadonnées
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Db\Table`` peut optionnellement utiliser ``Zend_Cache`` pour mettre en cahce les métadonnées de la table.
C'est typiquement plus rapide d'accès et moins coûteux que d'accéder à ces métadonnées directement dans la
base de données.

La documentation de :ref:`Zend\Db\Table <zend.db.table.metadata.caching>` inclue des informations concernant la
mise en cache des métadonnées.

.. _performance.database.tableMetadata.hardcoding:

Mettre en dur les métadonnées dans votre définition de table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A partir de la version 1.7.0, ``Zend\Db\Table`` fournit aussi :ref:`le support permettant de stocker les
métadonnées en dur dans la définition de la table <zend.db.table.metadata.caching.hardcoding>`. Ceci est un cas
d'utilisation très avancé, et ne devrait être utilisé que lorsque vous êtes que votre schéma de base de
données évolue rarement, ou que vous êtes certain de pouvoir maintenir à jour ces définitions.

.. _performance.database.select:

Le SQL généré avec Zend\Db\Select n'utilise pas mes index ; comment améliorer ceci ?
------------------------------------------------------------------------------------

``Zend\Db\Select`` est plutôt bon dans son trvail. Cependant si vous avez des requêtes complexes requiérant des
jointures ou des sous-sélections, il est souvent assez naïf.

.. _performance.database.select.writeyourown:

Ecrire votre SQL amélioré
^^^^^^^^^^^^^^^^^^^^^^^^^

La seule véritable réponse est d'écrire vous même votre propre *SQL*\  ; ``Zend_Db`` n'oblige pas
l'utilisation de ``Zend\Db\Select``, donc fournir votre propre instruction *SQL* de sélection est une approche
parfaitement légitime.

Effectuez un ``EXPLAIN`` sur vos requêtes, et testez plusieurs approches jusqu'à obtenir un indice le plus
performant, ensuite écrivez en dur votre *SQL* en tant que propriété de la classe ou comme constante.

Si votre *SQL* requiert des arguments variables, fournissez des emplacements réservés dans votre *SQL*, et
utilisez une combinaison de ``vsprintf()`` et ``array_walk()`` pour injecter les valeurs dans votre *SQL*\  :

.. code-block:: php
   :linenos:

   // $adapter est l'adaptateur de base de données. Dans Zend\Db\Table,
   // vous le récupérez en appelant $this->getAdapter().
   $sql = vsprintf(
       self::SELECT_FOO,
       array_walk($values, array($adapter, 'quoteInto'))
   );


