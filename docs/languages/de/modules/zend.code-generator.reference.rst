.. EN-Revision: none
.. _zend.codegenerator.reference:

Zend_CodeGenerator Referenz
===========================

.. _zend.codegenerator.reference.abstracts:

Abstrakte Klassen und Interfaces
--------------------------------

.. _zend.codegenerator.reference.abstracts.abstract:

Zend\CodeGenerator\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Basisklasse von der alle CodeGenerator Klassen abgeleitet sind und die minimal notwendige Funktionalität
anbietet. Dessen *API* ist wie folgt:

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

Der Constructor ruft zuerst ``_init()`` auf (welches für eine konkrete erweiterte Klasse für die Implementation
leer gelassen ist), übergibt dann den ``$options`` Parameter an ``setOptions()`` und ruft zuletzt ``_prepare()``
auf (welches auch von der erweiternden Klasse implementiert werden muß).

Wie die meisten Klassen im Zend Framework, vergleicht ``setOptions()`` den Schlüssel einer Option mit den in der
Klasse existierenden Settern, und übergibt den Wert an die gefundene Methode.

``__toString()`` ist als final markiert, und leitet auf ``generate()`` weiter.

``setSourceContent()`` und ``getSourceContent()`` sind dazu vergesehen entweder den Standardinhalt für den zu
erzeugenden Code zu setzen, oder um gesetzte Inhalte zu ersetzen sobald alle Arbeiten der Erzeugung beendet wurden.

.. _zend.codegenerator.reference.abstracts.php-abstract:

Zend\CodeGenerator_Php\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Abstract`` erweitert ``Zend\CodeGenerator\Abstract``, und fügt einige Eigenschaften hinzu
für das Verfolgen ob Inhalte geändert wurden sowie der Anzahl an Einrückungen die vorhanden sein sollten bevor
Inhalte erzeugt werden. Die *API* ist wie folgt:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator_Php\Abstract
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

``Zend\CodeGenerator\Php\Member\Abstract`` ist eine Basisklasse für die Erstellung von Klassen-Member --
Eigenschaften und Methoden -- und bietet Zugriffs- und Änderungsmethoden für die Ausführung der Sichtbarkeit; ob
ein Member Abstrakt, Statisch, oder Final ist; und der Name des Members. Die *API* ist wie folgt:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Php\Member\Abstract
       extends Zend\CodeGenerator_Php\Abstract
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

Konkrete CodeGenerator Klassen
------------------------------

.. _zend.codegenerator.reference.concrete.php-body:

Zend\CodeGenerator_Php\Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Body`` ist dazu gedacht generellen prozeduralen Code in einer Datei einzufügen. Als
solches kann man einfach den Inhalt für das Objekt setzen, und es wird den Inhalt zurückgeben wenn man
``generate()`` aufruft.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Body extends Zend\CodeGenerator_Php\Abstract
   {
       public function setContent($content)
       public function getContent()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-class:

Zend\CodeGenerator_Php\Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Class`` ist für die Erstellung von *PHP* Klassen gedacht. Die Basisfunktionalität ist
nur die Erstellung der *PHP* Klasse selbst, sowie optional den betreffenden *PHP* DocBlock. Klassen können von
anderen Klassen abgeleitet sein, oder diese Implementieren, und können als Abstrakt markiert sein. Bei Verwendung
von anderen CodeGenerator Klassen kann man auch Klassenkonstanten, Eigenschaften und Methoden hinzufügen.

Die *API* ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Class extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Class $reflectionClass
       )
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
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

Die ``setProperty()`` Methode akzeptiert ein Array von Informationen, die verwendet werden können um eine Instanz
von ``Zend\CodeGenerator_Php\Property`` zu erstellen -- oder einfach eine Instanz von
``Zend\CodeGenerator_Php\Property`` selbst. Genauso akzeptiert ``setMethod()`` entweder ein Array von Information
für die Erstellung einer ``Zend\CodeGenerator_Php\Method`` Instanz oder eine konkrete Instanz dieser Klasse.

Beachte das ``setDocBlock()`` eine Instanz von ``Zend\CodeGenerator_Php\DocBlock`` erwartet.

.. _zend.codegenerator.reference.concrete.php-docblock:

Zend\CodeGenerator_Php\Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Docblock`` kann verwendet werden um *PHP* DocBlocks zu erstellen, inklusive aller
standardmäßigen DocBlock Features: Kurz- und Langbeschreibung sowie zusätzliche Tags.

Zusätzliche Tags können durch Verwendung der ``setTag()`` und ``setTags()`` Methoden gesetzt werden; diese nehmen
entweder ein Array an dass das Tag beschreibt das an den ``Zend\CodeGenerator\Php\Docblock\Tag`` Contructor
übergeben wird, oder eine Instanz dieser Klasse selbst.

Die *API* ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Docblock extends Zend\CodeGenerator_Php\Abstract
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

