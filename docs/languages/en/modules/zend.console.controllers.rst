.. _zend.console.controllers:

Console-aware action controllers
===================================

Zend Framework 2 has built-in :doc:`MVC integration with console<zend.console.introduction>`. After the user runs
our application in console window, the request will be routed. By matching command line arguments against
:doc:`console routes we have defined in our application <zend.console.routes>`, MVC will invoke a controller and
an action.

In this chapter we will learn how ZF2 Controllers can interact with and return output to console window.

.. seealso::

    In order for a controller to be invoked, at least one route must point to it. To learn about creating console
    routes, please read this chapter :doc:`zend.console.routes`


Handling console requests
---------------------------

Console requests are very similar to http requests. In fact, they implement common interface and are created at the
same time in the MVC workflow. :doc:`Console routes <zend.console.routes>` match against command line arguments
and provide ``defaults`` array, which holds ``controller`` and ``action`` keys. These correspond with controller
alias in Service Manager, and method name in controller class. This is analogic to the way HTTP requests are handled
in ZF2.

.. seealso::

    To learn about defining and creating controllers, please read this chapter
    :doc:`../user-guide/routing-and-controllers`

In this example we'll use the following simple route:

.. code-block:: php
    :linenos:
    :emphasize-lines: 12-20

    // FILE: modules/Application/config/module.config.php
    array(
        'router' => array(
            'routes' => array(
                // HTTP routes are here
            )
        ),

        'console' => array(
            'router' => array(
                'routes' => array(
                    'list-users' => array(
                        'options' => array(
                            'route'    => 'show [all|disabled|deleted]:mode users [--verbose|-v]',
                            'defaults' => array(
                                'controller' => 'Application\Index',
                                'action'     => 'showusers'
                            )
                        )
                    )
                )
            )
        ),
    )

This route will match commands such as:

.. code-block:: bash

    > zf show users
    > zf show all users
    > zf show disabled users

This route points to ``Application\IndexController::listusersAction()`` method.

Let's add it to our controller.

.. code-block:: php
    :linenos:

    <?php
    namespace Application\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class IndexController extends AbstractActionController
    {
        public function indexAction()
        {
            return new ViewModel(); // display standard index page
        }

        public function showusersAction(){
            $request = $this->getRequest();

            // Check verbose flag
            $verbose = $request->getParam('verbose') || $request->getParam('v');

            // Check mode
            $mode = $request->getParam('mode', 'all'); // defaults to 'all'

            $users = array();
            switch ($mode) {
                case 'disabled':
                    $users = $this->getServiceLocator()->get('users')->fetchDisabledUsers();
                    break;
                case 'deleted':
                    $users = $this->getServiceLocator()->get('users')->fetchDeletedUsers();
                    break;
                case 'all':
                default:
                    $users = $this->getServiceLocator()->get('users')->fetchAllUsers();
                    break;
            }
        }
    }

We have fetched console request, read parameters and loaded users from our (theoretical) users service. In order to make
this method functional, we'll have to display the result in console window.


Sending output to console
-------------------------

The simplest way for our controller to display data in console window is to ``return`` a string. Let's modify our
example to output a list of users:

.. code-block:: php
    :linenos:
    :emphasize-lines: 25-35

    public function showusersAction(){
        $request = $this->getRequest();

        // Check verbose flag
        $verbose = $request->getParam('verbose') || $request->getParam('v');

        // Check mode
        $mode = $request->getParam('mode', 'all'); // defaults to 'all'

        $users = array();
        switch ($mode) {
            case 'disabled':
                $users = $this->getServiceLocator()->get('users')->fetchDisabledUsers();
                break;
            case 'deleted':
                $users = $this->getServiceLocator()->get('users')->fetchDeletedUsers();
                break;
            case 'all':
            default:
                $users = $this->getServiceLocator()->get('users')->fetchAllUsers();
                break;
        }

        if (count($users) == 0) {
            // Show an error message in the console
            return "There are no users in the database\n";
        }

        $result = '';

        foreach($users as $user){
            $result .= $user->name . ' ' . $user->email . "\n";
        }

        return $result; // show it in the console
    }

On line 26 we are checking if users service found any users - otherwise we are returning an error message that will
be immediately displayed and the application will end.

If there are 1 or more users, we will loop through them with and prepare a listing. It is then returned from the action
and displayed in console window.


Are we in a console?
---------------------

Sometimes we might need to check if our method is being called from a console or from a web request. This is useful
to block certain methods from running in console or to change their behavior based on that context.

Here is an example of how to check if we are dealing with a console request:

.. code-block:: php
    :linenos:
    :emphasize-lines: 14-18

    <?php
    namespace Application\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    use Zend\Console\Request as ConsoleRequest;
    use RuntimeException;

    class IndexController extends AbstractActionController
    {
        public function showusersAction(){
            $request = $this->getRequest();

            // Make sure that we are running in a console and the user has not tricked our
            // application into running this action from a public web server.
            if (!$request instanceof ConsoleRequest){
                thrown new RuntimeException('You can only use this action from a console!');
            }
            // ...
        }
    }

