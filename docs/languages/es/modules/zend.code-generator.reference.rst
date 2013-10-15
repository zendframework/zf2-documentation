.. EN-Revision: none
.. _zend.codegenerator.reference:

Referencias de Zend_CodeGenerator
=================================

.. _zend.codegenerator.reference.abstracts:

Clases Abstractas e Interfaces
------------------------------

.. _zend.codegenerator.reference.abstracts.abstract:

Zend\CodeGenerator\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

La clase base desde la cual heredan todos las clases CodeGenerator proporciona la funcionalidad mínima necesaria.
Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Abstract
   {
       final public function __construct(Array $options = array())
       public function setOptions(Array $options)
       public function setSourceContent($sourceContent)
       public function getSourceContent()
       protected function _init()
       protected function _prepare()
       abstract public function generate();
       final public function __toString()
   }

El constructor primero llama a ``_init()`` (que se deja vacía para implementar extenciones a clases concretas), se
pasa entonces el parámetro ``$options`` a ``setOptions()``, y finalmente se llama a ``_prepare()`` (nuevamente, a
ser implementada por extensión de una clase)

Al igual que la mayoría de las clases en Zend Framework, ``setOptions()`` compara una opción clave con setters
existentes en la clase, y pasa el valor de ese método si lo encuentra.

``__toString()`` es marcado como final, y proxies a ``generate()``.

``setSourceContent()`` y ``getSourceContent()`` están destinados ya sea para fijar el valor por defecto del
contenido para el código a ser generado, o para sustituir dicho contenido una vez que se completen todas las
tareas de generación.

.. _zend.codegenerator.reference.abstracts.php-abstract:

Zend\CodeGenerator\Php\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Abstract`` extiende ``Zend\CodeGenerator\Abstract``, y añade algunas propiedades para
localizar su contenido si es que ha cambiado, así como el nivel de identación que debe aparecer antes del
contenido generado. Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Php\Abstract
       extends Zend\CodeGenerator\Abstract
   {
       public function setSourceDirty($isSourceDirty = true)
       public function isSourceDirty()
       public function setIndentation($indentation)
       public function getIndentation()
   }

.. _zend.codegenerator.reference.abstracts.php-member-abstract:

Zend\CodeGenerator\Php\Member\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Member\Abstract`` es una clase base para generar los miembros de clase -- propiedades y
métodos -- y brinda accesos y mutadores para establecer visibilidad; ya sea el miembro abstracto o no, estático o
definitivo; y el nombre del miembro. Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Php\Member\Abstract
       extends Zend\CodeGenerator\Php\Abstract
   {
       public function setAbstract($isAbstract)
       public function isAbstract()
       public function setStatic($isStatic)
       public function isStatic()
       public function setVisibility($visibility)
       public function getVisibility()
       public function setName($name)
       public function getName()
   }

.. _zend.codegenerator.reference.concrete:

Clases Concretas de CodeGenerator
---------------------------------

.. _zend.codegenerator.reference.concrete.php-body:

Zend\CodeGenerator\Php\Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Body`` se destina para generar código procedural arbitrario para incluir dentro de un
archivo. Como tal, usted simplemente establece contenidos para el objeto, y éste devolverá el contenido cuando
usted invoque a ``generate()``.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Body extends Zend\CodeGenerator\Php\Abstract
   {
       public function setContent($content)
       public function getContent()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-class:

Zend\CodeGenerator\Php\Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Class`` Está destinado a generar clases *PHP*. La funcionalidad básica sólo genera la
clase *PHP* en si misma, así como opcionalmente el *PHP* DocBlock. Las clases pueden implementarse o heredarse de
otras clases, y pueden ser marcadas como abstractas. Utilizando otras clases generadoras de código, también puede
agregar constantes de clase, propiedades y métodos.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Class extends Zend\CodeGenerator\Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Class $reflectionClass
       )
       public function setDocblock(Zend\CodeGenerator\Php\Docblock $docblock)
       public function getDocblock()
       public function setName($name)
       public function getName()
       public function setAbstract($isAbstract)
       public function isAbstract()
       public function setExtendedClass($extendedClass)
       public function getExtendedClass()
       public function setImplementedInterfaces(Array $implementedInterfaces)
       public function getImplementedInterfaces()
       public function setProperties(Array $properties)
       public function setProperty($property)
       public function getProperties()
       public function getProperty($propertyName)
       public function setMethods(Array $methods)
       public function setMethod($method)
       public function getMethods()
       public function getMethod($methodName)
       public function hasMethod($methodName)
       public function isSourceDirty()
       public function generate()
   }

