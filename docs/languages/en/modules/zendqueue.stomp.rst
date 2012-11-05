.. _zendqueue.stomp:

Stomp
=====

``Zend\Queue\Stomp`` provides a basic client to communicate with `Stomp`_ compatible servers. Some servers, such as
Apache ActiveMQ and RabbitMQ, will allow you to communicate by other methods, such as *HTTP*, and *XMPP*.

The Stomp protocol provides `StompConnect`_ which supports any `Java Message Service (JMS)`_ provider. Stomp is
supported by `Apache ActiveMQ`_, `RabbitMQ`_, `stompserver`_, and `Gozirra`_.

.. _zendqueue.adapters-configuration.stomp:

Stomp - Supporting classes
--------------------------

- ``Zend\Queue\Stomp\Frame``. This class provides the basic functions for manipulating a Stomp Frame.

- ``Zend\Queue\Stomp\Client``. This class provides the basic functions to ``send()`` and ``receive()``
  ``Zend\Queue\Stomp\Frame``\ s to and from a Stomp compatible server.



.. _`Stomp`: http://stomp.codehaus.org/
.. _`StompConnect`: http://stomp.codehaus.org/StompConnect
.. _`Java Message Service (JMS)`: http://java.sun.com/products/jms/
.. _`Apache ActiveMQ`: http://activemq.apache.org/
.. _`RabbitMQ`: http://www.rabbitmq.com/
.. _`stompserver`: http://stompserver.rubyforge.org/
.. _`Gozirra`: http://www.germane-software.com/software/Java/Gozirra/
