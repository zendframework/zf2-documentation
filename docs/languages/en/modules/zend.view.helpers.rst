.. _zend.view.helpers:

View Helpers
============

In your view scripts, often it is necessary to perform certain complex functions over and over: e.g., formatting a
date, generating form elements, or displaying action links. You can use helper, or plugin, classes to perform these
behaviors for you.

A helper is simply a class that implements the interface ``Zend\View\Helper``. ``Helper`` simply defines two
methods, ``setView()``, which accepts a ``Zend\View\Renderer`` instance/implementation, and ``getView()``, used to
retrieve that instance. ``Zend\View\PhpRenderer`` composes a :ref:`plugin broker <zend.loader.plugin-broker>`,
allowing you to retrieve helpers, and also provides some method overloading capabilities that allow proxying method
calls to helpers.

As an example, let's say we have a helper class named ``My\Helper\LowerCase``, which we map in our plugin broker to
the name "lowercase". We can retrieve or invoke it in one of the following ways:

.. code-block:: php
   :linenos:

   // $view is a PhpRenderer instance

   // Via the plugin broker:
   $broker = $view->getBroker();
   $helper = $broker->load('lowercase');

   // Retrieve the helper instance, via the method "plugin",
   // which proxies to the plugin broker:
   $helper = $view->plugin('lowercase');

   // If the helper does not define __invoke(), the following also retrieves it:
   $helper = $view->lowercase();

   // If the helper DOES define __invoke, you can call the helper
   // as if it is a method:
   $filtered = $view->lowercase('some value');

The last two examples demonstrate how the ``PhpRenderer`` uses method overloading to retrieve and/or invoke helpers
directly, offering a convenience API for end users.

A large number of helpers are provided in the standard distribution of Zend Framework. You can also register
helpers by adding them to the :ref:`plugin broker <zend.loader.plugin-broker>`, or the plugin locator the broker
composes. Please refer to the :ref:`plugin broker documentation <zend.loader.plugin-broker>` for details.

.. _zend.view.helpers.initial:

Included Helpers
----------------

Zend Framework comes with an initial set of helper classes. In particular, there are helpers for creating
route-based *URL*\ s and *HTML* lists, as well as declaring variables. Additionally, there are a rich set of
helpers for providing values for, and rendering, the various HTML *<head>* tags, such as ``HeadTitle``,
``HeadLink``, and ``HeadScript``. The currently shipped helpers include:

- ``url($name, $urlOptions, $reset)``: Creates a *URL* string based on a named route. ``$urlOptions`` should be an
  associative array of key/value pairs used by the particular route.

- ``htmlList($items, $ordered, $attribs, $escape)``: generates unordered and ordered lists based on the ``$items``
  passed to it. If ``$items`` is a multidimensional array, a nested list will be built. If the ``$escape`` flag is
  ``TRUE`` (default), individual items will be escaped using the view objects registered escaping mechanisms; pass
  a ``FALSE`` value if you want to allow markup in your lists.

.. include:: zend.view.helpers.base-url.rst
.. include:: zend.view.helpers.cycle.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.navigation.rst
.. _zend.view.helpers.register:

Registering Helpers
-------------------

``Zend\View\Renderer\PhpRenderer`` composes a :ref:`plugin broker <zend.loader.plugin-broker>` for managing
helpers, specifically an instance of ``Zend\View\HelperBroker``, which extends the base plugin broker in order to
ensure we have valid helpers available. The ``HelperBroker`` by default uses ``Zend\View\HelperLoader`` as its
helper locator. The ``HelperLoader`` is a map-based loader, which means that you will simply map the helper/plugin
name by which you wish to refer to it to the actual class name of the helper/plugin.

Programmatically, this is done as follows:

.. code-block:: php
   :linenos:

   // $view is an instance of PhpRenderer
   $broker = $view->getBroker();
   $loader = $broker->getClassLoader();

   // Register singly:
   $loader->registerPlugin('lowercase', 'My\Helper\LowerCase');

   // Register several:
   $loader->registerPlugins(array(
       'lowercase' => 'My\Helper\LowerCase',
       'uppercase' => 'My\Helper\UpperCase',
   ));

