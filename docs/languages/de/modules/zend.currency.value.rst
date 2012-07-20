.. _zend.currency.value:

Wie viel Währung habe ich?
==========================

Wenn man mit Währungen arbeitet will man normalerweise eine Menge an Geld darstellen. Und wenn man mit
unterschiedlichen Währungen arbeitet dann will man mit Ihnen drei verschiedene Dinge machen. Man will die Menge
anzeigen, eine Genauigkeit und möglicherweise einen Wechselkurs verwenden.

.. _zend.currency.value.money:

Arbeiten mit Währungswerten
---------------------------

Der Wert einer Währung, auch als Geld bekannt, welchen man verwenden will kann durch Verwendung der Option
``value`` gesetzt werden.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Könnte '$ 1.000' zurückgeben

Durch Verwendung der Methode ``setFormat()`` mit dieser Arrayoption, und durch Verwendung der Methode
``setValue()`` kann der Wert im Nachhinein gesetzt werden.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency->setValue(2000); // Könnte '$ 2.000' zurückgeben

Mit der Methode ``getValue()`` erhält man den aktuell gesetzten Wert.

.. _zend.currency.value.precision:

Verwendung von Genauigkeit bei Währungen
----------------------------------------

Wenn man mit Währungen arbeitet muss man möglicherweise auch eine Genauigkeit verwenden. Die meisten Währungen
verwenden eine Genauigkeit von 2. Das bedeutet, wenn man 100 US Dollar hat dass man auch 50 Cent haben könnte. Der
betreffende Wert ist einfach eine Gleitkommazahl.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000.50,
           'currency' => 'USD',
       )
   );

   print $currency; // Könnte '$ 1.000,50' zurückgeben

Natürlich bekommt man, durch die standardmäßige Genauigkeit von 2, '00' für den Dezimalwert wenn es keine
Genauigkeit anzuzeigen gibt.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Könnte '$ 1.000,00' zurückgeben

Um die standardmäßige Genauigkeit zu entfernen kann die Option ``precision`` einfach auf '0' gesetzt werden. Und
man kann jede andere Genauigkeit zwischen 0 und 9 setzen. Alle Werte werden gerundet oder gestreckt wenn Sie nicht
in die gesetzte Genauigkeit passen.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'     => 1000,30,
           'currency'  => 'USD',
           'precision' => 0
       )
   );

   print $currency; // Könnte '$ 1.000' zurückgeben


