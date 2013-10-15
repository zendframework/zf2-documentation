.. EN-Revision: none
.. _zend.log.formatters:

Formatter
=========

Ein Formatter ist ein Objekt das dafür zuständig ist ein ``event`` Array anzunehmen welches ein Log Event
beschreibt und einen String auszugeben mit einer formatierten Logzeile.

Einige Writer sind nicht zeilen-orientiert und können keinen Formatter benutzen. Ein Beispiel ist der Datenbank
Writer, welcher die Events direkt in die Datenbankzeilen einfügt. Für Writer die Formatter nicht unterstützen
können, wird eine Ausnahme geworfen wenn versucht wird einen Formatter zu setzen.

.. _zend.log.formatters.simple:

Einfache Formatierung
---------------------

``Zend\Log\Formatter\Simple`` ist der Standard Formatter. Er ist automatisch konfiguriert wenn kein Formatter
definiert wird. Die Standard Konfiguration ist identisch mit dem folgenden:

.. code-block:: php
   :linenos:

   $format = '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL;
   $formatter = new Zend\Log\Formatter\Simple($format);

Ein Formatter wird einem individuellen Writer Objekt gesetzt durch Verwenden der ``setFormatter()`` Methode des
Writer's:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Simple('Hallo %message%' . PHP_EOL);
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Log();
   $logger->addWriter($writer);

   $logger->info('dort');

   // Gibt "Hallo dort" aus

Der Konstruktor von ``Zend\Log\Formatter\Simple`` akzeptiert einen einzelnen Parameter: Den Format String. Dieser
String enthält Schlüssel die durch Prozentzeichen begrenzt sind (z.B. ``%message%``). Der Format String kann
jeden Schlüssel des Event Data Arrays enthalten. Die Standardschlüssel können durch Verwendung der
DEFAULT_FORMAT Konstante von ``Zend\Log\Formatter\Simple`` empfangen werden.

.. _zend.log.formatters.xml:

In XML formatieren
------------------

``Zend\Log\Formatter\Xml`` formatiert Log Daten in einen *XML* String. Standardmäßig loggt er automatisch alle
Elemente des Event Data Arrays:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Xml();
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Log();
   $logger->addWriter($writer);

   $logger->info('Informative Nachricht');

Der obige Code gibt das folgende *XML* aus (Leerzeichen werden für Klarstellung hinzugefügt):

.. code-block:: xml
   :linenos:

   <logEntry>
     <timestamp>2007-04-06T07:24:37-07:00</timestamp>
     <message>Informative Nachricht</message>
     <priority>6</priority>
     <priorityName>INFO</priorityName>
   </logEntry>

Es ist möglich das Root Element anzupassen sowie ein Mapping von *XML* Elementen zu den Elementen im Event Data
Array zu definieren. Der Konstruktor von ``Zend\Log\Formatter\Xml`` akzeptiert einen String mit dem Namen des Root
Elements als ersten Parameter und ein assoziatives Array mit den gemappten Elementen als zweiten Parameter:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Xml('log',
                                           array('msg' => 'message',
                                                 'level' => 'priorityName')
                                          );
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Log();
   $logger->addWriter($writer);

   $logger->info('Informative Nachricht');

Der obige Code ändert das Root Element von seinem Standard ``logEntry`` zu ``log``. Er mappt auch das Element
``msg`` zum Event Daten Element ``message``. Das ergibt die folgende Ausgabe:

.. code-block:: xml
   :linenos:

   <log>
     <msg>Informative Nachricht</msg>
     <level>INFO</level>
   </log>


