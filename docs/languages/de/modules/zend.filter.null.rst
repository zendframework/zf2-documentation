.. EN-Revision: none
.. _zend.filter.set.null:

Null
====

Dieser Filter ändert die angegebene Eingabe so dass Sie ``NULL`` ist wenn Sie spezifischen Kriterien entspricht.
Das ist oft notwendig wenn man mit Datenbanken arbeitet und einen ``NULL`` Wert statt einem Boolean oder
irgendeinem anderen Typ haben will.

.. _zend.filter.set.null.default:

Standardverhalten für Zend_Filter_Null
--------------------------------------

Standardmäßig arbeitet dieser Filter wie *PHP*'s ``empty()`` Methode; in anderen Worten, wenn ``empty()`` ein
boolsches ``TRUE`` zurückgibt, dann wird ein ``NULL`` Wert zurückgegeben.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Null();
   $value  = '';
   $result = $filter->filter($value);
   // Gibt null statt einem leeren String zurück

Das bedeutet das ``Zend_Filter_Null``, ohne die Angabe irgendeiner Konfiguration, alle Eingabetypen akteptiert und
in den selben Fällen ``NULL`` zurückgibt wie ``empty()``.

Jeder andere Wert ist zurückgegeben wie er ist, ohne irgendwelche Änderungen.

.. _zend.filter.set.null.types:

Ändern des Verhaltens von Zend_Filter_Null
------------------------------------------

Manchmal ist es nicht genug basieren auf ``empty()`` zu filtern. Hierfür erlaubt es ``Zend_Filter_Null`` die Typen
zu konfigurieren welche konvertiert werden und jene die nicht konvertiert werden.

Die folgenden Typen können behandelt werden:

- **boolean**: Konvertiert einen boolschen **FALSE** Wert zu ``NULL``.

- **integer**: Konvertiert einen Integer **0** Wert zu ``NULL``.

- **empty_array**: Konvertiert ein leeres **Array** zu ``NULL``.

- **string**: Konvertiert einen leeren String **''** zu ``NULL``.

- **zero**: Konvertiert einen String der eine einzelne Null Ziffer enthält (**'0'**) zu ``NULL``.

- **all**: Konvertiert alle obigen Typen zu ``NULL``. (Das ist das Standardverhalten.)

Es gibt verschiedene Wege um zu wählen welche der obigen Typen gefiltert werden und welche nicht. Man kann einen
oder mehrere Typen angeben und diese addieren, man kann ein Array angeben, man kann Konstanten verwenden, oder man
kann einen textuellen String angeben. Siehe die folgenden Beispiele:

.. code-block:: php
   :linenos:

   // Konvertiert false zu null
   $filter = new Zend_Filter_Null(Zend_Filter_Null::BOOLEAN);

   // Konvertiert false und 0 zu null
   $filter = new Zend_Filter_Null(
       Zend_Filter_Null::BOOLEAN + Zend_Filter_Null::INTEGER
   );

   // Konvertiert false und 0 zu null
   $filter = new Zend_Filter_Null( array(
       Zend_Filter_Null::BOOLEAN,
       Zend_Filter_Null::INTEGER
   ));

   // Konvertiert false und 0 zu null
   $filter = new Zend_Filter_Null(array(
       'boolean',
       'integer',
   ));

Man kann auch eine Instanz von ``Zend_Config`` angeben um die gewünschten Typen zu setzen. Um Typen im nachhinein
zu setzen kann ``setType()`` verwendet werden.


