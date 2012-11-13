.. _user-guide.unit-testing.rst:

############
Unit Testing
############

A solid unit test suite is essential for ongoing development in large
projects, especially those with many people involved. Going back and
manually testing every individual component of an application after
every change is impractical. Your unit tests will help alleviate that
by automatically testing your application's components and alerting
you when something is not working the same way it was when you wrote
your tests.

The Zend Framework 2 API uses `PHPUnit <http://phpunit.de/>`_, and so
does this tutorial application. A detailed explanation of unit testing
is beyond the scope of this tutorial, so we will only provide sample
tests for the components in the pages that follow. This tutorial assumes
that you already have PHPUnit installed.

Setting up the tests directory
------------------------------

Start by creating a directory called ``tests`` in the project root with
the following subdirectories:

.. code-block:: text

    zf2-tutorial/
        /module
            /Application
                /test
                    /ApplicationTest
                        /Controller

The structure of the ``tests`` directory matches exactly with that of the
project's source files, and it will allow you to keep your tests
well-organized and easy to find. Later, you will create the proper
directories to test your models, but right now there is only the
IndexController for the Application module.

Bootstrapping your tests
------------------------

Next, create a file called ``phpunit.xml.dist`` under ``zf2-tutorial/module/Application/test``:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="Bootstrap.php">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./ApplicationTest</directory>
            </testsuite>
        </testsuites>
    </phpunit>


A file called ``Bootstrap.php``, also under ``zf-tutorial/module/Application/test``:
This is a Bootstrap written by Evan Coury which can just be dropped in, only the namespace needs changing.

.. code-block:: php

    <?php
    namespace ApplicationTest;//Change this namespace for your test

    use Zend\Loader\AutoloaderFactory;
    use Zend\Mvc\Service\ServiceManagerConfig;
    use Zend\ServiceManager\ServiceManager;
    use Zend\Stdlib\ArrayUtils;
    use RuntimeException;

    error_reporting(E_ALL | E_STRICT);
    chdir(__DIR__);

    class Bootstrap
    {
        protected static $serviceManager;
        protected static $config;
        protected static $bootstrap;

        public static function init()
        {
            // Load the user-defined test configuration file, if it exists; otherwise, load
            if (is_readable(__DIR__ . '/TestConfig.php')) {
                $testConfig = include __DIR__ . '/TestConfig.php';
            } else {
                $testConfig = include __DIR__ . '/TestConfig.php.dist';
            }

            $zf2ModulePaths = array();

            if (isset($testConfig['module_listener_options']['module_paths'])) {
                $modulePaths = $testConfig['module_listener_options']['module_paths'];
                foreach($modulePaths as $modulePath) {
                    if (($path = static::findParentPath($modulePath)) ) {
                        $zf2ModulePaths[] = $path;
                    }
                }
            }

            $zf2ModulePaths  = implode(PATH_SEPARATOR, $zf2ModulePaths) . PATH_SEPARATOR;
            $zf2ModulePaths .= getenv('ZF2_MODULES_TEST_PATHS') ?: (defined('ZF2_MODULES_TEST_PATHS') ? ZF2_MODULES_TEST_PATHS : '');

            static::initAutoloader();

            // use ModuleManager to load this module and it's dependencies
            $baseConfig = array(
                'module_listener_options' => array(
                    'module_paths' => explode(PATH_SEPARATOR, $zf2ModulePaths),
                ),
            );

            $config = ArrayUtils::merge($baseConfig, $testConfig);

            $serviceManager = new ServiceManager(new ServiceManagerConfig());
            $serviceManager->setService('ApplicationConfig', $config);
            $serviceManager->get('ModuleManager')->loadModules();

            static::$serviceManager = $serviceManager;
            static::$config = $config;
        }

        public static function getServiceManager()
        {
            return static::$serviceManager;
        }

        public static function getConfig()
        {
            return static::$config;
        }

        protected static function initAutoloader()
        {
            $vendorPath = static::findParentPath('vendor');

            if (is_readable($vendorPath . '/autoload.php')) {
                $loader = include $vendorPath . '/autoload.php';
            } else {
                $zf2Path = getenv('ZF2_PATH') ?: (defined('ZF2_PATH') ? ZF2_PATH : (is_dir($vendorPath . '/ZF2/library') ? $vendorPath . '/ZF2/library' : false));

                if (!$zf2Path) {
                    throw new RuntimeException('Unable to load ZF2. Run `php composer.phar install` or define a ZF2_PATH environment variable.');
                }

                include $zf2Path . '/Zend/Loader/AutoloaderFactory.php';

            }

            AutoloaderFactory::factory(array(
                'Zend\Loader\StandardAutoloader' => array(
                    'autoregister_zf' => true,
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/' . __NAMESPACE__,
                    ),
                ),
            ));
        }

        protected static function findParentPath($path)
        {
            $dir = __DIR__;
            $previousDir = '.';
            while (!is_dir($dir . '/' . $path)) {
                $dir = dirname($dir);
                if ($previousDir === $dir) return false;
                $previousDir = $dir;
            }
            return $dir . '/' . $path;
        }
    }

    Bootstrap::init();

