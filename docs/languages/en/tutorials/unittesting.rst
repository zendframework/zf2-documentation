.. _tutorials.unittesting.rst:

Unit Testing a Zend Framework 2 application
===========================================

A solid unit test suite is essential for ongoing development in large
projects, especially those with many people involved. Going back and
manually testing every individual component of an application after
every change is impractical. Your unit tests will help alleviate that
by automatically testing your application's components and alerting
you when something is not working the same way it was when you wrote
your tests.

This tutorial is written in the hopes of showing how to test different
parts of a Zend Framework 2 MVC application. As such, this tutorial
will use the application written in the :ref:`getting started
user guide <user-guide.overview>`. It is in no way a guide to
unit testing in general, but is here only to help overcome the
initial hurdles in writing unit tests for ZF2 applications.

It is recommended to have at least a basic understanding of unit
tests, assertions and mocks.

As the Zend Framework 2 API uses `PHPUnit <http://phpunit.de/>`_, so
will this tutorial. This tutorial assumes that you already have PHPUnit
installed. The version of PHPUnit used should be 3.7.*

.. _setting-up-the-tests-directory:

Setting up the tests directory
------------------------------

As Zend Framework 2 applications are built from modules that should be
standalone blocks of an application, we don't test the application in
it's entirety, but module by module.

We will show how to set up the minimum requirements to test a module,
the ``Album`` module we wrote in the user guide, and which then can be
used as a base for testing any other module.

Start by creating a directory called ``test`` in ``zf2-tutorial\module\Album`` with
the following subdirectories:

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /test
                    /AlbumTest
                        /Controller

The structure of the ``test`` directory matches exactly with that of the
module's source files, and it will allow you to keep your tests
well-organized and easy to find.

.. _bootstrapping-your-tests:

Bootstrapping your tests
------------------------

Next, create a file called ``phpunit.xml`` under ``zf2-tutorial/module/Album/test``:

.. code-block:: xml
    :linenos:

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="Bootstrap.php" colors="true">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./AlbumTest</directory>
            </testsuite>
        </testsuites>
    </phpunit>

And a file called ``Bootstrap.php``, also under ``zf2-tutorial/module/Album/test``:

.. code-block:: php
    :linenos:
    :emphasize-lines: 38

    <?php

    namespace AlbumTest;

    use Zend\Loader\AutoloaderFactory;
    use Zend\Mvc\Service\ServiceManagerConfig;
    use Zend\ServiceManager\ServiceManager;
    use RuntimeException;

    error_reporting(E_ALL | E_STRICT);
    chdir(__DIR__);

    /**
     * Test bootstrap, for setting up autoloading
     */
    class Bootstrap
    {
        protected static $serviceManager;

        public static function init()
        {
            $zf2ModulePaths = array(dirname(dirname(__DIR__)));
            if (($path = static::findParentPath('vendor'))) {
                $zf2ModulePaths[] = $path;
            }
            if (($path = static::findParentPath('module')) !== $zf2ModulePaths[0]) {
                $zf2ModulePaths[] = $path;
            }

            static::initAutoloader();

            // use ModuleManager to load this module and it's dependencies
            $config = array(
                'module_listener_options' => array(
                    'module_paths' => $zf2ModulePaths,
                ),
                'modules' => array(
                    'Album'
                )
            );

            $serviceManager = new ServiceManager(new ServiceManagerConfig());
            $serviceManager->setService('ApplicationConfig', $config);
            $serviceManager->get('ModuleManager')->loadModules();
            static::$serviceManager = $serviceManager;
        }
        
        public static function chroot()
        {
            $rootPath = dirname(static::findParentPath('module'));
            chdir($rootPath);
        }
        
        public static function getServiceManager()
        {
            return static::$serviceManager;
        }

        protected static function initAutoloader()
        {
            $vendorPath = static::findParentPath('vendor');

            $zf2Path = getenv('ZF2_PATH');
            if (!$zf2Path) {
                if (defined('ZF2_PATH')) {
                    $zf2Path = ZF2_PATH;
                } elseif (is_dir($vendorPath . '/ZF2/library')) {
                    $zf2Path = $vendorPath . '/ZF2/library';
                } elseif (is_dir($vendorPath . '/zendframework/zendframework/library')) {
                    $zf2Path = $vendorPath . '/zendframework/zendframework/library';
                }
            }

            if (!$zf2Path) {
                throw new RuntimeException(
                    'Unable to load ZF2. Run `php composer.phar install` or'
                    . ' define a ZF2_PATH environment variable.'
                );
            }
            
            if (file_exists($vendorPath . '/autoload.php')) {
                include $vendorPath . '/autoload.php';
            }

            include $zf2Path . '/Zend/Loader/AutoloaderFactory.php';
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
                if ($previousDir === $dir) {
                    return false;
                }
                $previousDir = $dir;
            }
            return $dir . '/' . $path;
        }
    }

    Bootstrap::init();
    Bootstrap::chroot();

