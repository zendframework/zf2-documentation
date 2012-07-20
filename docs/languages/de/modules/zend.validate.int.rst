.. _zend.validate.set.int:

Int
===

``Zend_Validate_Int`` prüft ob ein angegebener Wert ein Integer (Ganzzahl) ist. Auch lokalisierte Integerwerte
werden erkannt und können geprüft werden.

.. _zend.validate.set.int.options:

Unterstützte Optionen für Zend_Validate_Int
-------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Int`` unterstützt:

- **locale**: Setzt das Gebietsschema welches verwendet wird um lokalisierte Integerwerte zu prüfen.

.. _zend.validate.set.int.basic:

Einfache Integer Prüfung
------------------------

Der einfachste Weg um einen Integerwert zu prüfen ist die Verwendung der Systemeinstellungen. Wenn keine Optionen
angegeben werden, dann wird das Gebietsschema der Umgebung für die Prüfung verwendet:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Int();

   $validator->isValid(1234);   // Gibt true zurück
   $validator->isValid(1234.5); // Gibt false zurück
   $validator->isValid('1,234'); // Gibt true zurück

Um obigen Beispiel haben wir angenommen das unsere Umgebung auf "en" als Gebietsschema gesetzt ist. Wie man im
dritten Beispiel sieht wird auch die Gruppierung erkannt.

.. _zend.validate.set.int.localized:

Lokalisierte Integer Prüfung
----------------------------

Oft ist es nützlich dazu in der Lage zu sein lokalisierte Werte zu prüfen. Integerwerte werden in anderen
Ländern oft unterschiedlich geschrieben. Zum Beispiel kann man im Englischen "1234" oder "1,234" schreiben. Beides
sind Integerwerte, aber die Gruppierung ist optional. Im Deutschen kann man zum Beispiel "1.234" schreiben und im
Französischen "1 234".

``Zend_Validate_Int`` ist in der Lage solche Schreibweisen zu prüfen. Das bedeutet, das es nicht einfach das
Trennzeichen entfernt, sondern auch prüft ob das richtige Trennzeichen verwendet wird. Siehe den folgenden Code:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Int(array('locale' => 'de'));

   $validator->isValid(1234); // Gibt true zurück
   $validator->isValid("1,234"); // Gibt false zurück
   $validator->isValid("1.234"); // Gibt true zurück

Wie man sieht wird die Eingabe, bei Verwendung eines Gebietsschemas, lokalisiert geprüft. Bei Verwendung der
englischen Schreibweise erhält man ``FALSE`` wenn das Gebietsschema eine andere Schreibweise erzwingt.

Das Gebietsschema kann auch im Nachhinein gesetzt werden indem ``setLocale()`` verwendet wird, und empfangen indem
man ``getLocale()`` verwendet.


