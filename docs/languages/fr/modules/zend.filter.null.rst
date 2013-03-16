.. EN-Revision: none
.. _zend.filter.set.null:

Null
====

Ce filtre retournera la valeur ``NULL`` si des critères précis sont rencontrés. C'est souvent nécessaire
lorsqu'on travaille avec des bases de données et que l'on souhaite une valeur ``NULL`` plutôt qu'un booléen ou
tout autre type.

.. _zend.filter.set.null.default:

Comportement par défaut de Zend\Filter\Null
-------------------------------------------

Par défaut, ce filtre fonctionne comme la fonction *PHP* ``empty()``. Donc si ``empty()`` retourne true sur la
valeur, alors ``NULL`` sera retourné par ce filtre

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Null();
   $value  = '';
   $result = $filter->filter($value);
   // retourne null plutôt que la chaine vide

Ceci signifie qu'en l'absence d'une configuration spéciale, ``Zend\Filter\Null`` accepte tout type en entrée et
retourne ``NULL`` dans les mêmes cas que ``empty()``.

Toute autre valeur sera retournée telle quelle, sans aucune modification.

.. _zend.filter.set.null.types:

Changer le comportement de Zend\Filter\Null
-------------------------------------------

Quelques fois ça ne suffit pas de filtrer en se basant sur ``empty()``. Ainsi, ``Zend\Filter\Null`` permet de
déclarer quels types seront convertis.

Les types suivants sont gérés:

- **booléen**: Convertit le booléen **FALSE** en ``NULL``.

- **entier**: Convertit l'entier **0** en ``NULL``.

- **tableau_vide**: Convertit le **tableau** vide en ``NULL``.

- **chaîne**: Convertit la chaine vide **''** en ``NULL``.

- **zero**: Convertit la chaîne zéro (**'0'**) en ``NULL``.

- **tout**: Convertit tous les types cités en ``NULL``. (comportement par défaut).

Il existe plusieurs manières de spécifier les types à filtrer, des constantes, des types ajoutés à la suite,
des chaînes de caractères, un tableau... Voyez les exemples suivants:

.. code-block:: php
   :linenos:

   // convertit false en null
   $filter = new Zend\Filter\Null(Zend\Filter\Null::BOOLEAN);

   // convertit false et 0 en null
   $filter = new Zend\Filter\Null(
       Zend\Filter\Null::BOOLEAN + Zend\Filter\Null::INTEGER
   );

   // convertit false et 0 en null
   $filter = new Zend\Filter\Null( array(
       Zend\Filter\Null::BOOLEAN,
       Zend\Filter\Null::INTEGER
   ));

   // convertit false et 0 en null
   $filter = new Zend\Filter\Null(array(
       'boolean',
       'integer',
   ));

Un objet ``Zend_Config`` peut aussi être utilisé pour préciser les types. La méthode ``setType()`` existe de
même.


