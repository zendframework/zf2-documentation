.. EN-Revision: none
.. _zend.validate.set.creditcard:

CreditCard
==========

``Zend_Validate_CreditCard`` erlaubt es zu prüfen ob ein angegebener Wert eine Kreditkarten Nummer sein könnte.

Eine Kreditkarte enthält verschiedene Elemente an Metadaten, inklusive ein Hologramm, die Accountnummer, Logo,
Ablaufdatum, Sicherheitscode und den Namen des Kreditkartenbesitzers. Die Algorithmen für die Prüfung der
Kombination an Metadaten sind nur der ausgebenden Firma bekannt, und sollten mit Ihnen zum Zwecke der Zahlung
geprüft werden. Trotzdem ist es oft nützlich zu wissen ob eine akutell angegebene Nummer in den Bereich der
möglichen Nummern fällt **bevor** so eine Überprüfung durchgeführt wird, und daher prüft
``Zend_Validate_CreditCard`` einfach ob die angegebene Kreditkartennummer entspricht.

Für die Fälle in denen man ein Service hat, das tiefere Prüfungen durchführt, bietet
``Zend_Validate_CreditCard`` auch die Möglichkeit einen Service Callback anzuhängen der ausgeführt wird sobald
die Kreditkartennummer vorbehaltlich als gültig geprüft wurde; dieser Callback wird dann ausgeführt, und sein
Rückgabewert wird die komplette Gültigkeit erkennen.

Die folgenden Kreditkarteninstitute werden akzeptiert:

- **American Express**

  **China UnionPay**

  **Diners Club Card Blanche**

  **Diners Club International**

  **Diners Club US & Canada**

  **Discover Card**

  **JCB**

  **Laser**

  **Maestro**

  **MasterCard**

  **Solo**

  **Visa**

  **Visa Electron**

.. note::

   **Ungültige Institute**

   Die Institute **Bankcard** und **Diners Club enRoute** existieren nicht mehr. Deshalb werden Sie als ungültig
   erkannt.

   **Switch** wurde zu **Visa** umbenannt und wird daher auch als ungültig erkannt.

.. _zend.validate.set.creditcard.options:

Unterstützte Optionen für Zend_Validate_CreditCard
--------------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_CreditCard`` unterstützt:

- **service**: Ein Callback zu einem Online Service welcher zusätzlich für die Prüfung verwendet wird.

- **type**: Der Typ der Kreditkarte der geprüft werden soll. Siehe die folgende Liste an Instituten für Details.

.. _zend.validate.set.creditcard.basic:

Grundsätzliche Verwendung
-------------------------

Es gibt verschiedene Kreditkarten Institute wie mit ``Zend_Validate_CreditCard`` geprüft werden können.
Standardmäßig werden alle bekannte Institute akzeptiert. Siehe das folgende Beispiel:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend_Validate_CreditCard();
   if ($valid->isValid($input)) {
       // Die Eingabe scheint gültig zu sein
   } else {
       // Die Eingabe ist ungültig
   }

Das oben stehende Beispiel würde alle bekannten Kreditkarten Institute als gültig erkennen.

.. _zend.validate.set.creditcard.institute:

Definierte Kreditkarte akzeptieren
----------------------------------

Manchmal ist es notwendig nur definierte Kreditkarten Institute zu akzeptieren statt alle; z.B wenn man einen
Webshop hat der nur Visa und American Express Karten akzeptiert. ``Zend_Validate_CreditCard`` erlaubt einem exakt
das zu tun, indem auf genau diese Institute limitiert wird.

Um ein Limit zu verwenden kann man entweder spezifische Institute bei der Initiierung angeben, oder im nachhinein
durch Verwendung von ``setType()``. Jede kann verschiedene Argumente verwenden.

Man kann ein einzelnes Institut angeben:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend_Validate_CreditCard(
       Zend_Validate_CreditCard::AMERICAN_EXPRESS
   );

Wenn man mehrere Institute erlauben will, dann kann man diese als Array angeben:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend_Validate_CreditCard(array(
       Zend_Validate_CreditCard::AMERICAN_EXPRESS,
       Zend_Validate_CreditCard::VISA
   ));

