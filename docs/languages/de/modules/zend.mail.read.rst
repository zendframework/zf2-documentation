.. EN-Revision: none
.. _zend.mail.read:

Lesen von Mail Nachrichten
==========================

``Zend_Mail`` kann Mail Nachrichten von verschiedenen lokalen oder entfernen Mailspeichern lesen. Alle von diesen
haben die selbe Basis *API* für das Zählen und Holen von Nachrichten und einige von Ihnen implementieren
zusätzliche Interfaces für nicht so übliche Features. Für eine Übersicht der Features der implementierten
Speicher kann in die folgende Tabelle gesehen werden.

.. _zend.mail.read.table-1:

.. table:: Übersicht der Lesefeatures für Mails

   +---------------------------------+--------+--------+--------+--------+
   |Feature                          |Mbox    |Maildir |Pop3    |IMAP    |
   +=================================+========+========+========+========+
   |Speichertyp                      |lokal   |lokal   |entfernt|entfernt|
   +---------------------------------+--------+--------+--------+--------+
   |Nachrichten holen                |Yes     |Yes     |Yes     |Yes     |
   +---------------------------------+--------+--------+--------+--------+
   |MIME-Part holen                  |emulated|emulated|emulated|emulated|
   +---------------------------------+--------+--------+--------+--------+
   |Ordner                           |Yes     |Yes     |No      |Yes     |
   +---------------------------------+--------+--------+--------+--------+
   |Erstellen von Nachrichten/Ordnern|No      |todo    |No      |todo    |
   +---------------------------------+--------+--------+--------+--------+
   |Merker                           |No      |Yes     |No      |Yes     |
   +---------------------------------+--------+--------+--------+--------+
   |Quote                            |No      |Yes     |No      |No      |
   +---------------------------------+--------+--------+--------+--------+

.. _zend.mail.read-example:

Einfaches Beispiel für POP3
---------------------------

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'localhost',
                                            'user'     => 'test',
                                            'password' => 'test'));

   echo $mail->countMessages() . " Nachrichten gefunden\n";
   foreach ($mail as $message) {
       echo "Mail von '{$message->from}': {$message->subject}\n";
   }

.. _zend.mail.read-open-local:

Öffnen eines lokalen Speichers
------------------------------

Mbox und Maildir sind zwei unterstützte Formate für lokale Mailspeicher, beide in Ihrem einfachsten Format.

Wenn von einer Mbox Datei gelesen werden soll muß nur der Dateiname an den Konstruktor von
``Zend_Mail_Storage_Mbox`` übergeben werden:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Mbox(array('filename' =>
                                                '/home/test/mail/inbox'));

Maildir ist sehr einfach benötigt aber einen Verzeichnisnamen:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Maildir(array('dirname' =>
                                                   '/home/test/mail/'));

Beide Konstruktoren werfen eine ``Zend_Mail_Exception`` Ausnahme wenn der Speicher nicht gelesen werden kann.

.. _zend.mail.read-open-remote:

Öffnen eines entfernten Speichers
---------------------------------

Für entfernte Speicher werden die zwei populärsten Protokolle unterstützt: Pop3 und Imap. Beide benötigen
mindestens einen Host und einen Benutzer für das Verbinden und das Login. Das Standardpasswort ist ein leerer
String, der Standardport wie im *RFC* Protokoll definiert.

.. code-block:: php
   :linenos:

   // Verbinden mit Pop3
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // Verbinden mit Imap
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // Beispiel für einen nicht Standardport
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'port'     => 1120
                                            'user'     => 'test',
                                            'password' => 'test'));

Für beide Speicher werden *SSL* und TLS unterstützt. Wenn *SSL* verwendet wird, wird der Standardport laut *RFC*
geändert.

.. code-block:: php
   :linenos:

   // Beispiel für Zend_Mail_Storage_Pop3
   // funktioniert auch für Zend_Mail_Storage_Imap

   // SSL mit einem unterschiedlichen Port verwenden
   // (Standard ist 995 für Pop3 und 993 für Imap)
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'SSL'));

   // Verwenden von TLS
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'TLS'));

