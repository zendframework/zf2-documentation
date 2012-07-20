.. _zend.validate.set.in_array:

InArray
=======

``Zend_Validate_InArray`` erlaubt es zu prüfen ob ein gegebener Wert in einem Array enthalten ist. Er ist auch in
der Lage mehrdimensionale Arrays zu prüfen.

.. _zend.validate.set.in_array.options:

Unterstützte Optionen für Zend_Validate_InArray
-----------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_InArray`` unterstützt:

- **haystack**: Setzt den Haystack für die Prüfung.

- **recursive**: Definiert ob die Prüfung rekursiv durchgeführt werden soll. Diese Option ist standardmäßig
  ``FALSE``.

- **strict**: Definiert ob die Prüfung strikt durchgeführt werden soll. Diese Option ist standardmäßig
  ``FALSE``.

.. _zend.validate.set.in_array.basic:

Einfache Array Prüfung
----------------------

Der einfachste Weg ist es, das Array welches durchsucht werden soll, bei der Initiierung anzugeben:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(array('key' => 'value',
                                                'otherkey' => 'othervalue'));
   if ($validator->isValid('value')) {
       // Wert gefunden
   } else {
       // Wert nicht gefunden
   }

Das verhält sich genauso wie *PHP*'s ``in_array()`` Methode.

.. note::

   Standardmäßig ist diese Prüfung nicht strikt noch kann Sie mehrdimensionale Arrays prüfen.

Natürlich kann man das Array gegen das geprüft werden soll auch im Nachhinein durch Verwendung der
``setHaystack()`` Methode angegeben werden. ``getHaystack()`` gibt das aktuell gesetzte Haystack Array zurück.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray();
   $validator->setHaystack(array('key' => 'value', 'otherkey' => 'othervalue'));

   if ($validator->isValid('value')) {
       // Wert gefunden
   } else {
       // Wert nicht gefunden
   }

.. _zend.validate.set.in_array.strict:

Strikte Array Prüfung
---------------------

Wie vorher erwähnt kann man auch eine Strikte Prüfung im Array durchführen. Standardmäßig würde kein
Unterschied zwischen dem Integerwert **0** und dem String **"0"** sein. Wenn eine strikte Prüfung durchgeführt
wird dann wird dieser Unterschied auch geprüft und nur gleiche Typen werden akzeptiert.

Eine strikte Prüfung kann auch auf zwei verschiedenen Wegen durchgeführt werden. Bei der Initiierung und durch
Verwendung einer Methode. Bei der Initiierung muß hierfür ein Array mit der folgenden Struktur angegeben werden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'haystack' => array('key' => 'value', 'otherkey' => 'othervalue'),
           'strict'   => true
       )
   );

   if ($validator->isValid('value')) {
       // Wert gefunden
   } else {
       // Wert nicht gefunden
   }

Der **haystack** Schlüssel enthält das eigene Array das für die Prüfung verwendet wird. Durch das Setzen des
**script** Schlüssels auf ``TRUE`` wird die Prüfung so durchgeführt, das der Typ strikt geprüft wird.

Natürlich kann man auch die ``setStrict()`` Methode verwenden um diese Einstellung im Nachhinein zu ändern und
``getStrict()`` um den aktuell gesetzten Status zu erhalten.

.. note::

   Es ist zu beachten das die **strict** Einstellung standardmäßig ``FALSE`` ist.

.. _zend.validate.set.in_array.recursive:

Rekursive Array Prüfung
-----------------------

Zusätzlich zu *PHP*'s ``in_array()`` Methode kann diese Prüfung auch verwendet werden um Mehrdimensionale Arrays
zu prüfen.

Um mehrdimensionale Array zu prüfen muß die **recursive** Option gesetzt werden.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'haystack' => array(
               'firstDimension' => array('key' => 'value',
                                         'otherkey' => 'othervalue'),
               'secondDimension' => array('some' => 'real',
                                          'different' => 'key')),
           'recursive' => true
       )
   );

   if ($validator->isValid('value')) {
       // Wert gefunden
   } else {
       // Wert nicht gefunden
   }

Das eigene Array wird das rekursiv geprüft um zu sehen ob der angegebene Wert enthalten ist. Zusätzlich kann
``setRecursive()`` verwendet werden um diese Option im Nachhinein zu setzen und ``getRecursive()`` um Ihn zu
erhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'firstDimension' => array('key' => 'value',
                                     'otherkey' => 'othervalue'),
           'secondDimension' => array('some' => 'real',
                                      'different' => 'key')
       )
   );
   $validator->setRecursive(true);

   if ($validator->isValid('value')) {
       // Wert gefunden
   } else {
       // kein Wert gefunden
   }

.. note::

   **Standardwert für die Rekursion**

   Standardmäßig ist die rekursive Prüfung ausgeschaltet.

.. note::

   **Optionsschlüssel im Haystack**

   Wenn man die Schlüssel '``haystack``', '``strict``' oder '``recursive``' im eigenen Haystack verwenden, dann
   muß man diese mit dem ``haystack`` Schlüssel einhüllen.


