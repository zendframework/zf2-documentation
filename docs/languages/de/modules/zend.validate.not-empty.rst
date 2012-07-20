.. _zend.validate.set.notempty:

NotEmpty
========

Dieser Prüfer erlaubt es zu prüfen ob ein angegebener Wert nicht leer ist. Das ist oft nützlich wenn man mit
Formular Elementen oder anderen Benutzereingaben arbeitet, und man sicherstellen will das den benötigten Elementen
Werte zugeordnet wurden.

.. _zend.validate.set.notempty.options:

Unterstützte Optionen für Zend_Validate_NotEmpty
------------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_NotEmpty`` unterstützt:

- **type**: Setzt den Typ der Prüfung welcher durchgeführt wird. Für Details sollte in :ref:`diesem Abschnitt
  <zend.validate.set.notempty.types>` nachgesehen werden.

.. _zend.validate.set.notempty.default:

Standardverhalten für Zend_Validate_NotEmpty
--------------------------------------------

Standardmäßig arbeitet diese Prüfung anders als man es laut *PHP*'s ``empty()`` Funktion erwarten würde. Im
speziellen evaluiert diese Prüfung den den Integer **0** und den String '**0**' als leer.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_NotEmpty();
   $value  = '';
   $result = $valid->isValid($value);
   // gibt false zurück

.. note::

   **Unterschiedliches Standardverhalten zu PHP**

   Ohne Angabe einer Konfiguration ist das Verhalten von ``Zend_Validate_NotEmpty`` anders als das von *PHP*.

.. _zend.validate.set.notempty.types:

Ändern des Verhaltens für Zend_Validate_NotEmpty
------------------------------------------------

Einige Projekte haben andere Ansichten davon was als "leerer" Wert angesehen wird: ein String der nur Leerzeichen
enthält könnte als leer angesehen werden, oder **0** könnte als nicht leer angesehen werden (speziell für
boolsche Sequenzen). Um den unterschiedlichen Notwendigkeiten gerecht zu werden erlaubt es
``Zend_Validate_NotEmpty`` die Typen zu konfigurieren welche als leer angesehen werden und jene die es nicht
werden.

Die folgenden Typen können behandelt werden:

- **boolean**: Gibt ``FALSE`` zurück wenn der boolsche Wert ``FALSE`` ist.

- **integer**: Gibt ``FALSE`` zurück wenn ein Integerwert **0** angegeben ist. Standardmäßig ist diese Prüfung
  nicht aktiviert und gibt bei jedem Integerwert ``TRUE`` zurück.

- **float**: Gibt ``FALSE`` zurück wenn die Gleitkommazahl **0.0** angegeben ist. Standardmäßig ist diese
  Prüfung nicht aktiviert und gibt bei jeder Gleitkommazahl ``TRUE`` zurück.

- **string**: Gibt ``FALSE`` zurück wenn ein leerer String **''** angegeben wird.

- **zero**: Gibt ``FALSE`` zurück wenn das einzelne Zeichen Null (**'0'**) angegeben wird.

- **empty_array**: Gibt ``FALSE`` zurück wenn ein leeres **array** angegeben wird.

- **null**: Gibt ``FALSE`` zurück wenn ein ``NULL`` Wert angegeben wird.

- **php**: Gibt bei den gleichen Gründen ``FALSE`` zurück wo auch *PHP*'s Methode ``empty()`` ``TRUE``
  zurückgeben würde.

- **space**: Gibt ``FALSE`` zurück wenn ein String angegeben wird der nur Leerzeichen enthält.

- **object**: Gibt ``TRUE`` zurück wenn ein Objekt angegeben wurde. ``FALSE`` wird zurückgegeben wenn ``object``
  nicht erlaubt, aber ein Objekt angegeben wurde.

- **object_string**: Gibt ``FALSE`` zurück wenn ein Objekt angegeben wurde und dessen ``__toString()`` Methode
  einen leeren String zurückgibt.

- **object_count**: Gibt ``FALSE`` zurück wenn ein Objekt angegeben wurde, es ein ``Countable`` Interface hat und
  seine Anzahl 0 ist.

- **all**: Gibt bei allen oben stehenden Typen ``FALSE`` zurück.

Alle anderen Werte geben standardmäßig ``TRUE`` zurück.

Es gibt verschiedene Wege um zu wählen welche der obigen Typen geprüft werden sollen. Man kann ein oder mehrere
Typen angeben und Sie hinzufügen, man kann ein Array angeben, man kann Konstanten verwenden, oder man gibt einen
textuellen String an. Siehe auch die folgenden Beispiele:

.. code-block:: php
   :linenos:

   // Gibt bei 0 false zurück
   $validator = new Zend_Validate_NotEmpty(Zend_Validate_NotEmpty::INTEGER);

   // Gibt bei 0 oder '0' false zurück
   $validator = new Zend_Validate_NotEmpty(
       Zend_Validate_NotEmpty::INTEGER + Zend_NotEmpty::ZERO
   );

   // Gibt bei 0 oder '0' false zurück
   $validator = new Zend_Validate_NotEmpty(array(
       Zend_Validate_NotEmpty::INTEGER,
       Zend_Validate_NotEmpty::ZERO
   ));

   // Gibt bei 0 oder '0' false zurück
   $validator = new Zend_Validate_NotEmpty(array(
       'integer',
       'zero',
   ));

Man kann auch eine Instanz von ``Zend_Config`` angeben um die gewünschten Typen zu setzen. Um Typen nach der
Instanzierung zu setzen kann die Methode ``setType()`` verwendet werden.


