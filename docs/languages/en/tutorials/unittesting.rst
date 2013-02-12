.. _tutorials.unittesting.rst:

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

As the Zend Framework 2 API uses `PHPUnit <http://phpunit.de/>`_, so
will this tutorial. A detailed explanation of unit testing
is beyond the scope of this tutorial, so we will only provide sample
tests for the components in the pages that follow. This tutorial assumes
that you already have PHPUnit installed. The version of PHPUnit should be
3.7.*

Setting up the tests directory
------------------------------

Start by creating a directory called ``test`` in ``zf2-tutorial\module\Application`` with
the following subdirectories:

.. code-block:: text

    zf2-tutorial/
        /module
            /Application
                /test
                    /ApplicationTest
                        /Controller

The structure of the ``test`` directory matches exactly with that of the
module's source files, and it will allow you to keep your tests
well-organized and easy to find.

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


And a file called ``Bootstrap.php``, also under zf-tutorial/tests/:

.. code-block:: php

    chdir(dirname(__DIR__));

    include __DIR__ . '/../init_autoloader.php';

The contents of the bootstrap file are similar to those of zf-tutorial/public/index.php, except 
we don’t initialize the application. We’ll be doing that in our tests to ensure that each test 
is executed against a freshly initialized instance of our application without any previous tests 
influencing the current test’s results.

Your first Controller test
--------------------------

Next, create ``IndexControllerTest.php`` under
``zf-tutorial/module/Application/test/ApplicationTest/Controller`` with
the following contents:

.. code-block:: php

    <?php

    namespace ApplicationTest\Controller;

    use Zend\Test\PHPUnit\Controller\AbstractHttpControllerTestCase;

    class IndexControllerTest extends AbstractHttpControllerTestCase
    {
        public function setUp()
        {
            $this->setApplicationConfig(
                include '/path/to/application/config/test/application.config.php'
            );
            parent::setUp();
        }
    }

Add your application config with the ``setApplicationConfig`` method. You can use several config 
to test modules dependencies or your current application config.

Now, add the following function to the ``IndexControllerTest`` class:

.. code-block:: php

    public function testIndexActionCanBeAccessed()
    {
        $this->dispatch('/');
        $this->assertResponseStatusCode(200);

        $this->assertModule('application');
        $this->assertControllerName('application_index');
        $this->assertControllerClass('IndexController');
        $this->assertMatchedRouteName('home');
    }

The test is verifying that the homepage responds with HTTP status code 200 and
that the controller's return value is equal to 'IndexController'.

Testing
-----------

Finally, ``cd`` to ``zf-tutorial/module/Application/test/`` and run ``phpunit``. If you see something like
this, then your application is ready for more tests!

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 15.75Mb

    OK (1 test, 5 assertions)


Test your console router
--------------------------

Zend\Test component provide a HTTP controller tests case and a console controller. To test your application 
with the console, just switch with the AbstractConsoleControllerTestCaseTest. Now, you can use the same methods 
in your tests controllers :

.. code-block:: php

    public function testConsoleActionCanBeAccessed()
    {
        $this->dispatch('--your-arg');
        $this->assertResponseStatusCode(0);

        $this->assertModule('application');
        $this->assertControllerName('application_console');
        $this->assertControllerClass('ConsoleController');
        $this->assertMatchedRouteName('myaction');
    }

More informations at the ``Zend\Test`` component documentation page.


Write the tests
---------------

Our Album controller doesn't do much yet, so it should be easy to test.

Create a directory structure like described in the previous section `Unit Testing<http://framework.zend.com/manual/2.0/en/user-guide/routing-and-controllers.html/>

Create the follwing subdirectories:

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /test
                    /AlbumTest
                        /Controller


Add the 3 files as described in unit Testing to ``module/Album/test
* ``Bootstrap.php``
* ``phpunit.xml.dist``
* ``TestConfig.php.dist``

Remember here to change the namespace in ``Bootstrap.php`` and change the Module ``Application`` to ``Album in the ``TestConfig.php.dist``.
In phpunit.xml change the directory to point at `AlbumTest`

Create ``zf2-tutorial/module/Album/test/AlbumTest/Controller/AlbumControllerTest.php```
with the following contents:

