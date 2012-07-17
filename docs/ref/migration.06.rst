
.. _migration.06:

Zend Framework 0.6
==================

When upgrading from a previous release to Zend Framework 0.6 or higher you should note the following migration notes.


.. _migration.06.zend.controller:

Zend_Controller
---------------

The most basic usage of the *MVC* components has not changed; you can still do each of the following:

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/path/to/controllers');

.. code-block:: php
   :linenos:

   /* -- create a router -- */
   $router = new Zend_Controller_RewriteRouter();
   $router->addRoute('user',
                     'user/:username',
                     array('controller' => 'user', 'action' => 'info')
   );

   /* -- set it in a controller -- */
   $ctrl = Zend_Controller_Front::getInstance();
   $ctrl->setRouter($router);

   /* -- set controller directory and dispatch -- */
   $ctrl->setControllerDirectory('/path/to/controllers');
   $ctrl->dispatch();

We encourage use of the Response object to aggregate content and headers. This will allow for more flexible output format switching (for instance, *JSON* or *XML* instead of *XHTML*) in your applications. By default, ``dispatch()`` will render the response, sending both headers and rendering any content. You may also have the front controller return the response using ``returnResponse()``, and then render the response using your own logic. A future version of the front controller may enforce use of the response object via output buffering.

There are many additional features that extend the existing *API*, and these are noted in the documentation.

The main changes you will need to be aware of will be found when subclassing the various components. Key amongst these are:

- ``Zend_Controller_Front::dispatch()`` by default traps exceptions in the response object, and does not render them, in order to prevent sensitive system information from being rendered. You can override this in several ways:

  - Set ``throwExceptions()`` in the front controller:

    .. code-block:: php
       :linenos:

       $front->throwExceptions(true);


  - Set ``renderExceptions()`` in the response object:

    .. code-block:: php
       :linenos:

       $response->renderExceptions(true);
       $front->setResponse($response);
       $front->dispatch();

       // or:
       $front->returnResponse(true);
       $response = $front->dispatch();
       $response->renderExceptions(true);
       echo $response;



- ``Zend_Controller_Dispatcher_Interface::dispatch()`` now accepts and returns a :ref:`The Request Object <zend.controller.request>` instead of a dispatcher token.

- ``Zend_Controller_Router_Interface::route()`` now accepts and returns a :ref:`The Request Object <zend.controller.request>` instead of a dispatcher token.

- ``Zend_Controller_Action`` changes include:

  - The constructor now accepts exactly three arguments, ``Zend_Controller_Request_Abstract`` ``$request``, ``Zend_Controller_Response_Abstract`` ``$response``, and ``Array`` ``$params`` (optional). ``Zend_Controller_Action::__construct()`` uses these to set the request, response, and invokeArgs properties of the object, and if overriding the constructor, you should do so as well. Better yet, use the ``init()`` method to do any instance configuration, as this method is called as the final action of the constructor.

  - ``run()`` is no longer defined as final, but is also no longer used by the front controller; its sole purpose is for using the class as a page controller. It now takes two optional arguments, a ``Zend_Controller_Request_Abstract`` ``$request`` and a ``Zend_Controller_Response_Abstract`` ``$response``.

  - ``indexAction()`` no longer needs to be defined, but is encouraged as the default action. This allows using the RewriteRouter and action controllers to specify different default action methods.

  - ``__call()`` should be overridden to handle any undefined actions automatically.

  - ``_redirect()`` now takes an optional second argument, the *HTTP* code to return with the redirect, and an optional third argument, ``$prependBase``, that can indicate that the base *URL* registered with the request object should be prepended to the url specified.

  - The ``$_action`` property is no longer set. This property was a ``Zend_Controller_Dispatcher_Token``, which no longer exists in the current incarnation. The sole purpose of the token was to provide information about the requested controller, action, and *URL* parameters. This information is now available in the request object, and can be accessed as follows:

    .. code-block:: php
       :linenos:

       // Retrieve the requested controller name
       // Access used to be via: $this->_action->getControllerName().
       // The example below uses getRequest(), though you may also directly
       // access the $_request property; using getRequest() is recommended as
       // a parent class may override access to the request object.
       $controller = $this->getRequest()->getControllerName();

       // Retrieve the requested action name
       // Access used to be via: $this->_action->getActionName().
       $action = $this->getRequest()->getActionName();

       // Retrieve the request parameters
       // This hasn't changed; the _getParams() and _getParam() methods simply
       // proxy to the request object now.
       $params = $this->_getParams();
       // request 'foo' parameter, using 'default' as default value if not found
       $foo = $this->_getParam('foo', 'default');


  - ``noRouteAction()`` has been removed. The appropriate way to handle non-existent action methods should you wish to route them to a default action is using ``__call()``:

    .. code-block:: php
       :linenos:

       public function __call($method, $args)
       {
           // If an unmatched 'Action' method was requested, pass on to the
           // default action method:
           if ('Action' == substr($method, -6)) {
               return $this->defaultAction();
           }

           throw new Zend_Controller_Exception('Invalid method called');
       }



- ``Zend_Controller_RewriteRouter::setRewriteBase()`` has been removed. Use ``Zend_Controller_Front::setBaseUrl()`` instead (or ``Zend_Controller_Request_Http::setBaseUrl()``, if using that request class).

- ``Zend_Controller_Plugin_Interface`` was replaced by ``Zend_Controller_Plugin_Abstract``. All methods now accept and return a :ref:`The Request Object <zend.controller.request>` instead of a dispatcher token.


