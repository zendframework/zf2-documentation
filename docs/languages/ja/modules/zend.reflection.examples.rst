.. _zend.reflection.examples:

Zend_Reflectionサンプル
===================

.. _zend.reflection.examples.file:

.. rubric:: ファイルでreflectionを実行

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

.. rubric:: クラスでreflectionを実行

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Class($class);

   printf(
       "クラスレベルのdocblockの短い記述: %s\n".
       "クラスレベルのdocblockの長い記述:\n%s\n",
       $r->getDocblock()->getShortDescription(),
       $r->getDocblock()->getLongDescription(),
   );

   //宣言するファイルreflectionを取得
   $file = $r->getDeclaringFile();

.. _zend.reflection.examples.method:

.. rubric:: メソッドでreflectionを実行

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

.. rubric:: docblockでreflectionを実行

.. code-block:: php
   :linenos:

   $r = new Zend_Reflection_Method($class, $name);
   $docblock = $r->getDocblock();

   printf(
       "短い記述: %s\n".
       "長い記述:\n%s\n",
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


