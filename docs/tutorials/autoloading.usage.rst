
Basic Autoloader Usage
======================

Now that we have an understanding of what autoloading is and the goals and design of Zend Framework's autoloading solution, let's look at how to use ``Zend_Loader_Autoloader`` .

In the simplest case, you would simply require the class, and then instantiate it. Since ``Zend_Loader_Autoloader`` is a singleton (due to the fact that the *SPL* autoloader is a single resource), we use ``getInstance()`` to retrieve an instance.

.. code-block:: php
    :linenos:
    
    require_once 'Zend/Loader/Autoloader.php';
    Zend_Loader_Autoloader::getInstance();
    

By default, this will allow loading any classes with the class namespace prefixes of "Zend_" or "ZendX_", as long as they are on your ``include_path`` .

What happens if you have other namespace prefixes you wish to use? The best, and simplest, way is to call the ``registerNamespace()`` method on the instance. You can pass a single namespace prefix, or an array of them:

.. code-block:: php
    :linenos:
    
    require_once 'Zend/Loader/Autoloader.php';
    $loader = Zend_Loader_Autoloader::getInstance();
    $loader->registerNamespace('Foo_');
    $loader->registerNamespace(array('Foo_', 'Bar_'));
    

Alternately, you can tell ``Zend_Loader_Autoloader`` to act as a "fallback" autoloader. This means that it will try to resolve any class regardless of namespace prefix.

.. code-block:: php
    :linenos:
    
    $loader->setFallbackAutoloader(true);
    

.. note::
    **Namespace Prefixes vs PHP Namespaces**

    At the time this is written, *PHP* 5.3 has been released. With that version, *PHP* now has official namespace support.

    However, Zend Framework predates *PHP* 5.3, and thus namespaces. Within Zend Framework, when we refer to "namespaces", we are referring to a practice whereby classes are prefixed with a vender "namespace". As an example, all Zend Framework class names are prefixed with "Zend_" -- that is our vendor "namespace".

    Zend Framework plans to offer native *PHP* namespace support to the autoloader in future revisions, and its own library will utilize namespaces starting with version 2.0.0.

If you have a custom autoloader you wish to use with Zend Framework -- perhaps an autoloader from a third-party library you are also using -- you can manage it with ``Zend_Loader_Autoloader`` 's ``pushAutoloader()`` and ``unshiftAutoloader()`` methods. These methods will append or prepend, respectively, autoloaders to a chain that is called prior to executing Zend Framework's internal autoloading mechanism. This approach offers the following benefits:

Autoloaders managed this way may be any valid *PHP* callback.

.. code-block:: php
    :linenos:
    
    // Append function 'my_autoloader' to the stack,
    // to manage classes with the prefix 'My_':
    $loader->pushAutoloader('my_autoloader', 'My_');
    
    // Prepend static method Foo_Loader::autoload() to the stack,
    // to manage classes with the prefix 'Foo_':
    $loader->unshiftAutoloader(array('Foo_Loader', 'autoload'), 'Foo_');
    