``Zend\CodeGenerator\Php\Docblock\Tag`` ist für die Erstellung von eigenen Tags, zum Einfügen in *PHP* DocBlocks,
gedacht. Von Tags wird erwartet das Sie einen Namen enthalten (Der Teil der unmittelbar dem '@' Symbol folgt) und
eine Beschreibung (alles das dem Tag Namen folgt).

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag
       extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTag
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

``Zend\CodeGenerator\Php\DocBlock\Tag\Param`` ist eine spezielle Version von
``Zend\CodeGenerator\Php\DocBlock\Tag``, und repräsentiert einen Parameter einer Methode. Das TagName ist hierbei
bekannt ("param"), aber durch die Form des Tags, werden zusätzliche Informationen benötigt um Ihn zu erzeugen:
den Namen des Parameter und den Datentyp den dieser repräsentiert.

Die *API* dieser Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTagParam
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

Wie die Variante des Param DocBlock Tags ist ``Zend\CodeGenerator\Php\Docblock\Tab\Return`` eine Variante eines
Tags für die Darstellung eines Rückgabewerts einer Methode. In diesem Fall ist der Name des Tags bekannt
("return"), aber es benötigt einen Rückgabetyp.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTagReturn
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-file:

Zend\CodeGenerator_Php\File
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\File`` wird verwendet um den kompletten Inhalt einer Datei zu erstellen die *PHP* Code
enthalten wird. Die Datei kann Klassen oder eigenen *PHP* Code enthalten, und wenn gewünscht einen Datei-Level
Docblock.

Wenn der Datei Klassen hinzugefügt werden, muß man entweder ein Array von Informationen übergeben die an den
Constructor von ``Zend\CodeGenerator_Php\Class`` übergeben werden, oder eine Instanz dieser Klasse. Genau wie bei
den DocBlocks, muß man Informationen für den Constructor von ``Zend\CodeGenerator_Php\Docblock`` übergeben die
verwendet werden, oder eine Instanz dieser Klasse.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\File extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflectedFilePath(
           $filePath,
           $usePreviousCodeGeneratorIfItExists = true,
           $includeIfNotAlreadyIncluded = true)
       public static function fromReflection(Zend\Reflection\File $reflectionFile)
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
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

``Zend\CodeGenerator\Php\Member\Container`` wird intern von ``Zend\CodeGenerator_Php\Class`` verwendet um die
Klassenmember zu erheben -- Eigenschaften sowie Methoden. Diese werden durch den Namen indiziert, indem die
konkrete Instanz des Members als Wert verwendet wird.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Member\Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }

.. _zend.codegenerator.reference.concrete.php-method:

Zend\CodeGenerator_Php\Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Method`` beschreibt eine Klassenmethode, und kann sowohl Code als auch den DocBlock für
diese Methode erstellen. Die Sichtbarkeit und der Status als Statisch, Abstrakt, oder Final kann, über die
Eltern-Klasse, ``Zend\CodeGenerator\Php\Member\Abstract``, angegeben werden. Letztendlich können die Parameter und
Rückgabewerte für die Methode spezifiziert werden.

Parameter könnnen durch Verwendung von ``setParameter()`` oder ``setParameters()`` gesetzt werden. In jedem Fall,
sollte der Parameter entweder ein Array von Informationen sein die an den Constructor von
``Zend\CodeGenerator_Php\Parameter`` übergeben werden, oder eine Instanz dieser Klasse.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Method
       extends Zend\CodeGenerator\Php\Member\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Method $reflectionMethod
       )
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
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

Zend\CodeGenerator_Php\Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Parameter`` kann verwendet werden um Methodenparameter zu spezifizieren. Jeder Parameter
kann eine Position haben (wenn nicht spezifiziert wird die Reihenfolge in der diese spezifiziert werden verwendet),
einen Standardwert, und einen Datentyp; ein Parametername wird benötigt.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Parameter extends Zend\CodeGenerator_Php\Abstract
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

Es gibt einige Probleme die auftreten können wenn man versucht ``NULL``, boolsche Werte oder Arrays als
Standardwerte zu setzen. Hierfür kann das Wert-Halte-Objekt ``Zend\CodeGenerator_Php\ParameterDefaultValue``
verwendet werden. Zum Beispiel:

.. code-block:: php
   :linenos:

   $parameter = new Zend\CodeGenerator_Php\Parameter();
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("null")
   );
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("array('foo', 'bar')")
   );

Intern konvertiert ``setDefaultValue()`` die Werte, welche in *PHP* nicht ausgedrückt werden können, in den
Werte-Halter.

.. _zend.codegenerator.reference.concrete.php-property:

Zend\CodeGenerator_Php\Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Property`` beschreibt die Eigenschaft einer Klasse, welche entweder eine Konstante oder
eine Variable sein kann. In jedem Fall, kann der Eigenschaft ein optionaler Standardwert assoziiert werden.
Zusätzlich kann die Sichtbarkeit von variablen Eigenschaften über die Elternklasse
``Zend\CodeGenerator\Php\Member\Abstract`` gesetzt werden.

Die *API* der Klasse ist wie folgt:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Property
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


