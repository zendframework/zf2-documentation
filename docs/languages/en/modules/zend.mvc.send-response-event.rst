.. _zend.mvc.send-response-event:

The SendResponseEvent
=====================

The MVC layer of Zend Framework 2 also incorporates and utilizes a custom ``Zend\EventManager\Event``
implementation located at ``Zend\Mvc\ResponseSender\SendResponseEvent``. This event allows listeners to update the
response object, by setting headers and content.

The methods it defines are:

- ``setResponse($response)``

- ``getResponse()``

- ``setContentSent()``

- ``contentSent()``

- ``setHeadersSent()``

- ``headersSent()``

.. _zend.mvc.send-response-event.listeners:

Listeners
---------

Currently, three listeners are listening to this event at different priorities based on which listener is used most.

.. _zend.mvc.send-response-event.listeners.table:

.. table:: ``SendResponseEvent`` Listeners

   +---------------------------------------------------------------+---------+--------------+--------------------------------------------------------------+
   |Class                                                          |Priority |Method Called |Description                                                   |
   +===============================================================+=========+==============+==============================================================+
   |``Zend\Mvc\SendResponseListener\PhpEnvironmentResponseSender`` |-1000    |``__invoke``  |This is used in context of HTTP (this is the most often used).|
   +---------------------------------------------------------------+---------+--------------+--------------------------------------------------------------+
   |``Zend\Mvc\SendResponseListener\ConsoleResponseSender``        |-2000    |``__invoke``  |This is used in context of Console.                           |
   +---------------------------------------------------------------+---------+--------------+--------------------------------------------------------------+
   |``Zend\Mvc\SendResponseListener\SimpleStreamResponseSender``   |-3000    |``__invoke``  |                                                              |
   +---------------------------------------------------------------+---------+--------------+--------------------------------------------------------------+


Because all these listeners have negative priorities, adding your own logic to modify ``Response`` object is easy:
just add a new listener without any priority (it will default to 1) and it will always be executed first.

.. _zend.mvc.send-response-event.triggerers:

Triggerers
----------

This event is executed when MvcEvent::FINISH event is triggered, with a priority of -10000.
