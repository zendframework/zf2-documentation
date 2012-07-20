.. _zend.filter.set.normalizedtolocalized:

NormalizedToLocalized
=====================

Dieser Filter ist das Gegenteil des ``Zend_Filter_LocalizedToNormalized`` Filters und ändert jede angegebene
normalisierte Eingabe in Ihre lokalisierte Repräsentation. Er verwendet im Hintergrund ``Zend_Locale`` um diese
Transformation durchzuführen.

Das erlaubt es einem, dem Benutzer jeden gespeicherten normalisierten Wert in einer lokalisierten Art und Weise
anzugeben, die dem Benutzer verständlicher ist.

.. note::

   Es ist zu beachten das Lokalisierung nicht mit Übersetzung gleichzusetzen ist. Dieser Filter kann Strings nicht
   von einer Sprache in eine andere Übersetzen, wie man es zum Beispiel bei Monaten oder Namen von Tagen erwarten
   könnte.

Die folgenden Eingabetypen können lokalisiert werden:

- **integer**: Ganzzahlen, welche normalisiert sind, werden in die gesetzte Schreibweise lokalisiert.

- **float**: Gleitkommazahlen, welche normalisiert sind, werden in die gesetzte Schreibweise lokalisiert.

- **numbers**: Andere Zahlen, wie Realzahlen, werden in die gesetzte Schreibweise lokalisiert.

- **time**: Zeitwerte, werden in einen String lokalisiert.

- **date**: Datumswerte, werden in einen String lokalisiert.

Jede andere Eingabe wird so wie Sie ist zurückgegeben, ohne das Sie geändert wird.

.. _zend.filter.set.normalizedtolocalized.numbers:

Lokalisierung von Zahlen
------------------------

Jede angegebene Zahl wie Integer, Float oder Realzahlen können lokalisiert werden. Es ist zu beachten das Zahlen
in der Wissenschaftlichen Schreibweise, aktuell nicht von diesem Filter behandelt werden können.

Wie funktioniert diese Lokalisierung also im Detail für Nummern:

.. code-block:: php
   :linenos:

   // Den Filter initiieren
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(123456.78);
   // Gibt den Wert '123.456,78' zurück

Nehmen wir an das wir das Gebietsschema 'de' als Anwendungsweites Gebietsschema gesetzt haben.
``Zend_Filter_NormalizedToLocalized`` nimmt das gesetzte Gebietsschema und verwendet es um zu erkennen welche Art
der Eingabe man haben will. In unserem Beispiel wurde ein Wert mit Nachkommastellen angegeben. Jetzt gibt der
Filter die lokalisierte Repräsentation für diesen Wert als String zurück.

Man kann auch kontrollieren wie die lokalisierte Nummer auszusehen hat. Hierfür kann man alle Optionen angeben die
auch von ``Zend_Locale_Format`` verwendet werden. Die üblichsten sind:

- **date_format**

- **locale**

- **precision**

Für Details darüber, wie diese Optionen verwendet werden, sollte man in der :ref:`Kapitel Zend_Locale
<zend.locale.parsing>` sehen.

Anbei ist ein Beispiel welches Nachkommastellen definiert damit man sehen kann wie Optionen arbeiten:

.. code-block:: php
   :linenos:

   // Nummerischer Filter
   $filter = new Zend_Filter_NormalizedToLocalized(array('precision' => 2));

   $filter->filter(123456);
   // Gibt den Wert '123.456,00' zurück

   $filter->filter(123456.78901);
   // Gibt den Wert '123.456,79' zurück

.. _zend.filter.set.normalizedtolocalized.dates:

Lokalisierung für Datum und Zeit
--------------------------------

Normalisierte Datums- und Zeitwerte können auch lokalisiert werden. Alle angegebenen Datums- und Zeitwerte werden
als String, im Format das vom gesetzten Gebietsschema definiert ist, zurückgegeben.

.. code-block:: php
   :linenos:

   // Den Filter initiieren
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(array('day' => '12', 'month' => '04', 'year' => '2009');
   // Gibt '12.04.2009' zurück

Angenommen wir haben wieder das Gebietsschema 'de' gesetzt. Die Eingaben werden jetzt automatisch als Datum erkannt
und man erhält ein benanntes Array zurück.

Natürlich kann man auch kontrollieren wie die Datumseingaben auszusehen haben indem die Optionen **date_format**
und **locale** verwendet werden.

.. code-block:: php
   :linenos:

   // Datumsfilter
   $filter = new Zend_Filter_LocalizedToNormalized(
       array('date_format' => 'ss:mm:HH')
   );

   $filter->filter(array('hour' => '33', 'minute' => '22', 'second' => '11'));
   // Gibt '11:22:33' zurück


