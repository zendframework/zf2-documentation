.. EN-Revision: none
.. _zend.codegenerator.introduction:

Introducción
============

``Zend_CodeGenerator`` ofrece facilidades para generar código arbitrario usando una interfaz orientada a objetos,
tanto para crear código nuevo como para actualizar código existente. Mientras que la implementación actual se
limita a generar código *PHP*, usted fácilmente puede extender la clase base a fin de proveer generación de
código para otras tareas como: JavaScript, archivos de configuración, apache vhost, etc.

.. _zend.codegenerator.introduction.theory:

Teoría de Operación
-------------------

En el caso de uso más típico, simplemente instanciará una clase de generación de código y podrá pasarle tanto
la configuración adecuada o configurarla después de la instanciación. Para generar el código, simplemente haga
"echo" del objeto o llame a su método ``generate()``.

.. code-block:: php
   :linenos:

   // Pasando la configuración al constructor:
   $file = new Zend\CodeGenerator_Php\File(array(
       'classes' => array(
           new Zend\CodeGenerator_Php\Class(array(
               'name'    => 'World',
               'methods' => array(
                   new Zend\CodeGenerator_Php\Method(array(
                       'name' => 'hello',
                       'body' => 'echo \'Hello world!\';',
                   )),
               ),
           )),
       )
   ));

   // Configurando después de la instanciación
   $method = new Zend\CodeGenerator_Php\Method();
   $method->setName('hello')
          ->setBody('echo \'Hello world!\';');

   $class = new Zend\CodeGenerator_Php\Class();
   $class->setName('World')
         ->setMethod($method);

   $file = new Zend\CodeGenerator_Php\File();
   $file->setClass($class);

   // Mostrar el archivo generado
   echo $file;

   // o grabarlo a un archivo:
   file_put_contents('World.php', $file->generate());

Ambos ejemplos anteriores mostrarán el mismo resultado:

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

Otro caso de uso común es actualizar el código actual -- por ejemplo, para añadir un método a una clase. En ese
caso, primero debe inspeccionar el código actual utilizando reflexión, y entonces añadir su nuevo método.
``Zend_CodeGenerator`` lo hace trivialmente simple, aprovechando :ref:`Zend_Reflection <zend.reflection>`.

Como ejemplo, digamos que hemos grabado lo anterior al archivo "``World.php``", y que ya está incluído.
Podríamos entonces hacer lo siguiente:

.. code-block:: php
   :linenos:

   $class = Zend\CodeGenerator_Php\Class::fromReflection(
       new Zend\Reflection\Class('World')
   );

   $method = new Zend\CodeGenerator_Php\Method();
   $method->setName('mrMcFeeley')
          ->setBody('echo \'Hello, Mr. McFeeley!\';');
   $class->setMethod($method);

   $file = new Zend\CodeGenerator_Php\File();
   $file->setClass($class);

   // Mostrar el archivo generado
   echo $file;

   // O mejor aún, volver a grabarlo al archivo original:
   file_put_contents('World.php', $file->generate());

El archivo de la clase resultante se vería así:

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


