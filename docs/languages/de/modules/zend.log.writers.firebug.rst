.. _zend.log.writers.firebug:

An Firebug schreiben
====================

``Zend_Log_Writer_Firebug`` sendet Logdaten an die `Firebug`_ `Console`_.

.. image:: ../images/zend.wildfire.firebug.console.png
   :width: 310


Alle Daten werden über die ``Zend_Wildfire_Channel_HttpHeaders`` Komponente gesendet welche *HTTP* Header
verwendet um sicherzustellen das der Seiteninhalt nicht verändert wird. Das Debuggen von *AJAX* Anfragen die klare
*JSON* und *XML* Antworten benötigen ist mit diesem Vorgehen möglich.

Notwendigkeiten:

- Ein Firefox Browser idealerweise Version 3 aber auch Version 2 wird unterstützt.

- Die Firebug Firefox Erweiterung welche unter `https://addons.mozilla.org/en-US/firefox/addon/1843`_
  heruntergeladen werden kann.

- Die FirePHP Filefox Erweiterung welche unter `https://addons.mozilla.org/en-US/firefox/addon/6149`_
  heruntergeladen werden kann.

.. _zend.log.writers.firebug.example.with_front_controller:

.. rubric:: Loggen mit Zend_Controller_Front

.. code-block:: php
   :linenos:

   // In der Bootstrap Datei platzieren bevor der Frontcontroller ausgeführt wird
   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   // Verwende das in den Modell, View, und Controller Dateien
   $logger->log('Das ist eine Lognachricht!', Zend_Log::INFO);

.. _zend.log.writers.firebug.example.without_front_controller:

.. rubric:: Loggen ohne Zend_Controller_Front

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   $request = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Ausgabe buffering starten
   ob_start();

   // Jetzt können Aufrufe an den Logger durchgeführt werden
   $logger->log('Das ist eine Lognachricht!', Zend_Log::INFO);

   // Logdaten an den Browser senden
   $channel->flush();
   $response->sendHeaders();

.. _zend.log.writers.firebug.priority-styles:

Setzen von Stilen für Prioritäten
---------------------------------

Eingebaute und Benutzerdefinierte Prioritäten können mit der ``setPriorityStyle()`` Methode angepasst werden.

.. code-block:: php
   :linenos:

   $logger->addPriority('FOO', 8);
   $writer->setPriorityStyle(8, 'TRACE');
   $logger->foo('Foo Nachricht');

Der Standardstil für Benutzerdefinierte Prioritäten kann mit der ``setDefaultPriorityStyle()`` Methode gesetzt
werden.

.. code-block:: php
   :linenos:

   $writer->setDefaultPriorityStyle('TRACE');

Die unterstützten Stile sind wie folgt:



      .. _zend.log.writers.firebug.priority-styles.table:

      .. table:: Firebug Logging Stile

         +---------+-------------------------------------------------------------------------+
         |Stil     |Beschreibung                                                             |
         +=========+=========================================================================+
         |LOG      |Zeigt eine reine Lognachricht an                                         |
         +---------+-------------------------------------------------------------------------+
         |INFO     |Zeigt eine Info Lognachricht an                                          |
         +---------+-------------------------------------------------------------------------+
         |WARN     |Zeigt eine Warnungs Lognachricht an                                      |
         +---------+-------------------------------------------------------------------------+
         |ERROR    |Zeigt eine Fehler Lognachricht an die den Fehlerzählen von Firebug erhöht|
         +---------+-------------------------------------------------------------------------+
         |TRACE    |Zeigt eine Lognachricht mit einem erweiterbaren Stack Trace an           |
         +---------+-------------------------------------------------------------------------+
         |EXCEPTION|Zeigt eine lange Fehlernachicht mit erweiterbarem Stack Trace an         |
         +---------+-------------------------------------------------------------------------+
         |TABLE    |Zeigt eine Lognachricht mit erweiterbarer Tabelle an                     |
         +---------+-------------------------------------------------------------------------+



.. _zend.log.writers.firebug.preparing-data:

Daten für das Loggen vorbereiten
--------------------------------

Wärend jede *PHP* Variable mit den eingebauten Prioritäten geloggt werden kann, ist eine etwas spezielle
Formatierung notwendig wenn einige der spezialisierteren Logstile verwendet werden.

Die ``LOG``, ``INFO``, ``WARN``, ``ERROR`` und ``TRACE`` Stile benötigen keine spezielle Formatierung.

.. _zend.log.writers.firebug.preparing-data.exception:

Loggen von Ausnahmen
--------------------

Um eine ``Zend_Exception`` zu loggen muß einfach das Exceptionobjekt an den Logger übergeben werden. Es ist egal
welche Priorität oder welcher Stil gesetzt wurde, da die Ausnahme automatisch erkannt wird.

.. code-block:: php
   :linenos:

   $exception = new Zend_Exception('Test Ausnahme');
   $logger->err($exception);

.. _zend.log.writers.firebug.preparing-data.table:

Tabellen loggen
---------------

Man kann auch Daten loggen und diese in einem Table Stil formatieren. Spalten werden automatisch erkannt und die
erste Zeile der Daten wird automatisch der Header.

.. code-block:: php
   :linenos:

   $writer->setPriorityStyle(8, 'TABLE');
   $logger->addPriority('TABLE', 8);

   $table = array('Summary line for the table',
                  array(
                      array('Spalte 1', 'Spalte 2'),
                      array('Zeile 1 c 1','Zeile 1 c 2'),
                      array('Zeile 2 c 1',' Zeile 2 c 2')
                  )
            );
   $logger->table($table);



.. _`Firebug`: http://www.getfirebug.com/
.. _`Console`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
