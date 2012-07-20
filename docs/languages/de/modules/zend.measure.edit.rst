.. _zend.measure.edit:

Manipulation von Maßeinheiten
=============================

Analysieren und normalisieren von Eingaben kombiniert mit der Ausgabe in lokalisierter Schreibweise macht die Daten
für Benutzer in fremden Gebietsschemata benutzbar. Viele zusätzliche Methoden existieren in den
``Zend_Measure_*`` Komponentenum diese Daten zu manipulieren und mit Ihnen zu arbeiten nachdem Sie normalisiert
wurden.

- :ref:`Konvertieren <zend.measure.edit.convert>`

- :ref:`Addieren und Subtrahieren <zend.measure.edit.add>`

- :ref:`Identität Vergleichen <zend.measure.edit.equal>`

- :ref:`Werte Vergleichen <zend.measure.edit.compare>`

- :ref:`Werte per Hand ändern <zend.measure.edit.changevalue>`

- :ref:`Typ per Hand ändern <zend.measure.edit.changetype>`

.. _zend.measure.edit.convert:

Konvertieren
------------

Das warscheinlich wichtigste Feature ist die Konvertierung in verschiedene Maßeinheiten. Die Konvertierung von
Maßeinheiten kann durch verwendung der Methode ``convertTo()`` beliebig oft durchgeführt werden. Maßeinheiten
können nur in andere Einheiten des gleichen Typs (Klasse) konvertiert werden. Deswegen ist es nicht möglich z.B.
eine Länge in ein Gewicht zu konvertieren, was ja schlechte Programmierpraxis und Fehler erlauben würde ohne das
eine Ausnahme geworfen wird.

Die ``convertTo()`` Methode akzeptiert einen optionalen Parameter. Mit diesem Parameter kann eine Genauigkeit, für
den zurückgegebenen Wert, definiert werden. Die Standardgenauigkeit ist '2'.

.. _zend.measure.edit.convert.example-1:

.. rubric:: Konvertieren

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $mystring = "1.234.567,89";
   $unit = new Zend_Measure_Weight($mystring,'POND', $locale);

   print "Kilo:".$unit->convertTo('KILOGRAM');

   // Konstanten sind eine "bessere Praxis" als Zeichenketten
   print "Tonne:".$unit->convertTo(Zend_Measure_Weight::TON);

   // define a precision for the output
   print "Tonne:".$unit->convertTo(Zend_Measure_Weight::TON, 3);

.. _zend.measure.edit.add:

Addieren und Subtrahieren
-------------------------

Maßeinheiten können miteinander durch ``add()`` addiert und durch ``sub()`` subtrahiert werden. Das Ergebnis ist
vom selben Typ die das originale Objekt. Dynamische Objekte unterstützen einen flüssigen Programmierstil, bei dem
komplexe Sequenzen von Operationen geschachtelt werden können ohne das Risiko eines Nebeneffekts durch die
Veränderung des Eingabe Objektes.





      .. _zend.measure.edit.add.example-1:

      .. rubric:: Werte addieren

      .. code-block:: php
         :linenos:

         // Objekte definieren
         $unit = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // $unit2 zu $unit1 addieren
         $sum = $unit->add($unit2);

         echo $sum; // Ausgabe "300 cm"



.. note::

   **Automatische Konvertierung**

   Beim Addieren eines Objektes zu einem anderen wird dieses automatisch in die richtige Einheit konvertiert. Es
   ist nicht notwendig :ref:`convertTo() <zend.measure.edit.convert>` aufzurufen bevor unterschiedliche Einheiten
   addiert werden.





      .. _zend.measure.edit.add.example-2:

      .. rubric:: Subtrahieren

      Das Subtrahieren von Maßeinheiten funktioniert genauso wie das Addieren.

      .. code-block:: php
         :linenos:

         // Objekte definieren
         $unit = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // $unit2 von $unit subtrahieren
         $sum = $unit->sub($unit2);

         echo $sum;



.. _zend.measure.edit.equal:

Identität Vergleichen
---------------------

Maßeinheiten können genauso verglichen werden, aber ohne automatische Konvertierung. Das bedeutet das
``equals()`` nur dann ``TRUE`` zurückgibt wenn beide, sowohl der Wert als auch die Einheit identisch sind.





      .. _zend.measure.edit.equal.example-1:

      .. rubric:: Unterschiedliche Maßeinheiten

      .. code-block:: php
         :linenos:

         // Maßeinheiten definieren
         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         if ($unit->equals($unit2)) {
             print "Beide Maßeinheiten sind identisch";
         } else {
             print "Das sind unterschiedliche Maßeinheiten";
         }





      .. _zend.measure.edit.equal.example-2:

      .. rubric:: Identische Maßeinheiten

      .. code-block:: php
         :linenos:

         // Maßeinheiten definieren
         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         $unit2->setType(Zend_Measure_Length::CENTIMETER);

         if ($unit->equals($unit2)) {
             print "Beide Maßeinheiten sind identisch";
         } else {
             print "Das sind unterschiedliche Maßeinheiten";
         }



.. _zend.measure.edit.compare:

Werte Vergleichen
-----------------

Um herauszufinden ob eine Maßeinheite kleiner oder größer als eine andere ist kann ``compare()`` verwendet
werden, was 0, -1 oder 1 zurückgibt, abhängig von der Differenz zwischen den zwei Objekten. Identische
Maßeinheiten geben 0 zurück, kleinere einen negativen, und größere einen positiven Wert.





      .. _zend.measure.edit.compare.example-1:

      .. rubric:: Differenz

      .. code-block:: php
         :linenos:

         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);
         $unit3 = new Zend_Measure_Length(1.2, Zend_Measure_Length::METER);

         print "Gleich:".$unit2->compare($unit);
         print "Kleiner:".$unit2->compare($unit3);
         print "Größer:".$unit3->compare($unit2);



.. _zend.measure.edit.changevalue:

Werte per Hand ändern
---------------------

Um den Wert einer Maßeinheit explizit zu Ändern, kann ``setValue()`` verwendet werden um den aktuellen Wert zu
überschreiben. Die Parameter sind identisch mit denen des Konstruktors.





      .. _zend.measure.edit.changevalue.example-1:

      .. rubric:: Verändern eines Wertes

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de_AT');
         $unit = new Zend_Measure_Length(1,Zend_Measure_Length::METER);

         $unit->setValue(1.2);
         echo $unit;

         $unit->setValue(1.2, Zend_Measure_Length::KILOMETER);
         echo $unit;

         $unit->setValue("1.234,56", Zend_Measure_Length::MILLIMETER,$locale);
         echo $unit;



.. _zend.measure.edit.changetype:

Typ per Hand ändern
-------------------

Um den Typ einer Maßeinheit ohne den Wert zu verändern kann ``setType()`` verwendet werden.

.. _zend.measure.edit.changetype.example-1:

.. rubric:: Verändern des Typs

.. code-block:: php
   :linenos:

   $unit = new Zend_Measure_Length(1,Zend_Measure_Length::METER);
   echo $unit; // Ausgabe "1 m"

   $unit->setType(Zend_Measure_Length::KILOMETER);
   echo $unit; // Ausgabe "1000 km"


