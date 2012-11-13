.. _zendservice.amazon.sqs:

ZendService\Amazon\Sqs
=======================

.. _zendservice.amazon.sqs.introduction:

Introduction
------------

`Amazon Simple Queue Service (Amazon SQS)`_ offers a reliable, highly scalable, hosted queue for storing messages
as they travel between computers. By using Amazon SQS, developers can simply move data between distributed
components of their applications that perform different tasks, without losing messages or requiring each component
to be always available. Amazon SQS makes it easy to build an automated workflow, working in close conjunction with
the Amazon Elastic Compute Cloud (Amazon EC2) and the other *AWS* infrastructure web services.

Amazon SQS works by exposing Amazon's web-scale messaging infrastructure as a web service. Any computer on the
Internet can add or read messages without any installed software or special firewall configurations. Components of
applications using Amazon SQS can run independently, and do not need to be on the same network, developed with the
same technologies, or running at the same time.

.. _zendservice.amazon.sqs.registering:

Registering with Amazon SQS
---------------------------

Before you can get started with ``ZendService\Amazon\Sqs``, you must first register for an account. Please see the
`SQS FAQ`_ page on the Amazon website for more information.

After registering, you will receive an application key and a secret key. You will need both to access the SQS
service.

.. _zendservice.amazon.sqs.apiDocumentation:

API Documentation
-----------------

The ``ZendService\Amazon\Sqs`` class provides the *PHP* wrapper to the Amazon SQS REST interface. Please consult
the `Amazon SQS documentation`_ for detailed description of the service. You will need to be familiar with basic
concepts in order to use this service.

.. _zendservice.amazon.sqs.features:

Features
--------

``ZendService\Amazon\Sqs`` provides the following functionality:

- A single point for configuring your amazon.sqs authentication credentials that can be used across the amazon.sqs
  namespaces.

- A proxy object that is more convenient to use than an *HTTP* client alone, mostly removing the need to manually
  construct *HTTP* POST requests to access the REST service.

- A response wrapper that parses each response body and throws an exception if an error occurred, alleviating the
  need to repeatedly check the success of many commands.

- Additional convenience methods for some of the more common operations.

.. _zendservice.amazon.sqs.storing-your-first:

Getting Started
---------------

Once you have registered with Amazon SQS, you're ready to create your queue and store some messages on SQS. Each
queue can contain unlimited amount of messages, identified by name.

The following example demonstrates creating a queue, storing and retrieving messages.

.. _zendservice.amazon.sqs.storing-your-first.example:

.. rubric:: ZendService\Amazon\Sqs Usage Example

.. code-block:: php
   :linenos:

   $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);

   $queue_url = $sqs->create('test');

   $message = 'this is a test';
   $message_id = $sqs->send($queue_url, $message);

   foreach ($sqs->receive($queue_url) as $message) {
       echo $message['body'].'<br/>';
   }

Since the ``ZendService\Amazon\Sqs`` service requires authentication, you should pass your credentials (AWS key
and secret key) to the constructor. If you only use one account, you can set default credentials for the service:

.. code-block:: php
   :linenos:

   ZendService\Amazon\Sqs::setKeys($my_aws_key, $my_aws_secret_key);
   $sqs = new ZendService\Amazon\Sqs();

.. _zendservice.amazon.sqs.queues:

Queue operations
----------------

All messages SQS are stored in queues. A queue has to be created before any message operations. Queue names must be
unique under your access key and secret key.

Queue names can contain lowercase letters, digits, periods (.), underscores (\_), and dashes (-). No other symbols
allowed. Queue names can be a maximum of 80 characters.

- ``create()`` creates a new queue.

- ``delete()`` removes all messages in the queue.

  .. _zendservice.amazon.sqs.queues.removalExample:

  .. rubric:: ZendService\Amazon\Sqs Queue Removal Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_1');
     $sqs->delete($queue_url);

- ``count()`` gets the approximate number of messages in the queue.

  .. _zendservice.amazon.sqs.queues.countExample:

  .. rubric:: ZendService\Amazon\Sqs Queue Count Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_1');
     $sqs->send($queue_url, 'this is a test');
     $count = $sqs->count($queue_url); // Returns '1'

- ``getQueues()`` returns the list of the names of all queues belonging to the user.

  .. _zendservice.amazon.sqs.queues.listExample:

  .. rubric:: ZendService\Amazon\Sqs Queue Listing Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $list = $sqs->getQueues();
     foreach ($list as $queue) {
        echo "I have queue $queue\n";
     }

.. _zendservice.amazon.sqs.messages:

Message operations
------------------

After a queue is created, simple messages can be sent into the queue then received at a later point in time.
Messages can be up to 8KB in length. If longer messages are needed please see `S3`_. There is no limit to the
number of messages a queue can contain.

- ``sent($queue_url, $message)`` send the ``$message`` to the ``$queue_url`` SQS queue *URL*.

  .. _zendservice.amazon.sqs.messages.sendExample:

  .. rubric:: ZendService\Amazon\Sqs Message Send Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'this is a test message');

- ``receive($queue_url)`` retrieves messages from the queue.

  .. _zendservice.amazon.sqs.messages.receiveExample:

  .. rubric:: ZendService\Amazon\Sqs Message Receive Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'this is a test message');
     foreach ($sqs->receive($queue_url) as $message) {
         echo "got message ".$message['body'].'<br/>';
     }

- ``deleteMessage($queue_url, $handle)`` deletes a message from a queue. A message must first be received using the
  ``receive()`` method before it can be deleted.

  .. _zendservice.amazon.sqs.messages.deleteExample:

  .. rubric:: ZendService\Amazon\Sqs Message Delete Example

  .. code-block:: php
     :linenos:

     $sqs = new ZendService\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'this is a test message');
     foreach ($sqs->receive($queue_url) as $message) {
         echo "got message ".$message['body'].'<br/>';

         if ($sqs->deleteMessage($queue_url, $message['handle'])) {
             echo "Message deleted";
         }
         else {
             echo "Message not deleted";
         }
     }



.. _`Amazon Simple Queue Service (Amazon SQS)`: http://aws.amazon.com/sqs/
.. _`SQS FAQ`: http://aws.amazon.com/sqs/faqs/
.. _`Amazon SQS documentation`: http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=31
.. _`S3`: http://framework.zend.com/manual/en/zendservice.amazon.s3.html
