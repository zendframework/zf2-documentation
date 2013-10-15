.. EN-Revision: none
.. _zend.authentication.introduction:

Einführung
==========

``Zend_Auth`` bietet eine *API* für das Authentifizieren und enthält konkrete Authentifizierungs-Adapter für
übliche Use Case Szenarien.

``Zend_Auth`` behandelt nur die **Authentifizierung** und nicht die **Authorisierung**. Authentifizierung ist lose
definiert als das Ermitteln ob eine Entität aktuell das ist was Sie vorgibt zu sein (z.B. Identifizierung),
basierend auf einem Set von Zeugnissen. Authorisierung, der Prozess des Entscheidens ob es einer Entität erlaubt
wird auf andere Entitäten Zugriff zu erhalten, oder um auf diesen Operationen durchzuführen, ist ausserhalb der
Möglichkeit von ``Zend_Auth``. Für weitere Informationen über Authorisierung und Zugriffskontrolle mit dem Zend
Framework, sollte :ref:`Zend\Permissions\Acl <zend.permissions.acl>` angeschaut werden.

.. note::

   Die ``Zend_Auth`` Klasse implementiert das Singleton Pattern - nur eine Instanz der Klasse ist vorhanden - durch
   Ihre statische ``getInstance()`` Methode. Das bedeutet das die Verwendung des **new** Operators und des
   **clone** Keywords mit der ``Zend_Auth`` Klasse nicht funktioniert; stattdessen muß
   ``Zend\Auth\Auth::getInstance()`` verwendet werden.

.. _zend.authentication.introduction.adapters:

Adapter
-------

Ein ``Zend_Auth`` Adapter wird verwendet um sich gegenüber einem speziellen Typ von Authentifizierungs Services zu
authentifizieren, wie *LDAP*, *RDBMS*, oder Datei-basierenden Speichern. Verschiedene Adapter besitzen leicht
unterschiedliche Optionen und Verhaltensweisen, aber einige grundlegende Dinge sind für Authentifizierungs Adapter
üblich. Zum Beispiel das die Authentifizierung Zeugnisse akzeptiert werden (enthält auch vorgegebene
Identitäten), das Abfragen am Authentifizierungsservice durchgeführt werden, und das Ergebnisse zurückgegeben
werden, sind für ``Zend_Auth`` Adapter üblich.

Jede ``Zend_Auth`` Adapter Klasse implementiert ``Zend\Auth\Adapter\Interface``. Dieses Interface definiert eine
Methode, ``authenticate()``, die eine Adapter Klasse implementieren muß um eine Authentifizierungsanfrage
auszuführen. Jede Adapter Klasse muß vorher vorbereitet sein bevor ``authenticate()`` aufgerufen wird. Diese
Vorbereitung des Adapters enthält das Setzen der Zeugnisse (z.B. Benutzername und Passwort) und die Definition von
Werten für Adapter spezifische Konfigurationoptionen, wie Datenbank Verbindungsdaten für einen Datenbank Tabellen
Adapter.

Das folgende ist ein Beispiel eines Authentifierungs-Adapters der einen Benutzernamen und ein Passwort für die
Authentifizierung benötigt. Andere Details, wie zum Beispiel der Authentifizierungs-Service abgefragt wird, werden
der Kürze halber ausgelassen:

.. code-block:: php
   :linenos:

   class MyAuthAdapter implements Zend\Auth\Adapter\Interface
   {
       /**
        * Setzt Benutzername und Passwort für die Authentifizierung
        *
        * @return void
        */
       public function __construct($username, $password)
       {
           // ...
       }

       /**
        * Führt einen Authentifizierungs-Versuch durch
        *
        * @throws Zend\Auth\Adapter\Exception Wenn die Authentifizierung nicht
        *                                     durchgeführt wurde
        * @return Zend\Auth\Result
        */
       public function authenticate()
       {
           // ...
       }
   }

Wie im Docblock angegeben, muß ``authenticate()`` eine Instanz von ``Zend\Auth\Result`` (oder einer von
``Zend\Auth\Result`` abgeleiteten Klassen) zurückgeben. Wenn aus bestimmten Gründen eine Durchführung einer
Authentifizierungs-Anfrage nicht möglich ist, sollte ``authenticate()`` eine Ausnahme werfen die von
``Zend\Auth\Adapter\Exception`` abgeleitet ist.

