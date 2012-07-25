.. _zend.console.introduction:

Introduction
============

Zend Framework 2 features built-in console support.

When a ``Zend\Application`` is run from a console window (a shell window or Windows command prompt), it will recognize
this fact and prepare ``Zend\Mvc`` components to handle the request. Console support support is enabled by default,
but to function properly it requires at least one :doc:`console route <zend.console.routes>` and 
:doc:`one action controller <zend.mvc.controllers>` to handle the request.

``Zend\Console`` provides direct console access via :doc:`Console adapters<zend.console.adapter>`. This
includes reading from console and writing to it, working around various bugs on different operating systems.

``Zend\Console\Prompt`` is a collection of easy to use :doc:`console prompts<zend.console.prompts>`
that can be used to build interactive apps.


Writing console routes
----------------------
A console route defines required and optional command line parameters. When a route matches, it behaves analogical
to a standard, :doc:`http route <zend.mvc.routing>` and can point to a 
:doc:`MVC controller <zend.mvc.controllers>` and an action. 

Let's assume that we'd like our application to handle the following command line:

    zf user reset-password user@mail.com
    
When a user runs our application (``zf``) with these parameters, we'd like to call action ``resetpassword`` of 
``Application\IndexController``. First we want to create a **route definition**:

    user reset-password <userEmail>

This simple route definition expects exactly 3 arguments: a literal "user", literal "reset-password" followed by
a parameter we're calling "userEmail". Let's assume we also accept one optional parameter, that will turn on 
verbose operation:

    user reset-password [--verbose|-v] <userEmail>

Now our console route expects the same 3 parameters but will also recognise an optional ``--verbose`` flag, or it's
shorthand version: ``-v``.

.. note::

   The order of flags is ignored by ``Zend\Console``. Flags can appear before positional parameters, after them or 
   anywhere in between. The order of multiple flags is also irrelevant. This applies both to route definitions and the
   order that flags are used on the command line.


Let's use the definition above and configure our console route. Console routes are automatically loaded from the 
following location inside config file:

.. code-block:: php
    :linenos:

    array(
        'router' => array(
            'routes' => array(
                // HTTP routes are defined here 
            )
        ),
        
        'console' => array(
            'router' => array(
                'routes' => array(
                    // Console routes go here
                )
            )
        ),
    )

Let's create our console route and point it to ``Application\IndexController::resetpasswordAction()``
   
.. code-block:: php
    :linenos:

    // we could define routes for Application\IndexController in Application module config file
    // which is usually located at modules/application/config/module.config.php
    array(
        'console' => array(
            'router' => array(
                'routes' => array(
                    'user-reset-password' => array(
                        'options' => array(
                            'route'    => 'user reset-password [--verbose|-v] <userEmail>',
                            'defaults' => array(
                                'controller' => 'Application\Index',
                                'action'     => 'password'
                            )
                        )
                    )
                )
            )
        )
    )
    
To learn more about console routes and how to use them, follow this link: :doc:`zend.console.routes`

    
Handling console requests
-------------------------
When a user runs our application from command line and arguments match our console route, a ``controller``
class will be instantiated and an ``action`` method will be called, just like it is with http requests.

We will now add ``resetpassword`` action to ``Application\IndexController``:

.. code-block:: php
    :linenos:

    <?php
    namespace Application\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    use Zend\Console\Request;
    use Zend\Math\Rand;

    class IndexController extends AbstractActionController
    {
        public function indexAction()
        {
            return new ViewModel(); // display standard index page
        }

        public function resetpasswordAction(){
            $request = $this->getRequest();
            
            // Make sure that we are running in a console and the user has not tricked our
            // application into running this action from a public web server.
            if (!$request instanceof ConsoleRequest){
                thrown new \RuntimeException('You can only use this action from a console!');
            }
            
            // Get user email from console and check if the user used --verbose or -v flag
            $userEmail   = $request->getParam('userEmail');
            $verbose     = $request->getParam('verbose');
            
            // reset new password
            $newPassword = Rand::getString(16);
            
            //  Fetch the user and change his password, then email him ...
            // [...]
            
            if(!$verbose){
                return "Done! $userEmail has received an email with his new password.\n";
            }else{
                return "Done! New password for user $userEmail is '$newPassword'. It has also been emailed to him. \n";
            }
        }
    }
    
We have created ``resetpasswordAction()`` than retrieves current request and checks if it's really coming from the
console (as a precaution). In this example we do not want our action to be invocable from a web page. Because we have
not defined any http route pointing to it, it should never be possible. However in the future, we might define a 
wildcard route or a 3rd party module might erroneously route some requests to our action - that is why we want to make
sure that the request is always coming from a Console environment.

All console arguments supplied by the user are accessible via ``$request->getParam()`` method. Flags will be represented
by a booleans, where ``true`` means a flag has been used and ``false`` otherwise.

When our action has finished working it returns a simple ``string`` that will be shown to the user in console window. 

There are different ways you can interact with console from a controller. It has been covered in more detail 
in the following chapter: :doc:`zend.console.controllers`

Adding console usage info
-------------------------
It is a common practice for console application to display usage information when run for the first time (without any
arguments). This is also handled by ``Zend\Console`` together with ``MVC``.

Usage info in ZF2 console applications is provided by :doc:`loaded modules <zend.module.manager.intro>`. In case no
console route matches console arguments, ``Zend\Console`` will query all loaded modules and ask for their console
usage info.

Let's modify our ``Application\IndexController`` to provide usage info:

.. code-block:: php
    :linenos:

    <?php

    namespace Application;

    use Zend\ModuleManager\Feature\ConfigProviderInterface;
    use Zend\ModuleManager\Feature\ConsoleUsageProviderInterface;
    use Zend\Console\AdapterInterface as Console;

    class Module implements
        AutoloaderProviderInterface,
        ConfigProviderInterface,
        ConsoleUsageProviderInterface   // <- our module implement this feature and provides console usage info
    {
        public function getConfig()
        {
            // [...]
        }

        public function getAutoloaderConfig()
        {
            // [...]
        }

        public function getConsoleUsage(Console $console){
            return array(
                // Describe available commands
                'user reset-password [--verbose|-v] USER EMAIL'    => 'Reset password for a user',

                // Describe expected parameters
                array( 'USER NAME',       'Email of the user for a password reset' ),
                array( '--verbose|-v',    '(optional) turn on verbose mode'        ),
            );
        }
    }

Each module that implements ``ConsoleUsageProviderInterface`` will be queried for console usage info. On route
mismatch, all info from all modules will be concatenated, formatted to console width and shown to the user.

.. note::
   The order of usage info displayed in the console is the order modules load. If you want your application to
   display important usage info first, change the order your modules are loaded.

Modules can also provide application banner (title). To learn more about the format expected from
``getConsoleUsage()`` and application banners, please follow to the following chapter: :doc:`zend.console.controllers`
