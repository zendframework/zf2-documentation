.. _zend.validate.writing_validators:

Schreiben von Prüfern
=====================

``Zend_Validate`` bietet ein Set von standardmäßig benötigten Prüfern, aber zwangsläufig, werden Entwickler
wünschen, eigene Prüfer für die eigenen Bedürfnisse zu schreiben. Die Aufgabe des Schreibens eigener Prüfer
wird in diesem Kapitel beschrieben.

``Zend_Validate_Interface`` definiert zwei Methoden, ``isValid()`` und ``getMessages()``, welche von
Benutzerklassen implementiert werden können um eigene Prüfobjekte zu erstellen. Ein Objekt welches das
``Zend_Validate_Interface`` Interface implementiert kann einer Prüfkette mit ``Zend_Validate::addValidator()``
hinzugefügt werden. Solche Objekte können auch mit :ref:`Zend_Filter_Input <zend.filter.input>` verwendet werden.

Wie man bereits aus der obigen Beschreibung von ``Zend_Validate_Interface`` folgern kann, geben die vom Zend
Framework bereitgestellten Prüfklassen einen boolschen Wert zurück, ob die Prüfung des Wertes erfolgreich war
oder nicht. Sie geben auch darüber Informationen **warum** ein Wert die Prüfung nicht bestanden hat. Die
Verfügbarkeit der Gründe für fehlgeschlagene Prüfungen kann für eine Anwendung aus vielen Gründen nützlich
sein, wie zum Beispiel das zur Verfügung stellen von Statistiken für Useability Analysen.

Grundlegende Funktionalitäten für fehlgeschlagene Prüfmeldungen ist in ``Zend_Validate_Abstract`` implementiert.
Um diese Funktionalität einzubinden wenn eine Prüfklasse erstellt wird, muß einfach ``Zend_Validate_Abstract``
erweitert werden. In der existierenden Klasse wird die Logik der ``isValid()`` Methode implementiert und die
Variablen für die Nachrichten und Nachrichten-Templates definiert werden die zu den Typen von Prüffehlern passen
die auftreten können. Wenn ein Wert die Prüfung nicht besteht, sollte ``isValid()`` ``FALSE`` zurückgeben. Wenn
der Wert die Prüfung besteht, sollte ``isValid()`` ``TRUE`` zurückgeben.

Normalerweise sollte die ``isValid()`` Methode keine Ausnahmen werfen, ausser wenn es unmöglich ist festzustellen
ob ein Eingabewert gültig ist oder nicht. Einige Beispiele für gute Fälle in denen keine Ausnahme geworfen
werden sollte sind, wenn eine Datei nicht geöffnet werden konnte, ein *LDAP* Server nicht erreicht wurde, oder
eine Datenbank Verbindung unerreichbar ist, und wo solche Dinge für Prüfprozesse benötigt werden um zu erkennen
ob die Prüfung gültig oder ungültig ist.

.. _zend.validate.writing_validators.example.simple:

.. rubric:: Erstellen einer einfachen Prüfklasse

Das folgende Beispiel demonstriert wie ein sehr einfacher eigener Prüfer geschrieben werden könnte. In diesem
Fall sind die Prüfregeln sehr einfach und der Eingabewert muß ein Gleitkommawert sein.

.. code-block:: php
   :linenos:

   class MyValid_Float extends Zend_Validate_Abstract
   {
       const FLOAT = 'float';

       protected $_messageTemplates = array(
           self::FLOAT => "'%value%' ist kein Gleitkommawert"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           if (!is_float($value)) {
               $this->_error(self::FLOAT);
               return false;
           }

           return true;
       }
   }

Die Klasse definiert ein Template für Ihre einzige Nachricht bei Prüfungsfehlern, welche den eingebauten
magischen Parameter **%value%** inkludiert. Der Aufruf von ``_setValue()`` präpariert das Objekt den getesteten
Wert automatisch in die Fehlernachricht einzufügen, wenn die Prüfung des Wertes fehlschlägt. Der Aufruf von
``_error()`` spürt den Grund für die fehlgeschlagene Prüfung auf. Da diese Klasse nur eine Fehlernachricht
definiert, ist es nicht notwendig ``_error()`` den Namen des Templates der Fehlernachricht zu geben.

.. _zend.validate.writing_validators.example.conditions.dependent:

.. rubric:: Schreiben einer Prüfklasse die abhängige Konditionen besitzt

Das folgende Beispiel demonstriert ein komplexeres Set von Prüfregeln, wobei es notwendig ist das der Eingabewert
nummerisch und innerhalb eines Bereiches von Mindest- und Maximalgrenzwerten ist. Bei einem Eingabewert würde die
Prüfung wegen exakt einer der folgenden Gründe fehlschlagen:

- Der Eingabewert ist nicht nummerisch.

- Der Eingabewert ist kleiner als der minimal erlaubte Wert.

- Der Eingabewert ist größer als der maximal erlaubte Wert.

Diese Gründe für fehlgeschlagene Prüfungen werden in Definitionen der Klasse übersetzt:

