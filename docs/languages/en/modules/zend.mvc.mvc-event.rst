.. _zend.mvc.mvc-event:

The MvcEvent
============

The MVC layer of Zend Framework 2 incorporates and utilizes a custom ``Zend\EventManager\Event`` implementation -
``Zend\Mvc\MvcEvent``. This event is created during ``Zend\Mvc\Application::bootstrap()`` and is passed directly to
all the events that method triggers. Additionally, if your controllers implement the
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

.. _zend.mvc.mvc-event.order:

Order of events
---------------

The following events are triggered, in the following order:

.. table:: ``MvcEvent`` Events

   +-------------------+-----------------------------------+------------------------------------------------------+
   |Name               |Constant                           |Description                                           |
   +===================+===================================+======================================================+
   |``bootstrap``      |``MvcEvent::EVENT_BOOTSTRAP``      |Bootstrap the application by creating the ViewManager.|
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``route``          |``MvcEvent::EVENT_ROUTE``          |Perform all the route work (matching...).             |
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``dispatch``       |``MvcEvent::EVENT_DISPATCH``       |Dispatch the matched route to a controller/action.    |
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``dispatch.error`` |``MvcEvent::EVENT_DISPATCH_ERROR`` |Event triggered in case of a problem during dispatch  |
   |                   |                                   |process (unknown controller...).                      |
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``render``         |``MvcEvent::EVENT_RENDER``         |Prepare the data and delegate the rendering to the    |
   |                   |                                   |view layer.                                           |
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``render.error``   |``MvcEvent::EVENT_RENDER_ERROR``   |Event triggered in case of a problem during the render|
   |                   |                                   |process (no renderer found...).                       |
   +-------------------+-----------------------------------+------------------------------------------------------+
   |``finish``         |``MvcEvent::EVENT_FINISH``         |Perform any task once everything is done.             |
   +-------------------+-----------------------------------+------------------------------------------------------+

Those events are extensively describe in the following sections.


.. _zend.mvc.mvc-event.bootstrap:

MvcEvent::EVENT_BOOTSTRAP
-------------------------

.. _zend.mvc.mvc-event.bootstrap.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.bootstrap.listeners.table:

.. table:: ``MvcEvent::EVENT_BOOTSTRAP`` Listeners

   +-----------------------------------+---------+----------------+----------------+----------------------------------------------------------------------------+
   |Class                              |Priority |Method Called   |Itself Triggers |Description                                                                 |
   +===================================+=========+================+================+============================================================================+
   |``Zend\Mvc\View\Http\ViewManager`` |10000    |``onBootstrap`` |*none*          |Prepares the view layer (instantiate a ``Zend\Mvc\View\Http\ViewManager``). |
   +-----------------------------------+---------+----------------+----------------+----------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.bootstrap.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.bootstrap.triggerers.table:

.. table:: ``MvcEvent::EVENT_BOOTSTRAP`` Triggerers

   +-------------------------+--------------+
   |Class                    |In Method     |
   +=========================+==============+
   |``Zend\Mvc\Application`` |``bootstrap`` |
   +-------------------------+--------------+

.. _zend.mvc.mvc-event.route:

MvcEvent::EVENT_ROUTE
---------------------

.. _zend.mvc.mvc-event.route.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.route.listeners.table:

.. table:: ``MvcEvent::EVENT_ROUTE`` Listeners

   +---------------------------------+---------+--------------+-----------------------------------+--------------------------------------------------------------------------------------------------+
   |Class                            |Priority |Method Called |Itself Triggers                    |Description                                                                                       |
   +=================================+=========+==============+===================================+==================================================================================================+
   |``Zend\Mvc\ModuleRouteListener`` |1        |``onRoute``   |*none*                             |This listener determines if the module namespace should be prepended to the controller name. This |
   |                                 |         |              |                                   |is the case if the route match contains a parameter key matching the MODULE_NAMESPACE constant.   |
   +---------------------------------+---------+--------------+-----------------------------------+--------------------------------------------------------------------------------------------------+
   |``Zend\Mvc\RouteListener``       |1        |``onRoute``   |``MvcEvent::EVENT_DISPATCH_ERROR`` |Tries to match the request to the router and return a RouteMatch object.                          |
   |                                 |         |              |(if no route is matched)           |                                                                                                  |
   +---------------------------------+---------+--------------+-----------------------------------+--------------------------------------------------------------------------------------------------+