.. note::

    You do not need to secure all your controllers and method from console requests. Controller action will
    **only be invoked** when at least one :doc:`console route <zend.console.routes>` matches it. HTTP and Console
    routes are separated and defined in different places in module (and application) configuration.

    There is no way to invoke a console action unless there is at least one route pointing to it. Similarly, there is
    no way for a http action to be invoked unless there is at least one HTTP route that points to it.


The example below shows how a single controller method can handle **both Console and HTTP requests**:

.. code-block:: php
    :linenos:
    :emphasize-lines: 18-26

    <?php
    namespace Application\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    use Zend\Console\Request as ConsoleRequest;
    use Zend\Http\Request as HttpRequest;
    use RuntimeException;

    class IndexController extends AbstractActionController
    {
        public function showusersAction(){
            $request = $this->getRequest();

            $users = array();
            // ... fetch users from database ...

            if ($request instanceof HttpRequest){
                // display a web page with users list
                return new ViewModel($result);
            } elseif ($request instanceof ConsoleRequest) {
                // ... prepare console output and return it ...
                return $result;
            } else {
                throw new RuntimeException('Cannot handle request of type '.get_class($request));
            }
        }
    }




Reading values from console parameters
---------------------------------------

There are several types of parameters recognized by the Console component - all of them are described in
:doc:`the console routing chapter <zend.console.routes>`. Here we'll focus on how to retrieve values from distinct
parameters and flags.

Positional parameters
^^^^^^^^^^^^^^^^^^^^^

After a route matches, we can access both **literal parameters** and **value parameters** from within ``$request``
container.

Assuming we have the following route:

.. code-block:: php
    :linenos:
    :emphasize-lines: 4

    // inside of config.console.router.routes:
    'show-users' => array(
        'options' => array(
            'route'    => 'show (all|deleted|locked|admin) [<groupName>]'
            'defaults' => array(
                'controller' => 'Application\Users',
                'action'     => 'showusers'
            )
        )
    )

If this route matches, our action can now query parameters in the following way:

.. code-block:: php
    :linenos:

    // an action inside Application\UsersController:
    public function showusersAction(){
        $request = $this->getRequest();

        // We can access named value parameters directly by their name:
        $showUsersFromGroup = $request->getParam('groupName');

        // Literal parameters can be checked with isset() against their exact spelling
        if (isset($request->getParam('all'))) {
            // show all users
        } elseif (isset($request->getParam('deleted'))) {
            // show deleted users
        }
        // ...
    }

In case of parameter alternatives it is a good idea to **assign a name to the group**, which simplifies the branching
in our action controllers. We can do this with the following syntax:

.. code-block:: php
    :linenos:
    :emphasize-lines: 4

    // inside of config.console.router.routes:
    'show-users' => array(
        'options' => array(
            'route'    => 'show (all|deleted|locked|admin):userTypeFilter [<groupName>]'
            'defaults' => array(
                'controller' => 'Application\Users',
                'action'     => 'showusers'
            )
        )
    )

Now we can use a the group name ``userTypeFilter`` to check which option has been selected by the user:

.. code-block:: php
    :linenos:
    :emphasize-lines: 7-18

    public function showusersAction(){
        $request = $this->getRequest();

        // We can access named value parameters directly by their name:
        $showUsersFromGroup = $request->getParam('groupName');

        // The selected option from second parameter is now stored under 'userTypeFilter'
        $userTypeFilter     = $request->getParam('userTypeFilter');

        switch($userTypeFilter) {
            case 'all':
                // all users
            case 'deleted':
                // deleted users
            case 'locked'
               // ...
               // ...
        }
    }

Flags
^^^^^

Flags are directly accessible with their name. Value flags will contain string values, as provided by the user.
Non-value flags will be equal to ``true``.

Given the following route:

.. code-block:: php
    :linenos:
    :emphasize-lines: 3

    'find-user' => array(
        'options' => array(
            'route'    => 'find user [--fast] [--verbose] [--id=] [--firstName=] [--lastName=] [--email=] ',
            'defaults' => array(
                'controller' => 'Application\Users',
                'action'     => 'find'
            )
        )
    )

... we can easily retrieve values in the following fashion:

.. code-block:: php
    :linenos:

    public function findAction(){
        $request = $this->getRequest();

        // We can retrieve values from value flags using their name
        $searchId        = $request->getParam('id',        null); // default null
        $searchFirstName = $request->getParam('firstName', null);
        $searchLastName  = $request->getParam('lastName',  null);
        $searchEmail     = $request->getParam('email',     null);

        // Standard flags that have been matched will be equal to TRUE
        $isFast          = (bool)$request->getParam('fast',   false); // default false
        $isVerbose       = (bool)$request->getParam('verbose',false);

        if ($isFast) {
            // perform a fast query ...
        } else {
            // perform standard query ...
        }
    }

In case of **flag alternatives**, we have to check each alternative separately:

.. code-block:: php
    :linenos:
    :emphasize-lines: 1-3,7-8

    // Assuming our route now reads:
    //      'route'    => 'find user [--fast|-f] [--verbose|-v] ... ',
    //
    public function findAction(){
        $request = $this->getRequest();

        // Check both alternatives
        $isFast    = $request->getParam('fast',false)    || $request->getParam('f',false);
        $isVerbose = $request->getParam('verbose',false) || $request->getParam('v',false);

        // ...
    }

