.. _zend.session.manager:

Session Manager
===============

The session manager, ``Zend\Session\SessionManager``, is a class that is responsible for all aspects of session
management.  It initializes and configures configuration, storage and save handling.  Additionally the session
manager can be injected into the session container to provide a wrapper or namespace around your session data.

The session manager is responsible for session start, session exists, session write, regenerate id, time to live
and session destroy. The session manager can valid sessions from a validator chain to ensure that the session data
is indeed correct.

Initializing the Session Manager
--------------------------------

Generally speaking you will always want to initialize the session manager and ensure that you had initialized it
on your end; this puts in place a simple solution to prevent against session fixation.  Generally you will likely
setup configuration and then inside of your Application module bootstrap the session manager.

Additionally you will likely want to supply validators to prevent against session hijacking.

The following illustrates how you may configure session manager by setting options in your local or global config:

.. code-block:: php
   :linenos:

   return array(
       'session' => array(
           'config' => array(
               'class' => 'Zend\Session\Config\SessionConfig',
               'options' => array(
                   'name' => 'myapp',
               ),
           ),
           'storage' => 'Zend\Session\Storage\SessionArrayStorage',
           'validators' => array(
               array(
                   'Zend\Session\Validator\RemoteAddr',
                   'Zend\Session\Validator\HttpUserAgent',
               ),
           ),
       ),
   );

The following illustrates how you might utilize the above configuration to create the session manager:

.. code-block:: php
   :linenos:
   
   use Zend\Session\SessionManager;
   use Zend\Session\Container;

   class Module
   {
       public function onBootstrap($e)
       {
           $eventManager        = $e->getApplication()->getEventManager();
           $serviceManager      = $e->getApplication()->getServiceManager();
           $moduleRouteListener = new ModuleRouteListener();
           $moduleRouteListener->attach($eventManager);
           $this->bootstrapSession($e);
       }

       public function bootstrapSession($e)
       {   
           $session = $e->getApplication()
                        ->getServiceManager()
                        ->get('Zend\Session\SessionManager');
           $session->start();

           $container = new Container('initialized');
           if (!isset($container->init)) {
                $session->regenerateId(true);
                $container->init = 1;
           }
       }   

       public function getServiceConfig()
       {
           return array(
               'factories' => array(
                   'Zend\Session\SessionManager' => function ($sm) {
                       $config = $sm->get('config');
                       if (isset($config['session'])) {
                           $session = $config['session'];

                           $sessionConfig = null;
                           if (isset($session['config'])) {
                               $class = isset($session['config']['class'])  ? $session['config']['class'] : 'Zend\Session\Config\SessionConfig';
                               $options = isset($session['config']['options']) ? $session['config']['options'] : array();
                               $sessionConfig = new $class();
                               $sessionConfig->setOptions($options);
                           }

                           $sessionStorage = null;
                           if (isset($session['storage'])) {
                               $class = $session['storage'];
                               $sessionStorage = new $class();
                           }

                           $sessionSaveHandler = null;
                           if (isset($session['save_handler'])) {
                               // class should be fetched from service manager since it will require constructor arguments
                               $sessionSaveHandler = $sm->get($session['save_handler']);
                           }

                           $sessionManager = new SessionManager($sessionConfig, $sessionStorage, $sessionSaveHandler);

                           if (isset($session['validator'])) {
                               $chain = $sessionManager->getValidatorChain();
                               foreach ($session['validator'] as $validator) {
                                   $validator = new $validator();
                                   $chain->attach('session.validate', array($validator, 'isValid'));

                               }
                           }
                       } else {
                           $sessionManager = new SessionManager();
                       }
                       Container::setDefaultManager($sessionManager);
                       return $sessionManager;
                   },
               ),
           )
       }
   }

Session Compatibility
---------------------

In order to work with other 3rd party libraries and share sessions across software that may not be ZF2
related; you will need to ensure that you still provide access to the ZF2 autoloader as well as module
autoloading.

In the shared software make certain before the session starts that you bootstrap the ZF2 autoloader and
initialize the ZF2 Application.

.. code-block:: php
   :linenos:

   $cwd = getcwd();
   chdir('/path/to/zf2-application');
   require 'init_autoloader.php';
   Zend\Mvc\Application::init(require 'config/application.config.php');
   chdir($cwd);
   session_start();

