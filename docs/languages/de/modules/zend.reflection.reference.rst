.. _zend.reflection.reference:

Zend_Reflection Referenz
========================

Die verschiedenen Klassen in ``Zend_Reflection`` mimen die *API* von *PHP*'s `Reflection API`_- mit einem wichtigen
Unterschied. *PHP*'s Reflection *API* unterstützt die Introspection in die Annotation Tags von DocBlocks nicht,
und auch nicht in die Variablen-Typen von Parametern, oder die Rückgabe-Typen.

``Zend_Reflection`` analysiert die DocBlock Anotations von Methoden um die Variablen-Typen und Rückgabe-Typen von
Parametern zu Erkennen. Speziell die Annotations von *@param* und *@return* werden verwendet. Trotzdem kann man
auch auf andere Annotation Tags prüfen, sowie die Standardmäßigen "Kurz"- (short) und "Lang" (long)
Beschreibungen.

Jedes Reflection Objekt in ``Zend_Reflection`` überschreibt die ``getDocblock()`` Methode um eine Instanz von
``Zend_Reflection_Docblock`` zurückzugeben. Die Klasse bietet Introspektion in die DocBlocks und Annotation Tags.

``Zend_Reflection_File`` ist eine neue Reflection Klasse welche die Introspektion von *PHP* Dateien erlaubt. Mit
Ihr kann man die Klassen, Funktionen und globalen *PHP* Code erhalten der in der Datei enthalten ist.

Letztendlich erlauben die verschiedenen Methoden, die andere Reflection Objekte zurückgeben, einen zweiten
Parameter: Den Namen der Reflection Klasse die für das zurückzugebende Reflection Objekt zu verwenden ist.

.. _zend.reflection.reference.docblock:

Zend_Reflection_Docblock
------------------------

``Zend_Reflection_Docblock`` ist das Herz von ``Zend_Reflection_Docblock`` Bonus über *PHP*'s Reflection *API*. Es
bietet die folgenden Methoden:

- ``getContents()``: Gibt den kompletten Inhalt des DocBlocks zurück.

- ``getStartLine()``: Gibt die Startposition des DocBlocks in der definierten Datei zurück.

- ``getEndLine()``: Gibt die letzte Zeile des DocBlocks in der definierten Datei zurück.

- ``getShortDescription()``: Gibt die kurze, ein-zeilige Beschreibung zurück (normalerweise die erste Zeile des
  DocBlocks).

- ``getLongDescription()``: Gibt die lange Beschreibung des DocBlocks zurück.

- ``hasTag($name)``: Erkennt ob der DocBlock das angegebene Annotation Tag besitzt.

- ``getTag($name)``: Empfängt das Reflection Objekt des angegebenen Annotation Tags, oder ein boolsches ``FALSE``
  wenn es nicht vorhanden ist.

- ``getTags($filter)``: Gibt alle Tags zurück, oder alle Tags die dem angegebenen ``$filter`` String entsprechen.
  Die zurückgegebenen Tags werden ein Array von *Zend_Reflection_Docblock_Tag* Objekten sein.

.. _zend.reflection.reference.docblock-tag:

Zend_Reflection_Docblock_Tag
----------------------------

``Zend_Reflection_Docblock_Tag`` bietet Reflection für individuelle Annotation Tags. Die meisten Tags bestehen nur
aus einem Namen und einer Beschreibung. Im Fall einiger spezieller Tags, bietet die Klasse eine Factory Methode um
eine Instanz der entsprechenden Klasse zu erhalten.

Die folgenden Methoden sind für ``Zend_Reflection_Docblock_Tag`` definiert:

- ``factory($tagDocblockLine)``: Instanziert die entsprechende Reflection Klasse des Tags und gibt diese zurück.

- ``getName()``: Gibt den Namen des Annotation Tags zurück.

- ``getDescription()``: Gibt die Beschreibung des Annotation Tags zurück.

.. _zend.reflection.reference.docblock-tag-param:

Zend_Reflection_Docblock_Tag_Param
----------------------------------

``Zend_Reflection_Docblock_Tag_Param`` ist eine spezialisierte Version von ``Zend_Reflection_Docblock_Tag``. Die
Beschreibung des *@param* Annotation Tags besteht aus dem Typ des Parameters, dem Namen der Variable und der
Beschreibung der Variable. Sie fügt die folgenden Methoden zu ``Zend_Reflection_Docblock_Tag`` hinzu:

- ``getType()``: Gibt den Variablentyp des Parameters zurück.

- ``getVariableName()``: Gibt den Variablennamen des Parameters zurück.

.. _zend.reflection.reference.docblock-tag-return:

Zend_Reflection_Docblock_Tag_Return
-----------------------------------

Wie ``Zend_Reflection_Docblock_Tag_Param`` ist ``Zend_Reflection_Docblock_Tag_Return`` eine spezialisierte Version
von ``Zend_Reflection_Docblock_Tag``. Die Beschreibung des *@return* Annotation Tags besteht aus dem Rückgabetyp
und der Beschreibung der Variable. Sie fügt die folgende Methode zu *Zend_Reflection_Docblock_Tag* hinzu:

- ``getType()``: gibt den Rückgabetyp zurück.

.. _zend.reflection.reference.file:

Zend_Reflection_File
--------------------

``Zend_Reflection_File`` bietet Introspection in *PHP* Dateien. Mit Ihr kann man Klassen, Funktionen und reinen
*PHP* Code der in einer Datei definiert ist, betrachten. Sie definiert die folgenden Methoden:

- ``getFileName()``: empfängt den Dateinamen der Datei die reflektiert wird.

- ``getStartLine()``: empfängt den Startwert der Datei (Immer "1").

- ``getEndLine()``: empfängt die letzte Teile / Anzahl der Linien in der Datei.

- ``getDocComment($reflectionClass = 'Zend_Reflection_Docblock')``: empfängt das Reflection Objekt des Datei-Level
  DocBlocks.

- ``getClasses($reflectionClass = 'Zend_Reflection_Class')``: empfängt ein Array von Reflection Objekten, eines
  für jede Klasse die in der Datei definiert ist.

- ``getFunctions($reflectionClass = 'Zend_Reflection_Function')``: empfängt ein Array von Reflection Objekten,
  eines für jede Funktion die in der Datei definiert ist.

- ``getClass($name = null, $reflectionClass = 'Zend_Reflection_Class')``: empfängt das Reflection Objekt für eine
  einzelne Klasse.

- ``getContents()``: empfängt den kompletten Inhalt der Datei.

.. _zend.reflection.reference.class:

Zend_Reflection_Class
---------------------

``Zend_Reflection_Class`` erweitert *ReflectionClass* und folgt dessen *API*. Sie fügt eine zusätzliche,
``getDeclaringFile()``, Methode hinzu, welche verwendet werden kann um das ``Zend_Reflection_File`` Reflection
Objekt für die definierte Datei zu erhalten.

Zusätzlich fügen die folgenden Methoden ein zusätzliches Argument für die Spezifikation der Reflection Klasse
hinzu, die zu verwenden ist wenn ein Reflection Objekt geholt wird.

- ``getDeclaringFile($reflectionClass = 'Zend_Reflection_File')``

- ``getDocblock($reflectionClass = 'Zend_Reflection_Docblock')``

- ``getInterfaces($reflectionClass = 'Zend_Reflection_Class')``

- ``getMethod($reflectionClass = 'Zend_Reflection_Method')``

- ``getMethods($filter = -1, $reflectionClass = 'Zend_Reflection_Method')``

- ``getParentClass($reflectionClass = 'Zend_Reflection_Class')``

- *getProperty($name, $reflectionClass = 'Zend_Reflection_Property')*

- *getProperties($filter = -1, $reflectionClass = 'Zend_Reflection_Property')*

.. _zend.reflection.reference.extension:

Zend_Reflection_Extension
-------------------------

``Zend_Reflection_Extension`` erweitert *ReflectionExtension* und folgt dessen *API*. Sie überschreibt die
folgenden Methoden und fügt ein zusätzliches Argument hinzu, für die Spezifikation der Reflection Klasse, die zu
verwenden ist wenn ein Reflection Objekt geholt wird:

- ``getFunctions($reflectionClass = 'Zend_Reflection_Function')``: empfängt ein Array von Reflection Objekten
  welche die Funktionen repräsentieren die von der Erweiterung definiert werden.

- ``getClasses($reflectionClass = 'Zend_Reflection_Class')``: empfängt ein Array von Reflection Objekten welche
  die Klassen repräsentieren die von der Erweiterung definiert werden.

.. _zend.reflection.reference.function:

Zend_Reflection_Function
------------------------

``Zend_Reflection_Function`` fügt eine Methode für das Empfangen des Rückgabewerts der Funktion hinzu, und
überschreibt diverse Methoden um die Spezifikation der Reflection Klasse zu erlauben, die für zurückgegebene
Reflection Objekte zu verwenden ist.

- ``getDocblock($reflectionClass = 'Zend_Reflection_Docblock')``: empfängt das Reflection Objekt des Funktions
  DocBlocks.

- ``getParameters($reflectionClass = 'Zend_Reflection_Parameter')``: empfängt ein Array aller Reflection Objekte
  für die Parameter der Funktionen.

- ``getReturn()``: empfängt das Reflection Objekt des Rückgabewerts.

.. _zend.reflection.reference.method:

Zend_Reflection_Method
----------------------

``Zend_Reflection_Method`` spiegelt ``Zend_Reflection_Function`` und überschreibt nur eine zusätzliche Methode:

- ``getParentClass($reflectionClass = 'Zend_Reflection_Class')``: empfängt das Reflection Objekt der
  Eltern-Klasse.

.. _zend.reflection.reference.parameter:

Zend_Reflection_Parameter
-------------------------

``Zend_Reflection_Parameter`` fügt eine Methode für das Empfangen des Parametertyps hinzu, und überschreibt
Methoden um die Spezifikation der Reflection Klasse zu erlauben, die für zurückgegebene Reflection Objekte zu
verwenden ist.

- ``getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')``: gibt die deklarierte Klasse des Parameters als
  Reflection Objekt zurück (wenn vorhanden).

- ``getClass($reflectionClass = 'Zend_Reflection_Class')``: gibt die Klasse des Parameters als Reflection Objekt
  zurück (wenn vorhanden).

- ``getDeclaringFunction($reflectionClass = 'Zend_Reflection_Function')``: gibt die Funktion des Parameters als
  Reflection Objekt zurück (wenn vorhanden).

- ``getType()``: gibt den Typ des Parameters zurück.

.. _zend.reflection.reference.property:

Zend_Reflection_Property
------------------------

``Zend_Reflection_Property`` überschreibt eine einzelne Methode um die Spezifikation der zurückgegebenen
Reflection Objekt Klasse zu spezifizieren:

- ``getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')``: empfängt die deklarierte Klasse der
  Eigenschaft als Reflection Objekt.



.. _`Reflection API`: http://php.net/reflection
