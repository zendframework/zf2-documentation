.. _zend.di.examples:

Zend\\Di Usage Examples
=======================

This is a comprehensive list of examples featuring ``Zend\Di`` functionality and how it can be utilized/implemented.
Examples are picked from `Ralph Schindler's Zend\Di examples`_


Simple Constructor Injection
----------------------------

``Zend\Di`` can use introspection and understand what the requirements to build an instance of the ``Lister`` class
are. It automatically instantiates a new ``Finder`` and passes it to ``Lister``'s constructor.

.. code-block:: php
   :linenos:

   class MovieLister {
       public $finder;
       public function __construct(MovieFinder $finder){
           $this->finder = $finder;
       }
   }

   class MovieFinder {}

   $di = new Zend\Di\Di;

   $lister = $di->get('MovieLister');
   var_dump(get_class($lister->finder)); // dumps 'MovieFinder'


Interface Injection
-------------------

``Zend\Di`` can use introspection and detect that ``MovieLister`` class is an instance of a
``MovieFinderAwareInterface``. Any setter methods in that interface will be treated as injection method, and in this
case, a ``MovieFinder`` instance will be required to call ``setFinder``. The DiC will instantiate it and call the
``setFinder`` method.

.. code-block:: php
   :linenos:

   class MovieLister implements MovieFinderAwareInterface {
       public $finder;
       public function setFinder(MovieFinder $finder){
           $this->finder = $finder;
       }
   }

   class MovieFinder {}

   interface MovieFinderAwareInterface {
       public function setFinder(MovieFinder $finder);
   }

   $di = new Zend\Di\Di;

   $lister = $di->get('MovieLister');
   var_dump(get_class($lister->finder)); // dumps 'MovieFinder'


Setter Injection
----------------

When a method is marked as required in class definitions, ``Zend\Di`` will try to call it, thus also resolving the
required dependency.

.. code-block:: php
   :linenos:

   class MovieLister {
       public $finder;
       public function setFinder(MovieFinder $finder){
           $this->finder = $finder;
       }
   }

   class MovieFinder {}

   $di = new Zend\Di\Di;
   $di->configure(new Zend\Di\Configuration(array(
       'definition' => array(
           'class' => array(
               'MovieLister' => array(
                   'setFinder' => array(
                       'required' => true,
                   ),
               ),
           ),
       ),
   )));

   $lister = $di->get('MovieLister');
   var_dump(get_class($lister->finder)); // dumps 'MovieFinder'


Configured Parameters
---------------------

When a dependency is resolved, its configured parameters are taken into account too.

.. code-block:: php
   :linenos:

   class MovieLister {
       public $dbFinder;
       public function __construct(DbFinder $dbFinder){
           $this->dbFinder = $dbFinder;
       }
   }
   class DbFinder {
       public $username;
       public $password;
       public function __construct($username, $password)
       {
           $this->username = $username;
           $this->password = $password;
       }
   }

   $di = new Zend\Di\Di;
   $di->configure(new Zend\Di\Configuration(array(
       'instance' => array(
           'DbFinder' => array(
               'parameters' => array(
                   'username' => 'my-username',
                   'password' => 'my-password',
               ),
           ),
       ),
   )));

   $lister = $di->get('MovieLister');
   var_dump($lister->dbFinder->username); // dumps 'my-username'
   var_dump($lister->dbFinder->password); // dumps 'my-password'


Call-Time Parameters
--------------------

When parameters are passed to ``$di->get()``, they will be taken into account.

.. code-block:: php
   :linenos:

   class MovieLister {
       public $dbFinder;
       public function __construct(DbFinder $dbFinder){
           $this->dbFinder = $dbFinder;
       }
   }
   class DbFinder {
       public $username;
       public $password;
       public function __construct($username, $password)
       {
           $this->username = $username;
           $this->password = $password;
       }
   }

   $di = new Zend\Di\Di;

   $lister = $di->get(
        'MovieLister',
        array(
            'username' => 'my-username',
            'password' => 'my-password',
        )
   );
   var_dump($lister->dbFinder->username); // dumps 'my-username'
   var_dump($lister->dbFinder->password); // dumps 'my-password'


Setter Injection with Parameters
--------------------------------

When parameters fitting setter method parameters are provided, ``Zend\Di`` will inject those parameters (same happens
with call-time parameters).

.. code-block:: php
   :linenos:

   class MovieLister {
       public $dbFinder;
       public function __construct(DbFinder $dbFinder){
           $this->dbFinder = $dbFinder;
       }
   }
   class DbFinder {
       public $username;
       public $password;
       public function setUsername($username)
       {
           $this->username = $username;
       }
       public function setPassword($password)
       {
           $this->password = $password;
       }
   }

   $di = new Zend\Di\Di;
   $di->configure(new Zend\Di\Configuration(array(
       'instance' => array(
           'DbFinder' => array(
               'parameters' => array(
                   'username' => 'my-username',
                   'password' => 'my-password',
               ),
           ),
       ),
   )));

   $lister = $di->get('MovieLister');
   var_dump($lister->dbFinder->username); // dumps 'my-username'
   var_dump($lister->dbFinder->password); // dumps 'my-password'


Multiple Injections with Single Injection Point
-----------------------------------------------

Multiple injections configurations allows for calling a single injection method multiple time with different values.

.. code-block:: php
   :linenos:

   class Page {
       public $blocks;
       public function addBlock(PageBlock $block){
           $this->blocks[] = $block;
       }
   }

   interface PageBlock {}
   class BlockOne implements PageBlock {}
   class BlockTwo implements PageBlock {}

   $di = new Zend\Di\Di;
   $di->configure(new Zend\Di\Configuration(array(
       'instance' => array(
           'Page' => array(
               'injections' => array(
                   'BlockOne',
                   'BlockTwo',
               ),
           ),
       ),
   )));

   $page = $di->get('Page');
   var_dump(get_class($page->blocks[0])); // dumps 'BlockOne'
   var_dump(get_class($page->blocks[1])); // dumps 'BlockTwo'


Setter Injection enforced via Annotations
-----------------------------------------

Injections can be forced by using special annotations of the ``Zend\Di`` namespace.

.. code-block:: php
   :linenos:

   use Zend\Di\Definition\Annotation as Di;
   class MovieLister {
       public $finder;
       /** @Di\Inject() */
       public function setFinder(MovieFinder $finder){
           $this->finder = $finder;
       }
   }
   class MovieFinder {
   }

   $di = new Zend\Di\Di;

   $lister = $di->get('MovieLister');
   var_dump(get_class($lister->finder)); // dumps 'MovieFinder'


Compiler Based Constructor Injection
------------------------------------

TBD

Compiler based constructor injection
------------------------------------

TBD

Compiler Based Interface Injection
----------------------------------

TBD

Compiled Based Setter Injection With Annotation
-----------------------------------------------

TBD

Closure based dependency
------------------------

TBD

Disambiguation
--------------

TBD

Multiple Injection to Single Injection Point With Multiple Arguments
--------------------------------------------------------------------

TBD

Constructor Injection based on user-configured class definitions
----------------------------------------------------------------

TBD

Explicitly defined injections for parameters with same name on different methods
--------------------------------------------------------------------------------

TBD

Shared instances
----------------

TBD

Type preference for abstract types
----------------------------------

TBD

Injecting dependencies on existing instance
-------------------------------------------

TBD




.. _`Ralph Schindler's Zend\Di examples`: https://github.com/ralphschindler/Zend_DI-Examples