The contents of this bootstrap file can be daunting at first sight, but all it
really does is ensuring that all the necessary files are autoloadable for our
tests. The most important lines is line 38 on which we say what
modules we want to load for our test. In this case we are only loading the
``Album`` module as it has no dependencies against other modules.

Now, if you navigate to the ``zf2-tutorial/module/Album/test/`` directory,
and run ``phpunit``, you should get a similar output to this:

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /var/www/zf2-tutorial/module/Album/test/phpunit.xml

    Time: 0 seconds, Memory: 1.75Mb

    No tests executed!


Even though no tests were executed, we at least know that the autoloader found the
ZF2 files, otherwise it would throw a ``RuntimeException``, defined on line 69 of
our bootstrap file.

.. _your-first-controller-test:

Your first controller test
--------------------------

Testing controllers is never an easy task, but Zend Framework 2 comes
with the ``Zend\Test`` component which should make testing much less
cumbersome.

First, create ``AlbumControllerTest.php`` under
``zf2-tutorial/module/Album/test/AlbumTest/Controller`` with
the following contents:

.. code-block:: php
    :linenos:

    <?php

    namespace AlbumTest\Controller;

    use Zend\Test\PHPUnit\Controller\AbstractHttpControllerTestCase;

    class AlbumControllerTest extends AbstractHttpControllerTestCase
    {
        public function setUp()
        {
            $this->setApplicationConfig(
                include '/var/www/zf2-tutorial/config/application.config.php'
            );
            parent::setUp();
        }
    }

The ``AbstractHttpControllerTestCase`` class we extend here helps us setting up the
application itself, helps with dispatching and other tasks that happen during a request,
as well offers methods for asserting request params, response headers, redirects and more.
See :ref:`Zend\\Test <zend.test.introduction>` documentation for more.

One thing that is needed is to set the application config with the ``setApplicationConfig``
method.

Now, add the following function to the ``AlbumControllerTest`` class:

.. code-block:: php
    :linenos:

    public function testIndexActionCanBeAccessed()
    {
        $this->dispatch('/album');
        $this->assertResponseStatusCode(200);

        $this->assertModuleName('Album');
        $this->assertControllerName('Album\Controller\Album');
        $this->assertControllerClass('AlbumController');
        $this->assertMatchedRouteName('album');
    }

This test case dispatches the ``/album`` URL, asserts that the response code is 200,
and that we ended up in the desired module and controller.

.. note::
    For asserting the *controller name* we are using the controller name we defined in our
    routing configuration for the Album module. In our example this should be defined on line
    19 of the ``module.config.php`` file in the Album module.

.. _a-failing-test-case:

A failing test case
-------------------

Finally, ``cd`` to ``zf2-tutorial/module/Album/test/`` and run ``phpunit``. Uh-oh! The test
failed!

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /var/www/zf2-tutorial/module/Album/test/phpunit.xml

    F

    Time: 0 seconds, Memory: 8.50Mb

    There was 1 failure:

    1) AlbumTest\Controller\AlbumControllerTest::testIndexActionCanBeAccessed
    Failed asserting response code "200", actual status code is "500"

    /var/www/zf2-tutorial/vendor/ZF2/library/Zend/Test/PHPUnit/Controller/AbstractControllerTestCase.php:373
    /var/www/zf2-tutorial/module/Album/test/AlbumTest/Controller/AlbumControllerTest.php:22

    FAILURES!
    Tests: 1, Assertions: 0, Failures: 1.

The failure message doesn't tell us much, apart from that the expected status code
is not 200, but 500. To get a bit more information when something goes wrong in a
test case, we set the protected ``$traceError`` member to ``true``. Add the following
just above the ``setUp`` method in our ``AlbumControllerTest`` class:

.. code-block:: php
    :linenos:

    protected $traceError = true;


Running the ``phpunit`` command again and we should see some more information about
what went wrong in our test. The main error message we are interested in should read
something like:

.. code-block:: text

    Zend\ServiceManager\Exception\ServiceNotFoundException: Zend\ServiceManager\ServiceManager::get
    was unable to fetch or create an instance for Zend\Db\Adapter\Adapter

From this error message it is clear that not all our dependencies are available in the
service manager. Let us take a look how can we fix this.

