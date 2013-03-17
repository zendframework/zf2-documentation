.. _zend.mvc.mvc-event:

The MvcEvent
============

The MVC layer of Zend Framework 2 incorporates and utilizes a custom ``Zend\EventManager\Event`` implementation -
``Zend\Mvc\MvcEvent``. This event is created during ``Zend\Mvc\Application::bootstrap()`` and is passed directly to all
the events that method triggers. Additionally, if your controllers implement the
``Zend\Mvc\InjectApplicationEventInterface``, ``MvcEvent`` will be injected into those controllers.

The ``MvcEvent`` adds accessors and mutators for the following:

- ``Application`` object.
- ``Request`` object.
- ``Response`` object.
- ``Router`` object.
- ``RouteMatch`` object.
- Result - usually the result of dispatching a controller.
- ``ViewModel`` object, typically representing the layout view model.

The methods it defines are:

- ``setApplication($application)``

- ``getApplication()``

- ``setRequest($request)``

- ``getRequest()``

- ``setResponse($response)``

- ``getResponse()``

- ``setRouter($router)``

- ``getRouter()``

- ``setRouteMatch($routeMatch)``

- ``getRouteMatch()``

- ``setResult($result)``

- ``getResult()``

- ``setViewModel($viewModel)``

- ``getViewModel()``

- ``isError()``

- ``setError()``

- ``getError()``

- ``getController()``

- ``setController($name)``

- ``getControllerClass()``

- ``setControllerClass($class)``

The ``Application``, ``Request``, ``Response``, ``Router``, and ``ViewModel`` are all injected during the
``bootstrap`` event. Following the ``route`` event, it will be injected also with the ``RouteMatch`` object
encapsulating the results of routing.

Since this object is passed around throughout the MVC, it is a common location for retrieving the results of
routing, the router, and the request and response objects. Additionally, we encourage setting the results of
execution in the event, to allow event listeners to introspect them and utilize them within their execution. As an
example, the results could be passed into a view renderer.


Order of events
---------------

The following events are triggered, in the following order:

1. BOOTSTRAP: Bootstrap the application by creating the ViewManager.
2. ROUTE: Perform all the route work (matching…).
3. DISPATCH: Dispatch the matched route to a controller/action.
4. DISPATCH_ERROR: Event triggered in case of a problem during dispatch process (unknown controller…).
5. RENDER: Prepare the data and delegate the rendering to the view layer.
6. RENDER_ERROR: Event triggered in case of a problem during the render process (no renderer found…).
7. FINISH: Perform any task once everything is done.

Those events are extensively describe in the following sections.


MvcEvent::BOOTSRAP
------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

1. ``Zend\Mvc\View\Http\ViewManager`` / priority : 10000 / method called: ``onBootstrap`` / itself triggers: none => preparing the view layer (instantiate a ``Zend\Mvc\View\Http\ViewManager``…).


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\Application`` / in method: ``bootstrap``.


MvcEvent::ROUTE
---------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

1. ``Zend\Mvc\ModuleRouteListener`` / priority: 1 / method called: ``onRoute`` / itself triggers: none => this listener determines if the module namespace should be prepended to the controller name. This is the case if the route match contains a parameter key matching the MODULE_NAMESPACE constant.
2. ``Zend\Mvc\RouteListener`` / priority: 1 / method called: ``onRoute`` / itself triggers: MvcEvent::EVENT_DISPATCH_ERROR (if no route is matched) => tries to match the request to the router and return a RouteMatch object.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\Application`` / in method: ``run`` => it also has a short circuit callback that allows to stop the propagation of the event if an error is raised during the routing.



MvcEvent::DISPATCH
------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

1. ``Zend\Mvc\View\Console\InjectNamedConsoleParamsListener`` / priority: 1000 / method called: ``injectNamedParams`` => merge all the params (route matched params and params in the command) and add them to the Request obbject.
2. ``Zend\Mvc\View\Console\CreateViewModelListener`` / priority: -80 / method called: ``createViewModelFromArray`` => if the controller action returned an associative array, it casts it to a ``ConsoleModel`` object.
3. ``Zend\Mvc\View\Console\CreateViewModelListener`` / priority: -80 / method called: ``createViewModelFromString`` => if the controller action returned a string, it casts it to a ``ConsoleModel`` object.
4. ``Zend\Mvc\View\Console\CreateViewModelListener`` / priority: -80 / method called: ``createViewModelFromNull`` => if the controller action returned null, it casts it to a ``ConsoleModel`` object.
5. ``Zend\Mvc\View\Console\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.


Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

1. ``Zend\Mvc\View\Http\CreateViewModelListener`` / priority: -80 / method called: ``createViewModelFromArray`` => if the controller action returned an associative array, it casts it to a ``ViewModel`` object.
2. ``Zend\Mvc\View\Http\CreateViewModelListener`` / priority: -80 / method called: ``createViewModelFromNull`` => if the controller action returned null, it casts it to a ``ViewModel`` object.
3. ``Zend\Mvc\View\Http\RouteNotFoundStrategy`` / priority: -90 / method called: ``prepareNotFoundViewModel`` => it creates and return a 404 ``ViewModel``.
4. ``Zend\Mvc\View\Http\InjectTemplateListener`` / priority: -90 / method called: ``injectTemplate`` => inject a template into the view model, if none present. Template is derived from the controller found in the route match, and, optionally, the action, if present.
5. ``Zend\Mvc\View\Http\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.


