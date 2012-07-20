.. _zend.reflection.reference:

Réference de Zend_Reflection
============================

Les classes de ``Zend_Reflection`` reprennent l'API de `la Reflection PHP`_- mais avec une différence importante :
la Reflection *PHP* ne propose pas de manière d'introspecter les tags de documentation PHPDoc, ni les types des
variables paramètres ou encore les types de retour des fonctions.

``Zend_Reflection`` analyse les commentaires PHPDoc pour déterminer les types des variables passées en
paramètres ou de retour. Plus spécialement, les annotations *@param* et *@return* sont utilisées, même s'il
reste possible d'analyser les autres blocs de commentaire, ainsi que leurs descriptions respectives.

Chaque objet de réflexion dans ``Zend_Reflection``, surcharge la méthode ``getDocblock()`` pour retourner une
instance de ``Zend_Reflection_Docblock``. Cette classe propose alors l'introspection des blocs de commentaires et
notamment des tags PHPDoc.

``Zend_Reflection_File`` est une nouvelle classe qui permet d'introspecter les fichiers *PHP* à la recherche de
classes, fonctions ou encore code global *PHP* contenu à l'intérieur.

Enfin, la plupart des méthodes qui retournent des objets réflexion acceptent un second paramètre permettant de
spécifier la classe qui sera instanciée pour créer de tels objets.

.. _zend.reflection.reference.docblock:

Zend_Reflection_Docblock
------------------------

``Zend_Reflection_Docblock`` est le coeur de la valeur ajoutée par ``Zend_Reflection`` par rapport à la
Reflection *PHP*. Voici les méthodes proposées :

- ``getContents()``\  : retourne tout le contenu du bloc.

- ``getStartLine()``\  : retourne la position de départ du bloc dans le fichier.

- ``getEndLine()``\  : retourne la position de fin du bloc dans le fichier.

- ``getShortDescription()``\  : récupère la description courte (en général la première ligne de commentaire).

- ``getLongDescription()``\  : récupère la description longue du bloc.

- ``hasTag($name)``\  : détermine si le bloc possède un tag particulier.

- ``getTag($name)``\  : Récupère un tag particulier ou ``FALSE`` si celui-ci est absent.

- ``getTags($filter)``\  : Récupère tous les tags qui correspondent au filtre ``$filter``. Le type de retour est
  un tableau d'objets ``Zend_Reflection_Docblock_Tag``.

.. _zend.reflection.reference.docblock-tag:

Zend_Reflection_Docblock_Tag
----------------------------

``Zend_Reflection_Docblock_Tag`` propose la réflexion pour un tag individuel. La plupart des tags se composent
d'un nom et d'un description. Dans le cas de certains tags spéciaux, la classe propose une méthode de fabrique
qui retourne la bonne instance.

Voici les méthodes de ``Zend_Reflection_Docblock_Tag``\  :

- ``factory($tagDocblockLine)``\  : instancie la bonne classe de reflection pour le tag correspondant et en
  retourne l'objet.

- ``getName()``\  : retourne le nom du tag.

- ``getDescription()``\  : retourne la description du tag.

.. _zend.reflection.reference.docblock-tag-param:

Zend_Reflection_Docblock_Tag_Param
----------------------------------

``Zend_Reflection_Docblock_Tag_Param`` est une version spéciale de ``Zend_Reflection_Docblock_Tag``. La
description du tag *@param* consiste en un type, un nom de variable et une description. Elle ajoute les méthodes
suivantes à ``Zend_Reflection_Docblock_Tag``\  :

- ``getType()``\  : Retourne le type de la variable considérée par le tag.

- ``getVariableName()``\  : Retourne le nom de la variable considérée par le tag.

.. _zend.reflection.reference.docblock-tag-return:

Zend_Reflection_Docblock_Tag_Return
-----------------------------------

Comme ``Zend_Reflection_Docblock_Tag_Param``, ``Zend_Reflection_Docblock_Tag_Return`` est une version spéciale de
``Zend_Reflection_Docblock_Tag``. Le tag *@return* consiste en un type de retour et une description. Elle ajoute
les méthodes suivantes à ``Zend_Reflection_Docblock_Tag``\  :

- ``getType()``: retourne le type de retour.

.. _zend.reflection.reference.file:

Zend_Reflection_File
--------------------

``Zend_Reflection_File`` propose l'introspection de fichiers *PHP*. Grâce à cela, vous pouvez déterminer les
classes, fonctions ou le code pur *PHP* contenus dans un fichier *PHP* donné. Voici les méthodes proposées :

- ``getFileName()``\  : retourne le nom du fichier en cours de réflexion.

- ``getStartLine()``\  : retourne la ligne de démarrage du fichier (toujours "1").

- ``getEndLine()``\  : retourne la dernière ligne du fichier, donc le nombre de lignes.

