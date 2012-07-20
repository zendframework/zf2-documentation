.. _zend.reflection.examples:

Zend_Reflection Beispiele
=========================

.. _zend.reflection.examples.file:

.. rubric:: Durchführen von Reflection an einer Datei

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_File($filename);
   printf(
       "===> Die Datei %s\n".
       "     hat %d Zeilen\n",
       $r->getFileName(),
       $r->getEndLine()
   );

   $classes = $r->getClasses();
   echo "     Sie hat " . count($classes) . ":\n";
   foreach ($classes as $class) {
       echo "         " . $class->getName() . "\n";
   }

   $functions = $r->getFunctions();
   echo "     Sie hat " . count($functions) . ":\n";
   foreach ($functions as $function) {
       echo "         " . $function->getName() . "\n";
   }

.. _zend.reflection.examples.class:

.. rubric:: Durchführen von Reflection an einer Klasse

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Class($class);

   printf(
       "Der Klassen-Level Docblock hat die Kurzbeschreibung: %s\n".
       "Der Klassen-Level Docblock hat die Langbeschreibung:\n%s\n",
       $r->getDocblock()->getShortDescription(),
       $r->getDocblock()->getLongDescription(),
   );

   // Die Deklarierte Datei Reflektion
   $file = $r->getDeclaringFile();

.. _zend.reflection.examples.method:

.. rubric:: Durchführen von Reflection an einer Methode

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Method($class, $name);

   printf(
   "Die Methode '%s' hat einen Rückgabetyp von %s",
       $r->getName(),
       $r->getReturn()
   );

   foreach ($r->getParameters() as $key => $param) {
       printf(
           "Der Parameter an Position '%d' ist vom Typ '%s'\n",
           $key,
           $param->getType()
       );
   }

.. _zend.reflection.examples.docblock:

.. rubric:: Durchführen von Reflection an einem Docblock

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Method($class, $name);
   $docblock = $r->getDocblock();

   printf(
       "Die Kurzbeschreibung: %s\n".
       "Die Langbeschreibung:\n%s\n",
       $r->getDocblock()->getShortDescription(),
       $r->getDocblock()->getLongDescription(),
   );

   foreach ($docblock->getTags() as $tag) {
       printf(
           "Das Hinweis-Tag '%s' hat die Beschreibung '%s'\n",
           $tag->getName(),
           $tag->getDescription()
       );
   }


