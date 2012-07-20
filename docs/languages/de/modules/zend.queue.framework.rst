.. _zend.queue.framework:

Framework
=========

``Zend_Queue`` ist ein Proxy der die Details des Queue Services versteckt. Die Queue Services werden durch
``Zend_Queue_Adapter_<service>`` repräsentiert. Zum Beispiel ist ``Zend_Queue_Adapter_Db`` eine Queue die
Datenbanktabellen verwendet um Nachrichten zu speichern und zu empfangen.

Anbei ist ein Beispiel für die Verwendung von Datenbanktabellen für ein Queueing System:

.. code-block:: php
   :linenos:

   $options = array(
       'name'          => 'queue1',
       'driverOptions' => array(
           'host'      => '127.0.0.1',
           'port'      => '3306',
           'username'  => 'queue',
           'password'  => 'queue',
           'dbname'    => 'queue',
           'type'      => 'pdo_mysql'
       )
   );

   // Erstellt eine Datenbank Queue.
   // Zend_Queue fügt vorne Zend_Queue_Adapter_ an 'Db' für den Klassennamen an.
   $queue = new Zend_Queue('Db', $options);

Der Constructor von ``Zend_Queue`` erstellt eine ``Zend_Queue_Adapter_Db`` und initialisiert den Adapter mit den
Konfigurationseinstellungen.

Die akzeptierten Konfigurationseinstellungen für jeden Adapter sind in den :ref:`Adapter Notizen
<zend.queue.adapters>` beschrieben.

``Zend_Queue`` gibt Nachrichten zurück indem es die ``Zend_Queue_Message_Iterator`` Klasse verwendet, welche eine
Implementation vom *SPL* ``Iterator`` und von ``Countable`` ist. ``Zend_Queue_Message_Iterator`` enthält ein Array
von ``Zend_Queue_Message`` Objekten.

.. code-block:: php
   :linenos:

   $messages = $queue->receive(5);
   foreach ($messages as $i => $message) {
       echo "$i) Nachricht => ", $message->body, "\n";
   }

Alle Exceptions die geworfen werden sind von der Klasse ``Zend_Queue_Exception``.

.. _zend.queue.framework.basics:

Einführung
----------

``Zend_Queue`` ist eine Proxy Klasse die einen Adapter repräsentiert.

Die Methoden ``send()``, ``count($queue)``, und ``receive()`` werden von jedem Adapter verwendet um mit den Queues
zu interagieren.

Die Methoden ``createQueue()``, ``deleteQueue()`` werden verwendet um Queues zu managen.

.. _zend.queue.framework.support:

Gemeinsamkeiten für alle Adapter
--------------------------------

Die Queue Services die von ``Zend_Queue`` unterstützt werden unterstützen nicht alle die gleichen
Funktionalitäten. Zum Beispiel unterstützen ``Zend_Queue_Adapter_Array`` und ``Zend_Queue_Adapter_Db`` alle
Funktionen, wärend ``Zend_Queue_Adapter_Activemq`` das Auflisten und Löschen von Queues der das Zählen von
Nachrichten nicht unterstützt.

Man kann erkennen welche Funktionen unterstützt werden indem ``Zend_Queue::isSupported()`` oder
``Zend_Queue::getCapabilities()`` verwendet wird.

- **createQueue()**- Erstellt eine Queue

- **deleteQueue()**- Löscht eine Queue

- **send()**- Sendet eine Nachricht

  ``send()`` ist nicht in allen Adaptern vorhanden; ``Zend_Queue_Adapter_Null`` unterstützt ``send()`` nicht.

- **receive()**- Empfängt eine Nachricht

  ``receive()`` ist nicht in allen Adaptern vorhanden; ``Zend_Queue_Adapter_Null`` unterstützt ``receive()``
  nicht.

- **deleteMessage()**- Löscht eine Nachricht

- **count()**- Zählt die Anzahl an Nachrichten in einer Queue

- **isExists()**- Prüft auf die Existenz einer Queue

``receive()`` Methoden werden von jedem Adapter zur Verfügung gestellt um mit Queues zu interagieren.

Die Methoden ``createQueue()`` und ``deleteQueue()`` werden verwendet um Queues zu managen.