El método ``setProperty()`` acepta un array de información que puede ser utilizada para generar una instancia
``Zend\CodeGenerator\Php\Property``-- o simplemente una instancia de ``Zend\CodeGenerator\Php\Property``.
Análogamente, ``setMethod()`` acepta o un array de información para generar una instancia de
``Zend\CodeGenerator\Php\Method`` o una instancia concreta de esa clase.

Se debe observar que ``setDocBlock()`` espera una instancia de ``Zend\CodeGenerator\Php\DocBlock``.

.. _zend.codegenerator.reference.concrete.php-docblock:

Zend\CodeGenerator\Php\Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Docblock`` puede ser utilizada para generar *PHP* docblocks arbitrarios, incluidas todas
las características estándar de docblock: descripciones cortas y largas y además los tags de anotaciones.

Los tags de anotación pueden establecerse utilizando los métodos ``setTag()`` y ``setTags()``; cada una de estas
toman o un array describiendo el tag que puede ser pasado al constructor ``Zend\CodeGenerator\Php\Docblock\Tag``, o
una instancia de esa clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock extends Zend\CodeGenerator\Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Docblock $reflectionDocblock
       )
       public function setShortDescription($shortDescription)
       public function getShortDescription()
       public function setLongDescription($longDescription)
       public function getLongDescription()
       public function setTags(Array $tags)
       public function setTag($tag)
       public function getTags()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag:

Zend\CodeGenerator\Php\Docblock\Tag
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Docblock\Tag`` está destinado a crear tags de anotaciones arbitrarias para su inclusión
en *PHP* docblocks. Se espera que los tags (etiquetas) contengan un nombre (la porción que sigue inmediatamente
después del símbolo '@') y una descripción (todo lo que sigue después del nombre del tag).

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag
       extends Zend\CodeGenerator\Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Docblock\Tag $reflectionTag
       )
       public function setName($name)
       public function getName()
       public function setDescription($description)
       public function getDescription()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-param:

Zend\CodeGenerator\Php\DocBlock\Tag\Param
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\DocBlock\Tag\Param`` es una versión especializada de
``Zend\CodeGenerator\Php\DocBlock\Tag``, y representa un parámetro del método. El nombre del tag es por lo tanto
("param"), pero debido al formato de este tag de anotación, es necesaria información adicional a fin de
generarla: el nombre del parámetro y el tipo de datos que representa.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection\Docblock\Tag $reflectionTagParam
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function setParamName($paramName)
       public function getParamName()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-return:

Zend\CodeGenerator\Php\DocBlock\Tag\Return
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Al igual la variante del tag docblock, ``Zend\CodeGenerator\Php\Docblock\Tab\Return`` es una variante de un tag de
anotación para representar el valor de retorno del método. En este caso, el nombre del tag de anotación es
conocido ("return"), pero requiere un tipo de retorno.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection\Docblock\Tag $reflectionTagReturn
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-file:

Zend\CodeGenerator\Php\File
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\File`` se utiliza para generar el contenido íntegro de un archivo que contiene código
*PHP*. El archivo puede contener clases o código *PHP* arbitrario, así como un archivo de nivel docblock si así
lo desea.

