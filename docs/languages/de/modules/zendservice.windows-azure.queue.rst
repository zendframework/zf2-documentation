.. EN-Revision: none
.. _zendservice.windowsazure.storage.queue:

ZendService\WindowsAzure\Storage\Queue
=======================================

Das Queue Service speichert Nachrichten die von jedem Client gelesen werden können welche auf den Speicher Account
Zugriff haben.

Eine Queue kann eine unbegrenzte Anzahl an Nachrichten enthalten, jede von Ihnen bis zu 8KB groß. Nachrichten
werden generell am Ende der Queue hinzugefügt und vom Anfang der Queue empfangen, auch wenn das First In / First
Out Verhalten (*FIFO*) nicht garantiert ist. Wenn man Nachrichten speichern muss die größer als 8KB sind, können
die Daten der Nachricht als Queue gespeichert werden oder in einer Tabelle und anschließend eine Referenz zu den
Daten als Nachricht in der Queue.

Der Queue Speicher wird von Windows Azure als *REST* *API* angeboten welche von der
``ZendService\WindowsAzure\Storage\Queue`` Klasse umhüllt wird um ein natives *PHP* Interface zum Speicher
Account zu bieten.

.. _zendservice.windowsazure.storage.queue.api:

API Beispiele
-------------

Dieses Thema listet einige Beispiele der Verwendung der ``ZendService\WindowsAzure\Storage\Queue`` Klasse auf.
Andere Features sind im Download Paket vorhanden, sowie eine detailierte *API* Dokumentation dieser Features.

.. _zendservice.windowsazure.storage.queue.api.create-queue:

Erstellung einer Queue
^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Queue auf dem Development Speicher erstellt werden.

.. _zendservice.windowsazure.storage.queue.api.create-queue.example:

.. rubric:: Erstellung einer Queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();
   $result = $storageClient->createQueue('testqueue');

   echo 'Der Name der Queue ist: ' . $result->Name;

.. _zendservice.windowsazure.storage.queue.api.delete-queue:

Löschen einer Queue
^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Queue vom Development Speicher entfernt werden.

.. _zendservice.windowsazure.storage.queue.api.delete-queue.example:

.. rubric:: Löschen einer Queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();
   $storageClient->deleteQueue('testqueue');

.. _zendservice.windowsazure.storage.queue.api.storing-queue:

Hinzufügen einer Nachricht zu einer Queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Nachricht zu einer Queue im Development Speicher hinzugefügt werden.
Es ist zu beachten das die Queue hierfür bereits erstellt worden sein muss.

.. _zendservice.windowsazure.storage.queue.api.storing-queue.example:

.. rubric:: Hinzufügen einer Nachricht zu einer Queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // 3600 = Lebenszeit der Nachricht,
   // wenn nicht angegeben ist der Standardwert 7 Tage
   $storageClient->putMessage('testqueue', 'Das ist eine Testnachricht', 3600);

.. _zendservice.windowsazure.storage.queue.api.read-queue:

Lesen einer Nachricht von einer Queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Nachricht von einer Queue im Development Speicher gelesen werden. Es
ist zu beachten das die Queue und die Nachricht hierfür bereits erstellt worden sein muss.

.. _zendservice.windowsazure.storage.queue.api.read-queue.example:

.. rubric:: Lesen einer Nachricht von einer Queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // 10 Nachrichten auf einmal empfangen
   $messages = $storageClient->getMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message->MessageText . "\r\n";
   }

Die Nachrichten welche mit ``getMessages()`` gelesen werden, werden in der Queue für 30 Sekunden unsichtbar, und
danach werden die Nachrichten in der Queue wieder erscheinen. Um eine Nachricht als bearbeitet zu markieren und Sie
von der Queue zu entfernen, kann die Methode ``deleteMessage()`` verwendet werden.

.. _zendservice.windowsazure.storage.queue.api.read-queue.processexample:

.. rubric:: Eine Nachricht als bearbeitet markieren

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // 10 Nachrichten auf einmal empfangen
   $messages = $storageClient->getMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message . "\r\n";

       // Die Nachricht als bearbeitet markieren
       $storageClient->deleteMessage('testqueue', $message);
   }

.. _zendservice.windowsazure.storage.queue.api.peek-queue:

Prüfen ob es Nachrichten in der Queue gibt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Queue auf neue Nachrichten geprüft werden. Es ist zu beachten das die
Queue und die Nachricht hierfür bereits erstellt worden sein müssen.

.. _zendservice.windowsazure.storage.queue.api.peek-queue.example:

.. rubric:: Prüfen ob es Nachrichten in einer Queue gibt

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // 10 Nachrichten auf einmal empfangen
   $messages = $storageClient->peekMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message->MessageText . "\r\n";
   }

Es ist zu beachten das Nachrichten welche mit Hilfe von ``peekMessages()`` gelesen werden in der Queue nicht
unsichtbar, und durch Verwendung der Methode ``deleteMessage()`` auch nicht als bearbeitet markiert werden können.
Um das zu tun sollte stattdessen ``getMessages()`` verwendet werden.


