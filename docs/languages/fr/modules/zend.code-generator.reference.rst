.. _zend.codegenerator.reference:

Zend_CodeGenerator Réference
============================

.. _zend.codegenerator.reference.abstracts:

Classes abstraites et interfaces
--------------------------------

.. _zend.codegenerator.reference.abstracts.abstract:

Zend_CodeGenerator_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

La classe de base de CodeGenerator dont toutes les classes héritent. Elle propose l'*API* suivante :

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

Le constructeur appelle ``_init()`` (restée vide, à écrire dans les classes concrètes), puis passe le
paramètre ``$options`` à ``setOptions()``, et enfin appelle ``_prepare()`` (encore une fois, vide, à écrire
dans les classes concrètes).

Comme partout dans Zend Framework, ``setOptions()`` compare les clés du tableau passé comme paramètre à des
setters de la classe, et passe donc la valeur à la bonne méthode si trouvée.

``__toString()`` est marquée final, et proxie vers ``generate()``.

``setSourceContent()`` et ``getSourceContent()`` permettent soit de définir le contenu par défaut soit de
remplacer ce contenu par la tâche de génération.

.. _zend.codegenerator.reference.abstracts.php-abstract:

Zend_CodeGenerator_Php_Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Abstract`` étend ``Zend_CodeGenerator_Abstract`` et ajoute des méthodes permettant de
savoir si le contenu a changé et aussi le nombre d'indentation à utiliser avant chaque ligne de code à
générer. L'*API* est la suivante :

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

``Zend_CodeGenerator_Php_Member_Abstract`` est une classe de base pour générer des propriétés ou des méthodes
de classe, et propose des accesseurs et des mutateurs pour créer la visibilité, l'abstraction, la staticité ou
la finalité. L'*API* est la suivante :

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

Classes CodeGenerator concrêtes
-------------------------------

.. _zend.codegenerator.reference.concrete.php-body:

Zend_CodeGenerator_Php_Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Body`` est utilisée pour générer du code procédural à inclure dans un fichier. Vous
passez donc simplement du contenu à cet objet, qui vous le ressortira une fois son ``generate()`` appelé.

L'*API* de cette classe est comme suit :

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

``Zend_CodeGenerator_Php_Class`` est utilisée pour générer du code de classes *PHP*. Les fonctions de bases
génèrent la classe *PHP* elle-même, ainsi que ses commentaires *PHP* DocBlock. Vous pouvez bien sûr spécifier
la classe comme abstraite, finale, ou encore lui rajouter des constantes / attributs / méthodes sous forme
d'autres objets décrits eux aussi dans ce chapitre.

Voici l'*API*\  :

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

La méthode ``setProperty()`` accepte soit un tableau qui peut être utilisé pour générer une instance de
``Zend_CodeGenerator_Php_Property``, soit directement une instance de ``Zend_CodeGenerator_Php_Property``.
``setMethod()`` se manipule de la même manière, et utilise une instance de ``Zend_CodeGenerator_Php_Method``.

A noter que ``setDocBlock()`` attend une instance de ``Zend_CodeGenerator_Php_DocBlock``.

.. _zend.codegenerator.reference.concrete.php-docblock:

Zend_CodeGenerator_Php_Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Docblock`` est utilisée pour générer des éléments *PHP* arbitraire, y compris les
commentaires de description longs ou courts.

Les tags annotation doivent être spécifiés via ``setTag()`` ou ``setTags()`` qui prennent en paramètre un objet
``Zend_CodeGenerator_Php_Docblock_Tag`` ou un tableau qui permettra sa construction.

Voici l'*API*\  :

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

``Zend_CodeGenerator_Php_Docblock_Tag`` est utilisée pour créer des tags d'annotation *PHP* DocBlck. Les tags
doivent posséder un nom (la partie qui suit immédiatement le '@') et une description (ce qui suit le tag).

Voici l'*API*\  :

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

