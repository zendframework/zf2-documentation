.. _zend.mvc.services:

Default Services
================

The default and recommended way to write Zend Framework applications uses a set of services defined in the
``Zend\Mvc\Service`` namespace. This chapter details what each of those services are, the classes they represent,
and the configuration options available.

.. _zend.mvc.services.service-manager-configuration:

ServiceManagerConfiguration
---------------------------

This is the one service class referenced directly in the bootstrapping. It provides the following:

- **Invokable services**

  - ``DispatchListener``, mapping to ``Zend\Mvc\DispatchListener``.

  - ``Request``, mapping to ``Zend\Http\PhpEnvironment\Request``.

  - ``Response``, mapping to ``Zend\Http\PhpEnvironment\Response``.

  - ``RouteListener``, mapping to ``Zend\Mvc\RouteListener``.

  - ``ViewManager``, mapping to ``Zend\Mvc\View\ViewManager``.

- **Factories**

  - ``Application``, mapping to ``Zend\Mvc\Service\ApplicationFactory``.

  - ``Configuration``, mapping to ``Zend\Mvc\Service\ConfigFactory``. Internally, this pulls the
    ``ModuleManager`` service, and calls its ``loadModules()`` method, and retrieves the merged configuration from
    the module event. As such, this service contains the entire, merged application configuration.

  - ``ControllerLoader``, mapping to ``Zend\Mvc\Service\ControllerLoaderFactory``. Internally, this pulls the
    ``Configuration`` service, and, if it contains a ``controller`` key, inspects that for ``classes`` and
    ``factories`` subkeys. These are used to configure a scoped service manager container, from which controllers
    will be retrieved.

    Additionally, the scoped container is configured to use the ``Di`` service as both an initializer as well as an
    abstract service factory -- effectively allowing you to fall back to DI in order to retrieve your controllers.

    Finally, if the loaded controller is ``Pluggable``, an initializer will inject it with the
    ``ControllerPluginBroker`` service.

  - ``ControllerPluginBroker``, mapping to ``Zend\Mvc\Service\ControllerPluginBrokerFactory``. This instantiates
    the ``Zend\Mvc\Controller\PluginBroker`` instance, passing it the ``ControllerPluginLoader`` service as well as
    the service manager instance.

  - ``ControllerPluginLoader``, mapping to ``Zend\Mvc\Service\ControllerPluginLoaderFactory``. This grabs the
    ``Configuration`` service, and looks for a ``controller`` key with a ``map`` subkey. If found, this value is
    passed to the constructor of ``Zend\Mvc\Controller\PluginLoader`` (otherwise, an empty array is passed).

  - ``DependencyInjector``, mapping to ``Zend\Mvc\Service\DiFactory``. This pulls the ``Configuration`` service,
    and looks for a "di" key; if found, that value is used to configure a new ``Zend\Di\Di`` instance.
    Additionally, the ``Di`` instance is used to seed a ``Zend\ServiceManager\Di\DiAbstractServiceFactory``
    instance which is then attached to the service manager as an abstract factory -- effectively enabling DI as a
    fallback for providing services.

  - ``EventManager``, mapping to ``Zend\Mvc\Service\EventManagerFactory``. This factory composes a static reference
    to a ``SharedEventManager``, which is injected in a new ``EventManager`` instance. This service is not shared
    by default, allowing the ability to have an ``EventManager`` per service, with a shared ``SharedEventManager``
    injected in each.

  - ``ModuleManager``, mapping to ``Zend\Mvc\Service\ModuleManagerFactory``.

    This is perhaps the most complex factory in the MVC stack. It expects that an ``ApplicationConfiguration``
    service has been injected, with keys for ``module_listener_options`` and ``modules``; see the quick start for
    samples.

    It instantiates an instance of ``Zend\ModuleManager\Listener\DefaultListenerAggregate``, using the
    "module_listener_options" retrieved. It also instantiates an instance of
    ``Zend\ModuleManager\Listener\ServiceListener``, providing it the service manager.

    Next, it retrieves the ``EventManager`` service, and attaches the above listeners.

    It instantiates a ``Zend\ModuleManager\ModuleEvent`` instance, setting the "ServiceManager" parameter to the
    service manager object.

    Finally, it instantiates a ``Zend\ModuleManager\ModuleManager`` instance, and injects the ``EventManager`` and
    ``ModuleEvent``.

  - ``Router``, mapping to ``Zend\Mvc\Service\RouterFactory``. This grabs the ``Configuration`` service, and pulls
    from the ``router`` key, passing it to ``Zend\Mvc\Router\Http\TreeRouteStack::factory`` in order to get a
    configured router instance.

  - ``ViewFeedRenderer``, mapping to ``Zend\Mvc\Service\ViewFeedRendererFactory``, which simply returns a
    ``Zend\View\Renderer\FeedRenderer`` instance.

  - ``ViewFeedStrategy``, mapping to ``Zend\Mvc\Service\ViewFeedStrategyFactory``. This instantiates a
    ``Zend\View\Strategy\FeedStrategy`` instance with the ``ViewFeedRenderer`` service.

  - ``ViewJsonRenderer``, mapping to ``Zend\Mvc\Service\ViewJsonRendererFactory``, which simply returns a
    ``Zend\View\Renderer\JsonRenderer`` instance.

  - ``ViewJsonStrategy``, mapping to ``Zend\Mvc\Service\ViewJsonStrategyFactory``. This instantiates a
    ``Zend\View\Strategy\JsonStrategy`` instance with the ``ViewJsonRenderer`` service.