Beide Konstruktoren können eine ``Zend_Mail_Exception`` oder ``Zend_Mail_Protocol_Exception`` werfen (erweitert
``Zend_Mail_Exception``), abhängig vom Typ des Fehlers.

.. _zend.mail.read-fetching:

Nachrichten holen und einfache Methoden
---------------------------------------

Wenn der Speicher einmal geöffnet wurde können Nachrichten geholt werden. Man benötigt die Nachrichtennummer,
welche ein Zähler ist der mit 1 für die erste Nachricht beginnt. Um die Nachrichten zu holen muß die Methode
``getMessage()`` verwendet werden:

.. code-block:: php
   :linenos:

   $message = $mail->getMessage($messageNum);

Zugriff über Arrays ist auch möglich, unterstützt aber nicht jeden zusätzlichen Parameter der zu
``getMessage()`` hinzugefügt werden könnte:

.. code-block:: php
   :linenos:

   $message = $mail[$messageNum];

Um über alle Nachrichten zu iterieren wurde das Iterator Interface implementiert:

.. code-block:: php
   :linenos:

   foreach ($mail as $messageNum => $message) {
       // mach was ...
   }

Um die Nachrichten im Speicher zu zählen kann entweder die Methode ``countMessages()`` oder der Zugriff auf Arrays
verwendet werden:

.. code-block:: php
   :linenos:

   // Methode
   $maxMessage = $mail->countMessages();

   // Array Zugriff
   $maxMessage = count($mail);

Um eine Mail zu entfernen kann die Methode ``removeMessage()`` oder auch der Array Zugriff verwendet werden:

.. code-block:: php
   :linenos:

   // Methode
   $mail->removeMessage($messageNum);

   // Array Zugriff
   unset($mail[$messageNum]);

.. _zend.mail.read-message:

Arbeiten mit Nachrichten
------------------------

Nachdem die Nachrichten mit ``getMessage()`` geholt wurden, wird man die Kopfzeilen, den Inhalt oder einzelne Teile
einer Mehrteiligen Nachricht holen wollen. Auf alle Kopfzeilen kann über die Eigenschaften oder die Methode
``getHeader()``, wenn man mehr Kontrolle oder ungewöhnliche Kopfzeilen hat, zugegriffen werden. Die Kopfzeilen
sind intern kleingeschrieben, weswegen die Groß- und Kleinschreibung der Kopfzeilen in der Mail Nachricht egal
ist. Kopfzeilen mit einem Bindestrich können auch in camel-case Schreibweise geschrieben werden. Wenn für beide
Schreibweisen kein Header gefunden wird, wird eine Ausnahme geworfen. Um das zu verhindern kann die
``headerExists()`` Methode verwendet werden um die Existenz einer Kopfzeile zu prüfen.

.. code-block:: php
   :linenos:

   // Nachrichten Objekt holen
   $message = $mail->getMessage(1);

   // Betreff der Nachricht holen
   echo $message->subject . "\n";

   // Inhalts-Typ der Kopfzeile holen
   $type = $message->contentType;

   // Prüfen ob CC gesetzt ist:
   if( isset($message->cc) ) { // oder $message->headerExists('cc');
       $cc = $message->cc;
   }

Wenn mehrere Kopfzeilen mit dem selben Namen vorhanden sind z.B. die empfangenen Kopfzeilen kann es gewünscht sein
diese als Array statt als String zu haben, was mit der ``getHeader()`` Methode möglich ist.

