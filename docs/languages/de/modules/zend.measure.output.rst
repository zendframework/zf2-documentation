.. _zend.measure.output:

Ausgabe von Maßeinheiten
========================

Maßeinheiten können auf verschiedenen Wegen als Zahl ausgegeben werden.

:ref:`Automatische Ausgabe <zend.measure.output.auto>`

:ref:`Ausgabe als Wert <zend.measure.output.value>`

:ref:`Ausgabe mit einer Maßeinheit <zend.measure.output.unit>`

:ref:`Ausgabe als lokalisierte Zeichenkette <zend.measure.output.unit>`

.. _zend.measure.output.auto:

Automatische Ausgabe
--------------------

``Zend_Measure`` unterstützt die automatische Ausgabe von Zeichenketten.



      .. _zend.measure.output.auto.example-1:

      .. rubric:: Automatische Ausgabe

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit;



.. note::

   **Ausgabe der Maßeinheit**

   Die Ausgabe kann einfach erzielt werden durch Verwendung von `echo`_ oder `print`_.

.. _zend.measure.output.value:

Ausgabe als Wert
----------------

Der Wert einer Maßeinheit kann mit ``getValue()`` ausgegeben werden.



      .. _zend.measure.output.value.example-1:

      .. rubric:: Ausgabe eines Wertes

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit->getValue();



Die ``getValue()`` Methode akzeptiert einen optionalen Parameter ``round`` der es erlaubt eine Genauigkeit für die
erstellte Ausgabe zu definieren. Die Standardgenauigkeit ist '2'.

.. _zend.measure.output.unit:

Ausgabe mit einer Maßeinheit
----------------------------

Die Funktion ``getType()`` gibt die aktuelle Maßeinheit zurück.



      .. _zend.measure.output.unit.example-1:

      .. rubric:: Outputting units

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Weight($mystring,
                                         Zend_Measure_Weight::POUND,
                                         $locale);

         echo $unit->getType();



.. _zend.measure.output.localized:

Ausgabe als lokalisierte Zeichenkette
-------------------------------------

Die Ausgabe einer Zeichenkette in einem Format welches in dem Land des Benutzers üblich ist, ist normalerweise
gewünscht Die Maßeinheit "1234567.8" würde im Deutschen zum Beispiel zu "1.234.567,8" werden. Diese
Funktionalität wird in einem zukünftigen Release unterstützt.



.. _`echo`: http://php.net/echo
.. _`print`: http://php.net/print
