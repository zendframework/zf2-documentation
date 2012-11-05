.. EN-Revision: none
.. _zend.log.filters:

Filter
======

Ein Filter Objekt blockiert eine Nachricht damit diese nicht in das Log geschrieben wird.

.. _zend.log.filters.all-writers:

Filter für alle Writer
----------------------

Um vor allen Writern zu filtern, kann eine beliebige Anzahl von Filtern zu einem Log Objekt hinzugefügt werden
indem die ``addFilter()`` Methode verwendet wird:

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Log();

   $writer = new Zend\Log_Writer\Stream('php://output');
   $logger->addWriter($writer);

   $filter = new Zend\Log_Filter\Priority(Zend\Log\Log::CRIT);
   $logger->addFilter($filter);

   // Blockiert
   $logger->info('Informative Nachricht');

   // Gelogged
   $logger->emerg('Notfall Nachricht');

Wenn ein oder mehrere Filter zu einem Log Objekt hinzugefügt werden, muß die Nachricht durch alle Filter hindurch
bevor irgendein Filter sie empfängt.

.. _zend.log.filters.single-writer:

Filtern für eine Writer Instanz
-------------------------------

Um nur auf eine definierte Writer Instanz zu filtern, muß die ``addFilter()`` Methode dieses Writer's verwendet
werden:

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Log();

   $writer1 = new Zend\Log_Writer\Stream('/path/to/first/logfile');
   $logger->addWriter($writer1);

   $writer2 = new Zend\Log_Writer\Stream('/path/to/second/logfile');
   $logger->addWriter($writer2);

   // Einen Filter nur zu Writer2 hinzufügen
   $filter = new Zend\Log_Filter\Priority(Zend\Log\Log::CRIT);
   $writer2->addFilter($filter);

   // Geloggt von Writer1, Blockiert von Writer2
   $logger->info('Informative Nachricht');

   // Geloggt von beiden Writern
   $logger->emerg('Notfall Nachricht');