.. _zend.mvc.mvc-event.route.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.route.triggerers.table:

.. table:: ``MvcEvent::EVENT_ROUTE`` Triggerers

   +-------------------------+----------+-------------------------------------------------------------------+
   |Class                    |In Method |Description                                                        |
   +=========================+==========+===================================================================+
   |``Zend\Mvc\Application`` |``run``   |It also has a short circuit callback that allows to stop the       |
   |                         |          |propagation of the event if an error is raised during the routing. |
   +-------------------------+----------+-------------------------------------------------------------------+

.. _zend.mvc.mvc-event.dispatch:

MvcEvent::EVENT_DISPATCH
------------------------

.. _zend.mvc.mvc-event.dispatch.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.dispatch.listeners-console:

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

.. _zend.mvc.mvc-event.dispatch.listeners-console.table:

.. table:: ``MvcEvent::EVENT_DISPATCH`` Listeners for Console context only

   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |Class                                                      |Priority |Method Called                 |Description                                                                    |
   +===========================================================+=========+==============================+===============================================================================+
   |``Zend\Mvc\View\Console\InjectNamedConsoleParamsListener`` |1000     |``injectNamedParams``         |Merge all the params (route matched params and params in the command) and add  |
   |                                                           |         |                              |them to the Request object.                                                    |
   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\CreateViewModelListener``          |-80      |``createViewModelFromArray``  |If the controller action returned an associative array, it casts it to a       |
   |                                                           |         |                              |``ConsoleModel`` object.                                                       |
   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\CreateViewModelListener``          |-80      |``createViewModelFromString`` |If the controller action returned a string, it casts it to a ``ConsoleModel``  |
   |                                                           |         |                              |object.                                                                        |
   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\CreateViewModelListener``          |-80      |``createViewModelFromNull``   |If the controller action returned null, it casts it to a ``ConsoleModel``      |
   |                                                           |         |                              |object.                                                                        |
   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\InjectViewModelListener``          |-100     |``injectViewModel``           |Inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to    |
   |                                                           |         |                              |the MvcEvent object. It either (a) adds it as a child to the default, composed |
   |                                                           |         |                              |view model, or (b) replaces it if the result is marked as terminable.          |
   +-----------------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch.listeners-http:

Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

.. _zend.mvc.mvc-event.dispatch.listeners-http.table:

.. table:: ``MvcEvent::EVENT_DISPATCH`` Listeners for Http context only

   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+
   |Class                                          |Priority |Method Called                |Description                                                                       |
   +===============================================+=========+=============================+==================================================================================+
   |``Zend\Mvc\View\Http\CreateViewModelListener`` |-80      |``createViewModelFromArray`` |If the controller action returned an associative array, it casts it to a          |
   |                                               |         |                             |``ViewModel`` object.                                                             |
   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\CreateViewModelListener`` |-80      |``createViewModelFromNull``  |If the controller action returned null, it casts it to a ``ViewModel`` object.    |
   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\RouteNotFoundStrategy``   |-90      |``prepareNotFoundViewModel`` |It creates and return a 404 ``ViewModel``.                                        |
   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\InjectTemplateListener``  |-90      |``injectTemplate``           |Inject a template into the view model, if none present. Template is derived from  |
   |                                               |         |                             |the controller found in the route match, and, optionally, the action, if present. |
   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\InjectViewModelListener`` |-100     |``injectViewModel``          |Inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the      |
   |                                               |         |                             |MvcEvent object. It either (a) adds it as a child to the default, composed view   |
   |                                               |         |                             |model, or (b) replaces it if the result is marked as terminable.                  |
   +-----------------------------------------------+---------+-----------------------------+----------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch.listeners-all:

All contexts
""""""""""""

Those listeners are attached for both contexts:

.. _zend.mvc.mvc-event.dispatch.listeners-all.table:

.. table:: ``MvcEvent::EVENT_DISPATCH`` Listeners for both contexts

   +--------------------------------+---------+---------------+-----------------------------------------------+----------------------------------------------------------------------------------+
   |Class                           |Priority |Method Called  |Itself Triggers                                |Description                                                                       |
   +================================+=========+===============+===============================================+==================================================================================+
   |``Zend\Mvc\DispatchListener``   |1        |``onDispatch`` |``MvcEvent::EVENT_DISPATCH_ERROR`` (if an      |Try to load the matched controller from the service manager (and throws various   |
   |                                |         |               |exception is raised during dispatch processes) |exceptions if it does not).                                                       |
   +--------------------------------+---------+---------------+-----------------------------------------------+----------------------------------------------------------------------------------+
   |``Zend\Mvc\AbstractController`` |1        |``onDispatch`` |*none*                                         |The ``onDispatch`` method of the ``AbstractController`` is an abstract method. In |
   |                                |         |               |                                               |``AbstractActionController`` for instance, it simply calls the action method.     |
   +--------------------------------+---------+---------------+-----------------------------------------------+----------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.dispatch.triggerers.table:

.. table:: ``MvcEvent::EVENT_DISPATCH`` Triggerers

   +-------------------------------------------+-------------+-------------------------------------------------------------------+
   |Class                                      |In Method    |Description                                                        |
   +===========================================+=============+===================================================================+
   |``Zend\Mvc\Application``                   |``run``      |It also has a short circuit callback that allows to stop the       |
   |                                           |             |propagation of the event if an error is raised during the routing. |
   +-------------------------------------------+-------------+-------------------------------------------------------------------+
   |``Zend\Mvc\Controller\AbstractController`` |``dispatch`` |If a listener returns a ``Response`` object, it stops propagation. |
   |                                           |             |Note: every ``AbstractController`` listen to this event and execute|
   |                                           |             |the ``onBootstrap`` method when it is triggered.                   |
   +-------------------------------------------+-------------+-------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch-error:

MvcEvent::EVENT_DISPATCH_ERROR
------------------------------

.. _zend.mvc.mvc-event.dispatch-error.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.dispatch-error.listeners-console:

Console context only
""""""""""""""""""""

.. _zend.mvc.mvc-event.dispatch-error.listeners-console.table:

.. table:: ``MvcEvent::EVENT_DISPATCH_ERROR`` Listeners for Console context only

   +--------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------------+
   |Class                                             |Priority |Method Called                 |Description                                                                          |
   +==================================================+=========+==============================+=====================================================================================+
   |``Zend\Mvc\View\Console\RouteNotFoundStrategy``   |1        |``handleRouteNotFoundError``  |Detect if an error is a route not found condition. If a "controller not found" or    |
   |                                                  |         |                              |"invalid controller" error type is encountered, sets the response status code to 404.|
   +--------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\ExceptionStrategy``       |1        |``prepareExceptionViewModel`` |Create an exception view model and set the status code to 404.                       |
   +--------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\InjectViewModelListener`` |-100     |``injectViewModel``           |Inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to the      |
   |                                                  |         |                              |MvcEvent object. It either (a) adds it as a child to the default, composed view      |
   |                                                  |         |                              |model, or (b) replaces it if the result is marked as terminable.                     |
   +--------------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch-error.listeners-http:

Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

.. _zend.mvc.mvc-event.dispatch-error.listeners-http.table:

.. table:: ``MvcEvent::EVENT_DISPATCH_ERROR`` Listeners for Http context only

   +-----------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |Class                                          |Priority |Method Called                 |Description                                                                    |
   +===============================================+=========+==============================+===============================================================================+
   |``Zend\Mvc\View\Http\RouteNotFoundStrategy``   |1        |``detectNotFoundError``       |Detect if an error is a 404 condition. If a "controller not found" or "invalid |
   |                                               |         |                              |controller" error type is encountered, sets the response status code to 404.   |
   +-----------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\RouteNotFoundStrategy``   |1        |``prepareNotFoundViewModel``  |Create and return a 404 view model.                                            |
   +-----------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\ExceptionStrategy``       |1        |``prepareExceptionViewModel`` |Create an exception view model and set the status code to 404                  |
   +-----------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Http\InjectViewModelListener`` |-100     |``injectViewModel``           |Inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the   |
   |                                               |         |                              |MvcEvent object. It either (a) adds it as a child to the default, composed     |
   |                                               |         |                              |view model, or (b) replaces it if the result is marked as terminable.          |
   +-----------------------------------------------+---------+------------------------------+-------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.dispatch-error.listeners-all:

