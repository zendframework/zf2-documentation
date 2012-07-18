.. _zend.module-manager.intro:

Introduction to the Module System
=================================

Zend Framework 2.0 introduces a new and powerful approach to modules. This new module system is designed with flexibility, simplicity, and re-usability in mind. A module may contain just about anything: PHP code, including MVC functionality; library code; view scripts; and/or public assets such as images, CSS, and JavaScript. The possibilities are endless.

.. note::

   The module system in ZF2 has been designed to be useful as a generic and powerful foundation from which developers and other projects can build their own module or plugin systems.

   For a better understanding of the event-driven concepts behind the ZF2 module system, it may be helpful to read the :ref:`EventManager documentation. <zend.event-manager.event-manager>`.

The module system is made up of the following:

- **The Module Autoloader**-``Zend\Loader\ModuleAutoloader`` is a specialized autoloader that is responsible for the locating and loading of modules'``Module`` classes from a variety of sources.

- :ref:`The Module Manager <zend.module-manager.module-manager>`-``Zend\ModuleManager\ModuleManager`` simply takes an array of module names and fires a sequence of events for each one, allowing the behavior of the module system to be defined entirely by the listeners which are attached to the module manager.

- **ModuleManager Listeners**- Event listeners can be attached to the module manager's various events. These listeners can do everything from resolving and loading modules to performing complex initialization tasks and introspection into each returned module object.

.. note::

   The name of a module in a typical Zend Framework 2 application is simply a `PHP namespace`_ and must follow all of the same rules for naming.

The recommended structure of a typical MVC-oriented ZF2 module is as follows:


::

   module_root/
       Module.php
       autoload_classmap.php
       autoload_function.php
       autoload_register.php
       config/
           module.config.php
       public/
           images/
           css/
           js/
       src/
           <module_namespace>/
               <code files>
       tests/
           phpunit.xml
           bootstrap.php
           <module_namespace>/
               <test code files>
       views/
           <dir-named-after-module-namespace>/
               <dir-named-after-a-controller>/
                   <.phtml files>

.. _zend.module-manager.intro.the-autoload-files:

The autoload_*.php Files
------------------------

The three ``autoload_*.php`` files are not required, but recommended. They provide the following:

- ``autoload_classmap.php`` should return an array classmap of class name/filename pairs (with the filenames resolved via the ``__DIR__`` magic constant).

- ``autoload_function.php`` should return a PHP callback that can be passed to ``spl_autoload_register()``. Typically, this callback should utilize the map returned by ``autoload_classmap.php``.

- ``autoload_register.php`` should register a PHP callback (typically that returned by ``autoload_function.php`` with ``spl_autoload_register()``.

The purpose of these three files is to provide reasonable default mechanisms for autoloading the classes contained in the module, thus providing a trivial way to consume the module without requiring ``Zend\ModuleManager`` (e.g., for use outside a ZF2 application).



.. _`PHP namespace`: http://php.net/namespaces
