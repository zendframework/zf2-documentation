.. _learning.di:

#############################
Learning Dependency Injection
#############################

.. _learning.di.very-brief-introduction-to-di:

Very brief introduction to Di.
------------------------------

**Dependency Injection** is a concept that has been talked about in numerous places over the web. For the purposes
of this quickstart, we'll explain the act of injecting dependencies simply with this below code:

.. code-block:: php
   :linenos:

   $b = new B(new A());

Above, A is a dependency of B, and A was **injected** into B. If you are not familiar with the concept of dependency
injection, here are a couple of great reads: Matthew Weier O'Phinney's `Analogy`_, Ralph Schindler's `Learning
DI`_, or Fabien Potencier's `Series on DI`_.

.. _learning.di.simplest-usage-case-2-classes-one-consumes-the-other:

Simplest usage case (2 classes, one consumes the other)
-------------------------------------------------------

In the simplest use case, a developer might have one class (``A``) that is consumed by another class (``B``)
through the constructor. By having the dependency injected through the constructor, this requires an object of type
``A`` be instantiated before an object of type ``B`` so that ``A`` can be injected into ``B``.

.. code-block:: php
   :linenos:

   namespace My {

       class A
       {
           /* Some useful functionality */
       }

       class B
       {
           protected $a = null;
           public function __construct(A $a)
           {
               $this->a = $a;
           }
       }
   }

To create ``B`` by hand, a developer would follow this work flow, or a similar workflow to this:

.. code-block:: php
   :linenos:

   $b = new B(new A());

If this workflow becomes repeated throughout your application multiple times, this creates an opportunity where one
might want to `DRY`_ up the code. While there are several ways to do this, using a dependency injection container is
one of these solutions. With Zend's dependency injection container ``Zend\Di\Di``, the above use
case can be taken care of with no configuration (provided all of your autoloading is already configured properly)
with the following usage:

.. code-block:: php
   :linenos:

   $di = new Zend\Di\Di;
   $b = $di->get('My\B'); // will produce a B object that is consuming an A object

Moreover, by using the ``Di::get()`` method, you are ensuring that the same exact object is
returned on subsequent calls. To force new objects to be created on each and every request, one would use the
``Di::newInstance()`` method:

.. code-block:: php
   :linenos:

   $b = $di->newInstance('My\B');

Let's assume for a moment that ``A`` requires some configuration before it can be created. Our previous use case is
expanded to this (we'll throw a 3rd class in for good measure):

.. code-block:: php
   :linenos:

   namespace My {

       class A
       {
           protected $username = null;
           protected $password = null;
           public function __construct($username, $password)
           {
               $this->username = $username;
               $this->password = $password;
           }
       }

       class B
       {
           protected $a = null;
           public function __construct(A $a)
           {
               $this->a = $a;
           }
       }

       class C
       {
           protected $b = null;
           public function __construct(B $b)
           {
               $this->b = $b;
           }
       }

   }

With the above, we need to ensure that our ``Di`` is capable of setting the ``A`` class with a few
configuration values (which are generally scalar in nature). To do this, we need to interact with the
``InstanceManager``:

.. code-block:: php
   :linenos:

   $di = new Zend\Di\Di;
   $di->getInstanceManager()->setProperty('A', 'username', 'MyUsernameValue');
   $di->getInstanceManager()->setProperty('A', 'password', 'MyHardToGuessPassword%$#');

Now that our container has values it can use when creating ``A``, and our new goal is to have a ``C`` object that
consumes ``B`` and in turn consumes ``A``, the usage scenario is still the same:

.. code-block:: php
   :linenos:

   $c = $di->get('My\C');
   // or
   $c = $di->newInstance('My\C');

Simple enough, but what if we wanted to pass in these parameters at call time? Assuming a default
``Di`` object (``$di = new Zend\Di\Di()`` without any configuration to the
``InstanceManager``), we could do the following:

.. code-block:: php
   :linenos:

   $parameters = array(
       'username' => 'MyUsernameValue',
       'password' => 'MyHardToGuessPassword%$#',
   );

   $c = $di->get('My\C', $parameters);
   // or
   $c = $di->newInstance('My\C', $parameters);

Constructor injection is not the only supported type of injection. The other most popular method of injection is
also supported: setter injection. Setter injection allows one to have a usage scenario that is the same as our
previous example with the exception, for example, of our ``B`` class now looking like this:

.. code-block:: php
   :linenos:

   namespace My {
       class B
       {
           protected $a;
           public function setA(A $a)
           {
               $this->a = $a;
           }
       }
   }

Since the method is prefixed with set, and is followed by a capital letter, the ``Di`` knows that
this method is used for setter injection, and again, the use case ``$c = $di->get('C')``, will once again know how
to fill the dependencies when needed to create an object of type ``C``.

Other methods are being created to determine what the wirings between classes are, such as interface injection and
annotation based injection.

.. _learning.di.simplest-usage-case-without-type-hints:

Simplest Usage Case Without Type-hints
--------------------------------------

If your code does not have type-hints or you are using 3rd party code that does not have type-hints but does
practice dependency injection, you can still use the ``Di``, but you might find you need to
describe your dependencies explicitly. To do this, you will need to interact with one of the definitions that is
capable of letting a developer describe, with objects, the map between classes. This particular definition is
called the ``BuilderDefinition`` and can work with, or in place of, the default ``RuntimeDefinition``.

Definitions are a part of the ``Di`` that attempt to describe the relationship between classes so
that ``Di::newInstance()`` and ``Di::get()`` can know what the dependencies are
that need to be filled for a particular class/object. With no configuration, ``Di`` will use the
``RuntimeDefinition`` which uses reflection and the type-hints in your code to determine the dependency map.
Without type-hints, it will assume that all dependencies are scalar or required configuration parameters.

The ``BuilderDefinition``, which can be used in tandem with the ``RuntimeDefinition`` (technically, it can be used
in tandem with any definition by way of the ``AggregateDefinition``), allows you to programmatically describe the
mappings with objects. Let's say for example, our above ``A/B/C`` usage scenario, were altered such that class
``B`` now looks like this:

.. code-block:: php
   :linenos:

   namespace My {
       class B
       {
           protected $a;
           public function setA($a)
           {
               $this->a = $a;
           }
       }
   }

You'll notice the only change is that setA now does not include any type-hinting information.

.. code-block:: php
   :linenos:

   use Zend\Di\Di;
   use Zend\Di\Definition;
   use Zend\Di\Definition\Builder;

   // Describe this class:
   $builder = new Definition\BuilderDefinition;
   $builder->addClass(($class = new Builder\PhpClass));

   $class->setName('My\B');
   $class->addInjectableMethod(($im = new Builder\InjectableMethod));

   $im->setName('setA');
   $im->addParameter('a', 'My\A');

   // Use both our Builder Definition as well as the default
   // RuntimeDefinition, builder first
   $aDef = new Definition\AggregateDefinition;
   $aDef->addDefinition($builder);
   $aDef->addDefinition(new Definition\RuntimeDefinition);

   // Now make sure the Di understands it
   $di = new Di;
   $di->setDefinition($aDef);

   // and finally, create C
   $parameters = array(
       'username' => 'MyUsernameValue',
       'password' => 'MyHardToGuessPassword%$#',
   );

   $c = $di->get('My\C', $parameters);

This above usage scenario provides that whatever the code looks like, you can ensure that it works with the
dependency injection container. In an ideal world, all of your code would have the proper type hinting and/or would
be using a mapping strategy that reduces the amount of bootstrapping work that needs to be done in order to have a
full definition that is capable of instantiating all of the objects you might require.

.. _learning.di.simplest-usage-case-with-compiled-definition:

Simplest usage case with Compiled Definition
--------------------------------------------

Without going into the gritty details, as you might expect, PHP at its core is not DI friendly. Out-of-the-box, the
``Di`` uses a ``RuntimeDefinition`` which does all class map resolution via PHP's ``Reflection``
extension. Couple that with the fact that PHP does not have a true application layer capable of storing objects
in-memory between requests, and you get a recipe that is less performant than similar solutions you'll find in Java
and .Net (where there is an application layer with in-memory object storage.)

To mitigate this shortcoming, ``Zend\Di`` has several features built in capable of pre-compiling the most expensive
tasks that surround dependency injection. It is worth noting that the ``RuntimeDefinition``, which is used by
default, is the **only** definition that does lookups on-demand. The rest of the ``Definition`` objects are capable
of being aggregated and stored to disk in a very performant way.

Ideally, 3rd party code will ship with a pre-compiled ``Definition`` that will describe the various relationships
and parameter/property needs of each class that is to be instantiated. This ``Definition`` would have been built as
part of some deployment or packaging task by this 3rd party. When this is not the case, you can create these
``Definitions`` via any of the ``Definition`` types provided with the exception of the ``RuntimeDefinition``. Here
is a breakdown of the job of each definition type:

- ``AggregateDefinition``- Aggregates multiple definitions of various types. When looking for a class, it looks it
  up in the order the definitions were provided to this aggregate.

- ``ArrayDefinition``- This definition takes an array of information and exposes it via the interface provided by
  ``Zend\Di\Definition`` suitable for usage by ``Di`` or an ``AggregateDefinition``

- ``BuilderDefinition``- Creates a definition based on an object graph consisting of various ``Builder\PhpClass``
  objects and ``Builder\InjectionMethod`` objects that describe the mapping needs of the target codebase and …

- ``Compiler``- This is not actually a definition, but produces an ``ArrayDefinition`` based off of a code scanner
  (``Zend\Code\Scanner\DirectoryScanner`` or ``Zend\Code\Scanner\FileScanner``).

The following is an example of producing a definition via a ``DirectoryScanner``:

.. code-block:: php
   :linenos:

   $compiler = new Zend\Di\Definition\Compiler();
   $compiler->addCodeScannerDirectory(
       new Zend\Code\Scanner\ScannerDirectory('path/to/library/My/')
   );
   $definition = $compiler->compile();

This definition can then be directly used by the ``Di`` (assuming the above ``A, B, C`` scenario
was actually a file per class on disk):

.. code-block:: php
   :linenos:

   $di = new Zend\Di\Di;
   $di->setDefinition($definition);
   $di->getInstanceManager()->setProperty('My\A', 'username', 'foo');
   $di->getInstanceManager()->setProperty('My\A', 'password', 'bar');
   $c = $di->get('My\C');

One strategy for persisting these compiled definitions would be the following:

.. code-block:: php
   :linenos:

   if (!file_exists(__DIR__ . '/di-definition.php') && $isProduction) {
       $compiler = new Zend\Di\Definition\Compiler();
       $compiler->addCodeScannerDirectory(
           new Zend\Code\Scanner\ScannerDirectory('path/to/library/My/')
       );
       $definition = $compiler->compile();
       file_put_contents(
           __DIR__ . '/di-definition.php',
           '<?php return ' . var_export($definition->toArray(), true) . ';'
       );
   } else {
       $definition = new Zend\Di\Definition\ArrayDefinition(
           include __DIR__ . '/di-definition.php'
       );
   }

   // $definition can now be used; in a production system it will be written
   // to disk.

Since ``Zend\Code\Scanner`` does not include files, the classes contained within are not loaded into memory.
Instead, ``Zend\Code\Scanner`` uses tokenization to determine the structure of your files. This makes this suitable
to use this solution during development and within the same request as any one of your application's dispatched
actions.

.. _learning.di.creating-a-precompiled-definition-for-others-to-use:

Creating a precompiled definition for others to use
---------------------------------------------------

If you are a 3rd party code developer, it makes sense to produce a ``Definition`` file that describes your code so
that others can utilize this ``Definition`` without having to ``Reflect`` it via the ``RuntimeDefinition``, or
create it via the ``Compiler``. To do this, use the same technique as above. Instead of writing the resulting array
to disk, you would write the information into a definition directly, by way of ``Zend\Code\Generator``:

.. code-block:: php
   :linenos:

   // First, compile the information
   $compiler = new Zend\Di\Definition\CompilerDefinition();
   $compiler->addDirectoryScanner(
       new Zend\Code\Scanner\DirectoryScanner(__DIR__ . '/My/')
   );
   $compiler->compile();
   $definition = $compiler->toArrayDefinition();

   // Now, create a Definition class for this information
   $codeGenerator = new Zend\Code\Generator\FileGenerator();
   $codeGenerator->setClass(($class = new Zend\Code\Generator\ClassGenerator()));
   $class->setNamespaceName('My');
   $class->setName('DiDefinition');
   $class->setExtendedClass('\Zend\Di\Definition\ArrayDefinition');
   $class->addMethod(
       '__construct',
       array(),
       \Zend\Code\Generator\MethodGenerator::FLAG_PUBLIC,
       'parent::__construct(' . var_export($definition->toArray(), true) . ');'
   );
   file_put_contents(__DIR__ . '/My/DiDefinition.php', $codeGenerator->generate());

.. _learning.di.using-multiple-definitions-from-multiple-sources:

Using Multiple Definitions From Multiple Sources
------------------------------------------------

In all actuality, you will be using code from multiple places, some Zend Framework code, some other 3rd party code,
and of course, your own code that makes up your application. Here is a method for consuming definitions from
multiple places:

.. code-block:: php
   :linenos:

   use Zend\Di\Di;
   use Zend\Di\Definition;
   use Zend\Di\Definition\Builder;

   $di = new Di;
   $diDefAggregate = new Definition\Aggregate();

   // first add in provided Definitions, for example
   $diDefAggregate->addDefinition(new ThirdParty\Dbal\DiDefinition());
   $diDefAggregate->addDefinition(new Zend\Controller\DiDefinition());

   // for code that does not have TypeHints
   $builder = new Definition\BuilderDefinition();
   $builder->addClass(($class = Builder\PhpClass));
   $class->addInjectionMethod(
       ($injectMethod = new Builder\InjectionMethod())
   );
   $injectMethod->setName('injectImplementation');
   $injectMethod->addParameter(
   'implementation', 'Class\For\Specific\Implementation'
   );

   // now, your application code
   $compiler = new Definition\Compiler()
   $compiler->addCodeScannerDirectory(
       new Zend\Code\Scanner\DirectoryScanner(__DIR__ . '/App/')
   );
   $appDefinition = $compiler->compile();
   $diDefAggregate->addDefinition($appDefinition);

   // now, pass in properties
   $im = $di->getInstanceManager();

   // this could come from Zend\Config\Config::toArray
   $propertiesFromConfig = array(
       'ThirdParty\Dbal\DbAdapter' => array(
           'username' => 'someUsername',
           'password' => 'somePassword'
       ),
       'Zend\Controller\Helper\ContentType' => array(
           'default' => 'xhtml5'
       ),
   );
   $im->setProperties($propertiesFromConfig);

.. _learning.di.generating-service-locators:

Generating Service Locators
---------------------------

In production, you want things to be as fast as possible. The Dependency Injection Container, while engineered for
speed, still must do a fair bit of work resolving parameters and dependencies at runtime. What if you could speed
things up and remove those lookups?

The ``Zend\Di\ServiceLocator\Generator`` component can do just that. It takes a configured DI instance, and
generates a service locator class for you from it. That class will manage instances for you, as well as provide
hard-coded, lazy-loading instantiation of instances.

The method ``getCodeGenerator()`` returns an instance of ``Zend\CodeGenerator\Php\PhpFile``, from which you can
then write a class file with the new Service Locator. Methods on the ``Generator`` class allow you to specify the
namespace and class for the generated Service Locator.

As an example, consider the following:

.. code-block:: php
   :linenos:

   use Zend\Di\ServiceLocator\Generator;

   // $di is a fully configured DI instance
   $generator = new Generator($di);

   $generator->setNamespace('Application')
             ->setContainerClass('Context');
   $file = $generator->getCodeGenerator();
   $file->setFilename(__DIR__ . '/../Application/Context.php');
   $file->write();

The above code will write to ``../Application/Context.php``, and that file will contain the class
``Application\Context``. That file might look like the following:

.. code-block:: php
   :linenos:

   <?php

   namespace Application;

   use Zend\Di\ServiceLocator;

   class Context extends ServiceLocator
   {

       public function get($name, array $params = array())
       {
           switch ($name) {
               case 'composed':
               case 'My\ComposedClass':
                   return $this->getMyComposedClass();

               case 'struct':
               case 'My\Struct':
                   return $this->getMyStruct();

               default:
                   return parent::get($name, $params);
           }
       }

       public function getComposedClass()
       {
           if (isset($this->services['My\ComposedClass'])) {
               return $this->services['My\ComposedClass'];
           }

           $object = new \My\ComposedClass();
           $this->services['My\ComposedClass'] = $object;
           return $object;
       }
       public function getMyStruct()
       {
           if (isset($this->services['My\Struct'])) {
               return $this->services['My\Struct'];
           }

           $object = new \My\Struct();
           $this->services['My\Struct'] = $object;
           return $object;
       }

       public function getComposed()
       {
           return $this->get('My\ComposedClass');
       }

       public function getStruct()
       {
           return $this->get('My\Struct');
       }
   }

To use this class, you simply consume it as you would a DI container:

.. code-block:: php
   :linenos:

   $container = new Application\Context;

   $struct = $container->get('struct'); // My\Struct instance

One note about this functionality in its current incarnation. Configuration is per-environment only at this time.
This means that you will need to generate a container per execution environment. Our recommendation is that you do
so, and then in your environment, specify the container class to use.



.. _`Analogy`: http://weierophinney.net/matthew/archives/260-Dependency-Injection-An-analogy.html
.. _`Learning DI`: http://ralphschindler.com/2011/05/18/learning-about-dependency-injection-and-php
.. _`Series on DI`: http://fabien.potencier.org/article/11/what-is-dependency-injection
.. _`DRY`: http://en.wikipedia.org/wiki/Don%27t_repeat_yourself
