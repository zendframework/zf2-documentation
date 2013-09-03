.. _zend.view.helpers:

View Helpers
============

.. _zend.view.helpers.introduction:

Introduction
------------

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
----------------

Zend Framework comes with an initial set of helper classes. In particular, there are helpers for creating
route-based *URL*\ s and *HTML* lists, as well as declaring variables. Additionally, there are a rich set of
helpers for providing values for, and rendering, the various HTML *<head>* tags, such as ``HeadTitle``,
``HeadLink``, and ``HeadScript``. The currently shipped helpers include:

- :ref:`BasePath <zend.view.helpers.initial.basepath>`
- :ref:`Cycle <zend.view.helpers.initial.cycle>`
- :ref:`Doctype <zend.view.helpers.initial.doctype>`
- :ref:`FlashMessenger <zend.view.helpers.initial.flashmessenger>`
- :ref:`HeadLink <zend.view.helpers.initial.headlink>`
- :ref:`HeadMeta <zend.view.helpers.initial.headmeta>`
- :ref:`HeadScript <zend.view.helpers.initial.headscript>`
- :ref:`HeadStyle <zend.view.helpers.initial.headstyle>`
- :ref:`HeadTitle <zend.view.helpers.initial.headtitle>`
- :ref:`HtmlList <zend.view.helpers.initial.htmllist>`
- :ref:`HTML Object Plugins <zend.view.helpers.initial.object>`
- :ref:`Identity <zend.view.helpers.initial.identity>`
- :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`
- :ref:`JSON <zend.view.helpers.initial.json>`
- :ref:`Partial <zend.view.helpers.initial.partial>`
- :ref:`Placeholder <zend.view.helpers.initial.placeholder>`
- :ref:`Url <zend.view.helpers.initial.url>`

.. note::

   View helpers related to **Internationalization** are documented in the
   :ref:`I18n View Helpers <zend.i18n.view.helpers>` chapter.

.. note::

   View helpers related to **form** are documented in the
   :ref:`Form View Helpers <zend.form.view.helpers>` chapter.

.. note::

   View helpers related to **navigation** are documented in the
   :ref:`Navigation View Helpers <zend.navigation.view.helpers>` chapter.

.. note::

   View helpers related to **paginator** are documented in the
   :ref:`Paginator Usage <zend.paginator.rendering>` chapter.

.. note::

   For documentation on writing **custom view helpers** see the
   :ref:`Advanced usage <zend.view.helpers.advanced-usage>` chapter.
