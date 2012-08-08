.. EN-Revision: none
.. _zend.validator.set.alnum:

Alnum
=====

``Zend_Validate_Alnum`` erlaubt es zu prüfen ob ein angegebener Wert nur alphabetische Zeichen und Ziffern
enthält. Es gibt keine Begrenzung der Länge für die Eingabe welche geprüft werden soll.

.. _zend.validator.set.alnum.options:

Unterstützte Optionen für Zend_Validate_Alnum
---------------------------------------------

Die folgenden Optionen werden von ``Zend_Validate_Alnum`` unterstützt:

- **allowWhiteSpace**: Ob Leerzeichen erlaubt sind. Diese Option ist standardmäßig ``FALSE``

.. _zend.validator.set.alnum.basic:

Standardverhalten
-----------------

Das folgende ist ein Standardbeispiel:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Alnum();
   if ($validator->isValid('Abcd12')) {
       // Der Wert enthält nur erlaubte Zeichen
   } else {
       // false
   }

.. _zend.validator.set.alnum.whitespace:

Verwendung von Leerzeichen
--------------------------

Standardmäßig werden Leerzeichen nicht akzeptiert weil Sie nicht Teil des Alphabeths sind. Trotzdem gibt es einen
Weg Sie als Eingabe zu akzeptieren. Das erlaubt es komplette Sätze oder Phrasen zu prüfen.

Um die Verwendung von Leerzeichen zu erlauben muss man die Option ``allowWhiteSpace`` angeben. Das kann wärend der
Erstellung einer Instanz des Prüfers getan werden, oder im Nachhinein indem ``setAllowWhiteSpace()`` verwendet
wird. Um den aktuellen Zustand zu erhalten kann ``getAllowWhiteSpace()`` verwendet werden.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Alnum(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd und 12')) {
       // Der Wert enthält nur erlaubte Zeichen
   } else {
       // false
   }

.. _zend.validator.set.alnum.languages:

Andere Sprachen verwenden
-------------------------

Wenn ``Zend_Validate_Alnum`` verwendet wird dann wird jene Sprache verwendet, welche der Benutzer in seinem Browser
gesetzt hat, um die erlaubten Zeichen zu setzen. Das bedeutet, wenn ein Benutzer **de** für Deutsch setzt dann
kann er auch Zeichen wie **ä**, **ö** und **ü** zusätzlich zu den Zeichen des englischen Alphabeths setzen.

Welche Zeichen erlaubt sind hängt komplett von der verwendeten Sprache ab, da jede Sprache Ihr eigenes Set von
Zeichen definiert.

Es gibt aktuell 3 Sprachen welche nicht mit Ihrer eigenen Schreibweise akzeptiert werden. Diese Sprachen sind
**koreanisch**, **japanisch** und **chinesisch**, da diese Sprachen ein Alphabeth verwenden bei dem einzelne
Zeichen so aufgebaut werden dass Sie mehrere Zeichen verwenden.

Im Falle das diese Sprachen verwendet werden wird der Inhalt nur durch Verwendung des englischen Alphabeths
geprüft.


