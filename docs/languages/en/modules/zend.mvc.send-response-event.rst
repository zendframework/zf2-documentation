.. _zend.mvc.send-response-event:

The SendResponseEvent
=====================

The MVC layer of Zend Framework 2 also incorporates and utilizes a custom ``Zend\EventManager\Event`` implementation located at 
``Zend\Mvc\ResponseSender\SendResponseEvent``. This event allows listeners to update the response object, by setting headers and content.

The methods it defines are:

- ``setResponse($response)``

- ``getResponse()``

- ``setContentSent()``

- ``contentSent()``

- ``setHeadersSent()``

- ``headersSent()``


Listeners
---------

Currently, three listeners are listening to this event at different priorities based on which listener is used most.

1. ``Zend\Mvc\SendResponseListener\PhpEnvironmentResponseSender`` / priority : -1000 / method called : ``__invoke`` => this is used in context of HTTP (this is the most ofen used).
2. ``Zend\Mvc\SendResponseListener\ConsoleResponseSender`` / priority : -2000 / method called : ``__invoke`` => this is used in context of Console.
3. ``Zend\Mvc\SendResponseListener\SimpleStreamResponseSender`` / priority : -3000 / method called : ``__invoke``

Because all these listeners have negative priorities, adding your own logic to modify ``Response`` object is easy: just add a new listener without any priority (it will default to 1) and it will always be executed first.


Triggerers
----------

This event is executed when MvcEvent::FINISH event is triggered, with a priority of -10000.
