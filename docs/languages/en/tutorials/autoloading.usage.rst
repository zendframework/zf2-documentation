.. _learning.autoloading.usage:

Basic Autoloader Usage
======================

Now that we have an understanding of what autoloading is and the goals and design of Zend Framework's autoloading
solution, let's look at how to use ``Zend\Loader\Autoloader``.

In the simplest case, you would simply require the class, and then instantiate it. Since ``Zend\Loader\Autoloader``
is a singleton (due to the fact that the *SPL* autoloader is a single resource), we use ``getInstance()`` to
retrieve an instance.

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

By default, this will allow loading any classes with the class namespace prefixes of "Zend\_" or "ZendX\_", as long
as they are on your ``include_path``.

What happens if you have other namespace prefixes you wish to use? The best, and simplest, way is to call the
``registerNamespace()`` method on the instance. You can pass a single namespace prefix, or an array of them:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   $loader = Zend\Loader\Autoloader::getInstance();
   $loader->registerNamespace('Foo_');
   $loader->registerNamespace(array('Foo_', 'Bar_'));

Alternately, you can tell ``Zend\Loader\Autoloader`` to act as a "fallback" autoloader. This means that it will try
to resolve any class regardless of namespace prefix.

.. code-block:: php
   :linenos:

   $loader->setFallbackAutoloader(true);

.. warning::

   **Do not use as a fallback autoloader**

   While it's tempting to use ``Zend\Loader\Autoloader`` as a fallback autoloader, we do not recommend the
   practice.

   Internally, ``Zend\Loader\Autoloader`` uses ``Zend\Loader\Loader::loadClass()`` to load classes. That method uses
   ``include()`` to attempt to load the given class file. ``include()`` will return a boolean ``FALSE`` if not
   successful -- but also issues a *PHP* warning. This latter fact can lead to some issues:

   - If ``display_errors`` is enabled, the warning will be included in output.

   - Depending on the ``error_reporting`` level you have chosen, it could also clutter your logs.

   You can suppress the error messages (the ``Zend\Loader\Autoloader`` documentation details this), but note that
   the suppression is only relevant when ``display_errors`` is enabled; the error log will always display the
   messages. For these reasons, we recommend always configuring the namespace prefixes the autoloader should be
   aware of

.. note::

   **Namespace Prefixes vs PHP Namespaces**

   At the time this is written, *PHP* 5.3 has been released. With that version, *PHP* now has official namespace
   support.

   However, Zend Framework predates *PHP* 5.3, and thus namespaces. Within Zend Framework, when we refer to
   "namespaces", we are referring to a practice whereby classes are prefixed with a vender "namespace". As an
   example, all Zend Framework class names are prefixed with "Zend\_" -- that is our vendor "namespace".

   Zend Framework plans to offer native *PHP* namespace support to the autoloader in future revisions, and its own
   library will utilize namespaces starting with version 2.0.0.

If you have a custom autoloader you wish to use with Zend Framework -- perhaps an autoloader from a third-party
library you are also using -- you can manage it with ``Zend\Loader\Autoloader``'s ``pushAutoloader()`` and
``unshiftAutoloader()`` methods. These methods will append or prepend, respectively, autoloaders to a chain that is
called prior to executing Zend Framework's internal autoloading mechanism. This approach offers the following
benefits:

- Each method takes an optional second argument, a class namespace prefix. This can be used to indicate that the
  given autoloader should only be used when looking up classes with that given class prefix. If the class being
  resolved does not have that prefix, the autoloader will be skipped -- which can lead to performance improvements.

- If you need to manipulate ``spl_autoload()``'s registry, any autoloaders that are callbacks pointing to instance
  methods can pose issues, as ``spl_autoload_functions()`` does not return the exact same callbacks.
  ``Zend\Loader\Autoloader`` has no such limitation.

Autoloaders managed this way may be any valid *PHP* callback.

.. code-block:: php
   :linenos:

   // Append function 'my_autoloader' to the stack,
   // to manage classes with the prefix 'My_':
   $loader->pushAutoloader('my_autoloader', 'My_');

   // Prepend static method Foo_Loader::autoload() to the stack,
   // to manage classes with the prefix 'Foo_':
   $loader->unshiftAutoloader(array('Foo_Loader', 'autoload'), 'Foo_');


