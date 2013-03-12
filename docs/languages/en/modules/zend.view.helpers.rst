.. _zend.view.helpers:

View Helpers
============

In your view scripts, often it is necessary to perform certain complex functions over and over: e.g., formatting a
date, generating form elements, or displaying action links. You can use helper, or plugin, classes to perform these
behaviors for you.

A helper is simply a class that implements ``Zend\View\Helper\HelperInterface`` and it simply defines two methods,
``setView()``, which accepts a ``Zend\View\Renderer\RendererInterface`` instance/implementation, and ``getView()``,
used to retrieve that instance. ``Zend\View\Renderer\PhpRenderer`` composes a *plugin manager*, allowing you to
retrieve helpers, and also provides some method overloading capabilities that allow proxying method calls to helpers.

As an example, let's say we have a helper class named ``MyModule\View\Helper\LowerCase``, which we register in our
plugin manager with the name "lowercase". We can retrieve it in one of the following ways:

.. code-block:: php
   :linenos:

   // $view is a PhpRenderer instance

   // Via the plugin manager:
   $pluginManager = $view->getHelperPluginManager();
   $helper        = $pluginManager->get('lowercase');

   // Retrieve the helper instance, via the method "plugin",
   // which proxies to the plugin manager:
   $helper = $view->plugin('lowercase');

   // If the helper does not define __invoke(), the following also retrieves it:
   $helper = $view->lowercase();

   // If the helper DOES define __invoke, you can call the helper
   // as if it is a method:
   $filtered = $view->lowercase('some value');

The last two examples demonstrate how the ``PhpRenderer`` uses method overloading to retrieve and/or invoke helpers
directly, offering a convenience API for end users.

A large number of helpers are provided in the standard distribution of Zend Framework. You can also register
helpers by adding them to the *plugin manager*.

.. _zend.view.helpers.initial:

Included Helpers
================

Zend Framework comes with an initial set of helper classes. In particular, there are helpers for creating
route-based *URL*\ s and *HTML* lists, as well as declaring variables. Additionally, there are a rich set of
helpers for providing values for, and rendering, the various HTML *<head>* tags, such as ``HeadTitle``,
``HeadLink``, and ``HeadScript``. The currently shipped helpers include:

.. include:: zend.view.helpers.url.rst
.. include:: zend.view.helpers.html-list.rst
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