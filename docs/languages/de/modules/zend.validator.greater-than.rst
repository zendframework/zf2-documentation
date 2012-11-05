.. EN-Revision: none
.. _zend.validator.set.greaterthan:

GreaterThan
===========

``Zend\Validate\GreaterThan`` erlaubt es zu prüfen ob ein angegebener Wert größer ist als ein minimaler
Grenzwert.

.. note::

   **Zend\Validate\GreaterThan unterstützt nur die Überprüfung von Nummern**

   Es sollte beachtet werden das ``Zend\Validate\GreaterThan`` nur die Prüfung von Nummern unterstützt. Strings
   oder ein Datum können mit dieser Prüfung nicht geprüft werden.

.. _zend.validator.set.greaterthan.options:

Unterstützte Optionen für Zend\Validate\GreaterThan
---------------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\GreaterThan`` unterstützt:

- **min**: Setzt den mindesten erlaubten Wert.

.. _zend.validator.set.greaterthan.basic:

Normale Verwendung
------------------

Um zu prüfen ob ein angegebener Wert größer als eine definierte Grenze ist kann einfach das folgende Beispiel
verwendet werden.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\GreaterThan(array('min' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // Gibt true zurück

Das obige Beispiel gibt für alle Werte ``TRUE`` zurück die 10 sind oder größer als 10.


