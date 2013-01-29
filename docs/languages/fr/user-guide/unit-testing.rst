.. _user-guide.unit-testing.rst:

############
Test unitaires
############

Une suite de tests unitaires est essentielle pour un développement de gros
projets, surtout ceux avec beaucoup de personnes impliquées. Revenir en arrière
et tester manuellement chaque composant d'une application après chaque changement
n'est pas envisageable. Vos tests unitaires vont pemettre d'alléger ce processus
en testant automatiquement les composants de votre application et en déclanchant
des alertes quand l'un d'eux ne se comporte pas comme il se comportait au moment
de l'écriture du test.

L'API du Zend Framework 2 utlise `PHPUnit <http://phpunit.de/>`_, tout comme
l'application de ce tutoriel. Une explication détaillée des tests unitaires n'est
pas le but de ce tutoriel, et nous ne fournirons que des exemples de tests pour
les composants des pages suivantes. Ce tutoriel suppose que vous avez déjà
installé PHPUnit.

Configurer le répertoire des tests
------------------------------

Commencez par créer un répertoire appelé ``test`` dans
``zf2-tutorial\module\Application`` avec les sous-dossiers suivants:

.. code-block:: text

    zf2-tutorial/
        /module
            /Application
                /test
                    /ApplicationTest
                        /Controller

La structure du répertoire ``test`` correspond exactement à celle des fichiers
sources du module, et cela va nous permettre d'avoir des tests bien organisés
et facile à trouver.

Bootstrapp des tests
------------------------

Ensuite, nous créons un fichier ``phpunit.xml.dist`` sous ``zf2-tutorial/module/Application/test``:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="Bootstrap.php">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./ApplicationTest</directory>
            </testsuite>
        </testsuites>
    </phpunit>


Un fichier nommé ``Bootstrap.php``, également sous ``zf-tutorial/module/Application/test``:
il s'agit d'un bootstrap écrit par Evan Coury qui peut très bien être ajouté tel
quel, avec juste le besoin de changer l'espace de noms.

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
                foreach ($modulePaths as $modulePath) {
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

Et aussi un fichier TestConfig.php.dist

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

Il s'agit pour l'essentiel du même fichier que config/application.config.php,
mais nous ne définissons que les modules requis pour ce test.

Votre premier test de contrôleur
--------------------------

Esuite, créez ``IndexControllerTest.php`` sous
``zf-tutorial/module/Application/test/ApplicationTest/Controller`` avec le
contenu suivant :

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

Ici, nous renforçons un peu la configuration de
`Unit Testing a ZF 2 Controller <http://devblog.x2k.co.uk/unit-testing-a-zend-framework-2-controller/>`_
extrait du blog de Tom Oram en initialisant notre application dans la méthode
``setUp()`` et alimentant le ``EventManager`` et le ``ServiceLocator``
directement dans le contrôleur. Ce n'est pas très important pour le moment, mais
nous en aurons besoin par la suite pour implémenter des tests plus avancés.

Maintenant, ajoutez la fonction suivante à la classe ``IndexControllerTest``:

.. code-block:: php

    public function testIndexActionCanBeAccessed()
    {
        $this->routeMatch->setParam('action', 'index');

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(200, $response->getStatusCode());
    }

Le test vérifie que la page d'accueil répond avec un code HTTP 200.

Tester
-----------

Enfin, placez vous sur ``zf-tutorial/module/Application/test/`` et exécutez
``phpunit``. Si vous vouyez quelque chose comme ceci, votre application est
prête pour plus de tests !

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 5.75Mb

    OK (1 test, 2 assertions)