.. _zend.authentication.introduction.results:

Ergebnisse
----------

``Zend_Auth`` Adapter geben eine Instanz von ``Zend\Auth\Result`` mit Hilfe von ``authenticate()`` zurück um die
Ergebnisse des Authentifizierungs-Versuches darzustellen. Adapter veröffentlichen das ``Zend\Auth\Result`` Objekt
bei der Erstellung, so das die folgenden vier Methoden ein grundsätzliches Set von Benutzerbezogenen Operationen
bieten die für die Ergebnisse von ``Zend_Auth`` Adapter üblich sind:

- ``isValid()``- Gibt ``TRUE`` zurück wenn und nur wenn das Ergebnis einen erfolgreichen
  Authentifizierungs-Versuch repräsentiert

- ``getCode()``- Gibt einen konstanten ``Zend\Auth\Result`` Identifizierer damit der Typ des
  Authentifizierungs-Fehlers, oder des Erfolgs der stattgefunden hat, ermittelt werden kann. Das kann in
  Situationen verwendet werden in denen der Entwickler die verschiedenen Ergebnistypen der Authentifizierung
  unterschiedlich behandeln will. Das erlaubt es dem Entwickler zum Beispiel detailierte Statistiken über die
  Authentifizierungs-Ergebnisse zu erhalten. Eine andere Verwendung dieses Features ist es spezielle,
  benutzerdefinierte Nachrichten anzubieten, um Benutzern eine bessere Usability zu ermöglichen, einfach dadurch
  das Entwickler dazu aufgerufen sind die Risiken solche defailierte Informationen Benutzern anzubieten, statt
  einer generellen Nachricht eines Authentifizierungs-Fehlers. Für weitere Informationen siehe die Notiz anbei.

- ``getIdentity()``- Gibt die Identität des Authentifizierungs-Versuchs zurück

- ``getMessages()``- Gibt ein Array von Nachrichten zurück nach einem fehlgeschlagenen Authentifizierungs-Versuch

Ein Entwickler kann wünschen basierend auf dem Typ des Authentifizierungs-Ergebnisses zu verzweigen um
spezialisiertere Operationen durchzuführen. Einige Operationen die für Entwickler nützlich sein können sind zum
Beispiel das Sperren von Konten nachdem zu oft ein falsches Passwort angegeben wurde, das markieren von IP Adressen
nachdem zuviele nicht existierende Identitäten angegeben wurden und das anbieten von speziellen,
benutzerdefinierten Nachrichten für Authentifizierungs-Ergebnisse an den Benutzer. Die folgenden Ergebniscodes
sind vorhanden:

.. code-block:: php
   :linenos:

   Zend\Auth\Result::SUCCESS
   Zend\Auth\Result::FAILURE
   Zend\Auth\Result::FAILURE_IDENTITY_NOT_FOUND
   Zend\Auth\Result::FAILURE_IDENTITY_AMBIGUOUS
   Zend\Auth\Result::FAILURE_CREDENTIAL_INVALID
   Zend\Auth\Result::FAILURE_UNCATEGORIZED

Das folgende Beispiel zeigt wie ein Entwickler anhand des Ergebniscodes verzweigen könnte:

.. code-block:: php
   :linenos:

   // Innerhalb von AuthController / loginAction
   $result = $this->_auth->authenticate($adapter);

   switch ($result->getCode()) {

       case Zend\Auth\Result::FAILURE_IDENTITY_NOT_FOUND:
           /** Was wegen nicht existierender Identität machen **/
           break;

       case Zend\Auth\Result::FAILURE_CREDENTIAL_INVALID:
           /** Was wegen ungültigen Zeugnissen machen **/
           break;

       case Zend\Auth\Result::SUCCESS:
           /** Was wegen erfolgreicher Authentifizierung machen **/
           break;

       default:
           /** Was wegen anderen Fehlern machen **/
           break;
   }

.. _zend.authentication.introduction.persistence:

Dauerhafte Identitäten
----------------------

Eine Anfrage zu authentifizieren die Authentifizierungs Zeugnisse enthält ist per se nützlich, aber auch wichtig
um die Authentifizierungs Identität bearbeiten zu können ohne das immer die Authentifizierungs Zeugnisse mit
jeder Anfrage vorhanden sein müssen.