- **Aliases**

  - ``Config``, mapping to the ``Configuration`` service.

  - ``Di``, mapping to the ``DependencyInjector`` service.

  - ``Zend\EventManager\EventManagerInterface``, mapping to the ``EventManager`` service. This is mainly to ensure
    that when falling through to DI, classes are still injected via the ``ServiceManager``.

  - ``Zend\Mvc\Controller\PluginBroker``, mapping to the ``ControllerPluginBroker`` service. This is mainly to
    ensure that when falling through to DI, classes are still injected via the ``ServiceManager``.

  - ``Zend\Mvc\Controller\PluginLoader``, mapping to the ``ControllerPluginLoader`` service. This is mainly to
    ensure that when falling through to DI, classes are still injected via the ``ServiceManager``.

Additionally, two initializers are registered. Initializers are run on created instances, and may be used to
further configure them. The two initializers the ``ServiceManagerConfiguration`` class creates and registers do the
following:

- For objects that implement ``Zend\EventManager\EventManagerAwareInterface``, the ``EventManager`` service will be
  retrieved and injected. This service is **not** shared, though each instance it creates is injected with a shared
  instance of ``SharedEventManager``.

- For objects that implement ``Zend\ServiceManager\ServiceManagerAwareInterface``, the ``ServiceManager`` will
  inject itself into the object.

Finally, the ``ServiceManager`` registers itself as the ``ServiceManager`` service, and aliases itself to the class
names ``Zend\ServiceManager\ServiceManagerInterface`` and ``Zend\ServiceManager\ServiceManager``.

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

- ``ViewHelperLoader``, representing and aliased to ``Zend\View\HelperLoader``. If a ``helper_map`` subkey is
  provided, its value will be used as a map to seed the helper loader.

- ``ViewHelperBroker``, representing and aliased to ``Zend\View\HelperBroker``. It is seeded with the
  ``ViewHelperLoader`` service, as well as the ``ServiceManager`` itself.

  The ``Router`` service is retrieved, and injected into the ``Url`` helper.

  If the ``base_path`` key is present, it is used to inject the ``BasePath`` view helper; otherwise, the
  ``Request`` service is retrieved, and the value of its ``getBasePath()`` method is used.

  If the ``doctype`` key is present, it will be used to set the value of the ``Doctype`` view helper.

- ``ViewTemplateMapResolver``, representing and aliased to ``Zend\View\Resolver\TemplateMapResolver``. If a
  ``template_map`` key is present, it will be used to seed the template map.

