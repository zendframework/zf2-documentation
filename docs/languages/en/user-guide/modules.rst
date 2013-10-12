.. _user-guide.modules:

Modules
=======

Zend Framework 2 uses a module system and you organise your main
application-specific code within each module. The Application module provided by
the skeleton is used to provide bootstrapping, error and routing configuration to
the whole application. It is usually used to provide application level
controllers for, say, the home page of an application, but we are not going to
use the default one provided in this tutorial as we want our album list to be
the home page, which will live in our own module.

We are going to put all our code into the Album module which will contain our
controllers, models, forms and views, along with configuration. We’ll also tweak
the Application module as required.

Let’s start with the directories required.

Setting up the Album module
---------------------------

Start by creating a directory called ``Album`` under ``module`` with the following
subdirectories to hold the module’s files:

.. code-block:: text
   :linenos:

    zf2-tutorial/
        /module
            /Album
                /config
                /src
                    /Album
                        /Controller
                        /Form
                        /Model
                /view
                    /album
                        /album

As you can see the ``Album`` module has separate directories for the different
types of files we will have. The PHP files that contain classes within the
``Album`` namespace live in the ``src/Album`` directory so that we can have
multiple namespaces within our module should we require it. The view directory
also has a sub-folder called ``album`` for our module’s view scripts.

In order to load and configure a module, Zend Framework 2 has a
``ModuleManager``. This will look for ``Module.php`` in the root of the module
directory (``module/Album``) and expect to find a class called ``Album\Module``
within it. That is, the classes within a given module will have the namespace of
the module’s name, which is the directory name of the module.

Create ``Module.php`` in the ``Album`` module:
Create a file called ``Module.php`` under ``zf2-tutorial/module/Album``:

.. code-block:: php
   :linenos:

    namespace Album;

    class Module
    {
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\ClassMapAutoloader' => array(
                    __DIR__ . '/autoload_classmap.php',
                ),
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    ),
                ),
            );
        }

        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

The ``ModuleManager`` will call ``getAutoloaderConfig()`` and ``getConfig()``
automatically for us.

Autoloading files
^^^^^^^^^^^^^^^^^

Our ``getAutoloaderConfig()`` method returns an array that is compatible with
ZF2’s ``AutoloaderFactory``. We configure it so that we add a class map file to
the ``ClassMapAutoloader`` and also add this module’s namespace to the
``StandardAutoloader``. The standard autoloader requires a namespace and the
path where to find the files for that namespace. It is PSR-0 compliant and so
classes map directly to files as per the `PSR-0 rules
<https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.

As we are in development, we don’t need to load files via the classmap, so we provide an empty array for the
classmap autoloader. Create a file called ``autoload_classmap.php`` under ``zf2-tutorial/module/Album``:

.. code-block:: php
   :linenos:

    return array();

As this is an empty array, whenever the autoloader looks for a class within the
``Album`` namespace, it will fall back to the to ``StandardAutoloader`` for us.

.. note::

    If you are using Composer, you could instead just create an empty
    ``getAutoloaderConfig() { }`` and add to composer.json:

    .. code-block:: javascript
       :linenos:

        "autoload": {
            "psr-0": { "Album": "module/Album/src/" }
        },

    If you go this way, then you need to run ``php composer.phar update`` to update 
    the composer autoloading files.

Configuration
-------------

Having registered the autoloader, let’s have a quick look at the ``getConfig()``
method in ``Album\Module``.  This method simply loads the
``config/module.config.php`` file.

Create a file called ``module.config.php`` under ``zf2-tutorial/module/Album/config``:

.. code-block:: php
   :linenos:

    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

The config information is passed to the relevant components by the
``ServiceManager``.  We need two initial sections: ``controllers`` and
``view_manager``. The controllers section provides a list of all the controllers
provided by the module. We will need one controller, ``AlbumController``, which
we’ll reference as ``Album\Controller\Album``. The controller key must
be unique across all modules, so we prefix it with our module name.

Within the ``view_manager`` section, we add our view directory to the
``TemplatePathStack`` configuration. This will allow it to find the view scripts for
the ``Album`` module that are stored in our ``view/`` directory.

Informing the application about our new module
----------------------------------------------

We now need to tell the ``ModuleManager`` that this new module exists. This is done
in the application’s ``config/application.config.php`` file which is provided by the
skeleton application. Update this file so that its ``modules`` section contains the
``Album`` module as well, so the file now looks like this:

(Changes required are highlighted using comments.)

.. code-block:: php
   :linenos:
   :emphasize-lines: 4

    return array(
        'modules' => array(
            'Application',
            'Album',                  // <-- Add this line
        ),
        'module_listener_options' => array(
            'config_glob_paths'    => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                './module',
                './vendor',
            ),
        ),
    );

As you can see, we have added our ``Album`` module into the list of modules
after the ``Application`` module.

We have now set up the module ready for putting our custom code into it.