``Zend_CodeGenerator_Php_DocBlock_Tag_Param`` est une version spéciale de ``Zend_CodeGenerator_Php_DocBlock_Tag``,
et permet de représenter un paramètre d'une méthode. Le nom du tag est donc connu, mais des informations
additionnelles sont requises : le nom du paramètre et le type de données qu'il représente.

L'*API* de cette classe est la suivante :

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

``Zend_CodeGenerator_Php_Docblock_Tab_Return`` est une variante qui permet de modéliser la valeur de retour d'une
méthode. Dans ce cas, le nom du tag est connu ('return') mais pas le type de retour.

Voici l'*API*\  :

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

``Zend_CodeGenerator_Php_File`` est utilisée pour générer le contenu complet d'un fichier *PHP*. Le fichier peut
contenir des classes, du code *PHP* ou encore des commentaires PHPDoc.

Pour ajouter des classes, vous devrez soit passer un tableau d'informations à passer au constructeur de
``Zend_CodeGenerator_Php_Class``, soit un objet de cette dernière classe directement. Idem concernant les
commentaires PHPDoc et la classe ``Zend_CodeGenerator_Php_Docblock``

Voici l'*API* de la classe :

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

``Zend_CodeGenerator_Php_Member_Container`` est utilisée en interne par ``Zend_CodeGenerator_Php_Class`` pour
garder une trace des attributs et des méthodes de classe. Ceux-ci sont indéxés par nom.

Voici l'*API* de cette classe :

.. code-block:: php
   :linenos:

   class Zend_CodeGenerator_Php_Member_Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }

.. _zend.codegenerator.reference.concrete.php-method:

Zend_CodeGenerator_Php_Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Method`` est utilisée pour décrire une méthode d'une classe, et va générer son code,
et ses éventuels commentaires PHPDoc. La visibilité et le statut (abstraite, finale, statique) peuvent être
spécifiées par la classe parente ``Zend_CodeGenerator_Php_Member_Abstract``. Enfin, il est aussi possible de
spécifier les paramètres de la méthodes, et sa valeur de retour.

Les paramètres peuvent être indiqués via ``setParameter()`` ou ``setParameters()`` qui acceptent soit des
tableaux décrivant les paramètres à passer au constructeur de ``Zend_CodeGenerator_Php_Parameter``, soit des
objets de cette dernière classe.

L'*API* de cette classe est la suivante :

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

``Zend_CodeGenerator_Php_Parameter`` est utilisée pour décrire un paramètre de méthode. Chacun doit avoir une
position (sinon l'ordre de leur enregistrement sera utilisé par défaut), une valeur par défaut, un type et enfin
un nom.

Voici l'*API*\  :

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

Plusieurs problèmes peuvent apparaitre lorsque l'on veut paramétrer un ``NULL``, un booléen ou un tableau en
tant que valeur par défaut. Pour ceci le conteneur ``Zend_CodeGenerator_Php_ParameterDefaultValue`` peut être
utilisé, par exemple :

.. code-block:: php
   :linenos:

   $parameter = new Zend_CodeGenerator_Php_Parameter();
   $parameter->setDefaultValue(
       new Zend_CodeGenerator_Php_Parameter_DefaultValue("null")
   );
   $parameter->setDefaultValue(
       new Zend_CodeGenerator_Php_Parameter_DefaultValue("array('foo', 'bar')")
   );

En interne ``setDefaultValue()`` convertit aussi les valeurs qui peuvent être exprimées en *PHP* dans le
conteneur.

.. _zend.codegenerator.reference.concrete.php-property:

Zend_CodeGenerator_Php_Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_CodeGenerator_Php_Property`` est utilisée pour décrire une propriété, nous entendons par là une
variable ou une constante. Une valeur par défaut peut alors être spécifiée. La visibilité de la propriété
peut être définie par la classe parente, ``Zend_CodeGenerator_Php_Member_Abstract``.

Voici l'*API*\  :

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


