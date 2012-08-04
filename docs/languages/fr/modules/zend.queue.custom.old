.. _zend.queue.custom:

Customizing Zend_Queue
======================

.. _zend.queue.custom.adapter:

Creating your own adapter
-------------------------

``Zend_Queue`` will accept any adapter that implements ``Zend_Queue_Adapter_AdapterAbstract``. You can create your
own adapter by extending one of the existing adapters, or the abstract class
``Zend_Queue_Adapter_AdapterAbstract``. I suggest reviewing ``Zend_Queue_Adapter_Array`` as this adapter is the
easiest to conceptualize.

.. code-block:: php
   :linenos:

   class Custom_DbForUpdate extends Zend_Queue_Adapter_Db
   {
       /**
        * @see code in tests/Zend/Queue/Custom/DbForUpdate.php
        *
        * Custom_DbForUpdate uses the SELECT ... FOR UPDATE to find it's rows.
        * this is more likely to produce the wanted rows than the existing code.
        *
        * However, not all databases have SELECT ... FOR UPDATE as a feature.
        *
        * Note: this was later converted to be an option for Zend_Queue_Adapter_Db
        *
        * This code still serves as a good example.
        */
   }

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

   $adapter = new Custom_DbForUpdate($options);
   $queue = new Zend_Queue($adapter, $options);

You can also change the adapter on the fly as well.

.. code-block:: php
   :linenos:

   $adapter = new MyCustom_Adapter($options);
   $queue   = new Zend_Queue($options);
   $queue->setAdapter($adapter);
   echo "Adapter: ", get_class($queue->getAdapter()), "\n";

or

.. code-block:: php
   :linenos:

   $options = array(
       'name'           => 'queue1',
       'namespace'      => 'Custom',
       'driverOptions'  => array(
           'host'       => '127.0.0.1',
           'port'       => '3306',
           'username'   => 'queue',
           'password'   => 'queue',
           'dbname'     => 'queue',
           'type'       => 'pdo_mysql'
       )
   );
   $queue = new Zend_Queue('DbForUpdate', $config); // loads Custom_DbForUpdate

.. _zend.queue.custom.message:

Creating your own message class
-------------------------------

``Zend_Queue`` will also accept your own message class. Our variables start with an underscore. For example:

.. code-block:: php
   :linenos:

   class Zend_Queue_Message
   {
       protected $_data = array();
   }

You can extend the existing messaging class. See the example code in ``tests/Zend/Queue/Custom/Message.php``.

.. _zend.queue.custom-iterator:

Creating your own message iterator class
----------------------------------------

``Zend_Queue`` will also accept your own message iterator class. The message iterator class is used to return
messages from ``Zend_Queue_Adapter_Abstract::recieve()``. ``Zend_Queue_Abstract::receive()`` should always return a
container class like ``Zend_Queue_Message_Iterator``, even if there is only one message.

See the example filename in ``tests/Zend/Queue/Custom/Messages.php``.

.. _zend.queue.custom.queue:

Creating your own queue class
-----------------------------

``Zend_Queue`` can also be overloaded easily.

See the example filename in ``tests/Zend/Queue/Custom/Queue.php``.