.. code-block:: php
   :linenos:

   // Kopfzeilen als Eigenschaft holen - das Ergebnis ist immer ein String,
   // mit Zeilenumbruch zwischen den einzelnen Vorkommen in der Nachricht
   $received = $message->received;

   // Das gleiche über die getHeader() Methode
   $received = $message->getHeader('received', 'string');

   // Besser ein Array mit einem einzelnen Eintrag für jedes Vorkommen
   $received = $message->getHeader('received', 'array');
   foreach ($received as $line) {
       // irgendwas tun
   }

   // Wenn kein Format definiert wurde wird die interne Repräsentation
   // ausgegeben (String für einzelne Kopfzeilen, Array für mehrfache)
   $received = $message->getHeader('received');
   if (is_string($received)) {
       // Nur eine empfangene Kopfzeile in der Nachricht gefunden
   }

Die Methode ``getHeaders()`` gibt alle Kopfzeilen als Array mit den kleingeschriebenen Namen als Schlüssel und den
Wert als Array für mehrere Kopfzeilen oder als String für einzelne Kopfzeilen.

.. code-block:: php
   :linenos:

   // Alle Kopfzeilen wegschmeißen
   foreach ($message->getHeaders() as $name => $value) {
       if (is_string($value)) {
           echo "$name: $value\n";
           continue;
       }
       foreach ($value as $entry) {
           echo "$name: $entry\n";
       }
   }

Wenn keine Nachricht aus mehreren Teilen vorlieg kann der Inhalt sehr einfach über ``getContent()`` geholt werden.
Anders als die Kopfzeilen wird der Inhalt nur geholt wenn dies benötigt wird (wie spätes-holen).

.. code-block:: php
   :linenos:

   // Inhalt der Nachricht für HTML ausgeben
   echo '<pre>';
   echo $message->getContent();
   echo '</pre>';

Die Prüfung auf mehrteilige Nachrichten wird in der Methode ``isMultipart()`` gemacht. Wenn eine mehrteilige
Nachricht vorliegt kann eine Instanz von ``Zend_Mail_Part`` mit der Methode ``getPart()`` geholt werden.
``Zend_Mail_Part`` ist die Basisklasse von ``Zend_Mail_Message``, sie hat also die gleichen Methoden:
``getHeader()``, ``getHeaders()``, ``getContent()``, ``getPart()``, ``isMultipart()`` und die Eigenschaften der
Kopfzeilen.

.. code-block:: php
   :linenos:

   // Hole den ersten nicht geteilten Teil
   $part = $message;
   while ($part->isMultipart()) {
       $part = $message->getPart(1);
   }
   echo 'Der Typ des Teils ist ' . strtok($part->contentType, ';') . "\n";
   echo "Inhalt:\n";
   echo $part->getContent();

``Zend_Mail_Part`` implementiert auch den ``RecursiveIterator``, welcher es sehr einfach macht alle Teile zu
durchsuchen. Und für die einfache Ausgabe wurde auch die magische Methode ``__toString()`` implementiert, welche
den Inhalt zurückgibt.

.. code-block:: php
   :linenos:

   // Gibt den ersten text/plain Teil aus
   $foundPart = null;
   foreach (new RecursiveIteratorIterator($mail->getMessage(1)) as $part) {
       try {
           if (strtok($part->contentType, ';') == 'text/plain') {
               $foundPart = $part;
               break;
           }
       } catch (Zend_Mail_Exception $e) {
           // ignorieren
       }
   }
   if (!$foundPart) {
       echo 'kein reiner Text-Teil gefunden';
   } else {
       echo "Reiner Text-Teil: \n" . $foundPart;
   }

.. _zend.mail.read-flags:

Auf Flags prüfen
----------------

Maildir und IMAP unterstützen das Speichern von Flags. Die Klasse ``Zend_Mail_Storage`` hat Konstanten für alle
bekannten maildir und IMAP System Flags, welche ``Zend_Mail_Storage::FLAG_<flagname>`` heißen. Um auf Flags zu
Prüfen hat ``Zend_Mail_Message`` eine Methode die ``hasFlag()`` heißt. Mit ``getFlags()`` erhält man alle
gesetzten Flags.

