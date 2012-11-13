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
================

Zend Framework comes with an initial set of helper classes. In particular, there are helpers for creating
route-based *URL*\ s and *HTML* lists, as well as declaring variables. Additionally, there are a rich set of
helpers for providing values for, and rendering, the various HTML *<head>* tags, such as ``HeadTitle``,
``HeadLink``, and ``HeadScript``. The currently shipped helpers include:

- ``url($name, $urlParams, $routeOptions, $reuseMatchedParams)``: Creates a *URL* string based on a named route. 
  ``$urlParams`` should be an associative array of key/value pairs used by the particular route.

.. code-block:: php
   :linenos:

   // In a configuration array (e.g. returned by some module's module.config.php)
   'router' => array(
       'routes' => array(
           'auth' => array(
               'type' => 'segment',
               'options' => array(
                   'route' => '/auth[/:action][/:id]',
                   'constraints' => array(
                       'action' => '[a-zA-Z][a-zA-Z0-9_-]*'
                   ),
                   'defaults' => array(
                       'controller' => 'solon\solon',
                       'action' => 'index'
                   )
               )
           )
       )
   ),

   // In a view template:
   <a href="<?php echo $this->url('auth', array('action' => 'logout', 'id' => $id)); ?>">Logout</a>
   

- ``htmlList($items, $ordered, $attribs, $escape)``: generates unordered and ordered lists based on the ``$items``
  passed to it. If ``$items`` is a multidimensional array, a nested list will be built. If the ``$escape`` flag is
  ``TRUE`` (default), individual items will be escaped using the view objects registered escaping mechanisms; pass
  a ``FALSE`` value if you want to allow markup in your lists.

.. include:: zend.view.helpers.base-path.rst
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