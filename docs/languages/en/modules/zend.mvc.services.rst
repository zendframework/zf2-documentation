.. _zend.mvc.services:

Default Services
================

The default and recommended way to write Zend Framework applications uses a set of services defined in the
``Zend\Mvc\Service`` namespace. This chapter details what each of those services are, the classes they represent,
and the configuration options available.

.. _zend.mvc.services.intro:

Theory of Operation
-------------------

To allow easy configuration of all the different parts of the `MVC` system, a somewhat complex set of services and
their factories has been created. We'll try to give a simplified explanation of the process.

When a ``Zend\Mvc\Application`` is created, a ``Zend\ServiceManager\ServiceManager`` object is created and
configured via ``Zend\Mvc\Service\ServiceManagerConfig``. The ``ServiceManagerConfig`` gets the configuration from
``application.config.php`` (or some other `application` configuration you passed to the ``Application`` when
creating it). From all the service and factories provided in the ``Zend\Mvc\Service`` namespace,
``ServiceManagerConfig`` is responsible of configuring only three: ``SharedEventManager``, ``EventManager``,
and ``ModuleManager``.

After this, the ``Application`` calls for the ``ModuleManager``. At this point, the ``ModuleManager`` further
configures the ``ServiceManager`` with services and factories provided in ``Zend\Mvc\Service\ServiceLocator``.
This approach allows to keep the main application configuration as simple as possible, and to give the developer
the power to configure different parts of the `MVC` system from within the modules, overriding any default
configuration in these `MVC` services.

.. _zend.mvc.services.service-manager-configuration:

ServiceManager
--------------

This is the one service class referenced directly in the application bootstrapping. It provides the following:

- **Invokable services**

  - ``DispatchListener``, mapping to ``Zend\Mvc\DispatchListener``.

  - ``RouteListener``, mapping to ``Zend\Mvc\RouteListener``.

  - ``SendResponseListener``, mapping to ``Zend\Mvc\SendResponseListener``.

  - ``SharedEventManager``, mapping to ``Zend\EventManager\SharedEventManager``.