- ``ViewTemplatePathStack``, representing and aliased to ``Zend\View\Resolver\TemplatePathStack``. If a
  ``template_path_stack`` key is prsent, it will be used to seed the stack.

- ``ViewResolver``, representing and aliased to ``Zend\View\Resolver\AggregateResolver`` and
  ``Zend\View\Resolver\ResolverInterface``. It is seeded with the ``ViewTemplateMapResolver`` and
  ``ViewTemplatePathStack`` services as resolvers.

- ``ViewRenderer``, representing and aliased to ``Zend\View\Renderer\PhpRenderer`` and
  ``Zend\View\Renderer\RendererInterface``. It is seeded with the ``ViewResolver`` and ``ViewHelperBroker``
  services. Additionally, the ``ViewModel`` helper gets seeded with the ``ViewModel`` as its root (layout) model.

- ``ViewPhpRendererStrategy``, representing and aliased to ``Zend\View\Strategy\PhpRendererStrategy``. It gets
  seeded with the ``ViewRenderer`` service.

- ``View``, representing and aliased to ``Zend\View\View``. It gets seeded with the ``EventManager`` service, and
  attaches the ``ViewPhpRendererStrategy`` as an aggregate listener.

- ``DefaultRenderingStrategy``, representing and aliased to ``Zend\Mvc\View\DefaultRenderingStrategy``. If the
  ``layout`` key is prsent, it is used to seed the strategy's layout template. It is seeded with the ``View``
  service.

- ``ExceptionStrategy``, representing and aliased to ``Zend\Mvc\View\ExceptionStrategy``. If the
  ``dislay_exceptions`` or ``exception_template`` keys are present, they are usd to configure the strategy.

- ``RouteNotFoundStrategy``, representing and aliased to ``Zend\Mvc\View\RouteNotFoundStrategy`` and
  ``404Stategy``. If the ``display_not_found_reason`` or ``not_found_template`` keys are present, they are used to
  configure the strategy.

- ``ViewModel``. In this case, no service is registered; the ``ViewModel`` is simply retrieved from the
  ``MvcEvent`` and injected with the layout template name. template

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
``Configuration`` service, which is intended for configuring all other objects in the system.

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
           // modules are loaded. These effectively overide configuration
           // provided by modules themselves. Paths may use GLOB_BRACE notation.
           'config_glob_paths' => array(
           ),

           // Whether or not to enable a configuration cache.
           // If enabled, the merged configuration will be cached and used in
           // subsequent requests.
           'config_cache_enabled' => $booleanValue,

           // The key used to create the configuration cache file name.
           'config_cache_key' => $stringKey,

           // The path in which to cache merged configuration.
           'cache_dir' => $stringPath,
       ),

       // Initial configuration with which to seed the ServiceManager.
       // Should be compatible with Zend\ServiceManager\Config.
       'service_manager' => array(
       ),
   );

.. _zend.mvc.services.config:

Default Configuration Options
-----------------------------

The following options are available when using the default services configured by the
``ServiceManagerConfiguration`` and ``ViewManager``.

.. code-block:: php
   :linenos:

   <?php
   return array(
       // The following are used to configure controller or controller plugin loading
       'controller' => array(
           // Map of controller "name" to class
           // This should be used if you do not need to inject any dependencies
           // in your controller
           'classes' => array(
           ),

           // Map of controller "name" to factory for creating controller instance
           // You may provide either the class name of a factory, or a PHP callback.
           'factories' => array(
           ),

           // Map of controller plugin names to their classes
           'map' => array(
           ),
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
           // Defined helpers.
           // Typically helper name/helper class pairs. Can contain values without keys
           // that refer to either Traversable classes or Zend\Loader\PluginClassLoader
           // instances as well.
           'helper_map' => array(
               'foo' => 'My\Helper\Foo',      // name/class pair
               'Zend\Form\View\HelperLoader', // additional helper loader to seed
           ),

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


