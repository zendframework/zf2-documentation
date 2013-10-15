.. EN-Revision: none
.. _zend.log.overview:

Übersicht
=========

``Zend_Log`` ist eine Komponente für Mehrzweckprotokollierung. Es unterstützt vielfache Log Backends, das Senden
von formatierten Nachrichten zum Log, und das Filtern von Nachrichten um nicht protokolliert zu werden. Diese
Funktionen sind in die folgenden Objekte seperiert worden:



   - Ein Log (Instanz von ``Zend_Log``) ist das Objekt das die Anwendung am meisten benutzt. Man kann soviele Log
     Objekte haben wie man will; Sie interagieren nicht. Ein Log Objekt muß mindestens einen Schreiber beinhalten,
     und kann optional einen oder mehrere Filter beinhalten.

   - Ein Writer (Abgeleitet von ``Zend\Log\Writer\Abstract``) ist dafür zuständig das Daten in den Speicher
     geschrieben werden.

   - Ein Filter (implementiert ``Zend\Log\Filter\Interface``) blockiert Logdaten vom gespeichert werden. Ein Filter
     kann einem individuellen Writer hinzugefügt werden, oder an ein Log wo er vor allen Writern hinzugefügt
     wird. In jedem Fall können Filter verkettet werden.

   - Ein Formatter (implementiert ``Zend\Log\Formatter\Interface``) kann die Logdaten formatieren bevor diese durch
     den Writer geschrieben werden. Jeder Writer hat exakt einen Formatter.



.. _zend.log.overview.creating-a-logger:

Erstellen eines Logs
--------------------

Um das protokollieren zu starten, muß ein Writer instanziert werden und einer Log Instanz übergeben werden:

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Log();
   $writer = new Zend\Log\Writer\Stream('php://output');

   $logger->addWriter($writer);

Es ist wichtig anzumerken dass das Log mindestens einen Writer haben muß. Man kann eine beliebige Anzahl von
Writern hinzufügen indem man die ``addWriter()`` Methode des Log's verwendet.

Alternativ kann ein Writer direkt dem Konstruktor von Log, als Abkürzung, übergeben werden:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $logger = new Zend\Log\Log($writer);

Das Log ist nun fertig zur Verwendung.

.. _zend.log.overview.logging-messages:

Nachrichten protokollieren
--------------------------

Um eine Nachricht zu protokollieren, muß die ``log()`` Methode einer Log Instanz aufgerufen werden und die
Nachricht mit einer entsprechenden Priorität übergeben werden:

.. code-block:: php
   :linenos:

   $logger->log('Informative Nachricht', Zend\Log\Log::INFO);

Der erste Parameter der ``log()`` Methode ist ein ``message`` String und der zweite Parameter ist ein ``priority``
Integerwert. Die Priorität muß eine der Prioritäten sein die von der Log Instanz erkannt wird. Das wird in der
nächsten Sektion beschrieben.

Eine Abkürzung ist auch verfügbar. Statt dem Aufruf der ``log()`` Methode kann eine Methode des selben Namens wie
die Priorität aufgerufen werden:

.. code-block:: php
   :linenos:

   $logger->log('Informative Nachricht', Zend\Log\Log::INFO);
   $logger->info('Informative Nachricht');

   $logger->log('Notfall Nachricht', Zend\Log\Log::EMERG);
   $logger->emerg('Notfall Nachricht');

.. _zend.log.overview.destroying-a-logger:

Ein Log entfernen
-----------------

Wenn ein Log Objekt nicht länger benötigt wird, kann die Variable die das Log enthält auf ``NULL`` gesetzt
werden um es zu entfernen. Das wird automatisch die Instanzmethode ``shutdown()`` von jedem hinzugefügten Writer
aufrufen bevor das Log Objekt entfernt wird:

.. code-block:: php
   :linenos:

   $logger = null;

Das explizite entfernen des Logs auf diesem Weg ist optional und wird automatisch durchgeführt wenn *PHP*
herunterfährt.

.. _zend.log.overview.builtin-priorities:

Verwenden von eingebauten Prioritäten
-------------------------------------

Die ``Zend_Log`` Klasse definiert die folgenden Prioritäten:

.. code-block:: php
   :linenos:

   EMERG   = 0;  // Notfall: System ist nicht verwendbar
   ALERT   = 1;  // Alarm: Aktionen müßen sofort durchgefüht werden
   CRIT    = 2;  // Kritisch: Kritische Konditionen
   ERR     = 3;  // Fehler: Fehler Konditionen
   WARN    = 4;  // Warnung: Warnungs Konditionen
   NOTICE  = 5;  // Notiz: Normal aber signifikante Kondition
   INFO    = 6;  // Informativ: Informative Nachrichten
   DEBUG   = 7;  // Debug: Debug Nachrichten

Diese Prioritäten sind immer vorhanden und eine komfortable Methode für den selben Namen ist für jede einzelne
vorhanden.

Die Prioritäten sind nicht beliebig. Die kommen vom BSD syslog Protokoll, welches in `RFC-3164`_ beschrieben wird.
Die Namen und korrespondierenden Prioritätennummern sind auch mit einem anderen *PHP* Logging Systeme kompatibel,
`PEAR Log`_, welches möglicherweise mit Interoperabilität zwischen Ihm und ``Zend_Log`` wirbt.