- **Factories**

  - ``Application``, mapping to ``Zend\Mvc\Service\ApplicationFactory``.

  - ``Config``, mapping to ``Zend\Mvc\Service\ConfigFactory``. Internally, this pulls the
    ``ModuleManager`` service, and calls its ``loadModules()`` method, and retrieves the merged configuration from
    the module event. As such, this service contains the entire, merged application configuration.

  - ``ControllerLoader``, mapping to ``Zend\Mvc\Service\ControllerLoaderFactory``. This creates an instance of
    ``Zend\Mvc\Controller\ControllerManager``, passing the service manager instance.

    Additionally, it uses the ``DiStrictAbstractServiceFactory`` service -- effectively allowing you to fall back
    to DI in order to retrieve your controllers. If you want to use ``Zend\Di`` to retrieve your controllers,you
    must white-list them in your DI configuration under the ``allowed_controllers`` key (otherwise, they will just
    be ignored).

    The ``ControllerManager`` will add an initializer that will do the following:

      - If the controller implements the ``Zend\ServiceManager\ServiceLocatorAwareInterface`` interface, an
        instance of the ``ServiceManager`` will be injected into it.

      - If the controller implements the ``Zend\EventManager\EventManagerAwareInterface`` interface, an instance of
        the ``EventManager`` will be injected into it.

      - Finally, an initializer will inject it with the ``ControllerPluginManager`` service, as long as the
        ``setPluginManager`` method is implemented.

  - ``ControllerPluginManager``, mapping to ``Zend\Mvc\Service\ControllerPluginManagerFactory``. This instantiates
    the ``Zend\Mvc\Controller\PluginManager`` instance, passing it the service manager instance. It also uses the
    ``DiAbstractServiceFactory`` service -- effectively allowing you to fall back to DI in order to retrieve your
    :ref:`controller plugins <zend.mvc.controller-plugins>`.

    It registers a set of default controller plugins, and contains an initializer for injecting plugins
    with the current controller.

  - ``ConsoleAdapter``, mapping to ``Zend\Mvc\Service\ConsoleAdapterFactory``. This grabs the ``Config`` service,
    pulls from the ``console`` key, and do the following:

    - If the ``adapter`` subkey is present, it is used to get the adapter instance, otherwise,
    ``Zend\Console\Console::detectBestAdapter()`` will be called to configure an adapter instance.

    - If the ``charset`` subkey is present, the is used to set the adapter charset.

  - ``ConsoleRouter``, mapping to ``Zend\Mvc\Service\RouterFactory``. This grabs the ``Config`` service, and pulls
    from the ``console`` key and ``router`` subkey, configuring a ``Zend\Mvc\Router\Console\SimpleRouteStack``
    instance.

  - ``DependencyInjector``, mapping to ``Zend\Mvc\Service\DiFactory``. This pulls the ``Config`` service,
    and looks for a "di" key; if found, that value is used to configure a new ``Zend\Di\Di`` instance.

  - ``DiAbstractServiceFactory``, mapping to ``Zend\Mvc\Service\DiAbstractServiceFactoryFactory``. This creates an
    instance of ``Zend\ServiceManager\Di\DiAbstractServiceFactory`` injecting the ``Di`` service instance. That
    instance is attached to the service manager as an abstract factory -- effectively enabling DI as a fallback for
    providing services.

  - ``DiServiceInitializer``, mapping to ``Zend\Mvc\Service\DiServiceInitializerFactory``. This creates an instance
    of ``Zend\ServiceManager\Di\DiServiceInitializer`` injecting the ``Di`` service and the service manager itself.

  - ``DiStrictAbstractServiceFactory``, mapping to ``Zend\Mvc\Service\DiStrictAbstractServiceFactoryFactory``. This
    creates an instance of ``Zend\Mvc\Service\DiStrictAbstractServiceFactoryFactory`` injecting the ``Di`` service
    instance.

  - ``EventManager``, mapping to ``Zend\Mvc\Service\EventManagerFactory``. This factory composes a static reference
    to a ``SharedEventManager``, which is injected in a new ``EventManager`` instance. This service is not shared
    by default, allowing the ability to have an ``EventManager`` per service, with a shared ``SharedEventManager``
    injected in each.

  - ``FilterManager``, mapping to ``Zend\Mvc\Service\FilterManagerFactory``. This instantiates the
    ``Zend\Filter\FilterPluginManager`` instance, passing it the service manager instance -- this is used to manage
    filters for the :ref:`filter chains <zend.filter.filter_chains>`. It also uses the ``DiAbstractServiceFactory``
    service -- effectively allowing you to fall back to DI in order to retrieve filters.

  - ``FormElementManager``, mapping to ``Zend\Mvc\Service\FormElementManagerFactory``. This instantiates the
    ``Zend\Form\FormElementManager`` instance, passing it the service manager instance -- this is used to manage
    :ref:`form elements <zend.form.elements.intro>`. It also uses the ``DiAbstractServiceFactory`` service --
    effectively allowing you to fall back to DI in order to retrieve form elements.

  - ``HttpRouter``, mapping to ``Zend\Mvc\Service\RouterFactory``. This grabs the ``Config`` service, and pulls
    from the ``router`` key, configuring a ``Zend\Mvc\Router\Http\TreeRouteStack`` instance.

  - ``ModuleManager``, mapping to ``Zend\Mvc\Service\ModuleManagerFactory``.

    This is perhaps the most complex factory in the MVC stack. It expects that an ``ApplicationConfig``
    service has been injected, with keys for ``module_listener_options`` and ``modules``; see the quick start for
    samples.

    It instantiates an instance of ``Zend\ModuleManager\Listener\DefaultListenerAggregate``, using the
    "module_listener_options" retrieved. Checks if a service with the name ``ServiceListener`` exists, otherwise
    it sets a factory with that name mapping to ``Zend\Mvc\Service\ServiceListenerFactory``. A bunch of service
    listeners will be added to the ``ServiceListener``, like listeners for the ``getServiceConfig``,
    ``getControllerConfig``, ``getControllerPluginConfig``, ``getViewHelperConfig`` module methods.

    Next, it retrieves the ``EventManager`` service, and attaches the above listeners.

    It instantiates a ``Zend\ModuleManager\ModuleEvent`` instance, setting the "ServiceManager" parameter to the
    service manager object.

    Finally, it instantiates a ``Zend\ModuleManager\ModuleManager`` instance, and injects the ``EventManager`` and
    ``ModuleEvent``.

  - ``PaginatorPluginManager``, mapping to ``Zend\Mvc\Service\PaginatorPluginManagerFactory``. This instantiates
    the ``Zend\Paginator\AdapterPluginManager`` instance, passing it the service manager instance -- this is used
    to manage :ref:`paginator adapters <zend.paginator.usage.paginating.adapters>`. It also uses the
    ``DiAbstractServiceFactory`` service -- effectively allowing you to fall back to DI in order to retrieve
    paginator adapters.

  - ``Request``, mapping to ``Zend\Mvc\Service\RequestFactory``. The factory is used to create and return a
    request instance, according to the current environment. If the current environment is ``cli``, it will
    create a ``Zend\Console\Request``, or a ``Zend\Http\PhpEnvironment\Request`` if the current environment is
    `HTTP`.

  - ``Response``, mapping to ``Zend\Mvc\Service\ResponseFactory``. The factory is used to create and return a
    response instance, according to the current environment. If the current environment is ``cli``, it will
    create a ``Zend\Console\Response``, or a ``Zend\Http\PhpEnvironment\Response`` if the current environment is
    `HTTP`.

  - ``Router``, mapping to ``Zend\Mvc\Service\RouterFactory``. If in a console enviroment, this will behave the
    same way as the ``ConsoleRouter`` service, if not, it will behave the same way as ``HttpRouter`` service.

  - ``RoutePluginManager``, mapping to ``Zend\Mvc\Service\RoutePluginManagerFactory``. This instantiates the
    ``Zend\Mvc\Router\RoutePluginManager`` instance, passing it the service manager instance -- this is used to
    manage :ref:`route types <zend.mvc.routing.http-route-types>`. It also uses the ``DiAbstractServiceFactory``
    service -- effectively allowing you to fall back to DI in order to retrieve route types.

  - ``ServiceListener``, mapping to ``Zend\Mvc\Service\ServiceListenerFactory``. The factory is used to
    instantiate the ``ServiceListener``, while allowing easy extending. It checks if a service with the name
    ``ServiceListenerInterface`` exists, which must implement ``Zend\ModuleManager\Listener\ServiceListenerInterface``,
    before instantiating the default ``ServiceListener``.

    In addition to this, it retrieves the ``ApplicationConfig`` and looks for the ``service_listener_options`` key.
    This allows you to register own listeners for module methods and configuration keys to create an own service
    manager; see the :ref:`application configuration options <zend.mvc.services.app-config>` for samples.

  - ``ValidatorManager``, mapping to ``Zend\Mvc\Service\ValidatorManagerFactory``. This instantiates the
    ``Zend\Validator\ValidatorPluginManager`` instance, passing it the service manager instance -- this is used to
    manage :ref:`validators <zend.validator.set>`. It also uses the ``DiAbstractServiceFactory`` service --
    effectively allowing you to fall back to DI in order to retrieve validators.

  - ``ViewManager``, mapping to ``Zend\Mvc\Service\ViewManagerFactory``. The factory is used to create and return
    a view manager, according to the current environment.  If the current environment is ``cli``, it will
    create a ``Zend\Mvc\View\Console\ViewManager``, or a ``Zend\Mvc\View\Http\ViewManager`` if the current
    environment is `HTTP`.

  - ``ViewResolver``, mapping to ``Zend\Mvc\Service\ViewResolverFactory``, which creates and returns the aggregate
    view resolver. It also attaches the ``ViewTemplateMapResolver`` and ``ViewTemplatePathStack`` services to it.

  - ``ViewTemplateMapResolver``, mapping to ``Zend\Mvc\Service\ViewTemplateMapResolverFactory`` which creates,
    configures and returns the ``Zend\View\Resolver\TemplateMapResolver``.

  - ``ViewTemplatePathStack``, mapping to ``Zend\Mvc\Service\ViewTemplatePathStackFactory`` which creates,
    configures and returns the ``Zend\View\Resolver\TemplatePathStack``.

  - ``ViewHelperManager``, mapping to ``Zend\Mvc\Service\ViewHelperManagerFactory``, which creates, configures
    and returns the view helper manager.

  - ``ViewFeedRenderer``, mapping to ``Zend\Mvc\Service\ViewFeedRendererFactory``, which simply returns a
    ``Zend\View\Renderer\FeedRenderer`` instance.

  - ``ViewFeedStrategy``, mapping to ``Zend\Mvc\Service\ViewFeedStrategyFactory``. This instantiates a
    ``Zend\View\Strategy\FeedStrategy`` instance with the ``ViewFeedRenderer`` service.

  - ``ViewJsonRenderer``, mapping to ``Zend\Mvc\Service\ViewJsonRendererFactory``, which simply returns a
    ``Zend\View\Renderer\JsonRenderer`` instance.

  - ``ViewJsonStrategy``, mapping to ``Zend\Mvc\Service\ViewJsonStrategyFactory``. This instantiates a
    ``Zend\View\Strategy\JsonStrategy`` instance with the ``ViewJsonRenderer`` service.