- ``getDocComment($reflectionClass = 'Zend_Reflection_Docblock')``\  : retourne un objet de réflection de
  commentaire PHPDoc du fichier en cours d'analyse.

- ``getClasses($reflectionClass = 'Zend_Reflection_Class')``\  : retourne un tableau d'objets de réflexion de
  classe, pour les classes contenues dans le fichier en cours d'analyse.

- ``getFunctions($reflectionClass = 'Zend_Reflection_Function')``\  : retourne un tableau d'objets de réflexion
  de fonction, pour les fonctions contenues dans le fichier en cours d'analyse.

- *getClass($name = null, $reflectionClass = 'Zend_Reflection_Class')*\  : retourne l'objet de réflexion pour la
  classe contenue dans le fichier en cours d'analyse.

- ``getContents()``\  : retourne tout le contenu du fichier en cours d'analyse.

.. _zend.reflection.reference.class:

Zend_Reflection_Class
---------------------

``Zend_Reflection_Class`` étend *ReflectionClass*, et propose son *API*. Elle ajoute juste une méthode,
``getDeclaringFile()``, qui peut être utilisée pour créer un objet ``Zend_Reflection_File``.

Aussi, les méthodes suivantes proposent un argument supplémentaire pour spécifier sa propre classe de
réflexion:

- ``getDeclaringFile($reflectionClass = 'Zend_Reflection_File')``

- ``getDocblock($reflectionClass = 'Zend_Reflection_Docblock')``

- ``getInterfaces($reflectionClass = 'Zend_Reflection_Class')``

- ``getMethod($reflectionClass = 'Zend_Reflection_Method')``

- *getMethods($filter = -1, $reflectionClass = 'Zend_Reflection_Method')*

- ``getParentClass($reflectionClass = 'Zend_Reflection_Class')``

- ``getProperty($name, $reflectionClass = 'Zend_Reflection_Property')``

- *getProperties($filter = -1, $reflectionClass = 'Zend_Reflection_Property')*

.. _zend.reflection.reference.extension:

Zend_Reflection_Extension
-------------------------

``Zend_Reflection_Extension`` étend *ReflectionExtension* et propose son *API*. Elle surcharge les méthodes
suivantes afin d'ajouter un paramètre permettant de spécifier sa propre classe de réflexion :

- ``getFunctions($reflectionClass = 'Zend_Reflection_Function')``\  : retourne un tableau d'objets réflexion
  représentants les fonctions définies par l'extension en question.

- ``getClasses($reflectionClass = 'Zend_Reflection_Class')``\  : retourne un tableau d'objets réflexion
  représentants les classes définies par l'extension en question.

.. _zend.reflection.reference.function:

Zend_Reflection_Function
------------------------

``Zend_Reflection_Function`` ajoute une méthode pour retrouver le type de retour de la fonction introspéctée, et
surcharge d'autres méthodes pour proposer de passer en paramètre une classe de réflexion à utiliser.

- ``getDocblock($reflectionClass = 'Zend_Reflection_Docblock')``: Retourne un objet représentant les blocs de
  documentation.

- *getParameters($reflectionClass = 'Zend_Reflection_Parameter')*\  : Retourne un tableau représentant les
  paramètres de la fonction analysée sous forme d'objets réflexion.

- ``getReturn()``\  : Retourne le type de retour sous forme d'objet réflexion

.. _zend.reflection.reference.method:

Zend_Reflection_Method
----------------------

``Zend_Reflection_Method`` reprend l'API de ``Zend_Reflection_Function`` et surcharge la méthode suivante:

- ``getParentClass($reflectionClass = 'Zend_Reflection_Class')``\  : Retourne un objet réflexion de la classe
  parente

.. _zend.reflection.reference.parameter:

Zend_Reflection_Parameter
-------------------------

``Zend_Reflection_Parameter`` ajoute une méthode pour retrouver le type d'un paramètre, et aussi surcharge
certaines méthodes en rajoutant un paramètre permettant de spécifier sa propre classe de réflexion.

- *getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')*\  : retourne un objet réflexion représentant
  la classe de déclaration du paramètre (si disponible).

- ``getClass($reflectionClass = 'Zend_Reflection_Class')``\  : retourne un objet réflexion représentant la
  classe de l'objet passé comme paramètre (si disponible).

- *getDeclaringFunction($reflectionClass = 'Zend_Reflection_Function')*\  : retourne un objet réflexion
  représentant la fonction passée comme paramètre (si disponible).

- ``getType()``\  : retourne le type du paramètre.

.. _zend.reflection.reference.property:

Zend_Reflection_Property
------------------------

``Zend_Reflection_Property`` surcharge une seule méthode afin de pouvoir spécifier le type de classe de retour :

- *getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')*\  : Retourne un objet réflexion représentant
  la classe de l'objet passé comme paramètre (si disponible).



.. _`la Reflection PHP`: http://php.net/reflection
