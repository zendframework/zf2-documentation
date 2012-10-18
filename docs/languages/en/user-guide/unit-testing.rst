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
        /tests
            /module
                /Application
                    /src
                        /Application
                            /Controller

The structure of the ``tests`` directory matches exactly with that of the
project's source files, and it will allow you to keep your tests
well-organized and easy to find. Later, you will create the proper
directories to test your models, but right now there is only the
IndexController for the Application module.

Bootstrapping your tests
------------------------

Next, create a file called ``phpunit.xml`` under ``zf-tutorial/tests/``:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="bootstrap.php">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./</directory>
            </testsuite>
        </testsuites>
    </phpunit>


And a file called ``bootstrap.php``, also under ``zf-tutorial/tests/``:

.. code-block:: php

    <?php

    chdir(dirname(__DIR__));

    include __DIR__ . '/../init_autoloader.php';

    ?>

The contents of the bootstrap file are similar to those of
``zf-tutorial/public/index.php``, except we don't initialize the application.
We'll be doing that in our tests to ensure that each test is executed against
a freshly initialized instance of our application without any previous tests
influencing the current test's results.

Your first Controller test
--------------------------

Next, create ``IndexControllerTest.php`` under
``zf-tutorial/tests/module/Application/src/Application/Controller`` with
the following contents:

.. code-block:: php

    <?php

    namespace Application\Controller;

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
            $bootstrap        = \Zend\Mvc\Application::init(include 'config/application.config.php');
            $this->controller = new IndexController();
            $this->request    = new Request();
            $this->routeMatch = new RouteMatch(array('controller' => 'index'));
            $this->event      = $bootstrap->getMvcEvent();
            $this->event->setRouteMatch($this->routeMatch);
            $this->controller->setEvent($this->event);
            $this->controller->setEventManager($bootstrap->getEventManager());
            $this->controller->setServiceLocator($bootstrap->getServiceManager());
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
        $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
    }

The test is verifying that the homepage responds with HTTP status code 200 and
that the controller's return value is an instance of ``Zend\View\Model\ViewModel``.

Testing
-----------

Finally, ``cd`` to ``zf-tutorial/tests/`` and run ``phpunit``. If you see something like
this, then your application is ready for more tests!

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 5.75Mb

    OK (1 test, 2 assertions)
