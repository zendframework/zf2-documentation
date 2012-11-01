.. EN-Revision: none
.. _zend.validator.set.float:

Float
=====

``Zend\Validate\Float`` erlaubt es zu prüfen ob ein angegebener Wert eine Gleitkommazahl enthält. Diese Prüfung
kann auch lokalisierte Eingaben prüfen.

.. _zend.validator.set.float.options:

Unterstützte Optionen für Zend\Validate\Float
---------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\Float`` unterstützt:

- **locale**: Setzt das Gebietsschema welches verwendet wird um lokalisierte Gleitkommazahlen zu prüfen.

.. _zend.validator.set.float.basic:

Einfache Float Prüfung
----------------------

Der einfachste Weg eine Gleitkommazahl zu prüfen ist die Verwendung der Systemeinstellungen. Wenn keine Option
verwendet wird, dann wird das Gebietsschema der Umgebung für die Prüfung verwendet:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Float();

   $validator->isValid(1234.5);   // Gibt true zurück
   $validator->isValid('10a01'); // Gibt false zurück
   $validator->isValid('1,234.5'); // Gibt true zurück

Im obigen Beispiel wird in der Umgebung das Gebietsschema "en" erwartet.

.. _zend.validator.set.float.localized:

Lokalisierte Prüfung von Gleitkommazahlen
-----------------------------------------

Oft ist es nützlich in der Lage zu sein lokalisierte Werte zu prüfen. Gleitkommazahlen werden in anderen Ländern
oft unterschiedlich geschrieben. Wird zum Beispiel englisch verwendet wird "1.5" geschrieben. Im deutschen wird man
"1,5" schreiben und in anderen Sprachen können Gruppierungen verwendet werden.

``Zend\Validate\Float`` ist in der Lage solche Schreibweisen zu verwenden. Aber es ist auf das Gebietsschema
begrenzt welches man verwendet. Siehe den folgenden Code:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Float(array('locale' => 'de'));

   $validator->isValid(1234.5); // Gibt true zurück
   $validator->isValid("1 234,5"); // Gibt false zurück
   $validator->isValid("1.234"); // Gibt true zurück

Bei Verwendung eines Gebietsschemas wird die Eingabe, wie man sehen kann lokalisiert geprüft. Bei Verwendung einer
anderen Schreibweise erhält man ein ``FALSE`` wenn das Gebietsschema eine andere Schreibweise erzwingt.

Das Gebietsschema kann auch im Nachhinein gesetzt werden indem ``setLocale()`` verwendet wird, und empfangen indem
man ``getLocale()`` verwendet.