Trotzdem ist *HTTP* ein statusloses Protokoll, und Techniken wie Cookies und Sessions wurden entwickelt um Stati
über mehrere Anfragen hinweg in Server-seitigen Web Anwendungen zu erhalten.

.. _zend.authentication.introduction.persistence.default:

Normale Persistenz in PHP Sessions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig bietet ``Zend_Auth`` dauerhafte Speicherung der Identität eines erfolgreichen Authentifizierungs
Versuches durch Verwendung der *PHP* Session. Bei einem erfolgreichen Authentifizierungs Versuch speichert
``Zend\Auth\Auth::authenticate()`` die Identität des Authentifizierungs Ergebnisses im persistenten Speicher. Solange
die Konfiguration nicht verändert wird, verwendet ``Zend_Auth`` eine Speicherklasse die
``Zend\Auth\Storage\Session`` heißt und die im Gegenzug :ref:`Zend_Session <zend.session>` verwendet. Eine eigene
Klasse kann stattdessen verwendet werden, indem ein Objekt an ``Zend\Auth\Auth::setStorage()`` übergeben wird welches
``Zend\Auth\Storage\Interface`` implementiert.

.. note::

   Wenn das automatische persistente Speichern der Identität für einen bestimmten Anwendungsfall nicht anwendbar
   ist, können Entwickler trotzdem die ``Zend_Auth`` Klasse weiterhin verwenden statt direkt eine Adapterklasse
   anzusprechen.

.. _zend.authentication.introduction.persistence.default.example:

.. rubric:: Den Namensraum der Session ändern

``Zend\Auth\Storage\Session`` verwendet einen Session Namensraum von '``Zend_Auth``'. Diese Namensraum kann
überschrieben werden indem ein anderer Wert an den Konstruktor von ``Zend\Auth\Storage\Session`` übergeben wird,
und dieser Wert wird intern an den Konstruktor von ``Zend\Session\Namespace`` weitergereicht. Das sollte vor einem
Versuch einer Authentifizierung stattfinden da ``Zend\Auth\Auth::authenticate()`` die automatische Speicherung der
Identität durchführt.

.. code-block:: php
   :linenos:

   // Eine Referenz zur Singleton Instanz von Zend_Auth speichern
   $auth = Zend\Auth\Auth::getInstance();

   // 'someNamespace' statt 'Zend_Auth' verwenden
   $auth->setStorage(new Zend\Auth\Storage\Session('someNamespace'));

   /**
    * @todo Den Auth Adapter $authAdapter erstellen
    */

   // Authentifizieren, das Ergebnis speichern, und die Identität bei Erfolg
   // persistent machen
   $result = $auth->authenticate($authAdapter);

.. _zend.authentication.introduction.persistence.custom:

Eigene Speicher implementieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeitweise wollen Entwickler einen anderen Speichermechanismus für Identitäten verwenden als es von
``Zend\Auth\Storage\Session`` angeboten wird. Für solche Fälle können Entwickler einfach
``Zend\Auth\Storage\Interface`` implementieren und eine Instanz der Klasse an ``Zend\Auth\Auth::setStorage()``
übergeben.

.. _zend.authentication.introduction.persistence.custom.example:

.. rubric:: Eine eigene Speicher Klasse verwenden

Um eine andere Speicherklasse für die Persistenz von Identitäten zu verwenden als sie durch
``Zend\Auth\Storage\Session`` angeboten wird, können Entwickler ``Zend\Auth\Storage\Interface`` implementieren:

.. code-block:: php
   :linenos:

   class MyStorage implements Zend\Auth\Storage\Interface
   {
       /**
        * Gibt true zurück wenn und nur wenn der Speicher leer ist
        *
        * @throws Zend\Auth\Storage\Exception Wenn es unmöglich ist festzustellen
        *                                     ob der Speicher leer ist
        * @return boolean
        */
       public function isEmpty()
       {
           /**
            * @todo Implementierung
            */
       }

       /**
        * Gibt den Inhalt des Speichers zurück
        *
        * Das Verhalten ist undefiniert wenn der Speicher leer ist.
        *
        * @throws Zend\Auth\Storage\Exception Wenn das Lesen von Lesen vom Speicher
        *                                     unmöglich ist
        * @return mixed
        */
       public function read()
       {
           /**
            * @todo Implementierung
            */
       }

       /**
        * Schreibt $contents in den Speicher
        *
        * @param  mixed $contents
        * @throws Zend\Auth\Storage\Exception Wenn das Schreiben von $contents in
        *                                     den Speicher unmöglich ist
        * @return void
        */
       public function write($contents)
       {
           /**
            * @todo Implementierung
            */
       }

       /**
        * Löscht die Intalte vom Speicher
        *
        * @throws Zend\Auth\Storage\Exception Wenn das Löschen der Inhalte vom
        *                                     Speicher unmöglich ist
        * @return void
        */
       public function clear()
       {
           /**
            * @todo Implementierung
            */
       }

   }

