.. _zend.code.generator.examples:

Zend\Code\Generator Examples
===========================

.. _zend.code.generator.examples.class:

.. rubric:: Generating PHP classes

The following example generates an empty class with a class-level DocBlock.

.. code-block:: php
   :linenos:

   $foo      = new Zend\Code\Generator\ClassGenerator();
   $docblock = Zend\Code\Generator\DocblockGenerator::fromArray(array(
       'shortDescription' => 'Sample generated class',
       'longDescription'  => 'This is a class generated with Zend\Code\Generator.',
       'tags'             => array(
           array(
               'name'        => 'version',
               'description' => '$Rev:$',
           ),
           array(
               'name'        => 'license',
               'description' => 'New BSD',
           ),
       ),
   ));
   $foo->setName('Foo')
       ->setDocblock($docblock);
   echo $foo->generate();

The above code will result in the following:

.. code-block:: php
   :linenos:

   /**
    * Sample generated class
    *
    * This is a class generated with Zend\Code\Generator.
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

   }

.. _zend.code.generator.examples.class-properties:

.. rubric:: Generating PHP classes with class properties

Building on the previous example, we now add properties to our generated class.

.. code-block:: php
   :linenos:

   $foo      = new Zend\Code\Generator\ClassGenerator();
   $docblock = Zend\Code\Generator\DocBlockGenerator::fromArray(array(
       'shortDescription' => 'Sample generated class',
       'longDescription'  => 'This is a class generated with Zend\Code\Generator.',
       'tags'             => array(
           array(
               'name'        => 'version',
               'description' => '$Rev:$',
           ),
           array(
               'name'        => 'license',
               'description' => 'New BSD',
           ),
       ),
   ));
   $foo->setName('Foo')
       ->setDocblock($docblock)
       ->setProperties(array(
            array('_bar', 'baz', Zend\Code\Generator\PropertyGenerator::FLAG_PROTECTED),
            array('baz', 'bat', Zend\Code\Generator\PropertyGenerator::FLAG_PUBLIC),
            array('bat', 'foobarbazbat', Zend\Code\Generator\PropertyGenerator::FLAG_CONSTANT),
       ));
   echo $foo->generate();

The above results in the following class definition:

.. code-block:: php
   :linenos:

   /**
    * Sample generated class
    *
    * This is a class generated with Zend\Code\Generator.
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

   }

.. _zend.code.generator.examples.class-methods:

.. rubric:: Generating PHP classes with class methods

``Zend\Code\Generator\ClassGenerator`` allows you to attach methods with optional content to your classes. Methods may be
attached as either arrays or concrete ``Zend\Code\Generator\MethodGenerator`` instances.

.. code-block:: php
   :linenos:

    $foo      = new Zend\Code\Generator\ClassGenerator();
    $docblock = Zend\Code\Generator\DocBlockGenerator::fromArray(array(
        'shortDescription' => 'Sample generated class',
        'longDescription'  => 'This is a class generated with Zend\Code\Generator.',
        'tags'             => array(
            array(
                'name'        => 'version',
                'description' => '$Rev:$',
            ),
            array(
                'name'        => 'license',
                'description' => 'New BSD',
            ),
        ),
    ));
    $foo->setName('Foo')
        ->setDocblock($docblock)
        ->addProperties(array(
            array('_bar', 'baz', Zend\Code\Generator\PropertyGenerator::FLAG_PROTECTED),
            array('baz', 'bat', Zend\Code\Generator\PropertyGenerator::FLAG_PUBLIC),
            array('bat', 'foobarbazbat', Zend\Code\Generator\PropertyGenerator::FLAG_CONSTANT),
        ))
        ->addMethods(array(
            // Method passed as array
            Zend\Code\Generator\MethodGenerator::fromArray(array(
                'name'       => 'setBar',
                'parameters' => array('bar'),
                'body'       => '$this->_bar = $bar;' . "\n" . 'return $this;',
                'docblock'   => Zend\Code\Generator\DocBlockGenerator::fromArray(array(
                    'shortDescription' => 'Set the bar property',
                    'longDescription'  => null,
                    'tags'             => array(
                        new Zend\Code\Generator\DocBlock\Tag\ParamTag(array(
                            'paramName' => 'bar',
                            'datatype'  => 'string'
                        )),
                        new Zend\Code\Generator\DocBlock\Tag\ReturnTag(array(
                            'datatype'  => 'string',
                        )),
                    ),
                )),
            )),
            // Method passed as concrete instance
            new Zend\Code\Generator\MethodGenerator(
                'getBar',
                array(),
                Zend\Code\Generator\MethodGenerator::FLAG_PUBLIC,
                'return $this->_bar;',
                Zend\Code\Generator\DocBlockGenerator::fromArray(array(
                    'shortDescription' => 'Retrieve the bar property',
                    'longDescription'  => null,
                    'tags'             => array(
                        new Zend\Code\Generator\DocBlock\Tag\ReturnTag(array(
                            'datatype'  => 'string|null',
                        )),
                    ),
                ))
            ),
        ));

   echo $foo->generate();

The above generates the following output:

.. code-block:: php
   :linenos:

   /**
    * Sample generated class
    *
    * This is a class generated with Zend\Code\Generator.
    *
    * @version $Rev:$
    * @license New BSD
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

       /**
        * Set the bar property
        *
        * @param string bar
        * @return string
        */
       public function setBar($bar)
       {
           $this->_bar = $bar;
           return $this;
       }

       /**
        * Retrieve the bar property
        *
        * @return string|null
        */
       public function getBar()
       {
           return $this->_bar;
       }

   }

