.. _zend.reflection.examples:

Zend_Reflection Exemples
========================

.. _zend.reflection.examples.file:

.. rubric:: Effectuer la réflexion sur un fichier

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_File($filename);
   printf(
       "===> The %s file\n".
       "     has %d lines\n",
       $r->getFileName(),
       $r->getEndLine()
   );

   $classes = $r->getClasses();
   echo "     It has " . count($classes) . ":\n";
   foreach ($classes as $class) {
       echo "         " . $class->getName() . "\n";
   }

   $functions = $r->getFunctions();
   echo "     It has " . count($functions) . ":\n";
   foreach ($functions as $function) {
       echo "         " . $function->getName() . "\n";
   }

.. _zend.reflection.examples.class:

.. rubric:: Effectuer la réflexion d'une classe

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Class($class);

   printf(
       "The class level docblock has the short description: %s\n".
       "The class level docblock has the long description:\n%s\n",
       $r->getDocblock()->getShortDescription(),
       $r->getDocblock()->getLongDescription(),
   );

   // Get the declaring file reflection
   $file = $r->getDeclaringFile();

.. _zend.reflection.examples.method:

.. rubric:: Effectuer la réflexion d'une méthode

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Method($class, $name);

   printf(
   "The method '%s' has a return type of %s",
       $r->getName(),
       $r->getReturn()
   );

   foreach ($r->getParameters() as $key => $param) {
       printf(
           "Param at position '%d' is of type '%s'\n",
           $key,
           $param->getType()
       );
   }

.. _zend.reflection.examples.docblock:

.. rubric:: Effectuer la réflexion d'un bloc de documentation

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Method($class, $name);
   $docblock = $r->getDocblock();

   printf(
       "The short description: %s\n".
       "The long description:\n%s\n",
       $r->getDocblock()->getShortDescription(),
       $r->getDocblock()->getLongDescription(),
   );

   foreach ($docblock->getTags() as $tag) {
       printf(
           "Annotation tag '%s' has the description '%s'\n",
           $tag->getName(),
           $tag->getDescription()
       );
   }


