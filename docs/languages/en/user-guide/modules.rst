.. _user-guide.modules:

#######
Modules
#######

Zend Framework 2 uses a module system and you organise your main
application-speciﬁc code within each module. The Application module provided by
the skeleton is used to provide bootstrapping, error and routing conﬁguration to
the whole application. It is usually used to provide application level
controllers for, say, the home page of an application, but we are not going to
use the default one provided in this tutorial as we want our album list to be
the home page, which will live in our own module.

We are going to put all our code into the Album module which will contain our
controllers, models, forms and views, along with conﬁguration. We’ll also tweak
the Application module as required.

Let’s start with the directories required.

Setting up the Album module
---------------------------

Start by creating a directory called ``Album`` under with the following
subdirectories to hold the module’s ﬁles:

.. code-block:: text

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
types of ﬁles we will have. The PHP ﬁles that contain classes within the
``Album`` namespace live in the ``src/Album`` directory so that we can have
multiple namespaces within our module should we require it. The view directory
also has a sub-folder called ``album`` for our module’s view scripts.

In order to load and conﬁgure a module, Zend Framework 2 has a
``ModuleManager``. This will look for ``Module.php`` in the root of the module
directory (``module/Album``) and expect to ﬁnd a class called ``Album\Module``
within it. That is, the classes within a given module will have the namespace of
the module’s name, which is the directory name of the module.

Create ``Module.php`` in the ``Album`` module:

.. code-block:: php

    // module/Album/Module.php
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

Autoloading ﬁles
^^^^^^^^^^^^^^^^

Our ``getAutoloaderConfig()`` method returns an array that is compatible with
ZF2’s ``AutoloaderFactory``. We conﬁgure it so that we add a class map ﬁle to
the ``ClassmapAutoloader`` and also add this module’s namespace to the
``StandardAutoloader``. The standard autoloader requires a namespace and the
path where to ﬁnd the ﬁles for that namespace. It is PSR-0 compliant and so
classes map directly to ﬁles as per the `PSR-0 rules
<https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.

As we are in development, we don’t need to load ﬁles via the classmap, so we provide an empty array for the
classmap autoloader. Create ``autoload_classmap.php`` with these contents:

.. code-block:: php

    // module/Album/autoload_classmap.php:
    return array();

As this is an empty array, whenever the autoloader looks for a class within the
``Album`` namespace, it will fall back to the to ``StandardAutoloader`` for us.

.. note::

    Note that as we are using Composer, as an alternative, you could not implement
    ``getAutoloaderConfig()`` and instead add ``"Application":
    "module/Application/src"`` to the ``psr-0`` key in ``composer.json``. If you go
    this way, then you need to run ``php composer.phar update`` to update the
    composer autoloading ﬁles.

Configuration
-------------

Having registered the autoloader, let’s have a quick look at the ``getConfig()``
method in ``Album\Module``.  This method simply loads the
``config/module.config.php`` ﬁle.

Create the following conﬁguration ﬁle for the ``Album`` module:

.. code-block:: php

    // module/Album/conﬁg/module.config.php:
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

The conﬁg information is passed to the relevant components by the
``ServiceManager``.  We need two initial sections: ``controllers`` and
``view_manager``. The controllers section provides a list of all the controllers
provided by the module. We will need one controller, ``AlbumController``, which
we’ll reference as ``Album\Controller\Album``. The controller key must
be unique across all modules, so we preﬁx it with our module name.

Within the ``view_manager`` section, we add our view directory to the
``TemplatePathStack`` conﬁguration. This will allow it to ﬁnd the view scripts for
the ``Album`` module that are stored in our ``view/`` directory.

Informing the application about our new module
----------------------------------------------

We now need to tell the ``ModuleManager`` that this new module exists. This is done
in the application’s ``config/application.config.php`` file which is provided by the
skeleton application. Update this file so that its ``modules`` section contains the
``Album`` module as well, so the file now looks like this:

(Changes required are highlighted using comments.)

.. code-block:: php
    :emphasize-lines: 5

    // conﬁg/application.conﬁg.php:
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