All contexts
""""""""""""

Those listeners are attached for both contexts:

.. _zend.mvc.mvc-event.dispatch-error.listeners-all.table:

.. table:: ``MvcEvent::EVENT_DISPATCH_ERROR`` Listeners for both contexts

   +------------------------------+---------+-----------------------+---------------------------------------------+
   |Class                         |Priority |Method Called          |Description                                  |
   +==============================+=========+=======================+=============================================+
   |``Zend\Mvc\DispatchListener`` |1        |``reportMonitorEvent`` |Used to monitoring when Zend Server is used. |
   +------------------------------+---------+-----------------------+---------------------------------------------+


.. _zend.mvc.mvc-event.dispatch-error.triggerers:

Triggerers
^^^^^^^^^^

.. _zend.mvc.mvc-event.dispatch-error.triggerers.table:

.. table:: ``MvcEvent::EVENT_DISPATCH_ERROR`` Triggerers

   +------------------------------+------------------------------------+
   |Class                         |In Method                           |
   +==============================+====================================+
   |``Zend\Mvc\DispatchListener`` |``onDispatch``                      |
   +------------------------------+------------------------------------+
   |``Zend\Mvc\DispatchListener`` |``marshallControllerNotFoundEvent`` |
   +------------------------------+------------------------------------+
   |``Zend\Mvc\DispatchListener`` |``marshallBadControllerEvent``      |
   +------------------------------+------------------------------------+

.. _zend.mvc.mvc-event.render:

MvcEvent::EVENT_RENDER
----------------------

.. _zend.mvc.mvc-event.render.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.render.listeners-console:

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

.. _zend.mvc.mvc-event.render.listeners-console.table:

.. table:: ``MvcEvent::EVENT_RENDER`` Listeners for Console context only

   +---------------------------------------------------+---------+--------------+-----------------+
   |Class                                              |Priority |Method Called |Description      |
   +===================================================+=========+==============+=================+
   |``Zend\Mvc\View\Console\DefaultRenderingStrategy`` |-10000   |``render``    |Render the view. |
   +---------------------------------------------------+---------+--------------+-----------------+


.. _zend.mvc.mvc-event.render.listeners-http:

Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

.. _zend.mvc.mvc-event.render.listeners-http.table:

.. table:: ``MvcEvent::EVENT_RENDER`` Listeners for Http context only

   +------------------------------------------------+---------+--------------+-----------------+
   |Class                                           |Priority |Method Called |Description      |
   +================================================+=========+==============+=================+
   |``Zend\Mvc\View\Http\DefaultRenderingStrategy`` |-10000   |``render``    |Render the view. |
   +------------------------------------------------+---------+--------------+-----------------+


.. _zend.mvc.mvc-event.render.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.render.triggerers.table:

.. table:: ``MvcEvent::EVENT_RENDER`` Triggerers

   +-------------------------+--------------------+----------------------------------------------------------------+
   |Class                    |In Method           |Description                                                     |
   +=========================+====================+================================================================+
   |``Zend\Mvc\Application`` |``completeRequest`` |This event is triggered just before the MvcEvent::FINISH event. |
   +-------------------------+--------------------+----------------------------------------------------------------+


.. _zend.mvc.mvc-event.render-error:

MvcEvent::EVENT_RENDER_ERROR
----------------------------

.. _zend.mvc.mvc-event.render-error.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.render-error.listeners-console:

Console context only
""""""""""""""""""""

Those listeners are only attached in a Console context:

.. _zend.mvc.mvc-event.render-error.listeners-console.table:

.. table:: ``MvcEvent::EVENT_RENDER_ERROR`` Listeners for Console context only

   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+
   |Class                                             |Priority |Method Called                 |Description                                                                     |
   +==================================================+=========+==============================+================================================================================+
   |``Zend\Mvc\View\Console\ExceptionStrategy``       |1        |``prepareExceptionViewModel`` |Create an exception view model and set the status code to 404.                  |
   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\InjectViewModelListener`` |-100     |``injectViewModel``           |Inserts the ``ViewModel`` (in this case, a ``ConsoleModel``) and adds it to the |
   |                                                  |         |                              |MvcEvent object. It either (a) adds it as a child to the default, composed view |
   |                                                  |         |                              |model, or (b) replaces it if the result is marked as terminable.                |
   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.render-error.listeners-http:

Http context only
"""""""""""""""""

Those listeners are only attached in a Http context:

.. _zend.mvc.mvc-event.render-error.listeners-http.table:

.. table:: ``MvcEvent::EVENT_RENDER_ERROR`` Listeners for Http context only

   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+
   |Class                                             |Priority |Method Called                 |Description                                                                     |
   +==================================================+=========+==============================+================================================================================+
   |``Zend\Mvc\View\Console\ExceptionStrategy``       |1        |``prepareExceptionViewModel`` |Create an exception view model and set the status code to 404.                  |
   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+
   |``Zend\Mvc\View\Console\InjectViewModelListener`` |-100     |``injectViewModel``           |Inserts the ``ViewModel`` (in this case, a ``ViewModel``) and adds it to the    |
   |                                                  |         |                              |MvcEvent object. It either (a) adds it as a child to the default, composed view |
   |                                                  |         |                              |model, or (b) replaces it if the result is marked as terminable.                |
   +--------------------------------------------------+---------+------------------------------+--------------------------------------------------------------------------------+


.. _zend.mvc.mvc-event.render-error.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.render-error.triggerers.table:

.. table:: ``MvcEvent::EVENT_RENDER_ERROR`` Triggerers

   +------------------------------------------------+-----------+-------------------------------------------------+
   |Class                                           |In Method  |Description                                      |
   +================================================+===========+=================================================+
   |``Zend\Mvc\View\Http\DefaultRenderingStrategy`` |``render`` |This event is triggered if an exception is raised|
   |                                                |           |during rendering.                                |
   +------------------------------------------------+-----------+-------------------------------------------------+


.. _zend.mvc.mvc-event.finish:

MvcEvent::EVENT_FINISH
----------------------

.. _zend.mvc.mvc-event.finish.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

.. _zend.mvc.mvc-event.finish.listeners.table:

.. table:: ``MvcEvent::EVENT_FINISH`` Listeners

   +----------------------------------+---------+-----------------+-----------------------------------------------------------------------+
   |Class                             |Priority |Method Called    |Description                                                            |
   +==================================+=========+=================+=======================================================================+
   |``Zend\Mvc\SendResponseListener`` |-10000   |``sendResponse`` |It triggers the ``SendResponseEvent`` in order to prepare the response |
   |                                  |         |                 |(see the next page for more information about ``SendResponseEvent``).  |
   +----------------------------------+---------+-----------------+-----------------------------------------------------------------------+


.. _zend.mvc.mvc-event.finish.triggerers:

Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. _zend.mvc.mvc-event.finish.triggerers.table:

.. table:: ``MvcEvent::EVENT_FINISH`` Triggerers

   +-------------------------+--------------------+---------------------------------------------------------------+
   |Class                    |In Method           |Description                                                    |
   +=========================+====================+===============================================================+
   |``Zend\Mvc\Application`` |``run``             |This event is triggered once the MvcEvent::ROUTE event returns |
   |                         |                    |a correct ``ResponseInterface``.                               |
   +-------------------------+--------------------+---------------------------------------------------------------+
   |``Zend\Mvc\Application`` |``run``             |This event is triggered once the MvcEvent::DISPATCH event      |
   |                         |                    |returns a correct ``ResponseInterface``.                       |
   +-------------------------+--------------------+---------------------------------------------------------------+
   |``Zend\Mvc\Application`` |``completeRequest`` |This event is triggered after the MvcEvent::RENDER (this means |
   |                         |                    |that, at this point, the view is already rendered).            |
   +-------------------------+--------------------+---------------------------------------------------------------+