Wie bei allen Prüfern kann man auch ein assoziatives Array an Optionen oder eine Instanz von ``Zend_Config``
angeben. In diesem Fall muß man die Institute mit dem Arrayschlüssel ``type`` angeben wie hier simuliert:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend_Validate_CreditCard(array(
       'type' => array(Zend_Validate_CreditCard::AMERICAN_EXPRESS)
   ));

.. _zend.validate.set.creditcard.institute.table:

.. table:: Konstanten für Kreditkarten Institute

   +-------------------------+----------------+
   |Institut                 |Konstante       |
   +=========================+================+
   |American Express         |AMERICAN_EXPRESS|
   +-------------------------+----------------+
   |China UnionPay           |UNIONPAY        |
   +-------------------------+----------------+
   |Diners Club Card Blanche |DINERS_CLUB     |
   +-------------------------+----------------+
   |Diners Club International|DINERS_CLUB     |
   +-------------------------+----------------+
   |Diners Club US & Canada  |DINERS_CLUB_US  |
   +-------------------------+----------------+
   |Discover Card            |DISCOVER        |
   +-------------------------+----------------+
   |JCB                      |JCB             |
   +-------------------------+----------------+
   |Laser                    |LASER           |
   +-------------------------+----------------+
   |Maestro                  |MAESTRO         |
   +-------------------------+----------------+
   |MasterCard               |MASTERCARD      |
   +-------------------------+----------------+
   |Solo                     |SOLO            |
   +-------------------------+----------------+
   |Visa                     |VISA            |
   +-------------------------+----------------+
   |Visa Electron            |VISA            |
   +-------------------------+----------------+

Man kann Institute auch im Nachhinein setzen oder hinzufügen indem die Methoden ``setType()``, ``addType()`` und
``getType()`` verwendet werden.

.. code-block:: .validator.
   :linenos:

   $valid = new Zend_Validate_CreditCard();
   $valid->setType(array(
       Zend_Validate_CreditCard::AMERICAN_EXPRESS,
       Zend_Validate_CreditCard::VISA
   ));

.. note::

   **Standard Institute**

   Wenn bei der Initiierung kein Institut angegeben wird, dann wird ``ALL`` verwendet, welches alle Institute auf
   einmal verwendet.

   In diesem Fall ist die Verwendung von ``addType()`` sinnlos weil bereits alle Institute hinzugefügt wurden.

.. _zend.validate.set.creditcard.servicecheck:

Prüfung durch Verwendung einer fremden API
------------------------------------------

Wie vorher erwähnt prüft ``Zend_Validate_CreditCard`` nur die Kreditkarten Nummer. Glücklicherweise bieten
einige Institute online *API*\ s welche eine Kreditkarten Nummer durch Verwendung von Algorithmen prüfen kann,
welche nicht öffentlich bekannt sind. Die meisten dieser Services sind zu bezahlen. Deshalb ist diese Art der
Prüfung standardmäßig deaktiviert.

Wenn man auf so eine *API* zugreift, kann man diese als Addon für ``Zend_Validate_CreditCard`` verwenden um die
Sicherheit der Prüfung zu erhöhen.

Um das zu tun muss man einfach einen Callback angeben der aufgerufen wird wenn die generische Prüfung erfolgreich
war. Das verhindert das die *API* für ungültige Nummern aufgerufen wird, was wiederum die Performance der
Anwendung erhöht.

``setService()`` setzt ein neues Service und ``getService()`` gibt das gesetzte Service zurück. Als Option für
die Konfiguration kann man den Arrayschlüssel '``service``' bei der Initiierung verwenden. Für Details über
mögliche Optionen kann man unter :ref:`Callback <zend.validate.set.callback>` nachsehen.

.. code-block:: .validator.
   :linenos:

   // Die eigene Service Klasse
   class CcService
   {
       public function checkOnline($cardnumber, $types)
       {
           // einige online Prüfungen
       }
   }

   // Die Prüfung
   $service = new CcService();
   $valid   = new Zend_Validate_CreditCard(Zend_Validate_CreditCard::VISA);
   $valid->setService(array($service, 'checkOnline'));

Wie man sieht wird die Callback Methode mit der Kreditkarten Nummer als erster Parameter aufgerufen, und die
akzeptierten Typen als zweiter Parameter.


