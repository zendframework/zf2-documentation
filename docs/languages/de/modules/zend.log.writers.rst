.. EN-Revision: none
.. _zend.log.writers:

Writer
======

Ein Writer ist ein Objekt das von ``Zend\Log_Writer\Abstract`` abstammt. Die Aufgabe eines Writer's ist es Log
Daten in ein Speicher-Backend aufzunehmen.

.. _zend.log.writers.stream:

In Streams schreiben
--------------------

``Zend\Log_Writer\Stream`` sendet Log Daten in einen `PHP Stream`_.

Um Log Daten in den *PHP* Ausgabebuffer zu schreiben, muß die URL ``php://output`` verwendet werden. Alternativ
können Log Daten direkt an einen Stream wie z.B. ``STDERR`` (``php://stderr``) gesendet werden.

.. code-block:: php
   :linenos:

   $writer = new Zend\Log_Writer\Stream('php://output');
   $logger = new Zend\Log\Log($writer);

   $logger->info('Informational message');

Um Daten in eine Datei zu schreiben, muß eine der `Dateisystem URLs`_ verwendet werden:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log_Writer\Stream('/path/to/logfile');
   $logger = new Zend\Log\Log($writer);

   $logger->info('Informative Nachricht');

Standardmäßig wird der Stream im Anhänge-Modus geöffnet ("a"). Um Ihn in einem anderen Modus zu öffnen,
akzeptiert der ``Zend\Log_Writer\Stream`` Konstruktor einen optionalen zweiten Parameter für den Modus.

Der Konstruktor von ``Zend\Log_Writer\Stream`` akzeptiert auch eine existierende Stream Ressource:

.. code-block:: php
   :linenos:

   $stream = @fopen('/path/to/logfile', 'a', false);
   if (! $stream) {
       throw new Exception('Stream konnte nicht geöffnet werden');
   }

   $writer = new Zend\Log_Writer\Stream($stream);
   $logger = new Zend\Log\Log($writer);

   $logger->info('Informative Nachricht');

Der Modus kann für existierende Stream Ressourcen nicht definiert werden. Wenn das gemacht versucht wird, wird
eine ``Zend\Log\Exception`` geworfen.

.. _zend.log.writers.database:

In Datenbanken schreiben
------------------------

``Zend\Log_Writer\Db`` schreibt Log Informationen in eine Datenbank Tabelle wobei ``Zend_Db`` verwendet wird. Der
Konstrukor von ``Zend\Log_Writer\Db`` benötigt eine ``Zend\Db\Adapter`` Instanz, einen Tabellennamen, und ein
Abbild der Datenbankspalten zu den Elementen der Eventdaten:

.. code-block:: php
   :linenos:

   $params = array ('host'     => '127.0.0.1',
                    'username' => 'malory',
                    'password' => '******',
                    'dbname'   => 'camelot');
   $db = Zend\Db\Db::factory('PDO_MYSQL', $params);

   $columnMapping = array('lvl' => 'priority', 'msg' => 'message');
   $writer = new Zend\Log_Writer\Db($db, 'log_table_name', $columnMapping);

   $logger = new Zend\Log\Log($writer);

   $logger->info('Informative Nachricht');

Das obige Beispiel schreibt eine einzelne Zeile von Log Daten in einem Datenbanktabelle welche 'log_table_name'
Tabelle benannt wird. Die Datenbankspalte welche 'lvl' benannt ist empfängt die Nummer der Priorität und die
Spalte welche 'msg' benannt ist empfängt die Log Nachricht.

.. include:: zend.log.writers.firebug.rst
.. include:: zend.log.writers.mail.rst
.. include:: zend.log.writers.syslog.rst
.. include:: zend.log.writers.zend-monitor.rst
.. _zend.log.writers.null:

Einen Writer abstumpfen
-----------------------

``Zend\Log_Writer\Null`` ist ein Stumpf der keine Log Daten irgendwohin schreibt. Er ist nützlich um die
Protokollierung auszuschalten oder wärend Tests abzustumpfen:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log_Writer\Null;
   $logger = new Zend\Log\Log($writer);

   // geht nirgendwohin
   $logger->info('Informative Nachricht');

.. _zend.log.writers.mock:

Mit der Attrappe testen
-----------------------

``Zend\Log_Writer\Mock`` ist ein sehr einfacher Writer der die rohen Daten die er empfängt aufnimmt und in einem
Array als öffentliche Eigenschaft zur Verfügung stellt.

.. code-block:: php
   :linenos:

   $mock = new Zend\Log_Writer\Mock;
   $logger = new Zend\Log\Log($mock);

   $logger->info('Informative Nachricht');

   var_dump($mock->events[0]);

   // Array
   // (
   //    [timestamp] => 2007-04-06T07:16:37-07:00
   //    [message] => Informative Nachricht
   //    [priority] => 6
   //    [priorityName] => INFO
   // )

Um die Events die von der Attrappe protokolliert wurden zu entfernen, muß einfach ``$mock->events = array()``
gesetzt werden.

.. _zend.log.writers.compositing:

Gemischte Writer
----------------

Es gibt kein gemischtes Writer Objekt. Trotzdem kann eine Log Instanz in jede beliebige Anzahl von Writern
schreiben. Um das zu tun, muß die ``addWriter()`` Methode verwendet werden:

.. code-block:: php
   :linenos:

   $writer1 = new Zend\Log_Writer\Stream('/path/to/first/logfile');
   $writer2 = new Zend\Log_Writer\Stream('/path/to/second/logfile');

   $logger = new Zend\Log\Log();
   $logger->addWriter($writer1);
   $logger->addWriter($writer2);

   // Geht zu beiden Writern
   $logger->info('Informative Nachricht');



.. _`PHP Stream`: http://www.php.net/stream
.. _`Dateisystem URLs`: http://www.php.net/manual/de/wrappers.php#wrappers.file