- **Aliases**

  - ``Configuration``, mapping to the ``Config`` service.

  - ``Console``, mapping to the ``ConsoleAdapter`` service.

  - ``Di``, mapping to the ``DependencyInjector`` service.

  - ``Zend\Di\LocatorInterface``, mapping to the ``DependencyInjector`` service.

  - ``Zend\EventManager\EventManagerInterface``, mapping to the ``EventManager`` service. This is mainly to ensure
    that when falling through to DI, classes are still injected via the ``ServiceManager``.

  - ``Zend\Mvc\Controller\PluginManager``, mapping to the ``ControllerPluginManager`` service. This is mainly to
    ensure that when falling through to DI, classes are still injected via the ``ServiceManager``.

  - ``Zend\View\Resolver\TemplateMapResolver``, mapping to the ``ViewTemplateMapResolver`` service.

  - ``Zend\View\Resolver\TemplatePathStack``, mapping to the ``ViewTemplatePathStack`` service.

  - ``Zend\View\Resolver\AggregateResolver``, mapping to the ``ViewResolver`` service.

  - ``Zend\View\Resolver\ResolverInterface``, mapping to the ``ViewResolver`` service.

Additionally, two initializers are registered. Initializers are run on created instances, and may be used to
further configure them. The two initializers the ``ServiceManagerConfig`` class creates and registers do the
following:

- For objects that implement ``Zend\EventManager\EventManagerAwareInterface``, the ``EventManager`` service will be
  retrieved and injected. This service is **not** shared, though each instance it creates is injected with a shared
  instance of ``SharedEventManager``.

- For objects that implement ``Zend\ServiceManager\ServiceLocatorAwareInterface``, the ``ServiceManager`` will
  inject itself into the object.

Finally, the ``ServiceManager`` registers itself as the ``ServiceManager`` service, and aliases itself to the class
names ``Zend\ServiceManager\ServiceLocatorInterface`` and ``Zend\ServiceManager\ServiceManager``.

.. _zend.mvc.services.view-manager:

ViewManager
-----------

The View layer within ``Zend\Mvc`` consists of a large number of collaborators and event listeners. As such,
``Zend\Mvc\View\ViewManager`` was created to handle creation of the various objects, as well as wiring them
together and establishing event listeners.

The ``ViewManager`` itself is an event listener on the ``bootstrap`` event. It retrieves the ``ServiceManager``
from the ``Application`` object, as well as its composed ``EventManager``.

Configuration for all members of the ``ViewManager`` fall under the ``view_manager`` configuration key, and expect
values as noted below. The following services are created and managed by the ``ViewManager``:

- ``ViewHelperManager``, representing and aliased to ``Zend\View\HelperPluginManager``. It is seeded with the
  ``ServiceManager``. Created via the ``Zend\Mvc\Service\ViewHelperManagerFactory``.

  - The ``Router`` service is retrieved, and injected into the ``Url`` helper.

  - If the ``base_path`` key is present, it is used to inject the ``BasePath`` view helper; otherwise, the
    ``Request`` service is retrieved, and the value of its ``getBasePath()`` method is used.

  - If the ``doctype`` key is present, it will be used to set the value of the ``Doctype`` view helper.

- ``ViewTemplateMapResolver``, representing and aliased to ``Zend\View\Resolver\TemplateMapResolver``. If a
  ``template_map`` key is present, it will be used to seed the template map.

- ``ViewTemplatePathStack``, representing and aliased to ``Zend\View\Resolver\TemplatePathStack``. If a
  ``template_path_stack`` key is present, it will be used to seed the stack.

