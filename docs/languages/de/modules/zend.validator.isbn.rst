.. EN-Revision: none
.. _zend.validator.set.isbn:

Isbn
====

``Zend_Validate_Isbn`` erlaubt es einen *ISBN-10* oder *ISBN-13* Wert zu prüfen.

.. _zend.validator.set.isbn.options:

Unterstützte Optionen für Zend_Validate_Isbn
--------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Isbn`` unterstützt:

- **separator**: Definiert das erlaubte Trennzeichen für die *ISBN* Nummer. Diese ist standardmäßig ein leerer
  String.

- **type**: Definiert den erlaubten Typ an *ISBN* Nummern. Dieser ist standardmäßig ``Zend_Validate_Isbn::AUTO``.
  Für Details sollte in :ref:`diesem Abschnitt <zend.validator.set.isbn.type-explicit>` nachgesehen werden.

.. _zend.validator.set.isbn.basic:

Einfache Verwendung
-------------------

Ein einfaches Verwendungsbeispiel ist anbei zu finden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   if ($validator->isValid($isbn)) {
       // ISBN gültig
   } else {
       // ISBN ungültig
   }

Das prüft jeden *ISBN-10* und *ISBN-13* Wert ohne Trennzeichen.

.. _zend.validator.set.isbn.type-explicit:

Einen expliziten ISBN Prüfungstyp setzen
----------------------------------------

Ein Beispiel für die Begrenzung auf einen *ISBN* Typ ist anbei zu finden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   $validator->setType(Zend_Validate_Isbn::ISBN13);
   // ODER
   $validator = new Zend_Validate_Isbn(array(
       'type' => Zend_Validate_Isbn::ISBN13,
   ));

   if ($validator->isValid($isbn)) {
       // Das ist ein gültiger ISBN-13 Wert
   } else {
       // Das ist ein ungültiger ISBN-13 Wert
   }

Das vorherige prüft nur auf *ISBN-13* Werte.

Folgende gültige Typen sind vorhanden:

- ``Zend_Validate_Isbn::AUTO`` (default)

- ``Zend_Validate_Isbn::ISBN10``

- ``Zend_Validate_Isbn::ISBN13``

.. _zend.validator.set.isbn.separator:

Eine Begrenzung auf ein Trennzeichen spezifizieren
--------------------------------------------------

Ein Beispiel für die Begrenzung auf ein Trennzeichen ist anbei zu finden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   $validator->setSeparator('-');
   // ODER
   $validator = new Zend_Validate_Isbn(array(
       'separator' => '-',
   ));

   if ($validator->isValid($isbn)) {
       // Das ist eine gültige ISBN mit Trennzeichen
   } else {
       // Das ist eine ungültige ISBN mit Trennzeichen
   }

.. note::

   **Werte ohne Trennzeichen**

   Es ist zu beachten das dies ``FALSE`` zurückgibt wenn ``$isbn`` kein Trennzeichen **oder** einen ungültigen
   *ISBN* Wert enthält.

Gültige Separatoren sind:

- "" (Leer) (Standardwert)

- "-" (Bindestrich)

- " " (Leerzeichen)