.. code-block:: php
   :linenos:

   // Finde ungelesene Nachrichten
   echo "Ungelesene Nachrichten:\n";
   foreach ($mail as $message) {
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_SEEN)) {
           continue;
       }
       // Vorherige/Neue Nachrichten markieren
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_RECENT)) {
           echo '! ';
       } else {
           echo '  ';
       }
       echo $message->subject . "\n";
   }

   // Prüfen auf bekannte Flags
   $flags = $message->getFlags();
   echo "Nachricht wurde markiert als: ";
   foreach ($flags as $flag) {
       switch ($flag) {
           case Zend_Mail_Storage::FLAG_ANSWERED:
               echo 'Beantwortet ';
               break;
           case Zend_Mail_Storage::FLAG_FLAGGED:
               echo 'Markiert ';
               break;

           // ...
           // Auf andere Flags prüfen
           // ...

           default:
               echo $flag . '(unbekanntes Flag) ';
       }
   }

Da IMAP Benutzern oder auch Clients selbstdefinierte Flags erlaubt, können auch Flags empfangen werden die keine
Konstante in ``Zend_Mail_Storage`` haben. Stattdessen werden sie als String zurückgegeben und können auf dem
selben Weg mit ``hasFlag()`` geprüft werden.

.. code-block:: php
   :linenos:

   // Nachricht auf vom Client definierte Flags $IsSpam, $SpamTested prüfen
   if (!$message->hasFlag('$SpamTested')) {
       echo 'Die Nachricht wurde nicht auf Spam geprüft';
   } else if ($message->hasFlag('$IsSpam')) {
       echo 'Diese Nachricht ist Spam';
   } else {
       echo 'Diese Nachricht ist Speck';
   }

.. _zend.mail.read-folders:

Verwenden von Ordnern
---------------------

Alle Speicher, ausser Pop3, unterstützen Ordner, welche Mailboxen genannt werden. Das Interface das von allen
Speichern implementiert wurde und Ordner unterstützt heißt ``Zend_Mail_Storage_Folder_Interface``. Alle diese
Klassen besitzen auch einen zusätzlichen optionalen Parameter welcher ``folder`` heißt, was der ausgewählt
Ordner nach dem Login, im Konstruktor ist.

Für den lokalen Speicher müssen die eigenen Klassen ``Zend_Mail_Storage_Folder_Mbox`` oder
``Zend_Mail_Storage_Folder_Maildir`` genannt verwendet werden. Beide benötigen einen Parameter der ``dirname``
heißt mit dem Namen des Basisverzeichnisses. Das Format für Maildir ist wie in Maildir++ definiert (mit einem
Punkt als Standardbegrenzer), Mbox ist eine Verzeichnisstruktur mit Mbox Dateien. Wenn im Mbox Basisverzeichnis
keine Mbox Datei vorhanden ist die INBOX heißt, muß ein anderer Ordner im Konstruktor gesetzt werden.

``Zend_Mail_Storage_Imap`` unterstützt Ordner schon standardmäßig. Beispiele für das Öffnen solcher Speicher:

.. code-block:: php
   :linenos:

   // MBox mit Ordnern
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' =>
                                                       '/home/test/mail/'));

   // MBox mit standard Ordner der nicht INBOX heißt, funktioniert auch
   // mit Zend_Mail_Storage_Folder_Maildir und Zend_Mail_Storage_Imap
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' =>
                                                       '/home/test/mail/',
                                                   'folder'  =>
                                                       'Archive'));

   // Maildir mit Ordnern
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' =>
                                                          '/home/test/mail/'));

   // Maildir mir Doppelpunkt als Begrenzung, wie in Maildir++ empfohlen
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' =>
                                                          '/home/test/mail/',
                                                      'delim'   => ':'));

   // IMAP ist genauso mit und ohne Ordner
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

