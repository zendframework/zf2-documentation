.. EN-Revision: none
.. _zend.validator.set.lessthan:

LessThan
========

``Zend_Validate_LessThan`` erlaubt es zu prüfen ob ein angegebener Wert kleiner als ein maximaler Grenzwert ist.
Das ist der Cousine von ``Zend_Validate_GreaterThan``.

.. note::

   **Zend_Validate_LessThan unterstützt nur die Prüfung von Nummern**

   Es sollte beachtet werden das ``Zend_Validate_LessThan`` nur die Prüfung von Nummern unterstützt. Strings oder
   ein Datum können mit dieser Prüfung nicht geprüft werden.

.. _zend.validator.set.lessthan.options:

Unterstützte Optionen für Zend_Validate_LessThan
------------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_LessThan`` unterstützt:

- **max**: Setzt den maximal erlaubten Wert.

.. _zend.validator.set.lessthan.basic:

Normale Verwendung
------------------

Um zu prüfen ob ein angegebener Wert kleiner als eine definierte Grenz ist kann einfach das folgende Beispiel
verwendet werden.

.. code-block:: php
   :linenos:

   $valid  = new Zend_Validate_LessThan(array('max' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // Gibt true zurück

Das obige Beispiel gibt für alle Werte ``TRUE`` zurück die 10 sind oder kleiner als 10.


