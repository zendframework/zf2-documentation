.. EN-Revision: none
.. _zend.codegenerator.examples:

Ejemplos de Zend_CodeGenerator
==============================

.. _zend.codegenerator.examples.class:

.. rubric:: Generando clases PHP

El siguiente ejemplo genera una clase vacía con una clase de nivel DocBlock.

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
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

El código anterior resultará en lo siguiente:

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

.. rubric:: Generando clases PHP con propiedades de clase

Basándonos en el ejemplo anterior, ahora agreguemos propiedades a nuestra clase generada.

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
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

Lo anterior resulta en la siguiente definición de clase:

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

.. rubric:: Generando clases PHP con métodos de clase

``Zend\CodeGenerator_Php\Class`` le permite adjuntar métodos con contenido opcional a sus clases. Los métodos
pueden adjuntarse tanto como arrays o como instancias concretas de ``Zend\Code\Generator\MethodGenerator``.

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
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
           // Método pasado como array
           array(
               'name'       => 'setBar',
               'parameters' => array(
                   array('name' => 'bar'),
               ),
               'body'       => '$this->_bar = $bar;' . "\n" . 'return $this;',
               'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
                   'shortDescription' => 'Set the bar property',
                   'tags'             => array(
                       new Zend\CodeGenerator\Php\Docblock\Tag\Param(array(
                           'paramName' => 'bar',
                           'datatype'  => 'string'
                       )),
                       new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                           'datatype'  => 'string',
                       )),
                   ),
               )),
           ),
           // Método pasado como instancia concreta
           new Zend\CodeGenerator_Php\Method(array(
               'name' => 'getBar',
               'body'       => 'return $this->_bar;',
               'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
                   'shortDescription' => 'Retrieve the bar property',
                   'tags'             => array(
                       new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                           'datatype'  => 'string|null',
                       )),
                   ),
               )),
           )),
       ));

   echo $foo->generate();

Lo anterior genera la siguiente salida:

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

.. rubric:: Generando archivos PHP

``Zend\CodeGenerator_Php\File`` puede ser utilizada para generar el contenido de un archivo *PHP*. Usted puede
incluir clases, así como el contenido arbitrario del cuerpo. Cuando acople clases, debe adjuntar instancias
concretas de ``Zend\CodeGenerator_Php\Class`` o un array definiendo la clase.

En el ejemplo siguiente, asumiremos que ha definido ``$foo`` como una de las definiciones de clase del ejemplo
anterior.

.. code-block:: php
   :linenos:

   $file = new Zend\CodeGenerator_Php\File(array(
       'classes'  => array($foo);
       'docblock' => new Zend\CodeGenerator_Php\Docblock(array(
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

Llamando a ``generate()`` generará el código -- pero no lo grabará en un archivo. Usted mismo deberá capturar y
grabar los contenidos en un archivo. Por ejemplo:

.. code-block:: php
   :linenos:

   $code = $file->generate();
   file_put_contents('Foo.php', $code);

Lo anterior generará el siguiente archivo:

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

.. rubric:: Sembrando la generación de código para un archivo PHP via reflection

You can add *PHP* code to an existing *PHP* file using the code generator. To do so, you need to first do
reflection on it. The static method ``fromReflectedFileName()`` allows you to do this.

.. code-block:: php
   :linenos:

   $generator = Zend\CodeGenerator_Php\File::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.codegenerator.examples.reflection-class:

.. rubric:: Sembrando la generación de clases PHP via reflection

You may add code to an existing class. To do so, first use the static ``fromReflection()`` method to map the class
into a generator object. From there, you may add additional properties or methods, and then regenerate the class.

.. code-block:: php
   :linenos:

   $generator = Zend\CodeGenerator_Php\Class::fromReflection(
       new Zend\Reflection\Class($class)
   );
   $generator->setMethod(array(
       'name'       => 'setBaz',
       'parameters' => array(
           array('name' => 'baz'),
       ),
       'body'       => '$this->_baz = $baz;' . "\n" . 'return $this;',
       'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
           'shortDescription' => 'Set the baz property',
           'tags'             => array(
               new Zend\CodeGenerator\Php\Docblock\Tag\Param(array(
                   'paramName' => 'baz',
                   'datatype'  => 'string'
               )),
               new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                   'datatype'  => 'string',
               )),
           ),
       )),
   ));
   $code = $generator->generate();

.. _zend.codegenerator.examples.reflection-method:

.. rubric:: Sembrando la generación de métodos PHP via reflection

You may add code to an existing class. To do so, first use the static ``fromReflection()`` method to map the class
into a generator object. From there, you may add additional properties or methods, and then regenerate the class.


