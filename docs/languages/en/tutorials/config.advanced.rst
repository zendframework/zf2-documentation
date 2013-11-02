.. _tutorials.config.advanced:

Advanced Configuration Tricks
=============================

Configuration of Zend Framework 2 applications happens in several steps:

- Initial configuration is passed to the ``Application`` instance and used to
  seed the ``ModuleManager`` and ``ServiceManager``. In this tutorial, we will
  call this configuration **system configuration**.
- The ``ModuleManager``'s ``ConfigListener`` aggregates configuration and merges
  it while modules are being loaded. In this tutorial, we will call this
  configuration **application configuration**.
- Once configuration is aggregated from all modules, the ``ConfigListener`` will
  also merge application configuration globbed in specified directories
  (typically ``config/autoload/``).
- Finally, immediately prior to the merged application configuration being
  passed to the ``ServiceManager``, it is passed to a special
  ``EVENT_MERGE_CONFIG`` event to allow further modification.

In this tutorial, we'll look at the exact sequence, and how you can tie into it.

.. _tutorials.config.advanced.system-configuration:

System configuration
--------------------

To begin module loading, we have to tell the ``Application`` instance about the
available modules and where they live, optionally provide some information to
the default module listeners (e.g., where application configuration lives, and
what files to load; whether to cache merged configuration, and where; etc.), and
optionally seed the ``ServiceManager``. For purposes of this tutorial we will
call this the **system configuration**.

When using the skeleton application, the **system configuration** is by default
in ``config/application.config.php``. The defaults look like this:

.. code-block:: php
    :linenos:

    <?php
    return array(
        // This should be an array of module namespaces used in the application.
        'modules' => array(
            'Application',
        ),
    
        // These are various options for the listeners attached to the ModuleManager
        'module_listener_options' => array(
            // This should be an array of paths in which modules reside.
            // If a string key is provided, the listener will consider that a module
            // namespace, the value of that key the specific path to that module's
            // Module class.
            'module_paths' => array(
                './module',
                './vendor',
            ),
    
            // An array of paths from which to glob configuration files after
            // modules are loaded. These effectively overide configuration
            // provided by modules themselves. Paths may use GLOB_BRACE notation.
            'config_glob_paths' => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
    
            // Whether or not to enable a configuration cache.
            // If enabled, the merged configuration will be cached and used in
            // subsequent requests.
            //'config_cache_enabled' => $booleanValue,
    
            // The key used to create the configuration cache file name.
            //'config_cache_key' => $stringKey,
    
            // Whether or not to enable a module class map cache.
            // If enabled, creates a module class map cache which will be used
            // by in future requests, to reduce the autoloading process.
            //'module_map_cache_enabled' => $booleanValue,
    
            // The key used to create the class map cache file name.
            //'module_map_cache_key' => $stringKey,
    
            // The path in which to cache merged configuration.
            //'cache_dir' => $stringPath,
    
            // Whether or not to enable modules dependency checking.
            // Enabled by default, prevents usage of modules that depend on other modules
            // that weren't loaded.
            // 'check_dependencies' => true,
        ),
    
        // Used to create an own service manager. May contain one or more child arrays.
        //'service_listener_options' => array(
        //     array(
        //         'service_manager' => $stringServiceManagerName,
        //         'config_key'      => $stringConfigKey,
        //         'interface'       => $stringOptionalInterface,
        //         'method'          => $stringRequiredMethodName,
        //     ),
        // )
    
       // Initial configuration with which to seed the ServiceManager.
       // Should be compatible with Zend\ServiceManager\Config.
       // 'service_manager' => array(),
    );

The system configuration is for the bits and pieces related to the MVC that run
before your application is ready. The configuration is usually brief, and quite
minimal.

Also, system configuration is used *immediately*, and is not merged with any
other configuration -- which means it cannot be overridden by a module.

This leads us to our first trick: how do you provide environment-specific
system configuration?

.. _tutorials.config.advanced.system-configuration.environment-specific:

Environment-specific system configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

What happens when you want to change the set of modules you use based on the
environment? Or if the configuration caching should be enabled based on
environment?

It is for this reason that the default system configuration we provide in the
skeleton application is in PHP; providing it in PHP means you can
programmatically manipulate it.

As an example, let's make the following requirements:

- We want to use the ``ZendDeveloperTools`` module in development only.
- We want to have configuration caching on in production only.

To make this happen, we'll set an environment variable in our web server
configuration, ``APP_ENV``. In Apache, you'd put a directive like the following
in either your system-wide ``apache.conf`` or ``httpd.conf``, or in the
definition for your virtual host; alternately, it can be placed in an
``.htaccess`` file.

.. code-block:: apache

    SetEnv "APP_ENV" "development"

For other web servers, consult the web server documentation to determine how to
set environment variables.

To simplify matters, we'll assume the environment is "production" if no
environment variable is present.

We'll modify the ``config/application.config.php`` file to read as follows:

