.. _zend.di.definition:

Zend\\Di Definition
===================

Definitions are the place where Zend\\Di attempts to understand the structure of the code it is attempting to wire.
This means that if you've written non-ambiguous, clear and concise code; Zend\\Di has a very good chance of
understanding how to wire things up without much added complexity.

.. _zend.di.definition.definitionlist:

DefinitionList
--------------

Definitions are introduced to the Zend\\Di\\Di object through a definition list implemented as
Zend\\Di\\DefinitionList (SplDoublyLinkedList). Order is important. Definitions in the front of the list will be
consulted on a class before definitions at the end of the list.

.. note::

   Regardless of what kind of Definition strategy you decide to use, it is important that your autoloaders are
   already setup and ready to use.

.. _zend.di.definition.runtimedefinition:

RuntimeDefinition
-----------------

The default DefinitionList instantiated by Zend\\Di\\Di, when no other DefinitionList is provided, has as
Definition\\RuntimeDefinition baked-in. The RuntimeDefinition will respond to query's about classes by using
Reflection. This Runtime definitions uses any available information inside methods: their signature, the names of
parameters, the type-hints of the parameters, and the default values to determine if something is optional or
required when making a call to that method. The more explicit you can be in your method naming and method
signatures, the easier of a time Zend\\Di\\Definition\\RuntimeDefinition will have determining the structure of
your code.

This is what the constructor of a RuntimeDefinition looks like:

.. code-block:: php
   :linenos:

   public function __construct(IntrospectionStrategy $introspectionStrategy = null, array $explicitClasses = null)
   {
       $this->introspectionStrategy = ($introspectionStrategy) ?: new IntrospectionStrategy();
       if ($explicitClasses) {
           $this->setExplicitClasses($explicitClasses);
       }
   }

The IntrospectionStrategy object is an object that determines the rules, or guidelines, for how the
RuntimeDefinition will introspect information about your classes. Here are the things it knows how to do:

- Whether or not to use Annotations (Annotations are expensive and off by default, read more about these in the
  Annotations section)

- Which method names to include in the introspection, by default, the pattern /^set[A-Z]{1}\\w*/ is registered by
  default, this is a list of patterns.

- Which interface names represent the interface injection pattern. By default, the pattern /\\w*Aware\\w*/ is
  registered, this is a list of patterns.

The constructor for the IntrospectionStrategy looks like this:

.. code-block:: php
   :linenos:

   public function __construct(AnnotationManager $annotationManager = null)
   {
       $this->annotationManager = ($annotationManager) ?: $this->createDefaultAnnotationManager();
   }

This goes to say that an AnnotationManager is not required, but if you wish to create a special AnnotationManager
with your own annotations, and also wish to extend the RuntimeDefinition to look for these special Annotations,
this is the place to do it.

The RuntimeDefinition also can be used to look up either all classes (implicitly, which is default), or explicitly
look up for particular pre-defined classes. This is useful when your strategy for inspecting one set of classes
might differ from those of another strategy for another set of classes. This can be achieved by using the
setExplicitClasses() method or by passing a list of classes as a second argument to the constructor of the
RuntimeDefinition.

.. _zend.di.definition.compilerdefinition:

CompilerDefinition
------------------

The CompilerDefinition is very much similar in nature to the RuntimeDefinition with the exception that it can be
seeded with more information for the purposes of "compiling" a definition. This is useful when you do not want to
be making all those (sometimes expensive) calls to reflection and the annotation scanning system during the request
of your application. By using the compiler, a definition can be created and written to disk to be used during a
request, as opposed to the task of scanning the actual code.

For example, let's assume we want to create a script that will create definitions for some of our library code:

.. code-block:: php
   :linenos:

   // in "package name" format
   $components = array(
       'My_MovieApp',
       'My_OtherClasses',
   );

   foreach ($components as $component) {
       $diCompiler = new Zend\Di\Definition\CompilerDefinition;
       $diCompiler->addDirectory('/path/to/classes/' . str_replace('_', '/', $component));

       $diCompiler->compile();
       file_put_contents(
           __DIR__ . '/../data/di/' . $component . '-definition.php',
           '<?php return ' . var_export($diCompiler->toArrayDefinition()->toArray(), true) . ';'
       );
   }

This will create a couple of files that will return an array of the definition for that class. To utilize this in
an application, the following code will suffice:

.. code-block:: php
   :linenos:

   protected function setupDi(Application $app)
   {
       $definitionList = new DefinitionList(array(
           new Definition\ArrayDefinition(include __DIR__ . '/path/to/data/di/My_MovieApp-definition.php'),
           new Definition\ArrayDefinition(include __DIR__ . '/path/to/data/di/My_OtherClasses-definition.php'),
           $runtime = new Definition\RuntimeDefinition(),
       ));
       $di = new Di($definitionList, null, new Config($this->config->di));
       $di->instanceManager()->addTypePreference('Zend\Di\LocatorInterface', $di);
       $app->setLocator($di);
   }

The above code would more than likely go inside your application's or module's bootstrap file. This represents the
simplest and most performant way of configuring your DiC for usage.

.. _zend.di.definition.classdefinition:

ClassDefinition
---------------

The idea behind using a ClassDefinition is two-fold. First, you may want to override some information inside of a
RuntimeDefinition. Secondly, you might want to simply define your complete class's definition with an xml, ini, or
php file describing the structure. This class definition can be fed in via Configuration or by directly
instantiating and registering the Definition with the DefinitionList.

Todo - example


