.. _performance.view:

View Rendering
==============

When using Zend Framework's *MVC* layer, chances are you will be using ``Zend_View``. ``Zend_View`` is performs
well compared to other view or templating engines; since view scripts are written in *PHP*, you do not incur the
overhead of compiling custom markup to *PHP*, nor do you need to worry that the compiled *PHP* is not optimized.
However, ``Zend_View`` presents its own issues: extension is done via overloading (view helpers), and a number of
view helpers, while carrying out key functionality do so with a performance cost.

.. _performance.view.pluginloader:

How can I speed up resolution of view helpers?
----------------------------------------------

Most ``Zend_View``"methods" are actually provided via overloading to the helper system. This provides important
flexibility to ``Zend_View``; instead of needing to extend ``Zend_View`` and provide all the helper methods you may
utilize in your application, you can define your helper methods in separate classes and consume them at will as if
they were direct methods of ``Zend_View``. This keeps the view object itself relatively thin, and ensures that
objects are created only when needed.

Internally, ``Zend_View`` uses the :ref:`PluginLoader <zend.loader.pluginloader>` to look up helper classes. This
means that for each helper you call, ``Zend_View`` needs to pass the helper name to the PluginLoader, which then
needs to determine the class name, load the class file if necessary, and then return the class name so it may be
instantiated. Subsequent uses of the helper are much faster, as ``Zend_View`` keeps an internal registry of loaded
helpers, but if you use many helpers, the calls add up.

The question, then, is: how can you speed up helper resolution?

.. _performance.view.pluginloader.cache:

Use the PluginLoader include file cache
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The simplest, cheapest solution is the same as for :ref:`general PluginLoader performance
<performance.classloading.pluginloader>`: :ref:`use the PluginLoader include file cache
<zend.loader.pluginloader.performance.example>`. Anecdotal evidence has shown this technique to provide a 25-30%
performance gain on systems without an opcode cache, and a 40-65% gain on systems with an opcode cache.

.. _performance.view.pluginloader.extend:

Extend Zend_View to provide often used helper methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Another solution for those seeking to tune performance even further is to extend ``Zend_View`` to manually add the
helper methods they most use in their application. Such helper methods may simply manually instantiate the
appropriate helper class and proxy to it, or stuff the full helper implementation into the method.

.. code-block:: php
   :linenos:

   class My_View extends Zend_View
   {
       /**
        * @var array Registry of helper classes used
        */
       protected $_localHelperObjects = array();

       /**
        * Proxy to url view helper
        *
        * @param  array $urlOptions Options passed to the assemble method
        *                           of the Route object.
        * @param  mixed $name The name of a Route to use. If null it will
        *                     use the current Route
        * @param  bool $reset Whether or not to reset the route defaults
        *                     with those provided
        * @return string Url for the link href attribute.
        */
       public function url(array $urlOptions = array(), $name = null,
           $reset = false, $encode = true
       ) {
           if (!array_key_exists('url', $this->_localHelperObjects)) {
               $this->_localHelperObjects['url'] = new Zend\View\Helper\Url();
               $this->_localHelperObjects['url']->setView($this);
           }
           $helper = $this->_localHelperObjects['url'];
           return $helper->url($urlOptions, $name, $reset, $encode);
       }

       /**
        * Echo a message
        *
        * Direct implementation.
        *
        * @param  string $string
        * @return string
        */
       public function message($string)
       {
           return "<h1>" . $this->escape($message) . "</h1>\n";
       }
   }

Either way, this technique will substantially reduce the overhead of the helper system by avoiding calls to the
PluginLoader entirely, and either benefiting from autoloading or bypassing it altogether.

.. _performance.view.partial:

How can I speed up view partials?
---------------------------------

Those who use partials heavily and who profile their applications will often immediately notice that the
``partial()`` view helper incurs a lot of overhead, due to the need to clone the view object. Is it possible to
speed this up?

.. _performance.view.partial.render:

Use partial() only when really necessary
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``partial()`` view helper accepts three arguments:

- ``$name``: the name of the view script to render

- ``$module``: the name of the module in which the view script resides; or, if no third argument is provided and
  this is an array or object, it will be the ``$model`` argument.

- ``$model``: an array or object to pass to the partial representing the clean data to assign to the view.

The power and use of ``partial()`` come from the second and third arguments. The ``$module`` argument allows
``partial()`` to temporarily add a script path for the given module so that the partial view script will resolve to
that module; the ``$model`` argument allows you to explicitly pass variables for use with the partial view. If
you're not passing either argument, **use render() instead**!