Nummern für Prioritäten sinken in der Reihenfolge ihrer Wichtigkeit. ``EMERG`` (0) ist die wichtigste Priorität.
``DEBUG`` (7) ist die unwichtigste Priorität der eingebauten Prioritäten. Man kann Prioritäten von niedriger
Wichtigkeit als ``DEBUG`` definieren. Wenn die Priorität für die Lognachricht ausgewählt wird, sollte auf die
Hirarchie der Prioritäten geachtet werden und selbige sorgfältig ausgewählt werden.

.. _zend.log.overview.user-defined-priorities:

Hinzufügen von selbstdefinierten Prioritäten
--------------------------------------------

Selbstdefinierte Prioritäten können wärend der Laufzeit hinzugefügt werden durch Verwenden der
``addPriority()`` Methode des Log's:

.. code-block:: php
   :linenos:

   $logger->addPriority('FOO', 8);

Das obige Codeschnipsel erstellt eine neue Priorität, ``FOO``, dessen Wert '8' ist. Die neue Priorität steht für
die Protokollierung zur Verfügung:

.. code-block:: php
   :linenos:

   $logger->log('Foo Nachricht', 8);
   $logger->foo('Foo Nachricht');

Neue Prioritäten können bereits bestehende nicht überschreiben.

.. _zend.log.overview.understanding-fields:

Log Events verstehen
--------------------

Wenn die ``log()`` Methode oder eine Ihrer Abkürzungen aufgerufen wird, wird ein Log Event erstellt. Das ist
einfach ein assoziatives Array mit Daten welche das Event beschreiben das an die Writer übergeben wird. Die
folgenden Schlüssel werden immer in diesem Array erstellt: ``timestamp``, ``message``, ``priority``, und
``priorityName``.

Die Erstellung des ``event`` Arrays ist komplett transparent. Trotzdem wird das Wissen über das ``event`` Array
für das Hinzufügen von Elementen benötigt, die in dem obigen Standardset nicht existieren.

Um ein neues Element für jedes zukünftige Event hinzuzufügen, muß die ``setEventItem()`` Methode aufgerufen
werden wobei ein Schlüssel und ein Wert übergeben wird:

.. code-block:: php
   :linenos:

   $logger->setEventItem('pid', getmypid());

Das obige Beispiel setzt ein neues Element welches ``pid`` heißt und veröffentlicht es mit der PID des aktuellen
Prozesses. Wenn einmal ein neues Element gesetzt wurde, wird es automatisch für alle Writer verfügbar, zusammen
mit allen anderen Daten der Eventdaten wärend des Protokollierens. Ein Element kann jederzeit überschrieben
werden durch nochmaligen Aufruf der ``setEventItem()`` Methode.

Das Setzen eines neuen Eventelements mit ``setEventItem()`` führt dazu dass das neue Element an alle Writer des
Loggers gesendet wird. Trotzdem garantiert das nicht das die Writer das Element aktuell auch aufzeichnet. Und zwar
deswegen weil die Writer nicht wissen was zu tun ist solange das Formatter Objekt nicht über das neue Element
informiert wurde. Siehe in die Sektion über Formatter um mehr darüber zu lernen.

.. _zend.log.overview.as-errorHandler:

PHP Fehler loggen
-----------------

``Zend_Log`` kann auch verwendet werden um *PHP* Fehler zu loggen. Der Aufruf von ``registerErrorHandler()`` fügt
``Zend_Log`` vor dem aktuellen Error Handler hinzu, und gibt den Fehler genauso weiter.

.. _zend.log.overview.as-errorHandler.properties.table-1:

.. table:: Zend_Log Events für PHP Fehler haben ein zusätzliches Feld welches handler (int $errno ,string $errstr [,string $errfile [,int $errline [,array $errcontext]]]) von set_error_handler entspricht

   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name   |Parameter für den Error Handler|Beschreibung                                                                                                                                                                                                                                                                                                             |
   +=======+===============================+=========================================================================================================================================================================================================================================================================================================================+
   |message|errstr                         |Enthält die Fehlermeldung als String.                                                                                                                                                                                                                                                                                    |
   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |errno  |errno                          |Enthält das Level des geworfenen Fehlers als Integer.                                                                                                                                                                                                                                                                    |
   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file   |errfile                        |Enthält den Dateinamen in dem der Fehler geworfen wurde als String                                                                                                                                                                                                                                                       |
   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |line   |errline                        |Enthält die Zeilennummer in welcher der Fehler geworfen wurde als Integer                                                                                                                                                                                                                                                |
   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |context|errcontext                     |(Optional) Ein Array welches auf eine aktive Symboltabelle zeigt in welcher der Fehler aufgetreten ist. In anderen Worden, enthält errcontext ein Array jeder Variable welche in dem Scope existiert hat in welchem der Fehler geworfen wurde. Benutzerdefinierte Error Handler müssen den Error Context nicht verändern.|
   +-------+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`RFC-3164`: http://tools.ietf.org/html/rfc3164
.. _`PEAR Log`: http://pear.php.net/package/log
