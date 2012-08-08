.. EN-Revision: none
.. _zend.validator.set.hex:

Hex
===

``Zend_Validate_Hex`` erlaubt es zu prüfen ob ein angegebener Wert nur hexadezimale Zeichen enthält. Das sint
alle Zeichen von **0 bis 9** und unabhängig von der Schreibweise **A bis F**. Es gibt keine Begrenzung der Länge
für den Wert welchen man prüfen will.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hex();
   if ($validator->isValid('123ABC')) {
       // Der Wert enthält nur Hex Zeichen
   } else {
       // Falsch
   }

.. note::

   **Ungültige Zeichen**

   Alle anderen Zeichen geben false zurück, inklusive Leerzeichen und Kommazeichen. Auch Unicode Nullzeichen und
   Ziffern von anderen Schriften als Latein werden nicht als gültig erkannt.

.. _zend.validator.set.hex.options:

Unterstützte Optionen für Zend_Validate_Hex
-------------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Validate_Hex``:


