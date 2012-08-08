.. EN-Revision: none
.. _zend.validator.set.identical:

Identical
=========

``Zend_Validate_Identical`` erlaubt es zu prüfen ob ein angegebener Wert mit einem angegebenen Vergleichswert
identisch ist.

.. _zend.validator.set.identical.options:

Unterstützte Optionen für Zend_Validate_Identical
-------------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Identical`` unterstützt:

- **strict**: Definiert ob die Prüfung strikt durchgeführt werden soll. Der Standardwert ist ``TRUE``.

- **token**: Setzt den Token gegen den die Eingabe geprüft werden soll.

.. _zend.validator.set.identical.basic:

Grundsätzliche Verwendung
-------------------------

Um zu prüfen ob zwei Werte identisch sind muss man den originalen Wert als Vergleichswert setzen. Siehe das
folgende Beispiel welches zwei Strings vergleicht.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Identical('original');
   if ($valid->isValid($value) {
       return true;
   }

Die Prüfung wird nur dann ``TRUE`` zurückgeben wenn beide Werte 100% identisch sind. In unserem Beispiel wenn
``$value``'original' ist.

Man kann den gewünschten Token auch im Nachhinein durch Verwendung der Methode ``setToken()`` setzen und mit
``getToken()`` den aktuell gesetzten Token erhalten.

.. _zend.validator.set.identical.types:

Identische Objekte
------------------

Natürlich kann ``Zend_Validate_Identical`` nicht nur Strings prüfen, sondern jeden Variablentyp wie Boolean,
Integer, Float, Array oder sogar Objekte. Wie bereits notiert müssen Vergleichswert und Wert identisch sein.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Identical(123);
   if ($valid->isValid($input)) {
       // Der Wert scheint gültig zu sein
   } else {
       // Der Wert ist ungültig
   }

.. note::

   **Vergleich des Typs**

   Man sollte darauf acht geben das der Typ einer Variable für die Prüfung verwendet wird. Das bedeutet das der
   String **'3'** nicht identisch ist mit dem Integerwert **3**. Wenn man eine nicht strikte Prüfung durchführen
   will muss man die ``strict`` Option setzen.

.. _zend.validator.set.identical.formelements:

Formular Elemente
-----------------

``Zend_Validate_Identical`` unterstützt auch den Vergleich von Formularelementen. Das kann getan werden indem der
Name des Elements als ``token`` verwendet wird. Siehe das folgende Beispiel:

.. code-block:: php
   :linenos:

   $form->addElement('password', 'elementOne');
   $form->addElement('password', 'elementTwo', array(
       'validators' => array(
           array('identical', false, array('token' => 'elementOne'))
       )
   ));

Indem der Elementname vom ersten Element als ``token`` für das zweite Element verwendet wird, prüft der Prüfer
ob das zweite Element gleich dem ersten Element ist. Im Falle das der Benutzer keine zwei identischen Werte
eingegeben hat, erhält man einen Prüffehler.

.. _zend.validator.set.identical.strict:

Strikte Prüfung
---------------

Wie vorher erwähnt prüft ``Zend_Validate_Identical`` die Token strikt. Man kann dieses Verhalten ändern indem
die ``strict`` Option verwendet wird. Der Standardwert für diese Eigenschaft ist ``TRUE``.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Identical(array('token' => 123, 'strict' => FALSE));
   $input = '123';
   if ($valid->isValid($input)) {
       // Die Eingabe scheint gültig zu sein
   } else {
       // Die Eingabe ist ungültig
   }

Der Unterschied zum vorhergehenden Beispiel besteht darin dass die Prüfung in diesem Fall ``TRUE`` zurückgibt,
selbst wenn man einen Integerwert mit einem String prüft solange der Inhalt identisch aber nicht vom gleichen Typ
ist.

Der Bequemlichkeit halber kann man auch ``setStrict()`` und ``getStrict()`` verwenden.

.. _zend.validator.set.identical.configuration:

Konfiguration
-------------

Wie alle anderen Prüfungen unterstützt ``Zend_Validate_Identical`` auch die Verwendung von
Konfigurationseinstellungen als Eingabe Parameter. Das bedeutet das man den Prüfer mit einem ``Zend_Config``
Objekt konfigurieren kann.

Aber das führt zu einem weiteren Fall den man berücksichtigen muss. Wenn man ein Array als Vergleichswert
verwendet, dann sollte man dieses in einen '``token``' Schlüssel einhüllen wenn dieses nur ein Element enthält.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Identical(array('token' => 123));
   if ($valid->isValid($input)) {
       // Der Wert scheint gültig zu sein
   } else {
       // Der Wert ist ungültig
   }

Das oben stehende Beispiel prüft den Integerwert 123. Der Grund für diesen speziellen Fall ist, dass man den
Token der verwendet werden soll, durch Angabe des '``token``' Schlüssels, konfigurieren kann.

Wenn der eigene Vergleichswert nur ein Element enthält, und dieses Element '``token``' heißt dann muss man
dieses, wie im oben stehenden Beispiel gezeigt, einhüllen.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Identical(array('token' => array('token' => 123)));
   if ($valid->isValid($input)) {
       // Der Wert scheint gültig zu sein
   } else {
       // Der Wert ist ungültig
   }


