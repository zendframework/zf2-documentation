.. _zend.json.basics:

Grundlegende Verwendung
=======================

Die Verwendung von ``Zend_Json`` bedingt den Gebrauch der beiden öffentlich verfügbaren, statischen Methoden
``Zend_Json::encode()`` und ``Zend_Json::decode()``.

.. code-block:: php
   :linenos:

   // Empfange einen Wert
   $phpNative = Zend_Json::decode($encodedValue);

   // Kodiere ihn für die Rückgabe an den Client:
   $json = Zend_Json::encode($phpNative);

.. _zend.json.basics.prettyprint:

Schön-drucken von JSON
----------------------

Manchmal ist es schwer *JSON* Daten zu durchsuchen welche von ``Zend_Json::encode()`` erzeugt wurden da Sie keine
Leerzeichen oder Einrückungen enthalten. Um das einfacher zu machen erlaubt es ``Zend_Json`` *JSON* schön
ausgedruckt, in einem menschlich-lesbaren Format, zu erhalten, indem man ``Zend_Json::prettyPrint()`` verwendet.

.. code-block:: php
   :linenos:

   // Kodieren und an den Client zurückzugeben:
   $json = Zend_Json::encode($phpNative);
   if($debug) {
       echo Zend_Json::prettyPrint($json, array("indent" => " "));
   }

Das zweite optionale Argument von ``Zend_Json::prettyPrint()`` ist ein Optionen Array. Die Option ``indent``
erlaubt es einen String für die Einrückung zu definieren - standardmäßig ist das ein einzelnes Tabulator
Zeichen.


