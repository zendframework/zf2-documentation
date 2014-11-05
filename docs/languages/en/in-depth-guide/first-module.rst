.. _in-depth-guide.first-module:

Introducing our first "Blog" Module
===================================

Now that we know about the basics of the Zend Framework 2 Skeleton Application, let's continue and create our very own
module. We will create a module named "Blog". This module will display a list of database entries that represent a
single blog post. Each post will have three properties: ``id``, ``text`` and ``title``. We will create
forms to enter new posts into our database and to edit existing posts. Furthermore we will do so by using
best-practices throughout the whole QuickStart.


Writing a new Module
====================

Let's start by creating a new folder under the ``/module`` directory called ``Blog``.

To be recognized as a module by the :ref:`ModuleManager <zend.module-manager-intro>`
all we need to do is create a PHP class named ``Module`` under our module's namespace, which is ``Blog``. Create the
file ``/module/Blog/Module.php``

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/Module.php
    namespace Blog;

    class Module
    {
    }

We now have a module that can be detected by ZF2s :ref:`ModuleManager <zend.module-manager-intro>`.
Let's add this module to our application. Although our module doesn't do anything yet, just having the ``Module.php``
class allows it to be loaded by ZF2s :ref:`ModuleManager <zend.module-manager-intro>`.
To do this, add an entry for ``Blog`` to the modules array inside the main application config file at
``/config/application.config.php``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6

    <?php
    // Filename: /config/application.config.php
    return array(
        'modules' => array(
            'Application',
            'Blog'
        ),

        // ...
    );

If you refresh your application you should see no change at all (but also no errors).

At this point it's worth taking a step back to discuss what modules are for. In short, a module is an encapsulated
set of features for your application. A module might add features to the application that you can see, like our
Blog module; or it might provide background functionality for other modules in the application to use, such as
interacting with a third party API.

Organizing your code into modules makes it easier for you to reuse functionality in other application, or to use
modules written by the community.

Configuring the Module
======================

The next thing we're going to do is add a route to our application so that our module can be accessed through the
URL ``localhost:8080/blog``. We do this by adding router configuration to our module, but first we need to let the
``ModuleManager`` know that our module has configuration that it needs to load.

This is done by adding a ``getConfig()`` function to the ``Module`` class that returns the configuration. (This function is
defined in the ``ConfigProviderInterface`` although actually implementing this interface in the module class is optional.)
This function should return either an ``array`` or a ``Traversable`` object. Continue by editing your
``/module/Blog/Module.php``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,7,9-12

    <?php
    // Filename: /module/Blog/Module.php
    namespace Blog;

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
our array configuration in a separate file. Go ahead and create this file at ``/module/Blog/config/module.config.php``:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array();

Now we will rewrite the ``getConfig()`` function to include this newly created file instead of directly returning the
array.

.. code-block:: php
   :linenos:
   :emphasize-lines: 11

    <?php
    // Filename: /module/Blog/Module.php
    namespace Blog;

    use Zend\ModuleManager\Feature\ConfigProviderInterface;

    class Module implements ConfigProviderInterface
    {
        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

Reload your application and you'll see that everything remains as it was. Next we add the new route to our
configuration file:

.. code-block:: php
   :linenos:
   :emphasize-lines: 9,11,15,18-19

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        // This lines opens the configuration for the RouteManager
        'router' => array(
            // Open configuration for all possible routes
            'routes' => array(
                // Define a new route called "post"
                'post' => array(
                    // Define the routes type to be "Zend\Mvc\Router\Http\Literal", which is basically just a string
                    'type' => 'literal',
                    // Configure the route itself
                    'options' => array(
                        // Listen to "/blog" as uri
                        'route'    => '/blog',
                        // Define default controller and action to be called when this route is matched
                        'defaults' => array(
                            'controller' => 'Blog\Controller\List',
                            'action'     => 'index',
                        )
                    )
                )
            )
        )
    );

We've now created a route called ``blog`` that listens to the URL ``localhost:8080/blog``. Whenever someone accesses this
route, the ``indexAction()`` function of the class ``Blog\Controller\List`` will be executed. However, this controller
does not exist yet, so if you reload the page you will see this error message:

.. code-block:: html
   :linenos:

    A 404 error occurred
    Page not found.
    The requested controller could not be mapped to an existing controller class.

    Controller:
    Blog\Controller\List(resolves to invalid controller class or alias: Blog\Controller\List)
    No Exception available

We now need to tell our module where to find this controller named ``Blog\Controller\List``. To achieve this we have
to add this key to the ``controllers`` configuration key inside your ``/module/Blog/config/module.config.php``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'controllers' => array(
            'invokables' => array(
                'Blog\Controller\List' => 'Blog\Controller\ListController'
            )
        ),
        'router' => array( /** Route Configuration */ )
    );