- ``ViewResolver``, representing and aliased to ``Zend\View\Resolver\AggregateResolver`` and
  ``Zend\View\Resolver\ResolverInterface``. It is seeded with the ``ViewTemplateMapResolver`` and
  ``ViewTemplatePathStack`` services as resolvers.

- ``ViewRenderer``, representing and aliased to ``Zend\View\Renderer\PhpRenderer`` and
  ``Zend\View\Renderer\RendererInterface``. It is seeded with the ``ViewResolver`` and ``ViewHelperManager``
  services. Additionally, the ``ViewModel`` helper gets seeded with the ``ViewModel`` as its root (layout) model.

- ``ViewPhpRendererStrategy``, representing and aliased to ``Zend\View\Strategy\PhpRendererStrategy``. It gets
  seeded with the ``ViewRenderer`` service.

- ``View``, representing and aliased to ``Zend\View\View``. It gets seeded with the ``EventManager`` service, and
  attaches the ``ViewPhpRendererStrategy`` as an aggregate listener.

- ``DefaultRenderingStrategy``, representing and aliased to ``Zend\Mvc\View\DefaultRenderingStrategy``. If the
  ``layout`` key is present, it is used to seed the strategy's layout template. It is seeded with the ``View``
  service.

- ``ExceptionStrategy``, representing and aliased to ``Zend\Mvc\View\ExceptionStrategy``. If the
  ``display_exceptions`` or ``exception_template`` keys are present, they are used to configure the strategy.

- ``RouteNotFoundStrategy``, representing and aliased to ``Zend\Mvc\View\RouteNotFoundStrategy`` and
  ``404Strategy``. If the ``display_not_found_reason`` or ``not_found_template`` keys are present, they are used to
  configure the strategy.

- ``ViewModel``. In this case, no service is registered; the ``ViewModel`` is simply retrieved from the
  ``MvcEvent`` and injected with the layout template name.

The ``ViewManager`` also creates several other listeners, but does not expose them as services; these include
``Zend\Mvc\View\CreateViewModelListener``, ``Zend\Mvc\View\InjectTemplateListener``, and
``Zend\Mvc\View\InjectViewModelListener``. These, along with ``RouteNotFoundStrategy``, ``ExceptionStrategy``, and
``DefaultRenderingStrategy`` are attached as listeners either to the application ``EventManager`` instance or the
``SharedEventManager`` instance.

Finally, if you have a ``strategies`` key in your configuration, the ``ViewManager`` will loop over these and
attach them in order to the ``View`` service as listeners, at a priority of 100 (allowing them to execute before
the ``DefaultRenderingStrategy``).

.. _zend.mvc.services.app-config:

Application Configuration Options
---------------------------------

The following options may be used to provide initial configuration for the ``ServiceManager``, ``ModuleManager``,
and ``Application`` instances, allowing them to then find and aggregate the configuration used for the
``Config`` service, which is intended for configuring all other objects in the system. These configuration
directives go to the ``config/application.config.php`` file.

.. code-block:: php
   :linenos:

   <?php
   return array(
       // This should be an array of module namespaces used in the application.
       'modules' => array(
       ),

       // These are various options for the listeners attached to the ModuleManager
       'module_listener_options' => array(
           // This should be an array of paths in which modules reside.
           // If a string key is provided, the listener will consider that a module
           // namespace, the value of that key the specific path to that module's
           // Module class.
           'module_paths' => array(
           ),

           // An array of paths from which to glob configuration files after
           // modules are loaded. These effectively override configuration
           // provided by modules themselves. Paths may use GLOB_BRACE notation.
           'config_glob_paths' => array(
           ),

           // Whether or not to enable a configuration cache.
           // If enabled, the merged configuration will be cached and used in
           // subsequent requests.
           'config_cache_enabled' => $booleanValue,

           // The key used to create the configuration cache file name.
           'config_cache_key' => $stringKey,

           // Whether or not to enable a module class map cache.
           // If enabled, creates a module class map cache which will be used
           // by in future requests, to reduce the autoloading process.
           'module_map_cache_enabled' => $booleanValue,

           // The key used to create the class map cache file name.
           'module_map_cache_key' => $stringKey,

           // The path in which to cache merged configuration.
           'cache_dir' => $stringPath,

           // Whether or not to enable modules dependency checking.
           // Enabled by default, prevents usage of modules that depend on other modules
           // that weren't loaded.
           'check_dependencies' => $booleanValue,
       ),

       // Used to create an own service manager. May contain one or more child arrays.
       'service_listener_options' => array(
          array(
            'service_manager' => $stringServiceManagerName,
            'config_key'      => $stringConfigKey,
            'interface'       => $stringOptionalInterface,
            'method'          => $stringRequiredMethodName,
          ),
       )

       // Initial configuration with which to seed the ServiceManager.
       // Should be compatible with Zend\ServiceManager\Config.
       'service_manager' => array(
       ),
   );