And a file called TestConfig.php.dist

.. code-block:: php

    <?php
    return array(
        'modules' => array(
            'Application',
        ),
        'module_listener_options' => array(
            'config_glob_paths'    => array(
                '../../../config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                'module',
                'vendor',
            ),
        ),
    );

This is basically the same as config/application.config.php but we define only the modules which are required for this test

Your first Controller test
--------------------------

Next, create ``IndexControllerTest.php`` under
``zf-tutorial/module/Application/test/ApplicationTest/Controller`` with
the following contents:

.. code-block:: php

    <?php

    namespace ApplicationTest\Controller;

    use ApplicationTest\Bootstrap;
    use Zend\Mvc\Router\Http\TreeRouteStack as HttpRouter;
    use Application\Controller\IndexController;
    use Zend\Http\Request;
    use Zend\Http\Response;
    use Zend\Mvc\MvcEvent;
    use Zend\Mvc\Router\RouteMatch;
    use PHPUnit_Framework_TestCase;

    class IndexControllerTest extends PHPUnit_Framework_TestCase
    {
        protected $controller;
        protected $request;
        protected $response;
        protected $routeMatch;
        protected $event;

        protected function setUp()
        {
            $serviceManager = Bootstrap::getServiceManager();
            $this->controller = new IndexController();
            $this->request    = new Request();
            $this->routeMatch = new RouteMatch(array('controller' => 'index'));
            $this->event      = new MvcEvent();
            $config = $serviceManager->get('Config');
            $routerConfig = isset($config['router']) ? $config['router'] : array();
            $router = HttpRouter::factory($routerConfig);

            $this->event->setRouter($router);
            $this->event->setRouteMatch($this->routeMatch);
            $this->controller->setEvent($this->event);
            $this->controller->setServiceLocator($serviceManager);
        }
    }

Here, we expand a bit on the setup in Tom Oram's
`Unit Testing a ZF 2 Controller <http://devblog.x2k.co.uk/unit-testing-a-zend-framework-2-controller/>`_
blog entry by initializing our application in the ``setUp()`` method and
setting the ``EventManager`` and ``ServiceLocator`` directly on the controller.
This isn't important right now, but we'll need it later on when writing more
advanced tests.

Now, add the following function to the ``IndexControllerTest`` class:

.. code-block:: php

    public function testIndexActionCanBeAccessed()
    {
        $this->routeMatch->setParam('action', 'index');

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(200, $response->getStatusCode());
    }

The test is verifying that the homepage responds with HTTP status code 200 and
that the controller's return value is an instance of ``Zend\View\Model\ViewModel``.

Testing
-----------

Finally, ``cd`` to ``zf-tutorial/module/Application/test/`` and run ``phpunit``. If you see something like
this, then your application is ready for more tests!

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 5.75Mb

    OK (1 test, 2 assertions)
