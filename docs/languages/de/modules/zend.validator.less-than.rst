.. EN-Revision: none
.. _zend.validator.set.lessthan:

LessThan
========

``Zend\Validate\LessThan`` erlaubt es zu prüfen ob ein angegebener Wert kleiner als ein maximaler Grenzwert ist.
Das ist der Cousine von ``Zend\Validate\GreaterThan``.

.. note::

   **Zend\Validate\LessThan unterstützt nur die Prüfung von Nummern**

   Es sollte beachtet werden das ``Zend\Validate\LessThan`` nur die Prüfung von Nummern unterstützt. Strings oder
   ein Datum können mit dieser Prüfung nicht geprüft werden.

.. _zend.validator.set.lessthan.options:

Unterstützte Optionen für Zend\Validate\LessThan
------------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\LessThan`` unterstützt:

- **max**: Setzt den maximal erlaubten Wert.

.. _zend.validator.set.lessthan.basic:

Normale Verwendung
------------------

Um zu prüfen ob ein angegebener Wert kleiner als eine definierte Grenz ist kann einfach das folgende Beispiel
verwendet werden.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\LessThan(array('max' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // Gibt true zurück

Das obige Beispiel gibt für alle Werte ``TRUE`` zurück die 10 sind oder kleiner als 10.