Um diese selbstgeschriebene Speicherklasse zu verwenden wird ``Zend\Auth\Auth::setStorage()`` aufgerufen bevor eine
Authentifizierungsanfrage stattfindet:

.. code-block:: php
   :linenos:

   // Zend_Auth anweisen das die selbstdefinierte Speicherklasse verwendet wird
   Zend\Auth\Auth::getInstance()->setStorage(new MyStorage());

   /**
    * @todo Den Auth Adapter $authAdapter erstellen
    */

   // Authentifizieren, das Ergebnis speichern, und die Identität bei Erfolg
   $result = Zend\Auth\Auth::getInstance()->authenticate($authAdapter);

.. _zend.authentication.introduction.using:

Verwendung
----------

Es gibt zwei vorhandene Wege um ``Zend_Auth`` Adapter zu verwenden:

. Indirekt durch ``Zend\Auth\Auth::authenticate()``

. Direkt durch die ``authenticate()`` Methode des Adapters

Das folgende Beispiel zeigt wie ein ``Zend_Auth`` Adapter indirekt verwendet werden kann, durch die Verwendung der
``Zend_Auth`` Klasse:

.. code-block:: php
   :linenos:

   // Eine Referenz zur Singleton-Instanz von Zend_Auth erhalten
   $auth = Zend\Auth\Auth::getInstance();

   // Authentifizierungs Adapter erstellen
   $authAdapter = new MyAuthAdapter($username, $password);

   // Authentifizierungs Versuch, das Ergebnis abspeichern
   $result = $auth->authenticate($authAdapter);

   if (!$result->isValid()) {
       // Authentifizierung fehlgeschlagen; die genauen Gründe ausgeben
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Authentifizierung erfolgreich; die Identität ($username) wird in
       // der Session gespeichert
       // $result->getIdentity() === $auth->getIdentity()
       // $result->getIdentity() === $username
   }

Sobald die Authentifizierung in einer Anfrage durchgeführt wurde, so wie im obigen Beispiel, ist es sehr einfach
zu Prüfen ob eine erfolgreich authentifizierte Identität existiert:

.. code-block:: php
   :linenos:

   $auth = Zend\Auth\Auth::getInstance();
   if ($auth->hasIdentity()) {
       // Identität existiert; auslesen
       $identity = $auth->getIdentity();
   }

Um eine Identität vom persistenten Speicher zu entfernen muß einfach die ``clearIdentity()`` Methode verwendet
werden. Das würde typischerweise für die Implementierung einer "Abmelde" Operation in einer Anwendung Verwendung
finden.

.. code-block:: php
   :linenos:

   Zend\Auth\Auth::getInstance()->clearIdentity();

Wenn die automatische Verwendung von persistenten Speichern für einen bestimmten Verwendungszweck unangebracht
ist, kann ein Entwickler einfach die Verwendung der ``Zend_Auth`` Klasse umgehen, und eine Adapter Klasse direkt
verwenden. Die direkte Verwendung einer Adapterklasse enthält das Konfigurieren und Vorbereiten eines Adapter
Objektes und den Aufruf dessen ``authenticate()`` Methode. Adapter-spezifische Details werden in der Dokumentation
jeden Adapters besprochen. Das folgende Beispeil verwendet ``MyAuthAdapter`` direkt:

.. code-block:: php
   :linenos:

   // Den Authentifizierungs Adapter erstellen
   $authAdapter = new MyAuthAdapter($username, $password);

   // Authentifizierungs Versuch, speichere das Ergebnis
   $result = $authAdapter->authenticate();

   if (!$result->isValid()) {
       // Authentifizierung fehlgeschlagen; die genauen Gründe ausgeben
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Authentifizierung erfolgreich
       // $result->getIdentity() === $username
   }