Cuando se agregan clases al archivo, necesitará pasar o un array de información para pasar al constructor
``Zend\CodeGenerator\Php\Class``, o una instancia de esa clase. De manera similar, con docblocks, usted tendrá que
pasar información para que lo consuma el constructor ``Zend\CodeGenerator\Php\Docblock`` o una instancia de la
clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\File extends Zend\CodeGenerator\Php\Abstract
   {
       public static function fromReflectedFilePath(
           $filePath,
           $usePreviousCodeGeneratorIfItExists = true,
           $includeIfNotAlreadyIncluded = true)
       public static function fromReflection(Zend\Reflection\File $reflectionFile)
       public function setDocblock(Zend\CodeGenerator\Php\Docblock $docblock)
       public function getDocblock()
       public function setRequiredFiles($requiredFiles)
       public function getRequiredFiles()
       public function setClasses(Array $classes)
       public function getClass($name = null)
       public function setClass($class)
       public function setFilename($filename)
       public function getFilename()
       public function getClasses()
       public function setBody($body)
       public function getBody()
       public function isSourceDirty()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-member-container:

Zend\CodeGenerator\Php\Member\Container
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Member\Container`` es usado internamente por ``Zend\CodeGenerator\Php\Class`` para seguir
la pista de los los miembros de la clase -- a propiedades y métodos por igual. Estos están indexados por nombre,
utilizando las instancias concretas de los miembros como valores.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Member\Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }

.. _zend.codegenerator.reference.concrete.php-method:

Zend\CodeGenerator\Php\Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Method`` describe un método de clase, y puede generar tanto el código y el docblock para
el método. La visibilidad y condición estática, abstracta, o se puede indicar como final, por su clase padre,
``Zend\CodeGenerator\Php\Member\Abstract``. Finalmente, pueden especificarse los parámetros y valor de retorno
para el método.

Pueden establecerse los parámetros usando ``setParameter()`` o ``setParameters()``. En cada caso, un parámetro
debe ser un array de información para pasar al constructor ``Zend\CodeGenerator\Php\Parameter`` o una instancia de
esa clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Method
       extends Zend\CodeGenerator\Php\Member\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Method $reflectionMethod
       )
       public function setDocblock(Zend\CodeGenerator\Php\Docblock $docblock)
       public function getDocblock()
       public function setFinal($isFinal)
       public function setParameters(Array $parameters)
       public function setParameter($parameter)
       public function getParameters()
       public function setBody($body)
       public function getBody()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-parameter:

Zend\CodeGenerator\Php\Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Parameter`` puede ser utilizada para especificar parámetros del método. Cada parámetro
puede tener una posición (si no están especificados, se usarán en el orden que estén registrados en el
método), son oblogatorios un valor por defecto, un tipo de datos y un nombre de parámetro.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Parameter extends Zend\CodeGenerator\Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Parameter $reflectionParameter
       )
       public function setType($type)
       public function getType()
       public function setName($name)
       public function getName()
       public function setDefaultValue($defaultValue)
       public function getDefaultValue()
       public function setPosition($position)
       public function getPosition()
       public function getPassedByReference()
       public function setPassedByReference($passedByReference)
       public function generate()
   }

There are several problems that might occur when trying to set ``NULL``, booleans or arrays as default values. For
this the value holder object ``Zend\CodeGenerator\Php\ParameterDefaultValue`` can be used, for example:

.. code-block:: php
   :linenos:

   $parameter = new Zend\CodeGenerator\Php\Parameter();
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("null")
   );
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("array('foo', 'bar')")
   );

Internally ``setDefaultValue()`` also converts the values which can't be expressed in *PHP* into the value holder.

.. _zend.codegenerator.reference.concrete.php-property:

Zend\CodeGenerator\Php\Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Property`` describe una propiedad de clase, que puede ser tanto una constante o una
variable. En cada caso, la propiedad puede tener un valor predeterminado asociado con ella. Además, la visibilidad
de las propiedades de la variable puede ser establecida por la clase padre,
``Zend\CodeGenerator\Php\Member\Abstract``.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Property
       extends Zend\CodeGenerator\Php\Member\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Property $reflectionProperty
       )
       public function setConst($const)
       public function isConst()
       public function setDefaultValue($defaultValue)
       public function getDefaultValue()
       public function generate()
   }


