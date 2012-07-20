.. _zend.codegenerator.introduction:

Einführung
==========

``Zend_CodeGenerator`` bietet die Möglichkeit jeglichen Code zu erstellen indem ein Objekt Orientiertes Interface
verwendet wird, um sowohl neuen Code zu erstellen als auch bestehenden Code upzudaten. Wärend die aktuelle
Implementation darin limitiert ist *PHP* Code zu erstellen, kann die Basisklasse einfach erweitert werden um Code
Erzeugung für andere Zwecke zu bieten: JavaScript, Konfigurationsdateien, Apache VHosts, usw.

.. _zend.codegenerator.introduction.theory:

Theorie der Anwendung
---------------------

Der typischste Fall ist die Instanzierung einer Code Erzeugungs Klasse und entweder der Übergabe der
entsprechenden Konfiguration oder der Konfiguration nach dessen Erstellung. Um Code zu erstellen, muß man einfach
das Objekt ausgeben, oder dessen ``generate()`` Methode aufrufen.

.. code-block:: php
   :linenos:

   // Konfiguration an den Construktor übergeben:
   $file = new Zend_CodeGenerator_Php_File(array(
       'classes' => array(
           new Zend_CodeGenerator_Php_Class(array(
               'name'    => 'World',
               'methods' => array(
                   new Zend_CodeGenerator_Php_Method(array(
                       'name' => 'hello',
                       'body' => 'echo \'Hallo Welt!\';',
                   )),
               ),
           )),
       )
   ));

   // Konfiguration nach der Initialisierung
   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('hello')
          ->setBody('echo \'Hallo Welt!\';');

   $class = new Zend_CodeGenerator_Php_Class();
   $class->setName('World')
         ->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   // Die erzeugte Datei darstellen
   echo $file;

   // oder Sie in eine Datei schreiben:
   file_put_contents('World.php', $file->generate());

Beide der obigen Beispiele werden das gleiche Ergebnis darstellen:

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hallo Welt!';
       }

   }

Ein anderer üblicher Anwendungsfall ist die Aktualisierung von bestehendem Code -- zum Beispiel eine Methode zu
einer Klasse hinzufügen. In so einem Fall, muß man zuerst den bestehenden Code betrachten, indem Reflection
verwendet wird, und dann die neue Methode hinzufügen. ``Zend_CodeGenerator`` macht das sehr trivial, indem
:ref:`Zend_Reflection <zend.reflection>` verwendet wird.

Als Beispiel nehmen wir an dass das obige in der Datei "``World.php``" abgespeichert wurde, und wir diese bereits
inkludiert haben. Wir könnten dann das folgende tun:

.. code-block:: php
   :linenos:

   $class = Zend_CodeGenerator_Php_Class::fromReflection(
       new Zend_Reflection_Class('World')
   );

   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('mrMcFeeley')
          ->setBody('echo \'Hallo, Mr. McFeeley!\';');
   $class->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   // Die erzeugte Datei darstellen
   echo $file;

   // Oder besser, es in die originale Datei zurückschreiben:
   file_put_contents('World.php', $file->generate());

Die resultierende Klasse würde wie folgt aussehen:

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hallo Welt!';
       }

       public function mrMcFeeley()
       {
           echo 'Hallo, Mr. McFeeley!';
       }

   }