.. code-block:: php
    :linenos:

    <?php
    $env = getenv('APP_ENV') ?: 'production';

    // Use the $env value to determine which modules to load
    $modules = array(
        'Application',
    );
    if ($env == 'development') {
        $modules[] = 'ZendDeveloperTools';
    }

    return array(
        'modules' => $modules,
    
        'module_listener_options' => array(
            'module_paths' => array(
                './module',
                './vendor',
            ),
    
            'config_glob_paths' => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
    
            // Use the $env value to determine the state of the flag
            'config_cache_enabled' => ($env == 'production'),

            'config_cache_key' => 'app_config',
    
            // Use the $env value to determine the state of the flag
            'module_map_cache_enabled' => ($env == 'production'),
    
            'module_map_cache_key' => 'module_map',
    
            'cache_dir' => 'data/config/',
    
            // Use the $env value to determine the state of the flag
            'check_dependencies' => ($env != 'production'),
        ),
    );

This approach gives you flexibility to alter system-level settings.

However, how about altering *application* *specific* settings (not system
configuration) based on the environment?

.. _tutorials.config.advanced.system-configuration.environment-specific-application:

Environment-specific application configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes you want to change application configuration to load things such as
database adapters, log writers, cache adapters, and more based on the
environment. These are typically managed in the service manager, and may be
defined by modules. You can override them at the application level via
``Zend\ModuleManager\Listener\ConfigListener``, by specifying a glob path in the
**system configuration** -- the ``module_listener_options.config_glob_paths``
key from the previous examples.

The default value for this is ``config/autoload/{,*.}{global,local}.php``. What
this means is that it will look for **application configuration** files in the
``config/autoload`` directory, in the following order:

- ``global.php``
- ``*.global.php``
- ``local.php``
- ``*.local.php``

This allows you to define application-level defaults in "global" configuration
files, which you would then commit to your version control system, and
environment-specific overrides in your "local" configuration files, which you
would *omit* from version control.

This is a great solution for development, as it allows you to specify alternate
configuration that's specific to your development environment without worrying
about accidently deploying it. However, what if you have more environments --
such as a "testing" or "staging" environment -- and they each have their own
specific overrides?

Again, the application environment variable comes to play. We can alter the glob
path in the system configuration slightly:

.. code-block:: php

    'config_glob_paths' => array(
        sprintf('config/autoload/{,*.}{global,%s,local}.php', $env)
    ),

The above will allow you to define an additional set of application
configuration files per environment; furthermore, these will be loaded *only* if
that environment is detected!

As an example, consider the following tree of configuration files::

    config/
        autoload/
            global.php
            local.php
            users.development.php
            users.testing.php
            users.local.php

If ``$env`` evaluates to ``testing``, then the following files will be merged,
in the following order::

    global.php
    users.testing.php
    local.php
    users.local.php

Note that ``users.development.php`` is not loaded -- this is because it will not
match the glob pattern!

Also, because of the order in which they are loaded, you can predict which
values will overwrite the others, allowing you to both selectively overwrite as
well as debug later.

.. note::

    The files under ``config/autoload/`` are merged *after* your module
    configuration, detailed in next section. We have detailed it here, however,
    as setting up the **application configuration** glob path happens within the
    **system configuration** (``config/application.config.php``).

.. _tutorials.config.advanced.module-configuration:

Module Configuration
--------------------

One responsibility of modules is to provide their own configuration to the
application. Modules have two general mechanisms for doing this.

**First**, modules that either implement
``Zend\ModuleManager\Feature\ConfigProviderInterface`` and/or a ``getConfig()``
method can return their configuration. The default, recommended implementation
of the ``getConfig()`` method is:

.. code-block:: php

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

where ``module.config.php`` returns a PHP array. From that PHP array you can provide general configuration as
well as configuration for all the available Manager classes provided by the ServiceManager. Please refer to 
the `Configuration mapping table`_ to see which configuration key is used for each specific Manager.

**Second**, modules can implement a number of interfaces and/or methods related to
specific service manager or plugin manager configuration. You will find an overview of all 
interfaces and their matching Module Configuration functions inside the `Configuration mapping table`_.

All interfaces are in the ``Zend\ModuleManager\Feature`` namespace, and
each is expected to return an array of configuration for a service manager, as
denoted in the :ref:`section on default service configuration
<zend.mvc.services.service-manager-configuration>`.

Configuration mapping table
---------------------------