.. _zend.code.generator.examples.file:

.. rubric:: Generating PHP files

``Zend\Code\Generator\FileGenerator`` can be used to generate the contents of a *PHP* file. You can include classes as
well as arbitrary content body. When attaching classes, you should attach either concrete
``Zend\Code\Generator\ClassGenerator`` instances or an array defining the class.

In the example below, we will assume you've defined ``$foo`` per one of the class definitions in a previous
example.

.. code-block:: php
   :linenos:

    $file = Zend\Code\Generator\FileGenerator::fromArray(array(
        'classes'  => array($foo),
        'docblock' => Zend\Code\Generator\DocBlockGenerator::fromArray(array(
            'shortDescription' => 'Foo class file',
            'longDescription'   => null,
            'tags'             => array(
                array(
                    'name'        => 'license',
                    'description' => 'New BSD',
                ),
            ),
        )),
        'body'     => 'define(\'APPLICATION_ENV\', \'testing\');',
    ));

Calling ``generate()`` will generate the code -- but not write it to a file. You will need to capture the contents
and write them to a file yourself. As an example:

.. code-block:: php
   :linenos:

   $code = $file->generate();
   file_put_contents('Foo.php', $code);

The above will generate the following file:

.. code-block:: php
   :linenos:

   <?php
   /**
    * Foo class file
    *
    * @license New BSD
    */

   /**
    * Sample generated class
    *
    * This is a class generated with Zend\Code\Generator.
    *
    * @version $Rev:$
    * @license New BSD
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

       /**
        * Set the bar property
        *
        * @param string bar
        * @return string
        */
       public function setBar($bar)
       {
           $this->_bar = $bar;
           return $this;
       }

       /**
        * Retrieve the bar property
        *
        * @return string|null
        */
       public function getBar()
       {
           return $this->_bar;
       }

   }

   define('APPLICATION_ENV', 'testing');

.. _zend.code.generator.examples.reflection-file:

.. rubric:: Seeding PHP file code generation via reflection

You can add *PHP* code to an existing *PHP* file using the code generator. To do so, you need to first do
reflection on it. The static method ``fromReflectedFileName()`` allows you to do this.

.. code-block:: php
   :linenos:

   $generator = Zend\Code\Generator\FileGenerator::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.code.generator.examples.reflection-class:

.. rubric:: Seeding PHP class generation via reflection

You may add code to an existing class. To do so, first use the static ``fromReflection()`` method to map the class
into a generator object. From there, you may add additional properties or methods, and then regenerate the class.

.. code-block:: php
   :linenos:

    $generator = Zend\Code\Generator\ClassGenerator::fromReflection(
        new Zend\Code\Reflection\ClassReflection($class)
    );
    $generator->addMethod(
        'setBaz',
        array('baz'),
        Zend\Code\Generator\MethodGenerator::FLAG_PUBLIC,
        '$this->_baz = $baz;' . "\n" . 'return $this;',
        Zend\Code\Generator\DocBlockGenerator::fromArray(array(
            'shortDescription' => 'Set the baz property',
            'longDescription'  => null,
            'tags'             => array(
                new Zend\Code\Generator\DocBlock\Tag\ParamTag(array(
                    'paramName' => 'baz',
                    'datatype'  => 'string'
                )),
                new Zend\Code\Generator\DocBlock\Tag\ReturnTag(array(
                    'datatype'  => 'string',
                )),
            ),
        ))
    );
   $code = $generator->generate();
