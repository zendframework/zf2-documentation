.. _zend.currency.value:

Travailler avec les valeurs des monnaies (les montants)
=======================================================

Travailler avec des monnaies c'est avant tout travailler avec des valeurs, des "prix", un montant. Il faut ainsi
travailler avec le montant (la valeur), la précision et l'éventuel taux de change.

.. _zend.currency.value.money:

Travailler avec les valeurs des monnaies
----------------------------------------

La valeur de la monnaie (le montant) se précise grâce à l'option ``value``.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Retournerait '$ 1.000'

Vous pouvez changer la valeur en utilisant les méthodes ``setFormat()`` ou ``setValue()``.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency->setValue(2000); // Retournerait '$ 2.000'

``getValue()`` existe aussi.

.. _zend.currency.value.precision:

Utiliser la précision des monnaies
----------------------------------

La plupart des monnaies utilisent une précision de 2, ce qui signifie qu'avec 100 dollars US vous pouvez rajouter
50 cents. C'est simplement le paramètre après la virgule.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000.50,
           'currency' => 'USD',
       )
   );

   print $currency; // Retournerait '$ 1.000,50'

Comme la précision est de 2, vous obtiendrez des décimales à '00' pour un chiffre rond.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Retournerait '$ 1.000,00'

Pour pallier à ce problème de précision, vous pouvez simplement utiliser l'option ``precision`` avec la valeur
'0'. La précision prend une valeur entre 0 et 9. Les valeurs des monnaies seront arrondies lorsqu'elles ne
tiennent pas dans la précision demandée.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'     => 1000,30,
           'currency'  => 'USD',
           'precision' => 0
       )
   );

   print $currency; // Retournerait '$ 1.000'