For an example, see the `ZendSkeletonApplication configuration file`_.

.. _zend.mvc.services.config:

Default Configuration Options
-----------------------------

The following options are available when using the default services configured by the ``ServiceManagerConfig``
and ``ViewManager``.

These configuration directives can go to the ``config/autoload/{,*.}{global,local}.php`` files, or in the
``module/<module name>/config/module.config.php`` configuration files. The merging of these configuration
files is done by the ``ModuleManager``. It first merges each module's ``module.config.php`` file, and then
the files in ``config/autoload`` (first the ``*.global.php`` and then the ``*.local.php`` files). The order
of the merge is relevant so you can override a module's configuration with your application configuration.
If you have both a ``config/autoload/my.global.config.php`` and ``config/autoload/my.local.config.php``, the
local configuration file overrides the global configuration.

.. warning::

    Local configuration files are intended to keep sensitive information, such as database credentials, and as
    such, it is highly recommended to keep these local configuration files out of your VCS. The
    ``ZendSkeletonApplication``\'s ``config/autoload/.gitignore`` file ignores ``*.local.php`` files by default.

.. code-block:: php
   :linenos:

   <?php
   return array(
       // The following are used to configure controller loader
       // Should be compatible with Zend\ServiceManager\Config.
       'controllers' => array(
           // Map of controller "name" to class
           // This should be used if you do not need to inject any dependencies
           // in your controller
           'invokables' => array(
           ),

           // Map of controller "name" to factory for creating controller instance
           // You may provide either the class name of a factory, or a PHP callback.
           'factories' => array(
           ),
       ),

       // The following are used to configure controller plugin loader
       // Should be compatible with Zend\ServiceManager\Config.
       'controller_plugins' => array(
       ),

       // The following are used to configure view helper manager
       // Should be compatible with Zend\ServiceManager\Config.
       'view_helpers' => array(
       ),

       // The following is used to configure a Zend\Di\Di instance.
       // The array should be in a format that Zend\Di\Config can understand.
       'di' => array(
       ),

       // Configuration for the Router service
       // Can contain any router configuration, but typically will always define
       // the routes for the application. See the router documentation for details
       // on route configuration.
       'router' => array(
           'routes' => array(
           ),
       ),

       // ViewManager configuration
       'view_manager' => array(
           // Base URL path to the application
           'base_path' => $stringBasePath,

           // Doctype with which to seed the Doctype helper
           'doctype' => $doctypeHelperConstantString, // e.g. HTML5, XHTML1

           // TemplateMapResolver configuration
           // template/path pairs
           'template_map' => array(
           ),

           // TemplatePathStack configuration
           // module/view script path pairs
           'template_path_stack' => array(
           ),

           // Layout template name
           'layout' => $layoutTemplateName, // e.g., 'layout/layout'

           // ExceptionStrategy configuration
           'display_exceptions' => $bool, // display exceptions in template
           'exception_template' => $stringTemplateName, // e.g. 'error'

           // RouteNotFoundStrategy configuration
           'display_not_found_reason' => $bool, // display 404 reason in template
           'not_found_template' => $stringTemplateName, // e.g. '404'

           // Additional strategies to attach
           // These should be class names or service names of View strategy classes
           // that act as ListenerAggregates. They will be attached at priority 100,
           // in the order registered.
           'strategies' => array(
               'ViewJsonStrategy', // register JSON renderer strategy
               'ViewFeedStrategy', // register Feed renderer strategy
           ),
       ),
   );

For an example, see the `Application module configuration file`_ in the `ZendSkeletonApplication`.


.. _`ZendSkeletonApplication configuration file`: https://github.com/zendframework/ZendSkeletonApplication/blob/master/config/application.config.php
.. _`Application module configuration file`: https://github.com/zendframework/ZendSkeletonApplication/blob/master/module/Application/config/module.config.php