.. _configuring-the-service-manager-for-the-tests:

Configuring the service manager for the tests
---------------------------------------------

The error says that the service manager can not create an instance of a database adapter
for us. The database adapter is indirectly used by our ``Album\Model\AlbumTable`` to
fetch the list of albums from the database.

The first thought would be to create an instance of an adapter, pass it to the
service manager and let the code run from there as is. The problem with this approach
is that we would end up with our test cases actually doing queries against the database.
To keep our tests fast, and to reduce the number of possible failure points in our tests,
this should be avoided.

The second thought would be then to create a mock of the database adapter, and prevent
the actual database calls by mocking them out. This is a much better approach, but creating
the adapter mock is tedious (but no doubt we will have to create it at one point).

The best thing to do would be to mock out our ``Album\Model\AlbumTable`` class which
retrieves the list of albums from the database. Remember, we are now testing our controller,
so we can mock out the actual call to ``fetchAll`` and replace the return values with
dummy values. At this point, we are not interested in how ``fetchAll`` retrieves the
albums, but only that it gets called and that it returns an array of albums, so that is
why we can get away with this mocking. When we will test ``AlbumTable`` itself,
then we will write the actual tests for the ``fetchAll`` method.

Here is how we can accomplish this, by modifying the ``testIndexActionCanBeAccessed``
test method as follows:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3-13

    public function testIndexActionCanBeAccessed()
    {
        $albumTableMock = $this->getMockBuilder('Album\Model\AlbumTable')
                                ->disableOriginalConstructor()
                                ->getMock();

        $albumTableMock->expects($this->once())
                        ->method('fetchAll')
                        ->will($this->returnValue(array()));

        $serviceManager = $this->getApplicationServiceLocator();
        $serviceManager->setAllowOverride(true);
        $serviceManager->setService('Album\Model\AlbumTable', $albumTableMock);

        $this->dispatch('/album');
        $this->assertResponseStatusCode(200);

        $this->assertModuleName('Album');
        $this->assertControllerName('Album\Controller\Album');
        $this->assertControllerClass('AlbumController');
        $this->assertMatchedRouteName('album');
    }

By default, the Service Manager does not allow us to replace existing services. As the
``Album\Model\AlbumTable`` was already set, we are allowing for overrides (line 12), and then
replacing the real instance of the `AlbumTable` with a mock. The mock is created so that it
will return just an empty array when the ``fetchAll`` method is called. This allows us to
test for what we care about in this test, and that is that by dispatching to the ``/album``
URL we get to the `Album` module's `AlbumController`.

Running the ``phpunit`` command at this point, we will get the following output as the
tests now pass:

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /var/www/zf2-tutorial/module/Album/test/phpunit.xml

    .

    Time: 0 seconds, Memory: 9.00Mb

    OK (1 test, 6 assertions)

.. _testing-actions-with-post:

Testing actions with POST
-------------------------

One of the most common actions happening in controllers is submitting a form
with some POST data. Testing this is surprisingly easy:

.. code-block:: php
    :linenos:

    public function testAddActionRedirectsAfterValidPost()
    {
        $albumTableMock = $this->getMockBuilder('Album\Model\AlbumTable')
                                ->disableOriginalConstructor()
                                ->getMock();

        $albumTableMock->expects($this->once())
                        ->method('saveAlbum')
                        ->will($this->returnValue(null));

        $serviceManager = $this->getApplicationServiceLocator();
        $serviceManager->setAllowOverride(true);
        $serviceManager->setService('Album\Model\AlbumTable', $albumTableMock);

        $postData = array(
            'title'  => 'Led Zeppelin III',
            'artist' => 'Led Zeppelin',
        );
        $this->dispatch('/album/add', 'POST', $postData);
        $this->assertResponseStatusCode(302);

        $this->assertRedirectTo('/album');
    }

Here we test that when we make a POST request against the ``/album/add`` URL, the
``Album\Model\AlbumTable``'s ``saveAlbum`` will be called and after that we will
be redirected back to the ``/album`` URL.

Running ``phpunit`` gives us the following output:

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /home/robert/www/zf2-tutorial/module/Album/test/phpunit.xml

    ..

    Time: 0 seconds, Memory: 10.75Mb

    OK (2 tests, 9 assertions)


Testing the ``editAction`` and ``deleteAction`` methods can be easily done in a manner similar
as shown for the ``addAction``.

When testing the editAction you will also need to mock out the ``getAlbum`` method:
    
.. code-block:: php
    :linenos:

    $albumTableMock->expects($this->once())
        ->method('getAlbum')
        ->will($this->returnValue(new \Album\Model\Album()));