Within an MVC application, you will typically simply pass a map of plugins to the class via your configuration.

.. code-block:: php
   :linenos:

   // From within a configuration file
   return array(
       'di' => array('instance' => array(
           'Zend\View\HelperLoader' => array('parameters' => array(
               'map' => array(
                   'lowercase' => 'My\Helper\LowerCase',
                   'uppercase' => 'My\Helper\UpperCase',
               ),
           )),
       )),
   );

The above can be done in each module that needs to register helpers with the ``PhpRenderer``; however, be aware
that another module can register helpers with the same name, so order of modules can impact which helper class will
actually be registered!

.. _zend.view.helpers.custom:

Writing Custom Helpers
----------------------

Writing custom helpers is easy. We recommend extending ``Zend\View\Helper\AbstractHelper``, but at the minimum, you
need only implement the ``Zend\View\Helper`` interface:

.. code-block:: php
   :linenos:

   namespace Zend\View;

   interface Helper
   {
       /**
        * Set the View object
        *
        * @param  Renderer $view
        * @return Helper
        */
       public function setView(Renderer $view);

       /**
        * Get the View object
        *
        * @return Renderer
        */
       public function getView();
   }

If you want your helper to be capable of being invoked as if it were a method call of the ``PhpRenderer``, you
should also implement an ``__invoke()`` method within your helper.

As previously noted, we recommend extending ``Zend\View\Helper\AbstractHelper``, as it implements the methods
defined in ``Helper``, giving you a headstart in your development.

Once you have defined your helper class, make sure you can autoload it, and then :ref:`register it with the plugin
broker <zend.view.helpers.register>`.

Here is an example helper, which we're titling "SpecialPurpose"

.. code-block:: php
   :linenos:

   namespace My\View\Helper;

   use Zend\View\Helper\AbstractHelper;

   class SpecialPurpose extends AbstractHelper
   {
       protected $count = 0;

       public function __invoke()
       {
           $this->count++;
           $output = sprintf("I have seen 'The Jerk' %d time(s).", $this->count);
           return htmlspecialchars($output, ENT_QUOTES, 'UTF-8');
       }
   }

Then assume that when we :ref:`register it with the plugin broker <zend.view.helpers.register>`, we map it to the
string "specialpurpose".

Within a view script, you can call the ``SpecialPurpose`` helper as many times as you like; it will be instantiated
once, and then it persists for the life of that ``PhpRenderer`` instance.

.. code-block:: php
   :linenos:

   // remember, in a view script, $this refers to the Zend_View instance.
   echo $this->specialPurpose();
   echo $this->specialPurpose();
   echo $this->specialPurpose();

The output would look something like this:

.. code-block:: php
   :linenos:

   I have seen 'The Jerk' 1 time(s).
   I have seen 'The Jerk' 2 time(s).
   I have seen 'The Jerk' 3 time(s).

Sometimes you will need access to the calling ``PhpRenderer`` object -- for instance, if you need to use the
registered encoding, or want to render another view script as part of your helper. This is why we define the
``setView()`` and ``getView()`` methods. As an example, we could rewrite the ``SpecialPurpose`` helper as follows
to take advantage of the ``EscapeHtml`` helper:

.. code-block:: php
   :linenos:

   namespace My\View\Helper;

   use Zend\View\Helper\AbstractHelper;

   class SpecialPurpose extends AbstractHelper
   {
       protected $count = 0;

       public function __invoke()
       {
           $this->count++;
           $output  = sprintf("I have seen 'The Jerk' %d time(s).", $this->count);
           $escaper = $this->getView()->plugin('escapehtml');
           return $escaper($output);
       }
   }

.. _zend.view.helpers.registering-concrete:

Registering Concrete Helpers
----------------------------

Sometimes it is convenient to instantiate a view helper, and then register it with the renderer. This can be done
by injecting it directly into the plugin broker.

.. code-block:: php
   :linenos:

   // $view is a PhpRenderer instance

   $helper = new My_Helper_Foo();
   // ...do some configuration or dependency injection...

   $view->getBroker()->register('foo', $helper);

When registered, the plugin broker will inject the ``PhpRenderer`` instance into the helper.


