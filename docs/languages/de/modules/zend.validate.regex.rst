.. _zend.validate.set.regex:

Regex
=====

Diese Prüfung erlaubt es zu prüfen ob ein angegebener String einer definierten Regular Expression entspricht.

.. _zend.validate.set.regex.options:

Unterstützte Optionen für Zend_Validate_Regex
---------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Regex`` unterstützt:

- **pattern**: Setzt das Pattern der Regular Expression für diese Prüfung.

.. _zend.validate.set.regex.basic:

Prüfen mit Zend_Validate_Regex
------------------------------

Die Prüfung mit Regular Expressions erlaubt es komplizierte Prüfungen durchzuführen, ohne das eine eigene
Prüfung geschrieben werden muss. Die Verwendung von Regular Expressions ist relativ üblich und einfach. Sehen wir
uns ein Beispiel an:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Regex(array('pattern' => '/^Test/');

   $validator->isValid("Test"); // Gibt true zurück
   $validator->isValid("Testing"); // Gibt true zurück
   $validator->isValid("Pest"); // Gibt false zurück

Wie man sehen kann hat das Pattern welches anzugeben ist die gleiche Syntax wie für ``preg_match()``. Für Details
über Regular Expressions sollte man einen Blick in `PHP's Handbuch über die PCRE Pattern Syntax`_ werfen.

.. _zend.validate.set.regex.handling:

Handhabung von Pattern
----------------------

Es ist auch möglich andere Pattern im Nachhinein zu setzen indem ``setPattern()`` verwendet wird, und das aktuell
gesetzte Pattern mit ``getPattern()`` erhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Regex(array('pattern' => '/^Test/');
   $validator->setPattern('ing$/');

   $validator->isValid("Test"); // Gibt false zurück
   $validator->isValid("Testing"); // Gibt true zurück
   $validator->isValid("Pest"); // Gibt false zurück



.. _`PHP's Handbuch über die PCRE Pattern Syntax`: http://php.net/manual/en/reference.pcre.pattern.syntax.php