All contexts
""""""""""""

Those listeners are attached for both contexts:

1. ``Zend\Mvc\DispatchListener`` / priority: 1 / method called: ``onDispatch`` / itself triggers: MvcEvent::EVENT_DISPATCH_ERROR (if an exception is raised during dispatch processes) => try to load the matched controller from the service manager (and throws various exceptions if it does not).
2. ``Zend\Mvc\AbstractController`` / priority: 1 / method called: ``onDispatch`` => the ``onDispatch`` method of the ``AbstractController`` is an abstract method. In ``AbstractActionController`` for instance, it simply calls the action method.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\Application`` / in method: ``run`` => it also has a short circuit callback that allows to stop the propagation of the event if an error is raised during the routing.
* ``Zend\Mvc\Controller\AbstractController`` / in method: ``dispatch`` => if a listener returns a ``Response`` object, it stops propagation. Note: every ``AbstractController`` listen to this event and execute the ``onBootstrap`` method when it is triggered.


MvcEvent::DISPATCH_ERROR
------------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

1. ``Zend\Mvc\View\Console\RouteNotFoundStrategy`` / priority: 1 / method called: ``handleRouteNotFoundError`` => detect if an error is a route not found condition. If a "controller not found" or "invalid controller" error type is encountered, sets the response status code to 404.
2. ``Zend\Mvc\View\Console\ExceptionStrategy`` / priority: 1 / method called: ``prepareExceptionViewModel`` => create an exception view model and set the status code to 404
3. ``Zend\Mvc\View\Console\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.


Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

1. ``Zend\Mvc\View\Http\RouteNotFoundStrategy`` / priority: 1 / method called: ``detectNotFoundError`` => detect if an error is a 404 condition. If a "controller not found" or "invalid controller" error type is encountered, sets the response status code to 404.
2. ``Zend\Mvc\View\Http\RouteNotFoundStrategy`` / priority: 1 / method called: ``prepareNotFoundViewModel`` => create and return a 404 view model.
3. ``Zend\Mvc\View\Http\ExceptionStrategy`` / priority: 1 / method called: ``prepareExceptionViewModel`` => create an exception view model and set the status code to 404
4. ``Zend\Mvc\View\Http\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.


All contexts
""""""""""""

Those listeners are attached for both contexts:

1. ``Zend\Mvc\DispatchListener`` / priority: 1 / method called: ``reportMonitorEvent`` => used to monitoring when Zend Server is used.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\DispatchListener`` / in method: ``onDispatch``.
* ``Zend\Mvc\DispatchListener`` / in method: ``marshallControllerNotFoundEvent``.
* ``Zend\Mvc\DispatchListener`` / in method: ``marshallBadControllerEvent``.


MvcEvent::RENDER
----------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

1. ``Zend\Mvc\View\Console\DefaultRenderingStrategy`` / priority: -10000 / method called: ``render`` => render the view.


Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

1. ``Zend\Mvc\View\Http\DefaultRenderingStrategy`` / priority: -10000 / method called: ``render`` => render the view.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\Application`` / method called: ``completeRequest`` => this event is triggered just before the MvcEvent::FINISH event.


MvcEvent::RENDER_ERROR
----------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):


Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

1. ``Zend\Mvc\View\Console\ExceptionStrategy`` / priority: 1 / method called: ``prepareExceptionViewModel`` => create an exception view model and set the status code to 404.
2. ``Zend\Mvc\View\Console\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.

Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

1. ``Zend\Mvc\View\Console\ExceptionStrategy`` / priority: 1 / method called: ``prepareExceptionViewModel`` => create an exception view model and set the status code to 404.
2. ``Zend\Mvc\View\Console\InjectViewModelListener`` / priority: -100 / method called: ``injectViewModel`` => inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the MvcEvent object. It either (a) adds it as a child to the default, composed view model, or (b) replaces it if the result is marked as terminable.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\Mvc\View\Http\DefaultRenderingStrategy`` / in method: ``render`` => this event is triggered if an exception is raised during rendering.


MvcEvent::FINISH
----------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

1. ``Zend\Mvc\SendResponseListener`` / priority: -10000 / method called: ``sendResponse`` => it triggers the ``SendResponseEvent`` in order to prepare the response (see the next page for more information about ``SendResponseEvent``).


Triggerers
^^^^^^^^^^

* ``Zend\Mvc\Application`` / in method: ``run`` => this event is triggered once the MvcEvent::ROUTE event returns a correct ``ResponseInterface``.
* ``Zend\Mvc\Application`` / in method: ``run`` => this event is triggered once the MvcEvent::DISPATCH event returns a correct ``ResponseInterface``.
* ``Zend\Mvc\Application`` / in method: ``completeRequest`` => this event is triggered after the MvcEvent::RENDER (this means that, at this point, the view is already rendered).