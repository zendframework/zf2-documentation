.. _zend.codegenerator.reference:

Referencias de Zend_CodeGenerator
=================================

.. _zend.codegenerator.reference.abstracts:

Clases Abstractas e Interfaces
------------------------------

.. _zend.codegenerator.reference.abstracts.abstract:

Zend_CodeGenerator_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

La clase base desde la cual heredan todos las clases CodeGenerator proporciona la funcionalidad mínima necesaria.
Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend_CodeGenerator_Abstract
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

Zend_CodeGenerator_Php_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Abstract`` extiende ``Zend_CodeGenerator_Abstract``, y añade algunas propiedades para
localizar su contenido si es que ha cambiado, así como el nivel de identación que debe aparecer antes del
contenido generado. Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend_CodeGenerator_Php_Abstract
       extends Zend_CodeGenerator_Abstract
   {
       public function setSourceDirty($isSourceDirty = true)
       public function isSourceDirty()
       public function setIndentation($indentation)
       public function getIndentation()
   }

.. _zend.codegenerator.reference.abstracts.php-member-abstract:

Zend_CodeGenerator_Php_Member_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Member_Abstract`` es una clase base para generar los miembros de clase -- propiedades y
métodos -- y brinda accesos y mutadores para establecer visibilidad; ya sea el miembro abstracto o no, estático o
definitivo; y el nombre del miembro. Su *API* es la siguiente:

.. code-block:: php
   :linenos:

   abstract class Zend_CodeGenerator_Php_Member_Abstract
       extends Zend_CodeGenerator_Php_Abstract
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

Zend_CodeGenerator_Php_Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Body`` se destina para generar código procedural arbitrario para incluir dentro de un
archivo. Como tal, usted simplemente establece contenidos para el objeto, y éste devolverá el contenido cuando
usted invoque a ``generate()``.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Body extends Zend_CodeGenerator_Php_Abstract
   {
       public function setContent($content)
       public function getContent()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-class:

Zend_CodeGenerator_Php_Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Class`` Está destinado a generar clases *PHP*. La funcionalidad básica sólo genera la
clase *PHP* en si misma, así como opcionalmente el *PHP* DocBlock. Las clases pueden implementarse o heredarse de
otras clases, y pueden ser marcadas como abstractas. Utilizando otras clases generadoras de código, también puede
agregar constantes de clase, propiedades y métodos.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Class extends Zend_CodeGenerator_Php_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Class $reflectionClass
       )
       public function setDocblock(Zend_CodeGenerator_Php_Docblock $docblock)
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
``Zend_CodeGenerator_Php_Property``-- o simplemente una instancia de ``Zend_CodeGenerator_Php_Property``.
Análogamente, ``setMethod()`` acepta o un array de información para generar una instancia de
``Zend_CodeGenerator_Php_Method`` o una instancia concreta de esa clase.

Se debe observar que ``setDocBlock()`` espera una instancia de ``Zend_CodeGenerator_Php_DocBlock``.

.. _zend.codegenerator.reference.concrete.php-docblock:

Zend_CodeGenerator_Php_Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Docblock`` puede ser utilizada para generar *PHP* docblocks arbitrarios, incluidas todas
las características estándar de docblock: descripciones cortas y largas y además los tags de anotaciones.

Los tags de anotación pueden establecerse utilizando los métodos ``setTag()`` y ``setTags()``; cada una de estas
toman o un array describiendo el tag que puede ser pasado al constructor ``Zend_CodeGenerator_Php_Docblock_Tag``, o
una instancia de esa clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Docblock extends Zend_CodeGenerator_Php_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Docblock $reflectionDocblock
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

Zend_CodeGenerator_Php_Docblock_Tag
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Docblock_Tag`` está destinado a crear tags de anotaciones arbitrarias para su inclusión
en *PHP* docblocks. Se espera que los tags (etiquetas) contengan un nombre (la porción que sigue inmediatamente
después del símbolo '@') y una descripción (todo lo que sigue después del nombre del tag).

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Docblock_Tag
       extends Zend_CodeGenerator_Php_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Docblock_Tag $reflectionTag
       )
       public function setName($name)
       public function getName()
       public function setDescription($description)
       public function getDescription()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-param:

Zend_CodeGenerator_Php_DocBlock_Tag_Param
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_DocBlock_Tag_Param`` es una versión especializada de
``Zend_CodeGenerator_Php_DocBlock_Tag``, y representa un parámetro del método. El nombre del tag es por lo tanto
("param"), pero debido al formato de este tag de anotación, es necesaria información adicional a fin de
generarla: el nombre del parámetro y el tipo de datos que representa.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Docblock_Tag_Param
       extends Zend_CodeGenerator_Php_Docblock_Tag
   {
       public static function fromReflection(
           Zend_Reflection_Docblock_Tag $reflectionTagParam
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function setParamName($paramName)
       public function getParamName()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-return:

Zend_CodeGenerator_Php_DocBlock_Tag_Return
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Al igual la variante del tag docblock, ``Zend_CodeGenerator_Php_Docblock_Tab_Return`` es una variante de un tag de
anotación para representar el valor de retorno del método. En este caso, el nombre del tag de anotación es
conocido ("return"), pero requiere un tipo de retorno.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Docblock_Tag_Param
       extends Zend_CodeGenerator_Php_Docblock_Tag
   {
       public static function fromReflection(
           Zend_Reflection_Docblock_Tag $reflectionTagReturn
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-file:

Zend_CodeGenerator_Php_File
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_File`` se utiliza para generar el contenido íntegro de un archivo que contiene código
*PHP*. El archivo puede contener clases o código *PHP* arbitrario, así como un archivo de nivel docblock si así
lo desea.

Cuando se agregan clases al archivo, necesitará pasar o un array de información para pasar al constructor
``Zend_CodeGenerator_Php_Class``, o una instancia de esa clase. De manera similar, con docblocks, usted tendrá que
pasar información para que lo consuma el constructor ``Zend_CodeGenerator_Php_Docblock`` o una instancia de la
clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_File extends Zend_CodeGenerator_Php_Abstract
   {
       public static function fromReflectedFilePath(
           $filePath,
           $usePreviousCodeGeneratorIfItExists = true,
           $includeIfNotAlreadyIncluded = true)
       public static function fromReflection(Zend_Reflection_File $reflectionFile)
       public function setDocblock(Zend_CodeGenerator_Php_Docblock $docblock)
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

Zend_CodeGenerator_Php_Member_Container
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Member_Container`` es usado internamente por ``Zend_CodeGenerator_Php_Class`` para seguir
la pista de los los miembros de la clase -- a propiedades y métodos por igual. Estos están indexados por nombre,
utilizando las instancias concretas de los miembros como valores.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Member_Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }

.. _zend.codegenerator.reference.concrete.php-method:

Zend_CodeGenerator_Php_Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Method`` describe un método de clase, y puede generar tanto el código y el docblock para
el método. La visibilidad y condición estática, abstracta, o se puede indicar como final, por su clase padre,
``Zend_CodeGenerator_Php_Member_Abstract``. Finalmente, pueden especificarse los parámetros y valor de retorno
para el método.

Pueden establecerse los parámetros usando ``setParameter()`` o ``setParameters()``. En cada caso, un parámetro
debe ser un array de información para pasar al constructor ``Zend_CodeGenerator_Php_Parameter`` o una instancia de
esa clase.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Method
       extends Zend_CodeGenerator_Php_Member_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Method $reflectionMethod
       )
       public function setDocblock(Zend_CodeGenerator_Php_Docblock $docblock)
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

Zend_CodeGenerator_Php_Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Parameter`` puede ser utilizada para especificar parámetros del método. Cada parámetro
puede tener una posición (si no están especificados, se usarán en el orden que estén registrados en el
método), son oblogatorios un valor por defecto, un tipo de datos y un nombre de parámetro.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Parameter extends Zend_CodeGenerator_Php_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Parameter $reflectionParameter
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
this the value holder object ``Zend_CodeGenerator_Php_ParameterDefaultValue`` can be used, for example:

.. code-block:: php
   :linenos:

   $parameter = new Zend_CodeGenerator_Php_Parameter();
   $parameter->setDefaultValue(
       new Zend_CodeGenerator_Php_Parameter_DefaultValue("null")
   );
   $parameter->setDefaultValue(
       new Zend_CodeGenerator_Php_Parameter_DefaultValue("array('foo', 'bar')")
   );

Internally ``setDefaultValue()`` also converts the values which can't be expressed in *PHP* into the value holder.

.. _zend.codegenerator.reference.concrete.php-property:

Zend_CodeGenerator_Php_Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Property`` describe una propiedad de clase, que puede ser tanto una constante o una
variable. En cada caso, la propiedad puede tener un valor predeterminado asociado con ella. Además, la visibilidad
de las propiedades de la variable puede ser establecida por la clase padre,
``Zend_CodeGenerator_Php_Member_Abstract``.

La *API* de la clase es la siguiente:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Property
       extends Zend_CodeGenerator_Php_Member_Abstract
   {
       public static function fromReflection(
           Zend_Reflection_Property $reflectionProperty
       )
       public function setConst($const)
       public function isConst()
       public function setDefaultValue($defaultValue)
       public function getDefaultValue()
       public function generate()
   }


