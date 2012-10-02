.. _zend.mvc.controller-plugins:

Controller Plugins
==================

When using the ``AbstractActionController`` or ``AbstractRestfulController``, or if you compose the
``Zend\Mvc\Controller\PluginBroker`` in your custom controllers, you have access to a number of pre-built plugins.
Additionally, you can register your own custom plugins with the broker, just as you would with
``Zend\Loader\PluginBroker``.

The built-in plugins are:

- ``Zend\Mvc\Controller\Plugin\FlashMessenger``

- ``Zend\Mvc\Controller\Plugin\Forward``

- ``Zend\Mvc\Controller\Plugin\PostRedirectGet``

- ``Zend\Mvc\Controller\Plugin\Redirect``

- ``Zend\Mvc\Controller\Plugin\Url``

If your controller implements the ``Zend\Loader\Pluggable`` interface, you can access these using their shortname
via the ``plugin()`` method:

.. code-block:: php
   :linenos:

   $plugin = $this->plugin('url');

For an extra layer of convenience, both ``AbstractActionController`` and ``AbstractRestfulController`` have
``__call()`` implementations that allow you to retrieve plugins via method calls:

.. code-block:: php
   :linenos:

   $plugin = $this->url();

.. _zend.mvc.controller-plugins.flashmessenger:

The FlashMessenger
------------------

The ``FlashMessenger`` is a plugin designed to create and retrieve self-expiring, session-based messages. It
exposes a number of methods:

- ``setSessionManager()`` allows you to specify an alternate session manager, if desired.

- ``getSessionManager()`` allows you to retrieve the session manager registered.

- ``getContainer()`` returns the ``Zend\Session\Container`` instance in which the flash messages are stored.

- ``setNamespace()`` allows you to specify a specific namespace in the container in which to store or from which to
  retrieve flash messages.

- ``getNamespace()`` retrieves the name of the flash message namespace.

- ``addMessage()`` allows you to add a message to the current namespace of the session container.

- ``hasMessages()`` lets you determine if there are any flash messages from the current namespace in the session
  container.

- ``getMessages()`` retrieves the flash messages from the current namespace of the session container.

- ``clearMessages()`` clears all flash messages in current namespace of the session container.

- ``hasCurrentMessages()`` indicates whether any messages were added during the current request.

- ``getCurrentMessages()`` retrieves any messages added during the current request.

- ``clearCurrentMessages()`` removes any messages added during the current request.

Additionally, the ``FlashMessenger`` implements both ``IteratorAggregate`` and ``Countable``, allowing you to
iterate over and count the flash messages in the current namespace within the session container.

.. _zend.mvc.controller-plugins.examples:

Examples
^^^^^^^^

.. code-block:: php
   :linenos:

   public function processAction()
   {
       // ... do some work ...
       $this->flashMessenger()->addMessage('You are now logged in.');
       return $this->redirect()->toRoute('user-success');
   }

   public function successAction()
   {
       $return = array('success' => true);
       $flashMessenger = $this->flashMessenger();
       if ($flashMessenger->hasMessages()) {
           $return['messages'] = $flashMessenger->getMessages();
       }
       return $return;
   }

.. _zend.mvc.controller-plugins.forward:

The Forward Plugin
------------------

Occasionally, you may want to dispatch additional controllers from within the matched controller -- for instance,
you might use this approach to build up "widgetized" content. The ``Forward`` plugin helps enable this.

For the ``Forward`` plugin to work, the controller calling it must be ``ServiceLocatorAware``; otherwise, the
plugin will be unable to retrieve a configured and injected instance of the requested controller.

The plugin exposes a single method, ``dispatch()``, which takes two arguments:

- ``$name``, the name of the controller to invoke. This may be either the fully qualified class name, or an alias
  defined and recognized by the ``ServiceManager`` instance attached to the invoking controller.

- ``$params`` is an optional array of parameters with which to see a ``RouteMatch`` object for purposes of this
  specific request.

``Forward`` returns the results of dispatching the requested controller; it is up to the developer to determine
what, if anything, to do with those results. One recommendation is to aggregate them in any return value from the
invoking controller.

As an example:

.. code-block:: php
   :linenos:

   $foo = $this->forward()->dispatch('foo', array('action' => 'process'));
   return array(
       'somekey' => $somevalue,
       'foo'     => $foo,
   );

.. _zend.mvc.controller-plugins.postredirectget:

The Post/Redirect/Get Plugin
----------------------------

When a user sends a POST request (e.g. after submitting a form), their browser will try to protect them from
sending the POST again, breaking the back button, causing browser warnings and pop-ups, and sometimes reposting
the form. Instead, when receiving a POST, we should store the data in a session container and redirect the user
to a GET request.

This plugin can be invoked with two arguments:

- ``$redirect``, a string containing the redirect location which can either be a named route or a URL, based on
  the contents of the second parameter.
- ``$redirectToUrl``, a boolean that when set to TRUE, causes the first parameter to be treated as a URL instead
  of a route name (this is required when redirecting to a URL instead of a route). This argument defaults to false.

.. code-block:: php
   :linenos:

   // Pass in the route/url you want to redirect to after the POST
   $prg = $this->prg('/user/register', true);

   if ($prg instanceof \Zend\Http\PhpEnvironment\Response) {
       // returned a response to redirect us
       return $prg;
   } elseif ($prg === false) {
       // this wasn't a POST request, but there were no params in the flash messenger
       // probably this is the first time the form was loaded
       return array('form' => $myForm);
   }

   // $prg is an array containing the POST params from the previous request
   $form->setData($prg);

   // ... your form processing code here

.. _zend.mvc.controller-plugins.redirect:

The Redirect Plugin
-------------------

Redirections are quite common operations within applications. If done manually, you will need to do the following
steps:

- Assemble a url using the router

- Create and inject a "Location" header into the ``Response`` object, pointing to the assembled URL

- Set the status code of the ``Response`` object to one of the 3xx HTTP statuses.

The ``Redirect`` plugin does this work for you. It offers two methods:

- ``toRoute($route, array $params = array(), array $options = array())``: Redirects to a named route, using the
  provided ``$params`` and ``$options`` to assembled the URL.

- ``toUrl($url)``: Simply redirects to the given URL.

In each case, the ``Response`` object is returned. If you return this immediately, you can effectively
short-circuit execution of the request.

One note: this plugin requires that the controller invoking it implements ``InjectApplicationEvent``, and thus has
an ``MvcEvent`` composed, as it retrieves the router from the event object.

As an example:

.. code-block:: php
   :linenos:

   return $this->redirect()->toRoute('login-success');

.. _zend.mvc.controller-plugins.url:

The Url Plugin
--------------

Often you may want to generate URLs from route definitions within your controllers -- in order to seed the view,
generate headers, etc. While the ``MvcEvent`` object composes the router, doing so manually would require this
workflow:

.. code-block:: php
   :linenos:

   $router = $this->getEvent()->getRouter();
   $url    = $router->assemble($params, array('name' => 'route-name'));

The ``Url`` helper makes this slightly more convenient:

.. code-block:: php
   :linenos:

   $url = $this->url()->fromRoute('route-name', $params);

The ``fromRoute()`` method is the only public method defined, and has the following signature:

.. code-block:: php
   :linenos:

   public function fromRoute($route, array $params = array(), array $options = array())

One note: this plugin requires that the controller invoking it implements ``InjectApplicationEvent``, and thus has
an ``MvcEvent`` composed, as it retrieves the router from the event object.


