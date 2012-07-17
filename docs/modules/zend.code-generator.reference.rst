
.. _zend.codegenerator.reference:

Zend_CodeGenerator Reference
============================


.. _zend.codegenerator.reference.abstracts:

Abstract Classes and Interfaces
-------------------------------


.. _zend.codegenerator.reference.abstracts.abstract:

Zend_CodeGenerator_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The base class from which all CodeGenerator classes inherit provides the minimal functionality necessary. It's *API* is as follows:

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

The constructor first calls ``_init()`` (which is left empty for the concrete extending class to implement), then passes the ``$options`` parameter to ``setOptions()``, and finally calls ``_prepare()`` (again, to be implemented by an extending class).

Like most classes in Zend Framework, ``setOptions()`` compares an option key to existing setters in the class, and passes the value on to that method if found.

``__toString()`` is marked as final, and proxies to ``generate()``.

``setSourceContent()`` and ``getSourceContent()`` are intended to either set the default content for the code being generated, or to replace said content once all generation tasks are complete.


.. _zend.codegenerator.reference.abstracts.php-abstract:

Zend_CodeGenerator_Php_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Abstract`` extends ``Zend_CodeGenerator_Abstract``, and adds some properties for tracking whether content has changed as well as the amount of indentation that should appear before generated content. Its *API* is as follows:

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

``Zend_CodeGenerator_Php_Member_Abstract`` is a base class for generating class members -- properties and methods -- and provides accessors and mutators for establishing visibility; whether or not the member is abstract, static, or final; and the name of the member. Its *API* is as follows:

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

Concrete CodeGenerator Classes
------------------------------


.. _zend.codegenerator.reference.concrete.php-body:

Zend_CodeGenerator_Php_Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Body`` is intended for generating arbitrary procedural code to include within a file. As such, you simply set content for the object, and it will return that content when you invoke ``generate()``.

The *API* of the class is as follows:

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

``Zend_CodeGenerator_Php_Class`` is intended for generating *PHP* classes. The basic functionality just generates the *PHP* class itself, as well as optionally the related *PHP* DocBlock. Classes may implement or inherit from other classes, and may be marked as abstract. Utilizing other code generator classes, you can also attach class constants, properties, and methods.

The *API* is as follows:

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

The ``setProperty()`` method accepts an array of information that may be used to generate a ``Zend_CodeGenerator_Php_Property`` instance -- or simply an instance of ``Zend_CodeGenerator_Php_Property``. Likewise, ``setMethod()`` accepts either an array of information for generating a ``Zend_CodeGenerator_Php_Method`` instance or a concrete instance of that class.

Note that ``setDocBlock()`` expects an instance of ``Zend_CodeGenerator_Php_DocBlock``.


.. _zend.codegenerator.reference.concrete.php-docblock:

Zend_CodeGenerator_Php_Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Docblock`` can be used to generate arbitrary *PHP* docblocks, including all the standard docblock features: short and long descriptions and annotation tags.

Annotation tags may be set using the ``setTag()`` and ``setTags()`` methods; these each take either an array describing the tag that may be passed to the ``Zend_CodeGenerator_Php_Docblock_Tag`` constructor, or an instance of that class.

The *API* is as follows:

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

``Zend_CodeGenerator_Php_Docblock_Tag`` is intended for creating arbitrary annotation tags for inclusion in *PHP* docblocks. Tags are expected to contain a name (the portion immediately following the '@' symbol) and a description (everything following the tag name).

The class *API* is as follows:

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

``Zend_CodeGenerator_Php_DocBlock_Tag_Param`` is a specialized version of ``Zend_CodeGenerator_Php_DocBlock_Tag``, and represents a method parameter. The tag name is therefor known ("param"), but due to the format of this annotation tag, additional information is required in order to generate it: the parameter name and data type it represents.

The class *API* is as follows:

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

Like the param docblock tag variant, ``Zend_CodeGenerator_Php_Docblock_Tab_Return`` is an annotation tag variant for representing a method return value. In this case, the annotation tag name is known ("return"), but requires a return type.

The class *API* is as follows:

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

``Zend_CodeGenerator_Php_File`` is used to generate the full contents of a file that will contain *PHP* code. The file may contain classes or arbitrary *PHP* code, as well as a file-level docblock if desired.

When adding classes to the file, you will need to pass either an array of information to pass to the ``Zend_CodeGenerator_Php_Class`` constructor, or an instance of that class. Similarly, with docblocks, you will need to pass information for the ``Zend_CodeGenerator_Php_Docblock`` constructor to consume or an instance of the class.

The *API* of the class is as follows:

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

``Zend_CodeGenerator_Php_Member_Container`` is used internally by ``Zend_CodeGenerator_Php_Class`` to keep track of class members -- properties and methods alike. These are indexed by name, using the concrete instances of the members as values.

The *API* of the class is as follows:

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Member_Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }


.. _zend.codegenerator.reference.concrete.php-method:

Zend_CodeGenerator_Php_Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Method`` describes a class method, and can generate both the code and the docblock for the method. The visibility and status as static, abstract, or final may be indicated, per its parent class, ``Zend_CodeGenerator_Php_Member_Abstract``. Finally, the parameters and return value for the method may be specified.

Parameters may be set using ``setParameter()`` or ``setParameters()``. In each case, a parameter should either be an array of information to pass to the ``Zend_CodeGenerator_Php_Parameter`` constructor or an instance of that class.

The *API* of the class is as follows:

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

``Zend_CodeGenerator_Php_Parameter`` may be used to specify method parameters. Each parameter may have a position (if unspecified, the order in which they are registered with the method will be used), a default value, and a data type; a parameter name is required.

The *API* of the class is as follows:

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

There are several problems that might occur when trying to set ``NULL``, booleans or arrays as default values. For this the value holder object ``Zend_CodeGenerator_Php_ParameterDefaultValue`` can be used, for example:

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

``Zend_CodeGenerator_Php_Property`` describes a class property, which may be either a constant or a variable. In each case, the property may have an optional default value associated with it. Additionally, the visibility of variable properties may be set, per the parent class, ``Zend_CodeGenerator_Php_Member_Abstract``.

The *API* of the class is as follows:

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


