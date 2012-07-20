.. _zend.currency.position:

Où est le symbole monnétaire?
=============================

Le signe symbolique de la monnaie est positionné par rapport à sa valeur en fonction de la locale utilisée.
Cependant, vous pouvez forcer ce positionnement grâce à l'option ``display`` qui se configure au moyen de
constantes:

.. _zend.currency.position.table-1:

.. table:: Positions disponibles pour la monnaie

   +---------+---------------------------------------------------------------------------------+
   |Constante|Description                                                                      |
   +=========+=================================================================================+
   |STANDARD |Affiche le symbole de la monnaie dans une position standard, conforme à la locale|
   +---------+---------------------------------------------------------------------------------+
   |RIGHT    |Affiche le symbole de la monnaie à droite de sa valeur                           |
   +---------+---------------------------------------------------------------------------------+
   |LEFT     |Affiche le symbole de la monnaie à gauche de sa valeur                           |
   +---------+---------------------------------------------------------------------------------+

.. _zend.currency.position.example-1:

.. rubric:: Paramétrer la position du symbole monnétaire

Imaginons que le client utilise la locale "en_US". Sans option, la valeur retournée serait par exemple:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
       )
   );

   print $currency; // Retournerait '$ 100'

En utilisant la valeur par défaut, le symbole pourrait être retourné à gauche ou à droite de la valeur de
monnaie. Voyons comment fixer cette position:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 100,
           'position' => Zend_Currency::RIGHT,
       )
   );

   print $currency; // Retournerait '100 $';

Notez que dans le deuxième exemple, la position de *USD* est fixée quelle que soit la locale ou la monnaie
considérée.