.. _testing-model-entities:

Testing model entities
----------------------

Now that we know how to test our controllers, let us move to an other important part of our
application - the model entity.

Here we want to test that the initial state of the entity is what we expect it to be,
that we can convert the model's parameters to and from an array, and that it has all
the input filters we need.

Create the file ``AlbumTest.php`` in ``module/Album/test/AlbumTest/Model`` directory
with the following contents:

.. code-block:: php
    :linenos:

    <?php
    namespace AlbumTest\Model;

    use Album\Model\Album;
    use PHPUnit_Framework_TestCase;

    class AlbumTest extends PHPUnit_Framework_TestCase
    {
        public function testAlbumInitialState()
        {
            $album = new Album();

            $this->assertNull(
                $album->artist,
                '"artist" should initially be null'
            );
            $this->assertNull(
                $album->id,
                '"id" should initially be null'
            );
            $this->assertNull(
                $album->title,
                '"title" should initially be null'
            );
        }

        public function testExchangeArraySetsPropertiesCorrectly()
        {
            $album = new Album();
            $data  = array('artist' => 'some artist',
                           'id'     => 123,
                           'title'  => 'some title');

            $album->exchangeArray($data);

            $this->assertSame(
                $data['artist'],
                $album->artist,
                '"artist" was not set correctly'
            );
            $this->assertSame(
                $data['id'],
                $album->id,
                '"id" was not set correctly'
            );
            $this->assertSame(
                $data['title'],
                $album->title,
                '"title" was not set correctly'
            );
        }

        public function testExchangeArraySetsPropertiesToNullIfKeysAreNotPresent()
        {
            $album = new Album();

            $album->exchangeArray(array('artist' => 'some artist',
                                        'id'     => 123,
                                        'title'  => 'some title'));
            $album->exchangeArray(array());

            $this->assertNull(
                $album->artist, '"artist" should have defaulted to null'
            );
            $this->assertNull(
                $album->id, '"id" should have defaulted to null'
            );
            $this->assertNull(
                $album->title, '"title" should have defaulted to null'
            );
        }

        public function testGetArrayCopyReturnsAnArrayWithPropertyValues()
        {
            $album = new Album();
            $data  = array('artist' => 'some artist',
                           'id'     => 123,
                           'title'  => 'some title');

            $album->exchangeArray($data);
            $copyArray = $album->getArrayCopy();

            $this->assertSame(
                $data['artist'],
                $copyArray['artist'],
                '"artist" was not set correctly'
            );
            $this->assertSame(
                $data['id'],
                $copyArray['id'],
                '"id" was not set correctly'
            );
            $this->assertSame(
                $data['title'],
                $copyArray['title'],
                '"title" was not set correctly'
            );
        }

        public function testInputFiltersAreSetCorrectly()
        {
            $album = new Album();

            $inputFilter = $album->getInputFilter();

            $this->assertSame(3, $inputFilter->count());
            $this->assertTrue($inputFilter->has('artist'));
            $this->assertTrue($inputFilter->has('id'));
            $this->assertTrue($inputFilter->has('title'));
        }
    }

We are testing for 5 things:

1. Are all of the Album's properties initially set to NULL?
2. Will the Album's properties be set correctly when we call ``exchangeArray()``?
3. Will a default value of NULL be used for properties whose keys are not present in the ``$data`` array?
4. Can we get an array copy of our model?
5. Do all elements have input filters present?

If we run ``phpunit`` again, we will get the following output, confirming that our model is
indeed correct:

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /var/www/zf2-tutorial/module/Album/test/phpunit.xml

    .......

    Time: 0 seconds, Memory: 11.00Mb

    OK (7 tests, 25 assertions)

.. _testing-model-tables:

Testing model tables
--------------------

The final step in this unit testing tutorial for Zend Framework 2 applications
is writing tests for our model tables.

This test assures that we can get a list of albums, or one album by it's ID,
and that we can save and delete albums from the database.

To avoid actual interaction with the database itself, we will replace certain
parts with `mocks`.

Create a file ``AlbumTableTest.php`` in ``module/Album/test/AlbumTest/Model``
with the following contents:

.. code-block:: php
    :linenos:

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
            $resultSet = new ResultSet();
            $mockTableGateway = $this->getMock(
                'Zend\Db\TableGateway\TableGateway',
                array('select'),
                array(),
                '',
                false
            );
            $mockTableGateway->expects($this->once())
                             ->method('select')
                             ->with()
                             ->will($this->returnValue($resultSet));

            $albumTable = new AlbumTable($mockTableGateway);

            $this->assertSame($resultSet, $albumTable->fetchAll());
        }
    }