.. code-block:: php

    <?php
    namespace AlbumTest\Controller;

    use AlbumTest\Bootstrap;
    use Album\Controller\AlbumController;
    use Zend\Http\Request;
    use Zend\Http\Response;
    use Zend\Mvc\MvcEvent;
    use Zend\Mvc\Router\RouteMatch;
    use Zend\Mvc\Router\Http\TreeRouteStack as HttpRouter;
    use PHPUnit_Framework_TestCase;

    class AlbumControllerTest extends PHPUnit_Framework_TestCase
    {
        protected $controller;
        protected $request;
        protected $response;
        protected $routeMatch;
        protected $event;

        protected function setUp()
        {
            $serviceManager = Bootstrap::getServiceManager();
            $this->controller = new AlbumController();
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

        public function testAddActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'add');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
        }

        public function testDeleteActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'delete');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
        }

        public function testEditActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'edit');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
        }

        public function testIndexActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'index');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
        }
    }

And execute ``phpunit`` from ``module/Album/test``.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .....

    Time: 0 seconds, Memory: 5.75Mb

    OK (5 tests, 10 assertions)






But first, does the Album model we have so far work the way we expect it to? Let's write a few tests to be sure.
Create a file called ``AlbumTest.php`` under ``module/Album/test/AlbumTest/Model``:


.. code-block:: php

    <?php
    namespace AlbumTest\Model;

    use Album\Model\Album;
    use PHPUnit_Framework_TestCase;

    class AlbumTest extends PHPUnit_Framework_TestCase
    {
        public function testAlbumInitialState()
        {
            $album = new Album();

            $this->assertNull($album->artist, '"artist" should initially be null');
            $this->assertNull($album->id, '"id" should initially be null');
            $this->assertNull($album->title, '"title" should initially be null');
        }

        public function testExchangeArraySetsPropertiesCorrectly()
        {
            $album = new Album();
            $data  = array('artist' => 'some artist',
                           'id'     => 123,
                           'title'  => 'some title');

            $album->exchangeArray($data);

            $this->assertSame($data['artist'], $album->artist, '"artist" was not set correctly');
            $this->assertSame($data['id'], $album->id, '"id" was not set correctly');
            $this->assertSame($data['title'], $album->title, '"title" was not set correctly');
        }

        public function testExchangeArraySetsPropertiesToNullIfKeysAreNotPresent()
        {
            $album = new Album();

            $album->exchangeArray(array('artist' => 'some artist',
                                        'id'     => 123,
                                        'title'  => 'some title'));
            $album->exchangeArray(array());

            $this->assertNull($album->artist, '"artist" should have defaulted to null');
            $this->assertNull($album->id, '"id" should have defaulted to null');
            $this->assertNull($album->title, '"title" should have defaulted to null');
        }
    }

We are testing for 3 things:

1. Are all of the Album's properties initially set to NULL?
2. Will the Album's properties be set correctly when we call ``exchangeArray()``?
3. Will a default value of NULL be used for properties whose keys are not present in the ``$data`` array?

If we run ``phpunit`` again, we'll see that the answer to all three questions is "YES":

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ........

    Time: 0 seconds, Memory: 5.50Mb

    OK (8 tests, 19 assertions)



Testing
-------

Let's write a few tests for all this code we've just written. First, we need
to create a test class for the ``AlbumTable``.
Create a file ``AlbumTableTest.php`` in ``module/Album/test/AlbumTest/Model``

.. code-block:: php

    <?php
    namespace AlbumTest\Model;

    use Album\Model\AlbumTable;
    use Album\Model\Album;
    use Zend\Db\ResultSet\ResultSet;
    use PHPUnit_Framework_TestCase;

    class AlbumTableTest extends PHPUnit_Framework_TestCase
    {
        public function testFetchAllReturnsAllAlbums()
        {
            $resultSet        = new ResultSet();
            $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway',
                                               array('select'), array(), '', false);
            $mockTableGateway->expects($this->once())
                             ->method('select')
                             ->with()
                             ->will($this->returnValue($resultSet));

            $albumTable = new AlbumTable($mockTableGateway);

            $this->assertSame($resultSet, $albumTable->fetchAll());
        }
    }


In this test, we introduce the concept of `Mock objects
<http://www.phpunit.de/manual/3.6/en/test-doubles.html#test-doubles.mock-objects>`_.
A thorough explanation of what a Mock object is goes beyond the scope of this tutorial,
but it's basically an object that takes the place of another object and behaves in
a predefined way. Since we are testing the ``AlbumTable`` here and NOT the ``TableGateway``
class (the Zend team has already tested the ``TableGateway`` class and we know it works),
we just want to make sure that our ``AlbumTable`` class is interacting with the ``TableGatway``
class the way that we expect it to. Above, we're testing to see if the ``fetchAll()`` method
of ``AlbumTable`` will call the ``select()`` method of the ``$tableGateway`` property with
no parameters. If it does, it should return a ``ResultSet`` object. Finally, we expect that
this same ``ResultSet`` object will be returned to the calling method. This test should run
fine, so now we can add the rest of the test methods:

.. code-block:: php

    public function testCanRetrieveAnAlbumByItsId()
    {
        $album = new Album();
        $album->exchangeArray(array('id'     => 123,
                                    'artist' => 'The Military Wives',
                                    'title'  => 'In My Dreams'));

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('select'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        $this->assertSame($album, $albumTable->getAlbum(123));
    }

    public function testCanDeleteAnAlbumByItsId()
    {
        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('delete'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('delete')
                         ->with(array('id' => 123));

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->deleteAlbum(123);
    }

    public function testSaveAlbumWillInsertNewAlbumsIfTheyDontAlreadyHaveAnId()
    {
        $albumData = array('artist' => 'The Military Wives', 'title' => 'In My Dreams');
        $album     = new Album();
        $album->exchangeArray($albumData);

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('insert'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('insert')
                         ->with($albumData);

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testSaveAlbumWillUpdateExistingAlbumsIfTheyAlreadyHaveAnId()
    {
        $albumData = array('id' => 123, 'artist' => 'The Military Wives', 'title' => 'In My Dreams');
        $album     = new Album();
        $album->exchangeArray($albumData);

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway',
                                           array('select', 'update'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));
        $mockTableGateway->expects($this->once())
                         ->method('update')
                         ->with(array('artist' => 'The Military Wives', 'title' => 'In My Dreams'),
                                array('id' => 123));

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testExceptionIsThrownWhenGettingNonexistentAlbum()
    {
        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array());

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('select'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        try
        {
            $albumTable->getAlbum(123);
        }
        catch (\Exception $e)
        {
            $this->assertSame('Could not find row 123', $e->getMessage());
            return;
        }

        $this->fail('Expected exception was not thrown');
    }

Let's review our tests. We are testing that:

1. We can retrieve an individual album by its ID.
2. We can delete albums.
3. We can save new album.
4. We can update existing albums.
5. We will encounter an exception if we're trying to retrieve an album that doesn't exist.

Great - our ``AlbumTable`` class is tested. Let's move on!

Let's make sure it works by writing a test.

Add this test to your ``AlbumControllerTest`` class:

.. code-block:: php

    public function testGetAlbumTableReturnsAnInstanceOfAlbumTable()
    {
        $this->assertInstanceOf('Album\Model\AlbumTable', $this->controller->getAlbumTable());
    }

And execute ``phpunit`` from ``module/Album/test``.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ..............

    Time: 1 seconds, Memory: 12.25Mb

    OK (14 tests, 23 assertions)

And execute ``phpunit`` from ``module/Album/test``.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ...F...........

    Time: 1 second, Memory: 13.00Mb

    There was 1 failure:

    1) AlbumTest\Controller\AlbumControllerTest::testEditActionCanBeAccessed
    Failed asserting that 302 matches expected 200.

    /var/www/tutorial/module/Album/test/AlbumTest/Controller/AlbumControllerTest.php:65

    FAILURES!
    Tests: 14, Assertions: 23, Failures: 1.

We need to change the test for edit 'AlbumControllerTest'  in ``module/Album/test/AlbumTest/Controller`` :

.. code-block:: php

    <?php
    ...
    public function testEditActionCanBeAccessed()
    {
        $this->routeMatch->setParam('action', 'edit');
        $this->routeMatch->setParam('id', '1');//Add this Row

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(200, $response->getStatusCode());
    }

If we do not send any ``id`` parameter the Controller will redirect us to the ``album`` route which returns the HTTP Status Code ``302``

We will also add another test to check if the redirection works.
Add the following also to ``AlbumControllerTest.php``

.. code-block:: php

    <?php
    ...
    public function testEditActionRedirect()
    {
        $this->routeMatch->setParam('action', 'edit');

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(302, $response->getStatusCode());
    }

And execute ``phpunit`` from ``module/Album/test``.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ...............

    Time: 1 second, Memory: 13.00Mb


    OK (15 tests, 24 assertions)

Modify the tests in ``AlbumControllerTest.php`` in ``module/Album/test/AlbumTest/Controller``:

.. code-block:: php

        public function testDeleteActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'delete');
            $this->routeMatch->setParam('id', '1');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
        }

        public function testDeleteActionRedirect()
        {
            $this->routeMatch->setParam('action', 'delete');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(302, $response->getStatusCode());
        }


