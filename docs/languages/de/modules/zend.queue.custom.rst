.. _zend.queue.custom:

Anpassen von Zend_Queue
=======================

.. _zend.queue.custom.adapter:

Erstellung eigener Adapter
--------------------------

``Zend_Queue`` akzeptiert jeden Adapter der ``Zend_Queue_Adapter_AdapterAbstract`` implementiert. Man kann eigene
Adapter erstellen indem einer der existierenden Adapter, oder die abstrakte Klasse
``Zend_Queue_Adapter_AdapterAbstract`` erweitert wird. Es wird empfohlen ``Zend_Queue_Adapter_Array`` anzuschauen
da dieser Adapter in seiner Konzeption der einfachste ist.

.. code-block:: php
   :linenos:

   class Custom_DbForUpdate extends Zend_Queue_Adapter_Db
   {
       /**
        * @see Code in tests/Zend/Queue/Custom/DbForUpdate.php
        *
        * Custom_DbForUpdate verwendet SELECT ... FOR UPDATE um seine Zeilen zu
        * finden. Das ist besser um die gewünschten Zeilen zu erstellen als der
        * existierende Code.
        *
        * Trotzdem haben nicht alle Datenbanken SELECT ... FOR UPDATE als Feature.
        *
        * Notiz: Das wurde später konvertiert um eine Option für
        * Zend_Queue_Adapter_Db zu sein.
        *
        * Dieser Code ist trotzdem ein gutes Beispiel.
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
   $queue   = new Zend_Queue($adapter, $options);

Man kann den Adapter auch im Betrieb ändern.

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

Eine eigene Nachrichtenklasse erstellen
---------------------------------------

``Zend_Queue`` akzeptiert auch eigene Nachrichten Klassen. Unsere Variablen beginnen mit einem Unterstrich. Zum
Beispiel:

.. code-block:: php
   :linenos:

   class Zend_Queue_Message
   {
       protected $_data = array();
   }

Man kann die bestehende Nachrichten Klasse erweitern. Siehe den Beispielcode in
``tests/Zend/Queue/Custom/Message.php``.

.. _zend.queue.custom-iterator:

Erstellen einer eigenen Nachrichten Iterator Klasse
---------------------------------------------------

``Zend_Queue`` akzeptiert auch eine eigene Nachrichten Iterator Klasse. Diese Nachrichten Iterator Klasse wird
verwendet um Nachrichten von ``Zend_Queue_Adapter_Abstract::recieve()`` zurckzugeben.
``Zend_Queue_Abstract::receive()`` sollte immer eine Controller Klasse zurückgeben so wie
``Zend_Queue_Message_Iterator`` selbst wenn nur eine Nachricht vorhanden ist.

Siehe den Beispiel Dateinamen in ``tests/Zend/Queue/Custom/Messages.php``.

.. _zend.queue.custom.queue:

Erstellen einer eigenen Queue Klasse
------------------------------------

``Zend_Queue`` kann auch sehr einfach überladen werden.

Siehe den Beispiel Dateinamen in ``tests/Zend/Queue/Custom/Queue.php``.


