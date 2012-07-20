.. _zend.codegenerator.examples:

Exemples Zend_CodeGenerator
===========================

.. _zend.codegenerator.examples.class:

.. rubric:: Génération de classes PHP

L'exemple suivant génère le code d'une classe avec son bloc de commentaires PHPDoc.

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

Le résultat est :

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

.. rubric:: Générer des classes PHP avec des attributs de classe

Suivant l'exemple précédant, nous ajoutons maintenant des attributs à la classe.

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

Le résultat sera :

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

.. rubric:: Générer des classes PHP avec des méthodes

``Zend_CodeGenerator_Php_Class`` vous permet d'attacher des méthodes à vos classes générées. L'attachement se
fait soit par des tableaux, soit directement des objets ``Zend_CodeGenerator_Php_Method``.

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

Le résultat sera :

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

.. rubric:: Générer des fichiers PHP

``Zend_CodeGenerator_Php_File`` sert à générer le contenu de fichiers *PHP*. Il est possible d'insérer du code
de classes, ou n'importe quel code. Si vous attachez des classes, vous pouvez les passer sous forme de tableaux ou
directement d'objets ``Zend_CodeGenerator_Php_Class``.

Dans l'exemple suivant, nous supposons que vous avez défini ``$foo`` comme étant le code d'une des classes des
exemples précédents.

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

L'appel à ``generate()`` va générer le code, mais pas l'écrire dans un fichier. Pour ce faire, il faudra
d'abord capturer le contenu:

.. code-block:: php
   :linenos:

   $code = $file->generate();
   file_put_contents('Foo.php', $code);

Le résultat sera :

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

.. rubric:: Ajouter du code à un fichier PHP existant en utilisant la réflexion

Vous pouvez ajouter du code *PHP* à n'importe quel fichier *PHP* existant à condition d'utiliser la réflexion
sur celui-ci afin de l'analyser. La méthode ``fromReflectedFileName()`` va vous y aider.

.. code-block:: php
   :linenos:

   $generator = Zend_CodeGenerator_Php_File::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.codegenerator.examples.reflection-class:

.. rubric:: Ajouter du code à une classe PHP existante en utilisant la réflexion

Vous pouvez aussi ajouter du code à une classe existante. Utilisez ``fromReflection()`` pour transformer la classe
en objet Reflection. Ajoutez ensuite des méthodes, des attributs, puis régénérez le code de la classe
modifiée :

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


