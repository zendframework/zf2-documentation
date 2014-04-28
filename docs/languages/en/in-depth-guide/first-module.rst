.. _in-depth-guide.first-module:

Introducing our first "Album" Module
====================================

Now that we know about the basics of the Zend Framework 2 Skeleton Application, let's continue and create our very own
module. We will create a module named "Album". This module will display a list of database entries that represent a
single music album. Each album will receive a couple of properties like ``id``, ``artist`` and ``title``. We will create
forms to enter new albums into our database and to edit existing albums. Furthermore we will do so by using
best-practices throughout the whole QuickStart.


Writing a new Module
====================

Let's start by creating a new folder under the ``/module`` directory called ``Album``.

To be recognized as a module by the :ref:`ModuleManager <zend.module-manager-intro>`
all we need to do is create a PHP-Class named ``Module`` under our module's namespace, which is ``Album``. Create the
file ``/module/Album/Module.php``

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Album/Module.php
    namespace Album;

    class Module
    {
    }

We now have a module that can be detected by Zend Frameworks :ref:`ModuleManager <zend.module-manager-intro>`.
Let's add this module to our application. Although our module doesn't do anything yet, just having the ``Module.php``
class allows it to be loaded by Zend Framework's :ref:`ModuleManager <zend.module-manager-intro>`
To do this, add an entry for ``Album`` to the modules array inside the main application config file at
``/config/application.config.php``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6

    <?php
    // Filename: /config/application.config.php
    return array(
        'modules' => array(
            'Application',
            'Album'         //@todo Highlight this line at .rts
        ),

        // ...
    );

If you refresh your application you should see no change at all (but also no errors).

At this point it's worth taking a step back to discuss what modules are for. In short, a module is an encapsulated
set of features for your application. A module might add features to the application that you can see, like our
Album module; or it might provide background functionality for other modules in the application to use,  such as
interacting with a third party API.

Organizing your code into modules makes it easier for you to reuse functionality in other application, or to use
modules written by the community.

Configuring the Module
======================

The next thing we're going to do is add a route to our application so that our module can be accessed through the
URL ``localhost:8080/album``. We do this by adding router configuration to our module, but first we need to let the
``ModuleManager`` know that our module has configuration that it needs to load.

This is done by adding a ``getConfig()`` function to the ``Module`` class that returns the configuration. (This function is
defined in the ``ConfigProviderInterface`` although actually implementing this interface in the module class is optional.)
This function should return either an ``array`` or a ``Traversable`` object. Continue by editing your
``/module/Album/Module.php``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,7,9-12

    <?php
    // Filename: /module/Album/Module.php
    namespace Album;

    use Zend\ModuleManager\Feature\ConfigProviderInterface;

    class Module implements ConfigProviderInterface
    {
        public function getConfig()
        {
            return array();
        }
    }

With this our Module is now able to be configured. Configuration files can become quite big though and keeping
everything inside the ``getConfig()`` function won't be optimal. To help keep our project organized we're going to put
our array configuration in a separate file. Go ahead and create this file at ``/module/Album/config/module.config.php``:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Album/config/module.config.php
    return array();

Now we will rewrite the ``getConfig()`` function to include this newly created file instead of directly returning the
array.

.. code-block:: php
   :linenos:
   :emphasize-lines: 11

    <?php
    // Filename: /module/Album/src/Album/Module.php
    namespace Album;

    use Zend\ModuleManager\Feature\ConfigProviderInterface;

    class Module implements ConfigProviderInterface
    {
        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

Try reloading your application once and you'll see that everything remains as it is and no error occurs. This is so
because we haven't actually added any configuration to our module yet. Let's finally get started and add the new route
to our module:

.. code-block:: php
   :linenos:
   :emphasize-lines: 9,11,15,18-19

    <?php
    // Filename: /module/Album/config/module.config.php
    return array(
        // This lines opens the configuration for the RouteManager
        'router' => array(
            // Open configuration for all possible routes
            'routes' => array(
                // Create a new route called "album-default"
                'album' => array(
                    // Define the routes type to be "Zend\Mvc\Router\Http\Literal", which is basically just a string
                    'type' => 'literal',
                    // Configure the route itself
                    'options' => array(
                        // Listen to "/album" as uri
                        'route'    => '/album',
                        // Define default controller and action to be called when this route is matched
                        'defaults' => array(
                            'controller' => 'Album\Controller\List',
                            'action'     => 'index',
                        )
                    )
                )
            )
        )
    );

We've now created a route called ``album`` that listens to the URL ``localhost:8080/album``. Whenever someone accesses this
route, the ``indexAction()`` function of the class ``Album\Controller\List`` will be executed. However, this controller
does not exist yet, so if you reload the page you will see this error message:

.. code-block:: html
   :linenos:

    A 404 error occurred
    Page not found.
    The requested controller could not be mapped to an existing controller class.

    Controller:
    Album\Controller\List(resolves to invalid controller class or alias: Album\Controller\List)
    No Exception available

We now need to tell our module where to find this controller named ``Album\Controller\List``. To achieve this we have
to add this key to the ``controllers`` configuration key inside your ``/module/Album/config/module.config.php``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Album/config/module.config.php
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\List' => 'Album\Controller\ListController'
            )
        ),
        'router' => array( /** Route Configuration */ )
    );

This configuration defines ``Album\Controller\List`` as an alias for the ``ListController`` under the namespace
``Album\Controller``. Reloading the page should then give you:

.. code-block:: html
   :linenos:

    ( ! ) Fatal error: Class 'Album\Controller\ListController' not found in {libPath}/Zend/ServiceManager/AbstractPluginManager.php on line {lineNumber}

