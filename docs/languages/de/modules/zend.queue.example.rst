.. _zend.queue.example:

Beispiel der Verwendung
=======================

Das beiliegende Beispiel von ``Zend_Queue`` zeigt eine Vielzahl von Features, inklusive Erstellung der Queue,
Empfangen der Queue, Empfangen von Nachrichten, Löschen von Nachrichten und Senden von Nachrichten.

.. code-block:: php
   :linenos:

   // Für Konfigurations Optionen siehe
   // @see Zend_Queue_Adapater::__construct()
   $options = array(
       'name' => 'queue1',
   );

   // Erstellung einer Array Queue
   $queue = new Zend_Queue('Array', $options);

   // Eine Liste von Queues erhalten
   foreach ($queue->getQueues() as $name) {
       echo $name, "\n";
   }

   // eine neue Liste erstellen
   $queue2 = $queue->createQueue('queue2');

   // Die Anzahl von Nachrichten in einer Queue erhalten
   // (unterstützt das Countable Interface von SPL)
   echo count($queue);

   // Bis zu 5 Nachrichten von der Queue erhalten
   $messages = $queue->receive(5);

   foreach ($messages as $i => $message) {
       echo $message->body, "\n";

       // Wir haben die Nachrichten bearbeitet;
       // jetzt löschen wir Sie von der Queue
       $queue->deleteMessage($message);
   }

   // Eine Nachricht zur aktuell aktiven Queue senden
   $queue->send('Meine Test Nachricht');

   // Eine Queue die wir erstellt haben löschen inklusive aller Ihrer Nachrichten
   $queue->deleteQueue('queue2');