Mit der Methode getFolders($root = null) kann die Verzeichnisstruktur beginnend mit dem Basisverzeichnis oder einem
angegebenen Ordner ausgegeben werden. Sie wird als Instanz von ``Zend_Mail_Storage_Folder`` zurückgegeben, welche
``RecursiveIterator`` implementiert und alle Kinder sind genauso Instanzen von ``Zend_Mail_Storage_Folder``. Jede
dieser Instanzen hat einen lokalen und einen globalen Namen der durch die Methoden ``getLocalName()`` und
``getGlobalName()`` zurückgegeben wird. Der globale Name ist der absolute Name des Basisordners (inklusive
Begrenzer), der lokale Name ist der Name im Elternordner.

.. _zend.mail.read-folders.table-1:

.. table:: Namen für Nachrichtenordner

   +---------------+------------+
   |Globaler Name  |Lokaler Name|
   +===============+============+
   |/INBOX         |INBOX       |
   +---------------+------------+
   |/Archive/2005  |2005        |
   +---------------+------------+
   |List.ZF.General|General     |
   +---------------+------------+

Wenn der Iterator verwendet wird ist der lokale Name der Schlüssel des aktuellen Elements. Der globale Name wird
auch durch die magische Methode ``__toString()`` zurückgegeben. Gleiche Ordner können nicht ausgewählt werden,
was bedeutet das Sie keine Nachrichten speichern können und die Auswahl von Ergebnisses führt zu einem Fehler.
Das kann mit der Methode ``isSelectable()`` geprüft werden. Es ist also sehr einfach den ganzen Baum in einer
Ansicht auszugeben:

.. code-block:: php
   :linenos:

   $folders = new RecursiveIteratorIterator($this->mail->getFolders(),
                                            RecursiveIteratorIterator::SELF_FIRST);
   echo '<select name="folder">';
   foreach ($folders as $localName => $folder) {
       $localName = str_pad('', $folders->getDepth(), '-', STR_PAD_LEFT) .
                    $localName;
       echo '<option';
       if (!$folder->isSelectable()) {
           echo ' disabled="disabled"';
       }
       echo ' value="' . htmlspecialchars($folder) . '">'
           . htmlspecialchars($localName) . '</option>';
   }
   echo '</select>';

Der aktuell ausgewählte Ordner wird durch die Methode ``getSelectedFolder()`` zurückgegeben. Das Ändern von
Ordnern wird mit der Methode ``selectFolder()`` durchgeführt, welche den globalen Namen als Parameter benötigt.
Wenn das Schreiben von Begrenzern vermieden werden soll, können auch die Eigenschaften einer
``Zend_Mail_Storage_Folder`` Instanz verwendet werden:

.. code-block:: php
   :linenos:

   // Abhängig vom Mail Speicher und seinen Einstellungen
   // $rootFolder->Archive->2005 ist das gleiche wie:
   //   /Archive/2005
   //  Archive:2005
   //  INBOX.Archive.2005
   //  ...
   $folder = $mail->getFolders()->Archive->2005;
   echo 'Der letzte Ordner war '
      . $mail->getSelectedFolder()
      . "neuer Ordner ist $folder\n";
   $mail->selectFolder($folder);

.. _zend.mail.read-advanced:

Fortgeschrittene Verwendung
---------------------------

.. _zend.mail.read-advanced.noop:

NOOP verwenden
^^^^^^^^^^^^^^

Wenn ein entfernter Speicher verwendet werden soll und einige lange Aufgaben anstehen kann es notwendig sein die
Verbindung über noop am Leben zu halten:

.. code-block:: php
   :linenos:

   foreach ($mail as $message) {

       // einige Berechnungen ...

       $mail->noop(); // am Leben halten

       // irgendwas anderes tun ...

       $mail->noop(); // am Leben halten
   }

.. _zend.mail.read-advanced.caching:

Instanzen cachen
^^^^^^^^^^^^^^^^

