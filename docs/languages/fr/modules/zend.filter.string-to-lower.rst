.. EN-Revision: none
.. _zend.filter.set.stringtolower:

StringToLower
=============

Ce filtre convertit toute entrée vers des caractères minuscules.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringToLower();

   print $filter->filter('SAMPLE');
   // retourne "sample"

Par défaut, seul le jeu de caractères de la locale en cours sera utilisé. Les caractères provenant d'autres
jeux seront ignorés. Cela reste possible de les passer en minuscules si l'extension mbstring est présente dans
votre environnement PHP. Indiquez l'encodage voulu à la création du filtre ``StringToLower`` ou utilisez sa
méthode ``setEncoding()``.

.. code-block:: php
   :linenos:

   // utiliser UTF-8
   $filter = new Zend\Filter\StringToLower('UTF-8');

   // ou passer un tableau
   $filter = new Zend\Filter\StringToLower(array('encoding' => 'UTF-8'));

   // ou encore faire cela après coup
   $filter->setEncoding('ISO-8859-1');

.. note::

   **Préciser des mauvais encodages**

   Attention une exception sera levée si vous précisez un encodage alors que l'extension mbstring est absente.

   Une exception sera de même levée si l'encodage que vous précisez n'est pas pris en compte par mbstring.


