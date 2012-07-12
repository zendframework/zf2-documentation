
The MvcEvent
============

The ZF2 MVC layer incorporates and utilizes a custom ``Zend\EventManager\EventDescription`` type, ``Zend\Mvc\MvcEvent`` . This event is created during ``Zend\Mvc\Application::run()`` , and is passed directly to all events that method triggers. Additionally, if you mark your controllers with the ``Zend\Mvc\InjectApplicationEvent`` interface, it will be injected into those controllers.

The ``MvcEvent`` adds accessors and mutators for the following:

The methods it defines are:

The ``Application`` , ``Request`` , ``Response`` , ``Router`` , and ``ViewModel`` are all injected during the ``bootstrap`` event. Following the ``route`` event, it will be injected also with the ``RouteMatch`` object encapsulating the results of routing.

Since this object is passed around throughout the MVC, it is a common location for retrieving the results of routing, the router, and the request and response objects. Additionally, we encourage setting the results of execution in the event, to allow event listeners to introspect them and utilize them within their execution. As an example, the results could be passed into a view renderer.


