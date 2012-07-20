.. _zend.filter.set.localizedtonormalized:

LocalizedToNormalized
=====================

Dieser Filter ändert jede angegebene lokalisierte Eingabe in seine normalisierte Repräsentation. Er verwendet im
Hintergrund ``Zend_Locale`` um diese Transformation durchzuführen.

Das erlaubt es dem Benutzer Informationen in der Schreibweise seiner eigenen Sprache einzugeben, und man kann diese
anschließend den normalisierten Wert zum Beispiel in der Datenbank speichern.

.. note::

   Es ist zu beachten das Normalisierung nicht mit Übersetzung gleichzusetzen ist. Dieser Filter kann Strings
   nicht von einer Sprache in eine andere Übersetzen, wie man es zum Beispiel bei Monaten oder Namen von Tagen
   erwarten könnte.

Die folgenden Eingabetypen können normalisiert werden:

- **integer**: Ganzzahlen, welche lokalisiert sind, werden in die englische Schreibweise normalisiert.

- **float**: Gleitkommazahlen, welche lokalisiert sind, werden in die englische Schreibweise normalisiert.

- **numbers**: Andere Zahlen, wie Realzahlen, werden in die englische Schreibweise normalisiert.

- **time**: Zeitwerte, werden in ein benanntes Array normalisiert.

- **date**: Datumswerte, werden in ein benanntes Array normalisiert.

Jede andere Eingabe wird so wie Sie ist zurückgegeben, ohne das Sie geändert wird.

.. note::

   Man sollte beachten das normalisierte Ausgabe immer als String angegeben sind. Andernfalls würde die eigene
   Umgebung die normalisierte Ausgabe automatisch in die Schreibweise konvertieren welche die eigene Umgebung
   anhand des gesetzen Gebietsschemas aktuell verwendet.

.. _zend.filter.set.localizedtonormalized.numbers:

Normalisierung von Zahlen
-------------------------

Jede angegebene Zahl wie Integer, Float oder Realzahlen können normalisiert werden. Es ist zu beachten das Zahlen
in der Wissenschaftlichen Schreibweise, aktuell nicht von diesem Filter behandelt werden können.

Wie funktioniert diese Normalisierung also im Detail für Nummern:

.. code-block:: php
   :linenos:

   // Den Filter initiieren
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('123.456,78');
   // Gibt den Wert '123456.78' zurück

Nehmen wir an das wir das Gebietsschema 'de' als Anwendungsweites Gebietsschema gesetzt haben.
``Zend_Filter_LocalizedToNormalized`` nimmt das gesetzte Gebietsschema und verwendet es um zu erkennen welche Art
der Eingabe angegeben wurde. In unserem Beispiel wurde ein Wert mit Nachkommastellen angegeben. Jetzt gibt der
Filter die normalisierte Repräsentation für diesen Wert als String zurück.

Man kann auch kontrollieren wie die normalisierte Nummer auszusehen hat. Hierfür kann man alle Optionen angeben
die auch von ``Zend_Locale_Format`` verwendet werden. Die üblichsten sind:

- **date_format**

- **locale**

- **precision**

Für Details darüber, wie diese Optionen verwendet werden, sollte man in der :ref:`Kapitel Zend_Locale
<zend.locale.parsing>` sehen.

Anbei ist ein Beispiel welches Nachkommastellen definiert damit man sehen kann wie Optionen arbeiten:

.. code-block:: php
   :linenos:

   // Nummerischer Filter
   $filter = new Zend_Filter_LocalizedToNormalized(array('precision' => 2));

   $filter->filter('123.456');
   // Gibt den Wert '123456.00' zurück

   $filter->filter('123.456,78901');
   // Gibt den Wert '123456.79' zurück

.. _zend.filter.set.localizedtonormalized.dates:

Normalisierung für Datum und Zeit
---------------------------------

Eingaben für Datum und Zeitwerte können auch normalisiert werden. Alle angegebenen Datums- und Zeitwerte werden
als Array zurückgegeben, wobei jeder Teil des Datums mit einem eigenen Schlüssel angegeben wird.

.. code-block:: php
   :linenos:

   // Den Filter initiieren
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('12.April.2009');
   // Gibt array('day' => '12', 'month' => '04', 'year' => '2009') zurück

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

   $filter->filter('11:22:33');
   // Gibt array('hour' => '33', 'minute' => '22', 'second' => '11') zurück


