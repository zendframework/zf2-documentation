.. EN-Revision: none
.. _zend.validator.set.post_code:

PostCode
========

``Zend\Validate\PostCode`` erlaubt es zu eruieren ob ein angegebener Wert eine gültige Postleitzahl ist.
Postleitzahlen sind spezifisch für Städte und in einigen Gebietsschemata auch als *ZIP* Codes bezeichnet.

``Zend\Validate\PostCode`` kennt mehr als 160 unterschiedliche Formate für Postleitzahlen. Um das richtige Format
auszuwählen gibt es 2 Wege. Man kann entweder ein voll qualifiziertes Gebietsschema verwenden, oder ein eigenes
Format manuall setzen.

Die Verwendung eines Gebietsschemas ist bequemer da Zend Framework bereits die entsprechenden Formate für
Postleitzahlen für jedes Gebietsschema kennt; aber muss man ein voll qualifiziertes Gebietsschema verwenden (eines
das eine Region spezifiziert) damit es funktioniert. Das Gebietsschema "de" zum Beispiel ist zwar ein
Gebietsschema, kann aber nicht mit ``Zend\Validate\PostCode`` verwendet werden da es keine Region enthält; "de_AT"
andererseits würde ein gültiges Gebietsschema sein da es den Region Code spezifiziert ("AT", für Österreich).

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\PostCode('de_AT');

Wenn man das Gebietsschema nicht selbst setzt, dann verwendet ``Zend\Validate\PostCode`` das anwendungsweit
gesetzte Gebietsschema, oder wenn keines vorhanden ist, das Gebietsschema welches von ``Zend_Locale``
zurückgegeben wird.

.. code-block:: php
   :linenos:

   // Anwendungsweites Gebietsschema in der Bootstrap
   $locale = new Zend\Locale\Locale('de_AT');
   Zend\Registry\Registry::set('Zend_Locale', $locale);

   $validator = new Zend\Validate\PostCode();

Man kann das Gebietsschema auch im Nachhinein ändern, indem man ``setLocale()`` aufruft. Und natürlich kann man
das aktuelle Gebietsschema erhalten indem ``getLocale()`` aufgerufen wird.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\PostCode('de_AT');
   $validator->setLocale('en_GB');

Postleitzahlen Formate selbst sind einfache Regular Expression Strings. Wenn das internationale Postleitzahlen
Format, welches durch das Setzen des Gebietsschemas verwendet wird, den eigenen Bedüfnissen nicht entspricht, dann
kann man ein Format auch manuell setzen indem ``setFormat()`` aufgerufen wird.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\PostCode('de_AT');
   $validator->setFormat('AT-\d{5}');

.. note::

   **Konventionen für selbst definierte Formate**

   Wenn selbst definierte Formate verwendet werden sollten die Start- (``'/^'``) und Endetags (``'$/'``) nicht
   angegeben werden. Sie werden automatisch hinzugefügt.

   Man sollte darauf achtgeben das Postleitzahlen Werte immer auf einer strikte Art geprüft werden. Das bedeutet
   das Sie alleinstehend geschrieben werden müssen, ohne zusätzliche Zeichen, wenn diese nicht durch das Format
   abgedeckt werden.

.. _zend.validator.set.post_code.constructor:

Optionen des Constructors
-------------------------

Grundsätzlich kann man dem Contructor von ``Zend\Validate\PostCode`` entweder ein ``Zend_Locale`` Objekt, oder
einen String der ein voll qualifiziertes Gebietsschema repräsentiert, angeben.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\PostCode('de_AT');
   $validator = new Zend\Validate\PostCode($locale);

Zusätzlich kann man dem Contructor entweder ein Array oder ein ``Zend_Config`` Objekt übergeben. Wenn man das
tut, muss man entweder den Schlüssel "locale" oder "format" verwenden; diese werden verwendet um die betreffenden
Werte im Prüfobjekt zu setzen.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\PostCode(array(
       'locale' => 'de_AT',
       'format' => 'AT_\d+'
   ));

.. _zend.validator.set.post_code.options:

Unterstützte Optionen für Zend\Validate\PostCode
------------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\PostCode`` unterstützt:

- **format**: Setzt das Postleitzahl-Format welches für die Prüfung der Eingabe verwendet werden soll.

- **locale**: Setzt ein Gebietsschema von dem die Postleitzahl genommen wird.