.. code-block:: php
   :linenos:

   class MyValid_NumericBetween extends Zend_Validate_Abstract
   {
       const MSG_NUMERIC = 'msgNumeric';
       const MSG_MINIMUM = 'msgMinimum';
       const MSG_MAXIMUM = 'msgMaximum';

       public $minimum = 0;
       public $maximum = 100;

       protected $_messageVariables = array(
           'min' => 'minimum',
           'max' => 'maximum'
       );

       protected $_messageTemplates = array(
           self::MSG_NUMERIC => "'%value%' ist nicht nummerisch",
           self::MSG_MINIMUM => "'%value%' muß mindestens '%min%' sein",
           self::MSG_MAXIMUM => "'%value%' darf nicht mehr als '%max%' sein"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           if (!is_numeric($value)) {
               $this->_error(self::MSG_NUMERIC);
               return false;
           }

           if ($value < $this->minimum) {
               $this->_error(self::MSG_MINIMUM);
               return false;
           }

           if ($value > $this->maximum) {
               $this->_error(self::MSG_MAXIMUM);
               return false;
           }

           return true;
       }
   }

Die öffentlichen Eigenschaften ``$minimum`` und ``$maximum`` wurden eingeführt um die Mindest- und Maximalgrenzen
anzubieten, beziehungsweise, für einen Wert um die Prüfung erfolgreich zu bestehen. Die Klasse definiert auch
zwei Nachrichtenvariablen die zu den öffentlichen Eigenschaften korrespondieren und es erlauben ``min`` und
``max`` in den Nachrichten Templates als magische Parameter zu verwenden, genauso wie ``value``.

Zu beachten ist, das wenn eine der Prüfungen in ``isValid()`` fehlschlägt, eine entsprechende Fehlernachricht
vorbereitet wird, und die Methode sofort ``FALSE`` zurückgibt. Diese Prüfregeln sind deswegen sequentiell
abhängig. Das bedeuted, wenn einer der Tests fehlschlägt, gibt es keinen Grund eine weitere nachfolgende
Prüfregel zu testen. Das muß aber trotzdem nicht der Fall sein. Das folgende Beispiel zeigt wie man eine Klasse
schreiben kann die unabhängige Prüfregeln besitzt, wo die Prüfobjekte mehrfache Gründe zurückgeben könnten,
warum ein spezieller Prüfversuch fehlgeschlagen ist.

.. _zend.validate.writing_validators.example.conditions.independent:

.. rubric:: Prüfen mit unabhängigen Konditionen, mehrfache Gründe für Fehler

Angenommen es wird eine Prüfklasse geschrieben für das Erzwingen von Passwortstärke - wenn ein Benutzer ein
Passwort auswählen muß das diversen Kriterien entspricht um zu Helfen das die Benutzerzugänge sicher sind.
Angenommen die Passwort Sicherheitskriterien erzwingen das folgende Passwort:

- mindestens 8 Zeichen Länge,

- enthält mindestens ein großgeschriebenes Zeichen,

- enthält mindestens ein kleingeschriebenes Zeichen,

- und enthält mindestens eine Ziffer.

Die folgende Klasse impementiert diese Prüfkriterien:

.. code-block:: php
   :linenos:

   class MyValid_PasswordStrength extends Zend_Validate_Abstract
   {
       const LENGTH = 'length';
       const UPPER  = 'upper';
       const LOWER  = 'lower';
       const DIGIT  = 'digit';

       protected $_messageTemplates = array(
           self::LENGTH => "'%value%' muß mindestens 8 Zeichen lang sein",
           self::UPPER  => "'%value%' muß mindestens ein großgeschriebenes "
                         . "Zeichen enthalten",
           self::LOWER  => "'%value%' muß mindestens ein kleingeschriebenes "
                         . "Zeichen enthalten",
           self::DIGIT  => "'%value%' muß mindestens eine Ziffer enthalten"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           $isValid = true;

           if (strlen($value) < 8) {
               $this->_error(self::LENGTH);
               $isValid = false;
           }

           if (!preg_match('/[A-Z]/', $value)) {
               $this->_error(self::UPPER);
               $isValid = false;
           }

           if (!preg_match('/[a-z]/', $value)) {
               $this->_error(self::LOWER);
               $isValid = false;
           }

           if (!preg_match('/\d/', $value)) {
               $this->_error(self::DIGIT);
               $isValid = false;
           }

           return $isValid;
       }
   }

Zu beachten ist das diese vier Testkriterien in ``isValid()`` nicht sofort ``FALSE`` zurückgeben. Das erlaubt der
Prüfklasse **alle** Gründe anzubieten bei denen das Eingabepasswort den Prüfvoraussetzungen nicht entsprochen
hat. Wenn, zum Beispiel, ein Benutzer den String "#$%" als Passwort angegeben hat, würde ``isValid()`` alle vier
Prüfungfehlermeldungen zurückgeben bei einen nachfolgenden Aufruf von ``getMessages()``.


