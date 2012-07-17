
.. _zend.queue.framework:

Framework
=========

The ``Zend_Queue`` is a proxy that hides the details of the queue services. The queue services are represented by ``Zend_Queue_Adapter_<service>``. For example, ``Zend_Queue_Adapter_Db`` is a queue that will use database tables to store and retrieve messages.

Below is an example for using database tables for a queuing system:

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

   // Create a database queue.
   // Zend_Queue will prepend Zend_Queue_Adapter_ to 'Db' for the class name.
   $queue = new Zend_Queue('Db', $options);

The ``Zend_Queue`` constructor will create a ``Zend_Queue_Adapter_Db`` and initialize the adapter with the configuration settings.

The accepted configuration settings for each adapter are provided in the :ref:`adapter notes <zend.queue.adapters>`.

``Zend_Queue`` returns messages using the class ``Zend_Queue_Message_Iterator``, which is an implementation of *SPL* ``Iterator`` and ``Countable``. ``Zend_Queue_Message_Iterator`` contains an array of ``Zend_Queue_Message`` objects.

.. code-block:: php
   :linenos:

   $messages = $queue->receive(5);
   foreach ($messages as $i => $message) {
       echo "$i) Message => ", $message->body, "\n";
   }

Any exceptions thrown are of class ``Zend_Queue_Exception``.


.. _zend.queue.framework.basics:

Introduction
------------

``Zend_Queue`` is a proxy class that represents an adapter.

The ``send()``, ``count($queue)``, and ``receive()`` methods are employed by each adapter to interact with queues.

The ``createQueue()``, ``deleteQueue()`` methods are used to manage queues.


.. _zend.queue.framework.support:

Commonality among adapters
--------------------------

The queue services supported by ``Zend_Queue`` do not all support the same functions. For example, ``Zend_Queue_Adapter_Array``, ``Zend_Queue_Adapter_Db``, support all functions, while ``Zend_Queue_Adapter_Activemq`` does not support queue listing, queue deletion, or counting of messages.

You can determine what functions are supported by using ``Zend_Queue::isSupported()`` or ``Zend_Queue::getCapabilities()``.

- **createQueue()**- create a queue

- **deleteQueue()**- delete a queue

- **send()**- send a message

  ``send()`` is not available in all adapters; the ``Zend_Queue_Adapter_Null`` does not support ``send()``.


- **receive()**- receive messages

  ``receive()`` is not available in all adapters; the ``Zend_Queue_Adapter_Null`` does not support ``receive()``.


- **deleteMessage()**- delete a message

- **count()**- count the number of messages in a queue

- **isExists()**- checks the existence of a queue

``receive()`` methods are employed by each adapter to interact with queues.

The ``createQueue()`` and ``deleteQueue()`` methods are used to manage queues.


