.. EN-Revision: none
.. _zend.validate.set.alpha:

Alpha
=====

``Zend_Validate_Alpha`` erlaubt es zu prüfen ob ein angegebener Wert nur alphabetische Zeichen enthält. Es gibt
keine Begrenzung der Länge für die Eingabe welche man prüfen will. Diese Prüfung ist ähnlich wie die
``Zend_Validate_Alnum`` Prüfung mit der Ausnahme dass Sie keine Ziffern akzeptiert.

.. _zend.validate.set.alpha.options:

Unterstützte Optionen für Zend_Validate_Alpha
---------------------------------------------

Die folgenden Optionen werden von ``Zend_Validate_Alpha`` unterstützt:

- **allowWhiteSpace**: Ob Leerzeichen erlaubt sind. Diese Option ist standardmäßig ``FALSE``

.. _zend.validate.set.alpha.basic:

Standardverhalten
-----------------

Das folgende ist ein standardmäßiges Beispiel:

.. code-block:: .validator.
   :linenos:

   $validator = new Zend_Validate_Alpha();
   if ($validator->isValid('Abcd')) {
       // Der Wert enthält nur erlaubte Zeichen
   } else {
       // false
   }

.. _zend.validate.set.alpha.whitespace:

Verwendung von Leerzeichen
--------------------------

Standardmäßig werden Leerzeichen nicht akzeptiert weil Sie nicht Teil des Alphabeths sind. Trotzdem gibt es einen
Weg Sie als Eingabe zu akzeptieren. Das erlaubt es komplette Sätze oder Phrasen zu prüfen.

Um die Verwendung von Leerzeichen zu erlauben muss man die Option ``allowWhiteSpace`` angeben. Das kann wärend der
Erstellung einer Instanz des Prüfers getan werden, oder im Nachhinein indem ``setAllowWhiteSpace()`` verwendet
wird. Um den aktuellen Zustand zu erhalten kann ``getAllowWhiteSpace()`` verwendet werden.

.. code-block:: .validator.
   :linenos:

   $validator = new Zend_Validate_Alpha(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd and efg')) {
       // Der Wert enthält nur erlaubte Zeichen
   } else {
       // false
   }

.. _zend.validate.set.alpha.languages:

Andere Sprachen verwenden
-------------------------

Wenn ``Zend_Validate_Alpha`` verwendet wird dann wird jene Sprache verwendet, welche der Benutzer in seinem Browser
gesetzt hat, um die erlaubten Zeichen zu setzen. Das bedeutet, wenn ein Benutzer **de** für Deutsch setzt dann
kann er auch Zeichen wie **ä**, **ö** und **ü** zusätzlich zu den Zeichen des englischen Alphabeths setzen.

Welche Zeichen erlaubt sind hängt komplett von der verwendeten Sprache ab, da jede Sprache Ihr eigenes Set von
Zeichen definiert.

Es gibt aktuell 3 Sprachen welche nicht mit Ihrer eigenen Schreibweise akzeptiert werden. Diese Sprachen sind
**koreanisch**, **japanisch** und **chinesisch**, da diese Sprachen ein Alphabeth verwenden bei dem einzelne
Zeichen so aufgebaut werden dass Sie mehrere Zeichen verwenden.

Im Falle das diese Sprachen verwendet werden wird der Inhalt nur durch Verwendung des englischen Alphabeths
geprüft.


