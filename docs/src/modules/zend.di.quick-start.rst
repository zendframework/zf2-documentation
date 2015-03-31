.. _zend.di.quick-start:

Zend\\Di Quickstart
===================

This QuickStart is intended to get developers familiar with the concepts of the Zend\\Di DiC. Generally speaking,
code is never as simple as it is inside this example, so working knowledge of the other sections of the manual is
suggested.

Assume for a moment, you have the following code as part of your application that you feel is a good candidate for
being managed by a DiC, after all, you are already injecting all your dependencies:

.. code-block:: php
   :linenos:

   namespace MyLibrary
   {
       class DbAdapter
       {
           protected $username = null;
           protected $password = null;
           public function __construct($username, $password)
           {
               $this->username = $username;
               $this->password = $password;
           }
       }
   }

   namespace MyMovieApp
   {
       class MovieFinder
       {
           protected $dbAdapter = null;
           public function __construct(\MyLibrary\DbAdapter $dbAdapter)
           {
               $this->dbAdapter = $dbAdapter;
           }
       }

       class MovieLister
       {
           protected $movieFinder = null;
           public function __construct(MovieFinder $movieFinder)
           {
               $this->movieFinder = $movieFinder;
           }
       }
   }

With the above code, you find yourself writing the following to wire and utilize this code:

.. code-block:: php
   :linenos:

   // $config object is assumed

   $dbAdapter = new MyLibrary\DbAdapter($config->username, $config->password);
   $movieFinder = new MyMovieApp\MovieFinder($dbAdapter);
   $movieLister = new MyMovieApp\MovieLister($movieFinder);
   foreach ($movieLister as $movie) {
       // iterate and display $movie
   }

If you are doing this above wiring in each controller or view that wants to list movies, not only can this become
repetitive and boring to write, but also unmaintainable if for example you want to swap out one of these
dependencies on a wholesale scale.

Since this example of code already practices good dependency injection, with constructor injection, it is a great
candidate for using Zend\\Di. The usage is as simple as:

.. code-block:: php
   :linenos:

       // inside a bootstrap somewhere
       $di = new Zend\Di\Di();
       $di->instanceManager()->setParameters('MyLibrary\DbAdapter', array(
           'username' => $config->username,
           'password' => $config->password
       ));

       // inside each controller
       $movieLister = $di->get('MyMovieApp\MovieLister');
       foreach ($movieLister as $movie) {
           // iterate and display $movie
       }

In the above example, we are obtaining a default instance of Zend\\Di\\Di. By 'default', we mean that Zend\\Di\\Di
is constructed with a DefinitionList seeded with a RuntimeDefinition (uses Reflection) and an empty instance
manager and no configuration. Here is the Zend\\Di\\Di constructor:

.. code-block:: php
   :linenos:

       public function __construct(DefinitionList $definitions = null, InstanceManager $instanceManager = null, Configuration $config = null)
       {
           $this->definitions = ($definitions) ?: new DefinitionList(new Definition\RuntimeDefinition());
           $this->instanceManager = ($instanceManager) ?: new InstanceManager();

           if ($config) {
               $this->configure($config);
           }
       }

This means that when $di->get() is called, it will be consulting the RuntimeDefinition, which uses reflection to
understand the structure of the code. Once it knows the structure of the code, it can then know how the
dependencies fit together and how to go about wiring your objects for you. Zend\\Di\\Definition\\RuntimeDefinition
will utilize the names of the parameters in the methods as the class parameter names. This is how both username and
password key are mapped to the first and second parameter, respectively, of the constructor consuming these named
parameters.

If you were to want to pass in the username and password at call time, this is achieved by passing them as the
second argument of get():

.. code-block:: php
   :linenos:

       // inside each controller
       $di = new Zend\Di\Di();
       $movieLister = $di->get('MyMovieApp\MovieLister', array(
           'username' => $config->username,
           'password' => $config->password
       ));
       foreach ($movieLister as $movie) {
           // iterate and display $movie
       }

It is important to note that when using call time parameters, these parameter names will be applied to any class
that accepts a parameter of such name.

By calling $di->get(), this instance of MovieLister will be automatically shared. This means subsequent calls to
get() will return the same instance as previous calls. If you wish to have completely new instances of MovieLister,
you can utilize $di->newInstance().


