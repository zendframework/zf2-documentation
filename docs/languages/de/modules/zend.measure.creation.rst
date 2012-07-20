.. _zend.measure.creation:

Erstellung einer Maßeinheit
===========================

Bei der Erstellung einer Maßeinheit erwarten die ``Zend_Measure_*`` Methoden den Eingabe-/den Originalwert als
ersten Parameter. Dieser kann ein :ref:`nummerisches Argument <zend.measure.creation.number>`, einen :ref:`String
<zend.measure.creation.string>` oder Einheit, oder eine :ref:`lokalisierte Zeichenkette mit definierter Einheit
<zend.measure.creation.localized>` sein. Der zweite Parameter definiert die Art der Maßeinheit. Beide Parameter
sind zwingend erforderlich. Die Sprache kann als optionaler dritter Parameter definiert werden.

.. _zend.measure.creation.number:

Eine Maßeinheit von einer Integer oder Floatzahl erstellen
----------------------------------------------------------

Zusätzlich zu Integerwerten können Floatwerte benutzt werden, aber `"einfache Dezimalbrüche wie 0.1 or 0.7
können nicht in Ihre binäre Entsprechung konvertiert werden ohne den Verlust von Genauigkeit,"`_ was zeitweise zu
erstaunlichen Ergebnissen führt. Genauso sollten zwei Floatzahlen nicht auf Gleichheit geprüft werden.

.. _zend.measure.creation.number.example-1:

.. rubric:: Erstellung einer Maßeinheit durch Integer oder Floatwerte

.. code-block:: php
   :linenos:

   $measurement = 1234.7;
   $unit = new Zend_Measure_Length((integer)$measurement,
                                   Zend_Measure_Length::STANDARD);
   echo $unit;
   // Ausgabe '1234 m' (Meter)

   $unit = new Zend_Measure_Length($measurement, Zend_Measure_Length::STANDARD);
   echo $unit;
   // Ausgabe '1234.7 m' (Meter)

.. _zend.measure.creation.string:

Erstellen einer Maßeinheit aus Zeichenketten
--------------------------------------------

Viele Maßeinheiten die als Eingabe einer Zend Framework Anwendung empfangen werden können nur als Zeichenketten
den Klassen von ``Zend_Measure_*`` übergeben werden, wie z.B. Zahlen die in `Römischer Schreibweise`_ geschrieben
werden, oder extrem lange Binärwerte welche die Genauigkeit von *PHP*'s natürlichen Integer und Floattypen
übersteigen würden. Da Integer auch als Zeichenketten geschrieben werden können sollten, sobald die Gefahr eines
Genauigkeitverlustes durch die Limits von *PHP*'s Integer und Floatwerten besteht, stattdessen Zeichenketten
verwendet werden. ``Zend_Measure_Number`` benutzt die BCMath Erweiterung um aussergewöhnliche Genauigkeit zu
unterstützen, wie im gezeigen Beispiel, um die Beschränkungen von vielen *PHP* Funktionen wie `bin2dec()`_ zu
umgehen.

.. _zend.measure.creation.string.example-1:

.. rubric:: Erstellung einer Maßeinheit durch Strings

.. code-block:: php
   :linenos:

   $mystring = "10010100111010111010100001011011101010001";
   $unit = new Zend_Measure_Number($mystring, Zend_Measure_Number::BINARY);

   echo $unit;

.. _zend.measure.creation.localized:

Maßeinheiten von lokalisierten Zeichenketten
--------------------------------------------

Wenn eine Zeichenkette in lokalisierter Schreibweise eingegeben wurde, kann die richtige Interpretation nicht
herausgefunden werden ohne dass das gewünschte Gebietsschema bekannt ist. Die Teilung der Dezimalziffern mit "."
und die Gruppierung der Tausender mit "," ist in der Englischen Sprache üblich, aber nur in anderen Sprachen. Um
mit solchen Problemen umgehen zu können, besteht bei den lokalisierten Klassen der ``Zend_Measure_*`` Familie die
Möglichkeit eine Sprache oder Region anzugeben, um einen Eingabewert eindeutig zu machen und die erwartete
semantische Eingabe richtig zu interpretieren.

.. _zend.measure.creation.localized.example-1:

.. rubric:: Lokalisierte Zeichenketten

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $mystring = "1,234.50";
   $unit = new Zend_Measure_Length($mystring,
                                   Zend_Measure_Length::STANDARD,
                                   $locale);
   echo $unit; // Ausgabe "1.234 m"

   $mystring = "1,234.50";
   $unit = new Zend_Measure_Length($mystring,
                                   Zend_Measure_Length::STANDARD,
                                   'en_US');
   echo $unit; // Ausgabe "1234.50 m"

Seit Zend Framework 1.7.0 unterstützt ``Zend_Measure`` auch die Verwendung eines Anwendungsweiten Gebietsschemas.
Man kann ganz einfach eine ``Zend_Locale`` Instanz in der Registry setzen wie anbei gezeigt. Mit dieser
Schreibweise kann man das manuelle Setzen eines Gebietsschemas für jede Instanz vergessen wenn man das selbe
Gebietsschema mehrere Male verwenden will.

.. code-block:: php
   :linenos:

   // In der Bootstrap Datei
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // Irgendwo in der eigenen Anwendung
   $length = new Zend_Measure_Length(Zend_Measure_Length::METER();



.. _`"einfache Dezimalbrüche wie 0.1 or 0.7 können nicht in Ihre binäre Entsprechung konvertiert werden ohne den Verlust von Genauigkeit,"`: http://www.php.net/float
.. _`Römischer Schreibweise`: http://en.wikipedia.org/wiki/Roman_numerals
.. _`bin2dec()`: http://php.net/bin2dec
