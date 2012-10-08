.. _zend.loader.spl-autoloader:

The SplAutoloader Interface
===========================

.. _zend.loader.spl-autoloader.intro:

Overview
--------

While any valid PHP callback may be registered with ``spl_autoload_register()``, Zend Framework autoloaders often
provide more flexibility by being stateful and allowing configuration. To provide a common interface, Zend
Framework provides the ``SplAutoloader`` interface.

Objects implementing this interface provide a standard mechanism for configuration, a method that may be invoked to
attempt to load a class, and a method for registering with the SPL autoloading mechanism.

.. _zend.loader.spl-autoloader.quick-start:

Quick Start
-----------

To create your own autoloading mechanism, simply create a class implementing the ``SplAutoloader`` interface (you
may review the methods defined in the :ref:`Methods section <zend.loader.spl-autoloader.methods>`). As a simple
example, consider the following autoloader, which will look for a class file named after the class within a list of
registered directories.

.. code-block:: php
   :linenos:

   namespace Custom;

   use Zend\Loader\SplAutoloader;

   class ModifiedIncludePathAutoloader implements SplAutoloader
   {
       protected $paths = array();

       public function __construct($options = null)
       {
           if (null !== $options) {
               $this->setOptions($options);
           }
       }

       public function setOptions($options)
       {
           if (!is_array($options) && !($options instanceof \Traversable)) {
               throw new \InvalidArgumentException();
           }

           foreach ($options as $path) {
               if (!in_array($path, $this->paths)) {
                   $this->paths[] = $path;
               }
           }
           return $this;
       }

       public function autoload($classname)
       {
           $filename = $classname . '.php';
           foreach ($this->paths as $path) {
               $test = $path . DIRECTORY_SEPARATOR . $filename;
               if (file_exists($test)) {
                   return include($test);
               }
           }
           return false;
       }

       public function register()
       {
           spl_autoload_register(array($this, 'autoload'));
       }
   }

To use this ``ModifiedIncludePathAutoloader`` from the previous example:

.. code-block:: php
   :linenos:

   $options = array(
      '/path/one',
      '/path/two'
   );
   $autoloader = new Custom\ModifiedIncludePathAutoloader($options);
   $autoloader->register();

.. _zend.loader.spl-autoloader.options:

Configuration Options
---------------------

This component defines no configuration options, as it is an interface.

.. _zend.loader.spl-autoloader.methods:

Available Methods
-----------------

.. _zend.loader.spl-autoloader.methods.constructor:

\__construct
   Initialize and configure an autoloader
   ``__construct($options = null)``

   **Constructor**
   Autoloader constructors should optionally receive configuration options. Typically, if received, these will be
   passed to the ``setOptions()`` method to process.


.. _zend.loader.spl-autoloader.methods.set-options:

setOptions
   Configure the autoloader state
   ``setOptions($options)``

   **setOptions()**
   Used to configure the autoloader. Typically, it should expect either an array or a ``Traversable`` object,
   though validation of the options is left to implementation. Additionally, it is recommended that the method
   return the autoloader instance in order to implement a fluent interface.


.. _zend.loader.spl-autoloader.methods.autoload:

autoload
   Attempt to resolve a class name to the file defining it
   ``autoload($classname)``

   **autoload()**
   This method should be used to resolve a class name to the file defining it. When a positive match is found,
   return the class name; otherwise, return a boolean false.


.. _zend.loader.spl-autoloader.methods.register:

register
   Register the autoloader with the SPL autoloader
   ``register()``

   **register()**
   Should be used to register the autoloader instance with ``spl_autoload_register()``. Invariably, the method
   should look like the following:

   .. code-block:: php
      :linenos:

      public function register()
      {
          spl_autoload_register(array($this, 'autoload'));
      }


.. _zend.loader.spl-autoloader.examples:

Examples
--------

Please see the :ref:`Quick Start <zend.loader.spl-autoloader.quick-start>` for a complete example.


