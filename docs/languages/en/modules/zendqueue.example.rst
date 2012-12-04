.. _zendqueue.example:

Example usage
=============

The below example of ``ZendQueue`` shows a variety of features, including queue creation, queue retrieval, message
retrieval, message deletion, and sending messages.

.. code-block:: php
   :linenos:

   // For configuration options
   // @see Zend\Queue\Adapter::__construct()
   $options = array(
       'name' => 'queue1',
   );

   // Create an array queue
   $queue = new Zend\Queue\Queue('Array', $options);

   // Get list of queues
   foreach ($queue->getQueues() as $name) {
       echo $name, "\n";
   }

   // Create a new queue
   $queue2 = $queue->createQueue('queue2');

   // Get number of messages in a queue (supports Countable interface from SPL)
   echo count($queue);

   // Get up to 5 messages from a queue
   $messages = $queue->receive(5);

   foreach ($messages as $i => $message) {
       echo $message->body, "\n";

       // We have processed the message; now we remove it from the queue.
       $queue->deleteMessage($message);
   }

   // Send a message to the currently active queue
   $queue->send('My Test Message');

   // Delete a queue we created and all of it's messages
   $queue->deleteQueue('queue2');