This error tells us that the application knows what class to load, but not where to find it. To fix this, we need to
configure `autoloading <http://www.php.net/manual/en/language.oop5.autoload.php>`_ for our Module. Autoloading is a
process to allow PHP to automatically load classes on demand. For our Module we set this up by adding a
``getAutoloaderConfig()`` function to our Module class. (This function is defined in the `AutoloaderProviderInterface <https://github.com/zendframework/zf2/:current_branch/library/Zend/ModuleManager/Feature/AutoloaderProviderInterface.php>`_,
although the presence of the function is enough, actually implementing the interface is optional.)

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,9

    <?php
    // Filename: /module/Album/Module.php
    namespace Album;

    use Zend\ModuleManager\Feature\AutoloaderProviderInterface;
    use Zend\ModuleManager\Feature\ConfigProviderInterface;

    class Module implements
        AutoloaderProviderInterface,
        ConfigProviderInterface
    {
        /**
         * Return an array for passing to Zend\Loader\AutoloaderFactory.
         *
         * @return array
         */
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        // Autoload all classes from namespace 'Album' from '/module/Album/src/Album'
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    )
                )
            );
        }

        /**
         * Returns configuration to merge with application configuration
         *
         * @return array|\Traversable
         */
        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

Now this looks like a lot of change but don't be afraid. We've added an ``getAutoloaderConfig()`` function which provides
configuration for the ``Zend\Loader\StandardAutoloader``. This configuration tells the application that classes
in ``__NAMESPACE__`` (``Album``) can be found inside ``__DIR__ . '/src/' . __NAMESPACE__`` (``/module/Album/src/Album``).

The ``Zend\Loader\StandardAutoloader`` uses a PHP community driven standard called `PSR-0` <https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.
Amongst other things, this standard defines a way for PHP to map class names to the file system. So with this
configured, the application knows that our ``Album\Controller\ListController`` class should exist at
``/module/Album/src/Album/Controller/ListController.php``.

If you refresh the browser now you'll see the same error, as even though we've configured the autoloader, we still need
to create the controller class. Let's create this file now:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Album/src/Album/Controller/ListController.php
    namespace Album\Controller;

    class ListController
    {
    }

Reloading the page now will finally result into a new screen. The new error message looks like this:

.. code-block:: html
   :linenos:

    A 404 error occurred
    Page not found.
    The requested controller was not dispatchable.

    Controller:
    Album\Controller\List(resolves to invalid controller class or alias: Album\Controller\List)

    Additional information:
    Zend\Mvc\Exception\InvalidControllerException

    File:
    {libraryPath}/Zend/Mvc/Controller/ControllerManager.php:{lineNumber}
    Message:
    Controller of type Album\Controller\ListController is invalid; must implement Zend\Stdlib\DispatchableInterface

This happens because our controller must implement `Zend\Stdlib\DispatchableInterface <https://github.com/zendframework/zf2/:current_branch/library/Zend/Stdlib/DispatchableInterface.php>`_ in order to be 'dispatched'
(or run) by ZendFramework's MVC layer. ZendFramework provides some base controller implementation of it with
`AbstractActionController <https://github.com/zendframework/zf2/:current_branch/library/Zend/Mvc/Controller/AbstractActionController.php>`_,
which we are going to use. Let's modify our controller now:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,7

    <?php
    // Filename: /module/Album/src/Album/Controller/ListController.php
    namespace Album\Controller;

    use Zend\Mvc\Controller\AbstractActionController;

    class ListController extends AbstractActionController
    {
    }

It's now time for another refresh of the site. You should now see a new error message:

.. code-block:: html
   :linenos:

    An error occurred
    An error occurred during execution; please try again later.

    Additional information:
    Zend\View\Exception\RuntimeException

    File:
    {libraryPath}/library/Zend/View/Renderer/PhpRenderer.php:{lineNumber}
    Message:
    Zend\View\Renderer\PhpRenderer::render: Unable to render template "album/list/index"; resolver could not resolve to a file

Now the application tells you that a view template-file can not be rendered. Given our current progress this is more
than natural, because we have yet to actually write this view-file ourselves. The standard path would be
``/module/Album/view/album/list/index.phtml``. Create this file and add some dummy content to it:

.. code-block:: html
   :linenos:

    <!-- Filename: /module/Album/view/album/list/index.phtml -->
    <h1>Album\ListController::indexAction()</h1>

Before we continue let us quickly take a look at where we placed this file. First off, view files are not to be found
under the ``/src`` directory because they are not source files. They are views so ``/view`` is much more logical. The
succeeding path however deserves some explanation but it's very simple. First we have the lowercased namespace. Following
by the lowercased controller name without the appendix 'controller' and lastly comes the name of the action that we are
accessing, again without the appendix 'action'. All in all it looks like this: ``/view/{namespace}/{controller}/{action}.phtml``.
This has become a community standard but can potentionally be changed by you at any time.

However creating this file alone is not enough and this brings as to the final topic of this part of the QuickStart. We
need to let the application know where to look for view files. We do this within our modules configuration file ``module.config.php``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Album/config/module.config.php
    return array(
        'view_manager' => array(
            'template_path_stack' => array(
                __DIR__ . '/../view',
            ),
        ),
        'controllers' => array( /** Controller Configuration */),
        'router'      => array( /** Route Configuration */ )
    );

The above configuration tells the application that the folder ``/module/Album/view`` has view files in it that match the
above described default scheme. It is important to note that with this you can not only ship view files for your module
but you can also overwrite view files from other modules.

Reload your site now. Finally we are at a point where we see something different than an error display. Congratulations,
not only have you created a simple "Hello World" kinda module, you also learned about many error messages and their
sources. If we didn't exhaust you too much, continue with our QuickStart and let's create a module that actually does
something.