+------------------------------+---------------------------------------+---------------------------------+------------------------+
| Manager name                 | Interface name                        | Module Method name              | Config key name        |
+==============================+=======================================+=================================+========================+
| ``ControllerPluginManager``  | ``ControllerPluginProviderInterface`` | ``getControllerPluginConfig()`` | ``controller_plugins`` |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``ControllerLoader``         | ``ControllerProviderInterface``       | ``getControllerConfig()``       | ``controllers``        |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``FilterManager``            | ``FilterProviderInterface``           | ``getFilterConfig()``           | ``filters``            |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``FormElementManager``       | ``FormElementProviderInterface``      | ``getFormElementConfig()``      | ``form_elements``      |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``HydratorManager``          | ``HydratorProviderInterface``         | ``getHydratorConfig()``         | ``hydrators``          |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``InputFilterManager``       | ``InputFilterProviderInterface``      | ``getInputFilterConfig()``      | ``input_filters``      |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``RoutePluginManager``       | ``RouteProviderInterface``            | ``getRouteConfig()``            | ``route_manager``      |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``SerializerAdapterManager`` | ``SerializerProviderInterface``       | ``getSerializerConfig()``       | ``serializers``        |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``ServiceLocator``           | ``ServiceProviderInterface``          | ``getServiceConfig()``          | ``service_manager``    |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``ValidatorManager``         | ``ValidatorProviderInterface``        | ``getValidatorConfig()``        | ``validators``         |
+------------------------------+---------------------------------------+---------------------------------+------------------------+
| ``ViewHelperManager``        | ``ViewHelperProviderInterface``       | ``getViewHelperConfig()``       | ``view_helpers``       |
+------------------------------+---------------------------------------+---------------------------------+------------------------+

Configuration Priority
----------------------

Considering that you may have service configuration in your module configuration
file, what has precedence?

The order in which they are merged is:

- configuration returned by ``getConfig()``
- configuration returned by the various service configuration methods in a
  module class

In other words, your various service configuration methods win. Additionally,
and of particular note: the configuration returned from those methods will *not*
be cached. The reason for this is that it is not uncommon to use closures or
factory instances in configuration returned from your ``Module`` class -- which
cannot be cached reliably.

.. note::

    Use the various service configuration methods when you need to define
    closures or instance callbacks for factories, abstract factories, and
    initializers. This prevents caching problems, and also allows you to write
    your configuration files in other markup formats.

.. _tutorials.config.advanced.manipulating-merged-configuration:

Manipulating merged configuration
---------------------------------

Occasionally you will want to not just override an application configuration
key, but actually remove it. Since merging will not remove keys, how can you
handle this?

``Zend\ModuleManager\Listener\ConfigListener`` triggers a special event,
``Zend\ModuleManager\ModuleEvent::EVENT_MERGE_CONFIG``, after merging all
configuration, but prior to it being passed to the ``ServiceManager``. By
listening to this event, you can inspect the merged configuration and manipulate
it.

The ``ConfigListener`` itself listens to the event at priority 1000 (i.e., very
high), which is when the configuration is merged. You can tie into this to
modify the merged configuration from your module, via the ``init()`` method.

.. code-block:: php
    :linenos:

    namespace Foo;

    use Zend\ModuleManager\ModuleEvent;
    use Zend\ModuleManager\ModuleManager;

    class Module
    {
        public function init(ModuleManager $moduleManager)
        {
            $events = $moduleManager->getEventManager();

            // Registering a listener at default priority, 1, which will trigger
            // after the ConfigListener merges config.
            $events->attach(ModuleEvent::EVENT_MERGE_CONFIG, array($this, 'onMergeConfig'));
        }

        public function onMergeConfig(ModuleEvent $e)
        {
            $configListener = $e->getConfigListener();
            $config         = $configListener->getMergedConfig(false);

            // Modify the configuration; here, we'll remove a specific key:
            if (isset($config['some_key'])) {
                unset($config['some_key']);
            }

            // Pass the changed configuration back to the listener:
            $configListener->setMergedConfig($config);
        }
    }

At this point, the merged application configuration will no longer contain the
key ``some_key``.

.. note::

    If a cached config is used by the ``ModuleManager``, the
    ``EVENT_MERGE_CONFIG`` event will not be triggered. However, typically that
    means that what is cached will be what was originally manipulated by your
    listener.

.. _tutorials.config.advanced.workflow:

Configuration merging workflow
------------------------------

To cap off the tutorial, let's review how and when configuration is defined and
merged.

- **System configuration**

  - Defined in ``config/application.config.php``
  - No merging occurs
  - Allows manipulation programmatically, which allows the ability to:

    - Alter flags based on computed values
    - Alter the configuration glob path based on computed values

  - Configuration is passed to the ``Application`` instance, and then the
    ``ModuleManager`` in order to initialize the system.

- **Application configuration**

  - The ``ModuleManager`` loops through each module class in the order defined
    in the **system configuration**

    - Service configuration defined in ``Module`` class methods is aggregated
    - Configuration returned by ``Module::getConfig()`` is aggregated

  - Files detected from the **service configuration** ``config_glob_paths``
    setting are merged, based on the order they resolve in the glob path.
  - ``ConfigListener`` triggers ``EVENT_MERGE_CONFIG``:
    - ``ConfigListener`` merges configuration
    - Any other event listeners manipulate the configuration
  - Merged configuration is finally passed to the ``ServiceManager``