``Zend_Mail_Storage_Mbox``, ``Zend_Mail_Storage_Folder_Mbox``, ``Zend_Mail_Storage_Maildir`` und
``Zend_Mail_Storage_Folder_Maildir`` implementieren die magischen Methoden ``__sleep()`` und ``__wakeup()`` was
bedeutet das Sie serialisierbar sind. Das vermeidet das Parsen von Dateien oder Verzeichnisbäumen mehr als einmal.
Der Nachteil ist das der Mbox oder Maildir Speicher sich nicht Ändern sollte. Einige einfache Prüfungen werden
durchgeführt, wie das neuparsen der aktuellen Mbox Datei wenn sich der Bearbeitungszeitpunkt ändert oder das
neuparsen der Verzeichnisstruktur wenn ein Ordner entfernt wurde (was immer noch zu einem Fehler führt, es kan
aber im Nachhinein ein anderer Ordner gesucht werden). Es ist besser etwas wie eine Signaldatei für Änderungen zu
haben, und diese zu Prüfen bevor eine gecachete Instanz verwendet wird.

.. code-block:: php
   :linenos:

   // Es wird kein spezieller Cache Handler/Klasse verwendet
   // Code ändern damit er zum Cache Handler passt
   $signal_file = '/home/test/.mail.last_change';
   $mbox_basedir = '/home/test/mail/';
   $cache_id = 'Beispiel Nachrichten Cache ' . $mbox_basedir . $signal_file;

   $cache = new Your_Cache_Class();
   if (!$cache->isCached($cache_id) ||
       filemtime($signal_file) > $cache->getMTime($cache_id)) {
       $mail = new Zend_Mail_Storage_Folder_Pop3(array('dirname' =>
                                                           $mbox_basedir));
   } else {
       $mail = $cache->get($cache_id);
   }

   // irgendwas machen ...

   $cache->set($cache_id, $mail);

.. _zend.mail.read-advanced.extending:

Prokoll Klassen erweitern
^^^^^^^^^^^^^^^^^^^^^^^^^

Entfernte Speicher verwenden zwei Klassen: ``Zend_Mail_Storage_<Name>`` und ``Zend_Mail_Protocol_<Name>``. Die
Protkoll Klasse übersetzt die Protokollbefehle und antwortet von und zu *PHP*, wie Methoden für die Befehle oder
Variablen mit verschiedenen Strukturen für Daten. Die andere/Haupt Klasse implementiert das Standard Interface.

Wenn zusätzliche Protokoll Features benötigt werden kann die Protokoll Klasse erweitert werden und diese im
Konstruktor der Basisklasse verwendet werden. Als Beispiel nehmen wir an das verschiedene Ports abgeklopft werden
bevor auf POP3 verbunden werden kann.

.. code-block:: php
   :linenos:

   class Example_Mail_Exception extends Zend_Mail_Exception
   {
   }

   class Example_Mail_Protocol_Exception extends Zend_Mail_Protocol_Exception
   {
   }

   class Example_Mail_Protocol_Pop3_Knock extends Zend_Mail_Protocol_Pop3
   {
       private $host, $port;

       public function __construct($host, $port = null)
       {
           // kein automatisches Verbinden in dieser Klasse
           $this->host = $host;
           $this->port = $port;
       }

       public function knock($port)
       {
           $sock = @fsockopen($this->host, $port);
           if ($sock) {
               fclose($sock);
           }
       }

       public function connect($host = null, $port = null, $ssl = false)
       {
           if ($host === null) {
               $host = $this->host;
           }
           if ($port === null) {
               $port = $this->port;
           }
           parent::connect($host, $port);
       }
   }

   class Example_Mail_Pop3_Knock extends Zend_Mail_Storage_Pop3
   {
       public function __construct(array $params)
       {
           // ... Parameter hier prüfen! ...
           $protocol = new Example_Mail_Protocol_Pop3_Knock($params['host']);

           // Spezial "Ding" hier machen
           foreach ((array)$params['knock_ports'] as $port) {
               $protocol->knock($port);
           }

           // den richtigen Status erhalten
           $protocol->connect($params['host'], $params['port']);
           $protocol->login($params['user'], $params['password']);

           // Eltern initialisieren
           parent::__construct($protocol);
       }
   }

   $mail = new Example_Mail_Pop3_Knock(array('host'        => 'localhost',
                                             'user'        => 'test',
                                             'password'    => 'test',
                                             'knock_ports' =>
                                                 array(1101, 1105, 1111)));

