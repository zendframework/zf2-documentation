.. _zendqueue.framework:

Framework
=========

The ``ZendQueue\Queue`` is a proxy that hides the details of the queue services. The queue services are represented by
``Zend\Queue\Adapter\<service>``. For example, ``Zend\Queue\Adapter\Db`` is a queue that will use database tables
to store and retrieve messages.

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
   // ZendQueue\Queue will prepend Zend\Queue\Adapter\ to 'Db' for the class name.
   $queue = new Zend\Queue\Queue('Db', $options);

The ``ZendQueue\Queue`` constructor will create a ``Zend\Queue\Adapter\Db`` and initialize the adapter with the
configuration settings.

The accepted configuration settings for each adapter are provided in the :ref:`adapter notes
<zendqueue.adapters>`.

``ZendQueue\Queue`` returns messages using the class ``Zend\Queue\Message\Iterator``, which is an implementation of
*SPL* ``Iterator`` and ``Countable``. ``Zend\Queue\Message\Iterator`` contains an array of ``Zend\Queue\Message``
objects.

.. code-block:: php
   :linenos:

   $messages = $queue->receive(5);
   foreach ($messages as $i => $message) {
       echo "$i) Message => ", $message->body, "\n";
   }

Any exceptions thrown are of class ``Zend\Queue\Exception``.

.. _zendqueue.framework.basics:

Introduction
------------

``ZendQueue\Queue`` is a proxy class that represents an adapter.

The ``send()``, ``count($queue)``, and ``receive()`` methods are employed by each adapter to interact with queues.

The ``createQueue()``, ``deleteQueue()`` methods are used to manage queues.

.. _zendqueue.framework.support:

Commonality among adapters
--------------------------

The queue services supported by ``ZendQueue\Queue`` do not all support the same functions. For example,
``Zend\Queue\Adapter\Array``, ``Zend\Queue\Adapter\Db``, support all functions, while
``Zend\Queue\Adapter\Activemq`` does not support queue listing, queue deletion, or counting of messages.

You can determine what functions are supported by using ``Zend\Queue\Queue::isSupported()`` or
``Zend\Queue\Queue::getCapabilities()``.

- **createQueue()**- create a queue

- **deleteQueue()**- delete a queue

- **send()**- send a message

  ``send()`` is not available in all adapters; the ``Zend\Queue\Adapter\Null`` does not support ``send()``.

- **receive()**- receive messages

  ``receive()`` is not available in all adapters; the ``Zend\Queue\Adapter\Null`` does not support ``receive()``.

- **deleteMessage()**- delete a message

- **count()**- count the number of messages in a queue

- **isExists()**- checks the existence of a queue

``receive()`` methods are employed by each adapter to interact with queues.

The ``createQueue()`` and ``deleteQueue()`` methods are used to manage queues.