Basically, unless you are actually passing variables to the partial and need the clean variable scope, or rendering
a view script from another *MVC* module, there is no reason to incur the overhead of ``partial()``; instead, use
``Zend_View``'s built-in ``render()`` method to render the view script.

.. _performance.view.action:

How can I speed up calls to the action() view helper?
-----------------------------------------------------

Version 1.5.0 introduced the ``action()`` view helper, which allows you to dispatch an *MVC* action and capture its
rendered content. This provides an important step towards the *DRY* principle, and promotes code reuse. However, as
those who profile their applications will quickly realize, it, too, is an expensive operation. Internally, the
``action()`` view helper needs to clone new request and response objects, invoke the dispatcher, invoke the
requested controller and action, etc.

How can you speed it up?

.. _performance.view.action.actionstack:

Use the ActionStack when possible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Introduced at the same time as the ``action()`` view helper, the :ref:`ActionStack
<zend.controller.actionhelpers.actionstack>` consists of an action helper and a front controller plugin. Together,
they allow you to push additional actions to invoke during the dispatch cycle onto a stack. If you are calling
``action()`` from your layout view scripts, you may want to instead use the ActionStack, and render your views to
discrete response segments. As an example, you could write a ``dispatchLoopStartup()`` plugin like the following to
add a login form box to each page:

.. code-block:: php
   :linenos:

   class LoginPlugin extends Zend\Controller\Plugin\Abstract
   {
       protected $_stack;

       public function dispatchLoopStartup(
           Zend\Controller\Request\Abstract $request
       ) {
           $stack = $this->getStack();
           $loginRequest = new Zend\Controller\Request\Simple();
           $loginRequest->setControllerName('user')
                        ->setActionName('index')
                        ->setParam('responseSegment', 'login');
           $stack->pushStack($loginRequest);
       }

       public function getStack()
       {
           if (null === $this->_stack) {
               $front = Zend\Controller\Front::getInstance();
               if (!$front->hasPlugin('Zend\Controller\Plugin\ActionStack')) {
                   $stack = new Zend\Controller\Plugin\ActionStack();
                   $front->registerPlugin($stack);
               } else {
                   $stack = $front->getPlugin('ActionStack')
               }
               $this->_stack = $stack;
           }
           return $this->_stack;
       }
   }

The ``UserController::indexAction()`` method might then use the ``$responseSegment`` parameter to indicate which
response segment to render to. In the layout script, you would then simply render that response segment:

.. code-block:: php
   :linenos:

   <?php $this->layout()->login ?>

While the ActionStack still requires a dispatch cycle, this is still cheaper than the ``action()`` view helper as
it does not need to clone objects and reset internal state. Additionally, it ensures that all pre and post dispatch
plugins are invoked, which may be of particular concern if you are using front controller plugins for handling
*ACL*'s to particular actions.

.. _performance.view.action.model:

Favor helpers that query the model over action()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In most cases, using ``action()`` is simply overkill. If you have most business logic nested in your models and are
simply querying the model and passing the results to a view script, it will typically be faster and cleaner to
simply write a view helper that pulls the model, queries it, and does something with that information.

As an example, consider the following controller action and view script:

.. code-block:: php
   :linenos:

   class BugController extends Zend\Controller\Action
   {
       public function listAction()
       {
           $model = new Bug();
           $this->view->bugs = $model->fetchActive();
       }
   }

   // bug/list.phtml:
   echo "<ul>\n";
   foreach ($this->bugs as $bug) {
       printf("<li><b>%s</b>: %s</li>\n",
           $this->escape($bug->id),
           $this->escape($bug->summary)
       );
   }
   echo "</ul>\n";

Using ``action()``, you would then invoke it with the following:

.. code-block:: php
   :linenos:

   <?php $this->action('list', 'bug') ?>

This could be refactored to a view helper that looks like the following:

.. code-block:: php
   :linenos:

   class My_View_Helper_BugList extends Zend\View\Helper\Abstract
   {
       public function bugList()
       {
           $model = new Bug();
           $html  = "<ul>\n";
           foreach ($model->fetchActive() as $bug) {
               $html .= sprintf(
                   "<li><b>%s</b>: %s</li>\n",
                   $this->view->escape($bug->id),
                   $this->view->escape($bug->summary)
               );
           }
           $html .= "</ul>\n";
           return $html;
       }
   }

You would then invoke the helper as follows:

.. code-block:: php
   :linenos:

   <?php $this->bugList() ?>

This has two benefits: it no longer incurs the overhead of the ``action()`` view helper, and also presents a more
semantically understandable *API*.


