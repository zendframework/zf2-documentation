.. _zend.codegenerator.examples:

Zend_CodeGenerator Examples
===========================

.. _zend.codegenerator.examples.class:

.. rubric:: Generating PHP classes

The following example generates an empty class with a class-level DocBlock.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Sample generated class',
       'longDescription'  => 'This is a class generated with Zend_CodeGenerator.',
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
    * This is a class generated with Zend_CodeGenerator.
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

   }

.. _zend.codegenerator.examples.class-properties:

.. rubric:: Generating PHP classes with class properties

Building on the previous example, we now add properties to our generated class.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Sample generated class',
       'longDescription'  => 'This is a class generated with Zend_CodeGenerator.',
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
           array(
               'name'         => '_bar',
               'visibility'   => 'protected',
               'defaultValue' => 'baz',
           ),
           array(
               'name'         => 'baz',
               'visibility'   => 'public',
               'defaultValue' => 'bat',
           ),
           array(
               'name'         => 'bat',
               'const'        => true,
               'defaultValue' => 'foobarbazbat',
           ),
       ));
   echo $foo->generate();

The above results in the following class definition:

.. code-block:: php
   :linenos:

   /**
    * Sample generated class
    *
    * This is a class generated with Zend_CodeGenerator.
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

.. _zend.codegenerator.examples.class-methods:

.. rubric:: Generating PHP classes with class methods

``Zend_CodeGenerator_Php_Class`` allows you to attach methods with optional content to your classes. Methods may be attached as either arrays or concrete ``Zend_CodeGenerator_Php_Method`` instances.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Sample generated class',
       'longDescription'  => 'This is a class generated with Zend_CodeGenerator.',
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
           array(
               'name'         => '_bar',
               'visibility'   => 'protected',
               'defaultValue' => 'baz',
           ),
           array(
               'name'         => 'baz',
               'visibility'   => 'public',
               'defaultValue' => 'bat',
           ),
           array(
               'name'         => 'bat',
               'const'        => true,
               'defaultValue' => 'foobarbazbat',
           ),
       ))
       ->setMethods(array(
           // Method passed as array
           array(
               'name'       => 'setBar',
               'parameters' => array(
                   array('name' => 'bar'),
               ),
               'body'       => '$this->_bar = $bar;' . "\n" . 'return $this;',
               'docblock'   => new Zend_CodeGenerator_Php_Docblock(array(
                   'shortDescription' => 'Set the bar property',
                   'tags'             => array(
                       new Zend_CodeGenerator_Php_Docblock_Tag_Param(array(
                           'paramName' => 'bar',
                           'datatype'  => 'string'
                       )),
                       new Zend_CodeGenerator_Php_Docblock_Tag_Return(array(
                           'datatype'  => 'string',
                       )),
                   ),
               )),
           ),
           // Method passed as concrete instance
           new Zend_CodeGenerator_Php_Method(array(
               'name' => 'getBar',
               'body'       => 'return $this->_bar;',
               'docblock'   => new Zend_CodeGenerator_Php_Docblock(array(
                   'shortDescription' => 'Retrieve the bar property',
                   'tags'             => array(
                       new Zend_CodeGenerator_Php_Docblock_Tag_Return(array(
                           'datatype'  => 'string|null',
                       )),
                   ),
               )),
           )),
       ));

   echo $foo->generate();

The above generates the following output:

.. code-block:: php
   :linenos:

   /**
    * Sample generated class
    *
    * This is a class generated with Zend_CodeGenerator.
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

.. _zend.codegenerator.examples.file:

.. rubric:: Generating PHP files

``Zend_CodeGenerator_Php_File`` can be used to generate the contents of a *PHP* file. You can include classes as well as arbitrary content body. When attaching classes, you should attach either concrete ``Zend_CodeGenerator_Php_Class`` instances or an array defining the class.

In the example below, we will assume you've defined ``$foo`` per one of the class definitions in a previous example.

.. code-block:: php
   :linenos:

   $file = new Zend_CodeGenerator_Php_File(array(
       'classes'  => array($foo);
       'docblock' => new Zend_CodeGenerator_Php_Docblock(array(
           'shortDescription' => 'Foo class file',
           'tags'             => array(
               array(
                   'name'        => 'license',
                   'description' => 'New BSD',
               ),
           ),
       )),
       'body'     => 'define(\'APPLICATION_ENV\', \'testing\');',
   ));

Calling ``generate()`` will generate the code -- but not write it to a file. You will need to capture the contents and write them to a file yourself. As an example:

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
    * This is a class generated with Zend_CodeGenerator.
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

.. _zend.codegenerator.examples.reflection-file:

.. rubric:: Seeding PHP file code generation via reflection

You can add *PHP* code to an existing *PHP* file using the code generator. To do so, you need to first do reflection on it. The static method ``fromReflectedFileName()`` allows you to do this.

.. code-block:: php
   :linenos:

   $generator = Zend_CodeGenerator_Php_File::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.codegenerator.examples.reflection-class:

.. rubric:: Seeding PHP class generation via reflection

You may add code to an existing class. To do so, first use the static ``fromReflection()`` method to map the class into a generator object. From there, you may add additional properties or methods, and then regenerate the class.

.. code-block:: php
   :linenos:

   $generator = Zend_CodeGenerator_Php_Class::fromReflection(
       new Zend_Reflection_Class($class)
   );
   $generator->setMethod(array(
       'name'       => 'setBaz',
       'parameters' => array(
           array('name' => 'baz'),
       ),
       'body'       => '$this->_baz = $baz;' . "\n" . 'return $this;',
       'docblock'   => new Zend_CodeGenerator_Php_Docblock(array(
           'shortDescription' => 'Set the baz property',
           'tags'             => array(
               new Zend_CodeGenerator_Php_Docblock_Tag_Param(array(
                   'paramName' => 'baz',
                   'datatype'  => 'string'
               )),
               new Zend_CodeGenerator_Php_Docblock_Tag_Return(array(
                   'datatype'  => 'string',
               )),
           ),
       )),
   ));
   $code = $generator->generate();


