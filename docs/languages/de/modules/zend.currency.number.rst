.. _zend.currency.number:

Wie sieht die Währung aus?
==========================

Wie der Wert einer Währung dargestellt wird hängt hauptsächlich vom verwendeten Gebietsschema ab. Es gibt
verschiedene Informationen welche vom Gebietsschema gesetzt werden. Jede von Ihnen kann manuell überschrieben
werden indem die richtige Option verwendet wird.

Zum Beispiel verwenden die meisten Gebietsschemata die lateinische Schreibweise für die darstellung von Ziffern.
Aber es gibt Sprachen wie "Arabisch" welche andere Ziffern verwenden. Und wenn man eine arabische Website hat, will
man möglicherweise andere Währungen auch durch Verwendung der arabischen Schreibweise darstellen. Siehe das
folgende Beispiel:

.. _zend.currency.number.example-1:

.. rubric:: Verwendung einer eigenen Schreibweise

Angenommen wir verwenden wieder unsere Währung "Dollar". Aber jetzt wollen wir unsere Währung durch Verwendung
der arabischen Schreibweise darstellen.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'  => 1000,
           'script' => 'Arab',
       )
   );

   print $currency; // Könnte '$ ١٬٠٠٠٫٠٠' zurückgeben

Weitere Informationen über vorhandenen Schreibweisen können in ``Zend_Locale``'s :ref:`Kapitel über
Zahlensysteme <zend.locale.numbersystems>` nachgelesen werden.

Aber auch die Formatierung der Währungszahl (Geldwert) kann verwändert werden. Standardmäßig hängt Sie vom
verwendeten Gebietsschema ab. Sie enthält einen Separator der zwischen Tausendern verwendet wird, ein Zeichen das
als Dezimalpunkt verwendet wird, sowie die verwendete Genauigkeit.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'de',
       )
   );

   print $currency; // Könnte '$ 1.000' zurückgeben

Es gibt zwei Wege um das Format zu definieren das verwendet wird. Man kann entweder ein Gebietsschema angeben oder
ein Format manuell definieren.

Wenn man ein Gebietsschema für die Definierung des Formats verwendet wird alles automatisch gesetzt. Das
Gebietsschema 'de' zum Beispiel,definiert '.' als Separator für die Tausender, und ',' als Dezimalpunkt. Im
englischen ist es genau umgekehrt.

.. code-block:: php
   :linenos:

   $currency_1 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'de',
       )
   );

   $currency_2 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'en',
       )
   );

   print $currency_1; // Könnte '$ 1.000' zurückgeben
   print $currency_2; // Könnte '$ 1,000' zurückgeben

Wenn man es manuell definiert muss es dem Format entsprechen welches in :ref:`diesem Kapitel über Lokalisierung
<zend.locale.number.localize.table-1>` beschrieben wird. Siehe das folgende:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => '#0',
       )
   );

   print $currency; // Könnte '$ 1000' zurückgeben

Im obigen Abschnitt haben wir den Separator und auch die Genauigkeit gelöscht.