Wie gesehen werden kann wird angenommen das man immer verbunden, eingeloggt und, wenn es unterstützt wird, ein
Ordner im Konstruktor der Basisklasse ausgewählt ist. Das bedeutet, wenn eine eigene Protokollklasse verwendet
wird muß immer sichergestellt werden dass das durchgeführt wird, da sonst die nächste Methode fehlschlagen wird
wenn der Server das im aktuellen Status nicht zulässt.

.. _zend.mail.read-advanced.quota:

Quote verwenden (seit 1.5)
^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Mail_Storage_Writable_Maildir`` bietet Unterstützung für Maildir++ Quoten. Diese sind standardmäßig
ausgeschaltet, aber es ist möglich Sie manuell zu verwenden, wenn automatische Checks nicht gewünscht sind (das
bedeutet ``appendMessage()``, ``removeMessage()`` und ``copyMessage()`` führen keine Checks durch und fügen
keinen Eintrag zur maildirsize Datei hinzu). Wenn aktiviert, wird eine Ausnahme geworfen wenn versucht wird in
maildir zu schreiben wenn es bereits voll ist und die Quote überschritten wurde.

Es gibt drei Methoden die für Quoten verwendet werden: ``getQuota()``, ``setQuota()`` und ``checkQuota()``:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Writable_Maildir(array('dirname' =>
                                                      '/home/test/mail/'));
   $mail->setQuota(true); // true zum einschalten, false zum ausschalten
   echo 'Quotenprüfung ist jetzt ', $mail->getQuota() ? 'eingeschaltet'
                                                      : 'ausgeschaltet', "\n";
   // Quotenprüfung kann verwendet werden
   // selbst wenn die Quotenprüfung ausgeschaltet ist
   echo 'Sie sind ', $mail->checkQuota() ? 'über der Quote'
                                         : 'nicht über der Quote', "\n";

``checkQuota()`` kann eine viel detailiertere Antwort zurückgeben:

.. code-block:: php
   :linenos:

   $quota = $mail->checkQuota(true);
   echo 'Sie sind ', $quota['over_quota'] ? 'über der Quote'
                                          : 'nicht über der Quote', "\n";
   echo 'Sie haben ',
       $quota['count'],
       ' von ',
       $quota['quota']['count'],
       ' Nachrichten und verwenden ';
   echo $quota['size'], ' von ', $quota['quota']['size'], ' Oktets';

Wenn man eigene Quoten spezifizieren will statt die bereits in der maildirsize Datei spezifizierte zu verwenden
kann das mit ``setQuota()`` getan werden:

.. code-block:: php
   :linenos:

   // message count and octet size supported, order does matter
   $quota = $mail->setQuota(array('size' => 10000, 'count' => 100));

Wenn eigene Quotenchecks hinzugefügt werden sollen können einzelne Buchstaben als Schlüssel verwendet werden und
Sie werden reserviert (aber logischerweise nicht geprüft). Es ist auch möglich
``Zend_Mail_Storage_Writable_Maildir`` zu erweitern um eigene Quoten zu definieren wenn die maildirsize Datei fehlt
(was in Maildir++ vorkommen kann):

.. code-block:: php
   :linenos:

   class Example_Mail_Storage_Maildir extends Zend_Mail_Storage_Writable_Maildir {
       // getQuota wird mit $fromStorage = true durch die Quotenprüfung aufgerufen
       public function getQuota($fromStorage = false) {
           try {
               return parent::getQuota($fromStorage);
           } catch (Zend_Mail_Storage_Exception $e) {
               if (!$fromStorage) {
                   // unbekannter Fehler:
                   throw $e;
               }
               // Die maildirsize Datei muß fehlen

               list($count, $size) = get_quota_from_somewhere_else();
               return array('count' => $count, 'size' => $size);
           }
       }
   }


