.. EN-Revision: none
.. _zend.validator.set.digits:

Digits
======

``Zend_Validate_Digit`` prüft ob ein angegebener Wert nur Ziffern enthält.

.. _zend.validator.set.digits.options:

Unterstützte Optionen für Zend_Validate_Digits
----------------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Validate_Digits``:

.. _zend.validator.set.digits.basic:

Prüfen von Ziffern
------------------

Um zu prüfen ob ein angegebener Wert nur Ziffern und keine anderen Zeichen enthält, muss die Prüfung einfach wie
in diesem Beispiel gezeigt aufgerufen werden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Digits();

   $validator->isValid("1234567890"); // Gibt true zurück
   $validator->isValid(1234);         // Gibt true zurück
   $validator->isValid('1a234');      // Gibt false zurück

.. note::

   **Nummern prüfen**

   Wenn man Nummern oder nummerische Werte prüfen will, muss man darauf achten dass diese Prüfung nur auf Ziffern
   prüft. Das bedeutet dass jedes andere Zeichen wie ein Trennzeichen für Tausender oder ein Komma diese Prüfung
   nicht bestehen. In diesem Fall sollte man ``Zend_Validate_Int`` oder ``Zend_Validate_Float`` verwenden.


