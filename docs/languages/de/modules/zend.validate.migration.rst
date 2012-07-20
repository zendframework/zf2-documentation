.. _zend.validate.migration:

Migration von vorhergehenden Versionen
======================================

Die *API* von ``Zend_Validate`` wurde von Zeit zu Zeit geändert. Wenn man begonnen hat ``Zend_Validate`` und
dessen Unterkomponenten in früheren Versionen zu verwenden sollte man den folgenden Richtlinien folgen um eigene
Skripte zur neuen *API* zu migrieren.

.. _zend.validate.migration.fromoneninetooneten:

Migration von 1.9 zu 1.10 oder neuer
------------------------------------

.. _zend.validate.migration.fromoneninetooneten.selfwritten:

Selbst geschriebene Adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn in einer selbst geschriebenen Prüfung ein Fehler gesetzt wird um diesen zurückzugeben muß die ``_error()``
Methode aufgerufen werden. Vor Zend Framework 1.10 konnte man diese Methode ohne einen angegebenen Parameter
aufrufen. Es wurde dann das erste gefundene Nachrichtentemplate verwendet.

Dieses Verhalten ist problematisch wenn man Prüfungen hat die mehr als eine Nachricht zurückgeben kann. Auch wenn
man eine existierende Prüfung erweitert kann man unerwartete Ergebnisse erhalten. Das kann zum Problem führen das
der Benutzer nicht die Nachricht erhält die man erwartet.

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(); // Unerwartete Ergebnisse zwischen verschiedenen OS
           ...
       }
   }

Um dieses Problem zu verhindern erlaubt es die ``_error()`` Methode nicht mehr ohne einen angegebenen Parameter
aufgerufen zu werden.

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(self::MY_ERROR);
           // Definierter Fehler, keine unerwarteten Ergebnisse
           ...
       }
   }

.. _zend.validate.migration.fromoneninetooneten.datevalidator:

Vereinfachungen im Date Prüfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vor Zend Framework 1.10 wurden 2 identische Nachrichten im Date Prüfer geworfen. Es gab ``NOT_YYYY_MM_DD`` und
``FALSEFORMAT``. Ab Zend Framework 1.10 wird nur mehr die ``FALSEFORMAT`` Meldung zurückgegeben wenn das
angegebene Datum mit dem gesetzten Format nicht übereinstimmt.

.. _zend.validate.migration.fromoneninetooneten.barcodevalidator:

Fehlerbehebungen im Alpha, Alum und Barcode Prüfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vor dem Zend Framework 1.10 waren Nachrichten in den 2 Barcode Adaptern, dem Alpha und dem Alnum Prüfer identisch.
Das führte zu Problemen bei der Verwendung von eigenen Meldungen, Übersetzungen oder mehreren Instanzen dieser
Prüfer.

Mit Zend Framework 1.10 wurden die Werte dieser Konstanten so geändert das Sie eindeutig sind. Wenn man, so wie es
im Handbuhc erklärt wird, die Konstanten verwendet gibt es keine Änderungen. Aber wenn man den Inhalt der
Konstanten im eigenen Code verwendet dann muß man diese Ändern. Die folgende Tabelle zeigt die geänderten Werte:

.. _zend.validate.migration.fromoneninetooneten.barcodevalidator.table:

.. table:: Vorhandenen Meldungen der Prüfer

   +-------------+--------------+------------------+
   |Prüfer       |Konstante     |Wert              |
   +=============+==============+==================+
   |Alnum        |STRING_EMPTY  |alnumStringEmpty  |
   +-------------+--------------+------------------+
   |Alpha        |STRING_EMPTY  |alphaStringEmpty  |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID       |ean13Invalid      |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID_LENGTH|ean13InvalidLength|
   +-------------+--------------+------------------+
   |Barcode_UpcA |INVALID_LENGTH|upcaInvalidLength |
   +-------------+--------------+------------------+
   |Digits       |STRING_EMPTY  |digitsStringEmpty |
   +-------------+--------------+------------------+