This configuration defines ``Blog\Controller\List`` as an alias for the ``ListController`` under the namespace
``Blog\Controller``. Reloading the page should then give you:

.. code-block:: html
   :linenos:

    ( ! ) Fatal error: Class 'Blog\Controller\ListController' not found in {libPath}/Zend/ServiceManager/AbstractPluginManager.php on line {lineNumber}

This error tells us that the application knows what class to load, but not where to find it. To fix this, we need to
configure `autoloading <http://www.php.net/manual/en/language.oop5.autoload.php>`_ for our Module. Autoloading is a
process to allow PHP to automatically load classes on demand. For our Module we set this up by adding a
``getAutoloaderConfig()`` function to our Module class. (This function is defined in the `AutoloaderProviderInterface <https://github.com/zendframework/zf2/:current_branch/library/Zend/ModuleManager/Feature/AutoloaderProviderInterface.php>`_,
although the presence of the function is enough, actually implementing the interface is optional.)

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,9

    <?php
    // Filename: /module/Blog/Module.php
    namespace Blog;

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
                        // Autoload all classes from namespace 'Blog' from '/module/Blog/src/Blog'
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
in ``__NAMESPACE__`` (``Blog``) can be found inside ``__DIR__ . '/src/' . __NAMESPACE__`` (``/module/Blog/src/Blog``).

The ``Zend\Loader\StandardAutoloader`` uses a PHP community driven standard called `PSR-0` <https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.
Amongst other things, this standard defines a way for PHP to map class names to the file system. So with this
configured, the application knows that our ``Blog\Controller\ListController`` class should exist at
``/module/Blog/src/Blog/Controller/ListController.php``.

If you refresh the browser now you'll see the same error, as even though we've configured the autoloader, we still need
to create the controller class. Let's create this file now:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Controller/ListController.php
    namespace Blog\Controller;

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
    Blog\Controller\List(resolves to invalid controller class or alias: Blog\Controller\List)

    Additional information:
    Zend\Mvc\Exception\InvalidControllerException

    File:
    {libraryPath}/Zend/Mvc/Controller/ControllerManager.php:{lineNumber}
    Message:
    Controller of type Blog\Controller\ListController is invalid; must implement Zend\Stdlib\DispatchableInterface

This happens because our controller must implement `Zend\Stdlib\DispatchableInterface <https://github.com/zendframework/zf2/:current_branch/library/Zend/Stdlib/DispatchableInterface.php>`_ in order to be 'dispatched'
(or run) by ZendFramework's MVC layer. ZendFramework provides some base controller implementation of it with
`AbstractActionController <https://github.com/zendframework/zf2/:current_branch/library/Zend/Mvc/Controller/AbstractActionController.php>`_,
which we are going to use. Let's modify our controller now:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,7

    <?php
    // Filename: /module/Blog/src/Blog/Controller/ListController.php
    namespace Blog\Controller;

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
    Zend\View\Renderer\PhpRenderer::render: Unable to render template "blog/list/index"; resolver could not resolve to a file

Now the application tells you that a view template-file can not be rendered, which is to be expected as we've not
created it yet. The application is expecting it to be at ``/module/Blog/view/blog/list/index.phtml``. Create this
file and add some dummy content to it:

.. code-block:: html
   :linenos:

    <!-- Filename: /module/Blog/view/blog/list/index.phtml -->
    <h1>Blog\ListController::indexAction()</h1>

Before we continue let us quickly take a look at where we placed this file. Note that view files are found within the
``/view`` subdirectory, not ``/src`` as they are not PHP class files, but template files for rendering HTML. The
following path however deserves some explanation but it's very simple. First we have the lowercased namespace. Followed
by the lowercased controller name without the appendix 'controller' and lastly comes the name of the action that we are
accessing, again without the appendix 'action'. All in all it looks like this: ``/view/{namespace}/{controller}/{action}.phtml``.
This has become a community standard but can potentionally be changed by you at any time.

However creating this file alone is not enough and this brings as to the final topic of this part of the QuickStart. We
need to let the application know where to look for view files. We do this within our modules configuration file ``module.config.php``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'view_manager' => array(
            'template_path_stack' => array(
                __DIR__ . '/../view',
            ),
        ),
        'controllers' => array( /** Controller Configuration */),
        'router'      => array( /** Route Configuration */ )
    );

The above configuration tells the application that the folder ``/module/Blog/view`` has view files in it that match the
above described default scheme. It is important to note that with this you can not only ship view files for your module
but you can also overwrite view files from other modules.

Reload your site now. Finally we are at a point where we see something different than an error being displayed.
Congratulations, not only have you created a simple "Hello World" style module, you also learned about many error
messages and their causes. If we didn't exhaust you too much, continue with our QuickStart and let's create a module
that actually does something.
