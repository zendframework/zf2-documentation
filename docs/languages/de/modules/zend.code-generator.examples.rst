.. _zend.codegenerator.examples:

Zend_CodeGenerator Beispiele
============================

.. _zend.codegenerator.examples.class:

.. rubric:: Erzeugung von PHP Klassen

Das folgende Beispiel erzeugt eine leere Klasse mit einem Klassen-level DocBlock.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Beispiel einer erzeugten Klasse',
       'longDescription'  => 'Das ist eine mit Zend_CodeGenerator '
                           . 'erzeugte Klasse.',
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

Der obige Code führt zu dem folgenden:

.. code-block:: php
   :linenos:

   /**
    * Beispiel einer erzeugten Klasse
    *
    * Das ist eine mit Zend_CodeGenerator erzeugte Klasse.
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

   }

.. _zend.codegenerator.examples.class-properties:

.. rubric:: Erzeugung von PHP Klassen mit Klassen-Eigenschaften

Aufbauend auf dem vorherigen Beispiel, fügen wir jetzt Eigenschaften in unsere erzeugte Klasse ein.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Beispiel einer erzeugten Klasse',
       'longDescription'  => 'Das ist eine mit Zend_CodeGenerator '
                           . 'erzeugte Klasse.',
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

Das obige führt zu der folgenden Klassen-Definition:

.. code-block:: php
   :linenos:

   /**
    * Beispiel einer erzeugten Klasse
    *
    * Das ist eine mit Zend_CodeGenerator erzeugte Klasse.
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

.. rubric:: Erzeugung von PHP Klassen mit Klassen-Methoden

``Zend_CodeGenerator_Php_Class`` erlaubt es Methoden mit optionalem Inhalt zur Klasse hinzuzufügen. Methoden
können entweder als Array oder als konkrete Instanzen von ``Zend_CodeGenerator_Php_Method`` hinzugefügt werden.

.. code-block:: php
   :linenos:

   $foo      = new Zend_CodeGenerator_Php_Class();
   $docblock = new Zend_CodeGenerator_Php_Docblock(array(
       'shortDescription' => 'Beispiel einer erzeugten Klasse',
       'longDescription'  => 'Das ist eine mit Zend_CodeGenerator '
                           . 'erzeugte Klasse.',
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
           // Methoden als Array übergeben
           array(
               'name'       => 'setBar',
               'parameters' => array(
                   array('name' => 'bar'),
               ),
               'body'       => '$this->_bar = $bar;' . "\n" . 'return $this;',
               'docblock'   => new Zend_CodeGenerator_Php_Docblock(array(
                   'shortDescription' => 'Setzt die bar Eigenschaft',
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
           // Methoden als konkrete Instanz übergeben
           new Zend_CodeGenerator_Php_Method(array(
               'name' => 'getBar',
               'body'       => 'return $this->_bar;',
               'docblock'   => new Zend_CodeGenerator_Php_Docblock(array(
                   'shortDescription' => 'Empfängt die bar Eigenschaft',
                   'tags'             => array(
                       new Zend_CodeGenerator_Php_Docblock_Tag_Return(array(
                           'datatype'  => 'string|null',
                       )),
                   ),
               )),
           )),
       ));

   echo $foo->generate();

Das obige erzeugt die folgende Ausgabe:

.. code-block:: php
   :linenos:

   /**
    * Beispiel einer erzeugten Klasse
    *
    * Das ist eine mit Zend_CodeGenerator erzeugte Klasse.
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
        * Setzt die bar Eigenschaft
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
        * Empfängt die bar Eigenschaft
        *
        * @return string|null
        */
       public function getBar()
       {
           return $this->_bar;
       }

   }

.. _zend.codegenerator.examples.file:

.. rubric:: Erzeugung von PHP Dateien

``Zend_CodeGenerator_Php_File`` kann verwendet werden um den Inhalt einer *PHP* Datei zu erzeugen. Man kann Klassen
inkludieren als auch eigene Inhalte. Wenn Klassen angegängt werden sollte man entweder eine konkrete Instanz von
``Zend_CodeGenerator_Php_Class`` oder ein Array das die Klasse definiert anhängen.

Das folgende Beispiel nimmt an das wir ``$foo`` mit einer der Klassen-Definitionen der vorherigen Beispiele
definiert haben.

.. code-block:: php
   :linenos:

   $file = new Zend_CodeGenerator_Php_File(array(
       'classes'  => array($foo);
       'docblock' => new Zend_CodeGenerator_Php_Docblock(array(
           'shortDescription' => 'Foo Klassen Datei',
           'tags'             => array(
               array(
                   'name'        => 'license',
                   'description' => 'New BSD',
               ),
           ),
       )),
       'body'     => 'define(\'APPLICATION_ENV\', \'testing\');',
   ));

Der Aufruf von ``generate()`` erzeugt den Code -- schreibt Ihn aber nicht in die Datei. Man muß den Inhalt holen
und Ihn selbst in eine Datei schreiben. Als Beispiel:

.. code-block:: php
   :linenos:

   $code = $file->generate();
   file_put_contents('Foo.php', $code);

Das obige erzeugt die folgende Datei:

.. code-block:: php
   :linenos:

   <?php
   /**
    * Foo Klassen Datei
    *
    * @license New BSD
    */

   /**
    * Beispiel einer erzeugten Klasse
    *
    * Das ist eine mit Zend_CodeGenerator erzeugte Klasse.
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

.. rubric:: Sähen der Code Erzeugung einer PHP Datei über Reflection

Man kann *PHP* Code zu einer existierenden *PHP* Datei hinzufügen indem der Code Generator verwendet wird. Um das
Durchzuführen muß man auf diesem zuerst Reflection ausführen. Die statische Methode ``fromReflectedFileName()``
erlaubt es das zu tun.

.. code-block:: php
   :linenos:

   $generator = Zend_CodeGenerator_Php_File::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.codegenerator.examples.reflection-class:

.. rubric:: Sähen der Erzeugung einer PHP Klasse über Reflection

Man kann Code zu einer bestehenden Klasse hinzufügen. Um das Durchzuführen muß die statische
``fromReflection()`` Methode verwendet werden um die Klasse in ein Generator Objekt zu mappen. Von dort, kann man
zusätzliche Eigenschaften oder Methoden hinzufügen und die Klasse neu erstellen.

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
           'shortDescription' => 'Die baz Eigenschaft setzen',
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


