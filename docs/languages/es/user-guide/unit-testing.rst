.. _user-guide.unit-testing.rst:

################
Prueba unitaria
################

Una prueba unitaria sólida es esencial para poner en marcha el
desarrollo de proyectos grandes, especialmente proyectos con muchas
personas involucradas. Regresar y probar manualmente cada componente 
de una aplicación después de cada cambio es muy incómodo. 
La prueba unitaria te ayudara a aligerar esto de forma automática
probando los componentes de tu aplicación y alertándote cuando algo
no está trabajando de la misma forma de cuando lo escribiste y probaste.

El API de Zend Framework 2 usa `PHPUnit <http://phpunit.de/>`_, el cual
usaremos en la aplicación de este tutorial. Una explicación detallada
de una prueba unitaria está mas allá del alcance de este tutorial, por lo que
sólo se proporcionarán pruebas de muestra para los componentes en las páginas
que sigue. Este tutorial asume que ya tienes instalado PHPUnit.

Configuración del directorio de prueba
------------------------------

Hay que crear un directorio llamado ``test`` en ``zf2-tutorial\module\Application`` con
los siguientes subdirectorios:

.. code-block:: text

    zf2-tutorial/
        /module
            /Application
                /test
                    /ApplicationTest
                        /Controller

La estructura del directorio ``test`` coincide exactamente con el de los
archivos fuente de los módulos, lo que permitirá tener las pruebas
bien organizadas y fáciles de encontrar.

 Bootstrapping en la prueba.
-----------------------------

Crea un archivo llamado ``phpunit.xml.dist`` en ``zf2-tutorial/module/Application/test``:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="Bootstrap.php">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./ApplicationTest</directory>
            </testsuite>
        </testsuites>
    </phpunit>


Y un archivo ``Bootstrap.php``, también en ``zf-tutorial/module/Application/test``:
Este es el Bootstrap escrito por Evan Coury, sólo los namespaces necesitan ser cambiados.


.. code-block:: php

    <?php
    namespace ApplicationTest;//Cambia este namespace para tu prueba

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
            // Carga el archivo de prueba de configuración definida por el usuario, si es que existe; de lo contrario, la carga
            if (is_readable(__DIR__ . '/TestConfig.php')) {
                $testConfig = include __DIR__ . '/TestConfig.php';
            } else {
                $testConfig = include __DIR__ . '/TestConfig.php.dist';
            }

            $zf2ModulePaths = array();

            if (isset($testConfig['module_listener_options']['module_paths'])) {
                $modulePaths = $testConfig['module_listener_options']['module_paths'];
                foreach ($modulePaths as $modulePath) {
                    if (($path = static::findParentPath($modulePath)) ) {
                        $zf2ModulePaths[] = $path;
                    }
                }
            }

            $zf2ModulePaths  = implode(PATH_SEPARATOR, $zf2ModulePaths) . PATH_SEPARATOR;
            $zf2ModulePaths .= getenv('ZF2_MODULES_TEST_PATHS') ?: (defined('ZF2_MODULES_TEST_PATHS') ? ZF2_MODULES_TEST_PATHS : '');

            static::initAutoloader();

            // usa el ModuleManager para cargar este modulo y sus dependencias
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

Y crea un archivo llamado ``TestConfig.php.dist``

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

Básicamente es lo mismo que config/application.config.php, pero nosotros definimos sólo los módulos que se requieren en esta prueba.

Primera prueba del controlador
-------------------------------

Crea ``IndexControllerTest.php`` en 
``zf-tutorial/module/Application/test/ApplicationTest/Controller``
con el siguiente contenido.

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

    class IndexControllerTest extends \PHPUnit_Framework_TestCase
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

Aquí, tenemos que ampliar la configuración de Tom Oram en su entrada de blog
`Unit Testing a ZF 2 Controller <http://devblog.x2k.co.uk/unit-testing-a-zend-framework-2-controller/>`_
para inicializar nuestra aplicación con el método ``setUp()`` y
configurar el ``EventManager`` y `ServiceLocator``  directamente en el controlador.
No es importante en este momento, pero lo vamos a necesitar más adelante al escribir 
pruebas más complejas.

Ahora, agregue la siguiente función en la clase ``IndexControllerTest``

.. code-block:: php

    public function testIndexActionCanBeAccessed()
    {
        $this->routeMatch->setParam('action', 'index');

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(200, $response->getStatusCode());
    }

La prueba consiste en verificar que la página principal responda con el código de estado HTTP 200.

Probando
-----------

Finalmente ``cd`` a ``zf-tutorial/module/Application/test/`` y ejecutar ``phpunit``. Si ves algo como
esto, entonces ¡tu aplicación está lista para más pruebas!.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 5.75Mb

    OK (1 test, 2 assertions)
    
