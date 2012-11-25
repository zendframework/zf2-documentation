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


And a file called bootstrap.php, also under zf-tutorial/tests/:

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

More informations at the Zend\Test component documentation page.