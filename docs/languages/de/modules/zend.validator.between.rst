.. EN-Revision: none
.. _zend.validate.set.between:

Between
=======

``Zend_Validate_Between`` erlaubt es zu prüfen ob ein angegebener Wert zwischen zwei anderen Werten ist.

.. note::

   **Zend_Validate_Between unterstützt nur die Prüfung von Nummern**

   Es ist zu beachten das ``Zend_Validate_Between`` nur die Prüfung von Nummern unterstützt. Strings, oder ein
   Datum können mit dieser Prüfung nicht geprüft werden.

.. _zend.validate.set.between.options:

Unterstützte Optionen für Zend_Validate_Between
-----------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Between`` unterstützt:

- **inclusive**: Definiert ob die Prüfung inklusive oder explusive der minimalen und maximalen Grenzwerte ist. Sie
  ist standardmäßig ``TRUE``.

- **max**: Setzt die maximale Grenze für die Prüfung.

- **min**: Setzt die minimale Grenze für die Prüfung.

.. _zend.validate.set.between.basic:

Standardverhalten für Zend_Validate_Between
-------------------------------------------

Standardmäßig prüft diese Prüfung ob ein Wert zwischen ``min`` und ``max`` liegt wobei beide Grenzwerte als
Wert erlaubt sind.

.. code-block:: .validator.
   :linenos:

   $valid  = new Zend_Validate_Between(array('min' => 0, 'max' => 10));
   $value  = 10;
   $result = $valid->isValid($value);
   // Gibt true zurück

Im oben stehenden Beispiel ist das Ergebnis ``TRUE`` da die Suche standardmäßig inklusive den Grenzwerten
stattfindet. Das bedeutet in unserem Fall das jeder Wert zwischen '0' und '10' erlaubt ist. Und Werte wie '-1' und
'11' geben ``FALSE`` zurück.

.. _zend.validate.set.between.inclusively:

Prüfung exklusive den Grenzwerten
---------------------------------

Manchmal ist es nützlich einen Wert zu prüfen wobei die Grenzwerte exkludiert werden. Siehe das folgende
Beispiel:

.. code-block:: .validator.
   :linenos:

   $valid  = new Zend_Validate_Between(
       array(
           'min' => 0,
           'max' => 10,
           'inclusive' => false
       )
   );
   $value  = 10;
   $result = $valid->isValid($value);
   // Gibt false zurück

Das Beispiel ist fast so ähnlich wie unser erstes Beispiel, aber wir haben die Grenzwerte ausgeschlossen. Jetzt
sind die Werte '0' und '10' nicht mehr erlaubt und geben ``FALSE`` zurück.


