.. _zendservice.windowsazure.storage.queue:

ZendService\\WindowsAzure\\Storage\Queue
========================================

The Queue service stores messages that may be read by any client who has access to the storage account.

A queue can contain an unlimited number of messages, each of which can be up to 8 KB in size. Messages are
generally added to the end of the queue and retrieved from the front of the queue, although first in/first out
(*FIFO*) behavior is not guaranteed. If you need to store messages larger than 8 KB, you can store message data as
a queue or in a table and then store a reference to the data as a message in a queue.

Queue Storage is offered by Windows Azure as a *REST* *API* which is wrapped by the
``ZendService\WindowsAzure\Storage\Queue`` class in order to provide a native *PHP* interface to the storage
account.

.. _zendservice.windowsazure.storage.queue.api:

API Examples
------------

This topic lists some examples of using the ``ZendService\WindowsAzure\Storage\Queue`` class. Other features are
available in the download package, as well as a detailed *API* documentation of those features.

.. _zendservice.windowsazure.storage.queue.api.create-queue:

Creating a queue
^^^^^^^^^^^^^^^^

Using the following code, a queue can be created on development storage.

.. _zendservice.windowsazure.storage.queue.api.create-queue.example:

.. rubric:: Creating a queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();
   $result = $storageClient->createQueue('testqueue');

   echo 'Queue name is: ' . $result->Name;

.. _zendservice.windowsazure.storage.queue.api.delete-queue:

Deleting a queue
^^^^^^^^^^^^^^^^

Using the following code, a queue can be removed from development storage.

.. _zendservice.windowsazure.storage.queue.api.delete-queue.example:

.. rubric:: Deleting a queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();
   $storageClient->deleteQueue('testqueue');

.. _zendservice.windowsazure.storage.queue.api.storing-queue:

Adding a message to a queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, a message can be added to a queue on development storage. Note that the queue has already
been created before.

.. _zendservice.windowsazure.storage.queue.api.storing-queue.example:

.. rubric:: Adding a message to a queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // 3600 = time-to-live of the message, if omitted defaults to 7 days
   $storageClient->putMessage('testqueue', 'This is a test message', 3600);

.. _zendservice.windowsazure.storage.queue.api.read-queue:

Reading a message from a queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, a message can be read from a queue on development storage. Note that the queue and
message have already been created before.

.. _zendservice.windowsazure.storage.queue.api.read-queue.example:

.. rubric:: Reading a message from a queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // retrieve 10 messages at once
   $messages = $storageClient->getMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message->MessageText . "\r\n";
   }

The messages that are read using ``getMessages()`` will be invisible in the queue for 30 seconds, after which the
messages will re-appear in the queue. To mark a message as processed and remove it from the queue, use the
``deleteMessage()`` method.

.. _zendservice.windowsazure.storage.queue.api.read-queue.processexample:

.. rubric:: Marking a message as processed

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // retrieve 10 messages at once
   $messages = $storageClient->getMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message . "\r\n";

       // Mark the message as processed
       $storageClient->deleteMessage('testqueue', $message);
   }

.. _zendservice.windowsazure.storage.queue.api.peek-queue:

Check if there are messages in a queue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, a queue can be checked for new messages. Note that the queue and message have already
been created before.

.. _zendservice.windowsazure.storage.queue.api.peek-queue.example:

.. rubric:: Check if there are messages in a queue

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Queue();

   // retrieve 10 messages at once
   $messages = $storageClient->peekMessages('testqueue', 10);

   foreach ($messages as $message) {
       echo $message->MessageText . "\r\n";
   }

Note that messages that are read using ``peekMessages()`` will not become invisible in the queue, nor can they be
marked as processed using the ``deleteMessage()`` method. To do this, use ``getMessages()`` instead.