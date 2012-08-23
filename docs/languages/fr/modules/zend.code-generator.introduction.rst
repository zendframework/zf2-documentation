.. EN-Revision: none
.. _zend.codegenerator.introduction:

Introduction
============

``Zend_CodeGenerator`` est un outils permettant de générer du code *PHP* en utilisant une interface orientée
objet. Il peut générer ou mettre à jour du code. Il est aussi possible d'étendre ces classes afin de changer le
langage de référence pour générer du Javascript, des hôtes virtuels Apache ..., par exemple.

.. _zend.codegenerator.introduction.theory:

Théorie
-------

Dans la plupart des cas, vous créerez une instance du générateur de code, et vous le configurez. Pour afficher
le code généré, un simple echo suffira, ou l'appel à sa méthode ``generate()``.

.. code-block:: php
   :linenos:

   // Passage de configuration au constructor:
   $file = new Zend_CodeGenerator_Php_File(array(
       'classes' => array(
           new Zend_CodeGenerator_Php_Class(array(
               'name'    => 'World',
               'methods' => array(
                   new Zend_CodeGenerator_Php_Method(array(
                       'name' => 'hello',
                       'body' => 'echo \'Hello world!\';',
                   )),
               ),
           )),
       )
   ));

   // Configuration après instanciation
   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('hello')
          ->setBody('echo \'Hello world!\';');

   $class = new Zend_CodeGenerator_Php_Class();
   $class->setName('World')
         ->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   // Rendu du fichier généré:
   echo $file;

   // 2criture du fichier généré:
   file_put_contents('World.php', $file->generate());

Les 2 exemples ci-dessus vont rendre le même résultat :

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hello world!';
       }

   }

Il est aussi possible de mettre à jour un code existant, par exemple, ajouter une méthode à une classe. Dans ce
cas, vous devez inspecter le code existant en utilisant la réflexion, puis ajouter une nouvelle méthode.
``Zend_CodeGenerator`` rend ceci très simple en utilisant :ref:`Zend_Reflection <zend.reflection>`.

Par exemple, imaginons que nous avons sauvegardé le code de l'exemple ci-dessus dans un fichier "``World.php``"
que nous avons alors inclus. Nous pourrions dès lors agir comme suit :

.. code-block:: php
   :linenos:

   $class = Zend_CodeGenerator_Php_Class::fromReflection(
       new Zend_Reflection_Class('World')
   );

   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('mrMcFeeley')
          ->setBody('echo \'Hello, Mr. McFeeley!\';');
   $class->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   // Rendu du code généré
   echo $file;

   // Ou encore sauvegarde par dessus l'ancien fichier
   file_put_contents('World.php', $file->generate());

La nouvelle classe ressemblera à ça :

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hello world!';
       }

       public function mrMcFeeley()
       {
           echo 'Hellow Mr. McFeeley!';
       }

   }