Since we are testing the ``AlbumTable`` here and not the ``TableGateway``
class (which has already been tested in Zend Framework),
we just want to make sure that our ``AlbumTable`` class is interacting with the ``TableGateway``
class the way that we expect it to. Above, we're testing to see if the ``fetchAll()`` method
of ``AlbumTable`` will call the ``select()`` method of the ``$tableGateway`` property with
no parameters. If it does, it should return a ``ResultSet`` object. Finally, we expect that
this same ``ResultSet`` object will be returned to the calling method. This test should run
fine, so now we can add the rest of the test methods:

.. code-block:: php
    :linenos:

    public function testCanRetrieveAnAlbumByItsId()
    {
        $album = new Album();
        $album->exchangeArray(array('id'     => 123,
                                    'artist' => 'The Military Wives',
                                    'title'  => 'In My Dreams'));

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock(
            'Zend\Db\TableGateway\TableGateway',
            array('select'),
            array(),
            '',
            false
        );
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        $this->assertSame($album, $albumTable->getAlbum(123));
    }

    public function testCanDeleteAnAlbumByItsId()
    {
        $mockTableGateway = $this->getMock(
            'Zend\Db\TableGateway\TableGateway',
            array('delete'),
            array(),
            '',
            false
        );
        $mockTableGateway->expects($this->once())
                         ->method('delete')
                         ->with(array('id' => 123));

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->deleteAlbum(123);
    }

    public function testSaveAlbumWillInsertNewAlbumsIfTheyDontAlreadyHaveAnId()
    {
        $albumData = array(
            'artist' => 'The Military Wives',
            'title'  => 'In My Dreams'
        );
        $album     = new Album();
        $album->exchangeArray($albumData);

        $mockTableGateway = $this->getMock(
            'Zend\Db\TableGateway\TableGateway',
            array('insert'),
            array(),
            '',
            false
        );
        $mockTableGateway->expects($this->once())
                         ->method('insert')
                         ->with($albumData);

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testSaveAlbumWillUpdateExistingAlbumsIfTheyAlreadyHaveAnId()
    {
        $albumData = array(
            'id'     => 123,
            'artist' => 'The Military Wives',
            'title'  => 'In My Dreams',
        );
        $album     = new Album();
        $album->exchangeArray($albumData);

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock(
            'Zend\Db\TableGateway\TableGateway',
            array('select', 'update'),
            array(),
            '',
            false
        );
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));
        $mockTableGateway->expects($this->once())
                         ->method('update')
                         ->with(
                            array(
                                'artist' => 'The Military Wives',
                                'title'  => 'In My Dreams'
                            ),
                            array('id' => 123)
                         );

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testExceptionIsThrownWhenGettingNonExistentAlbum()
    {
        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array());

        $mockTableGateway = $this->getMock(
            'Zend\Db\TableGateway\TableGateway',
            array('select'),
            array(),
            '',
            false
        );
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        try {
            $albumTable->getAlbum(123);
        }
        catch (\Exception $e) {
            $this->assertSame('Could not find row 123', $e->getMessage());
            return;
        }

        $this->fail('Expected exception was not thrown');
    }

These tests are nothing complicated and they should be self explanatory. In each test
we are injecting a mock table gateway into our ``AlbumTable`` and set our expectations
accordingly.

We are testing that:

1. We can retrieve an individual album by its ID.
2. We can delete albums.
3. We can save new album.
4. We can update existing albums.
5. We will encounter an exception if we're trying to retrieve an album that doesn't exist.

Running ``phpunit`` command for one last time, we get the output as follows:

.. code-block:: text

    PHPUnit 3.7.13 by Sebastian Bergmann.

    Configuration read from /var/www/zf2-tutorial/module/Album/test/phpunit.xml

    .............

    Time: 0 seconds, Memory: 11.50Mb

    OK (13 tests, 34 assertions)


Conclusion
----------

In this short tutorial we gave a few examples how different parts of a Zend
Framework 2 MVC application can be tested. We covered :ref:`setting up
<setting-up-the-tests-directory>` the environment
for testing, how to test :ref:`controllers and actions <testing-actions-with-post>`, 
how to approach :ref:`failing test cases <a-failing-test-case>`, how to configure
:ref:`the service manager <configuring-the-service-manager-for-the-tests>`,
as well as how to test :ref:`model entities <testing-model-entities>`
and :ref:`model tables <testing-model-tables>`.

This tutorial is by no means a definitive guide to writing unit tests, just
a small stepping stone helping you develop applications of higher quality.
