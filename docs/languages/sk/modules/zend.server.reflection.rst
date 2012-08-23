.. EN-Revision: none
.. _zend.server.reflection:

Zend_Server_Reflection
======================

.. _zend.server.reflection.introduction:

Úvod
----

Zend_Server_Reflection poskytuje štandardný mechanizmus pre zisťovanie informácií o funkciách a triedach pre
použitie spolu so serverom. Je postavený na PHP 5 Reflection API a rozširuje ho pre poskytnutie metód na
získanie parametrov, návratových hodnôt, plného zoznamu prototypov funkcií a metód (t.j. všetky možné a
validné spôsoby volania) a popis funkcií a metód.

Typicky využije túto funkčnosť iba programátor serverových tried pre framework.

.. _zend.server.reflection.usage:

Použitie
--------

Základné použitie je jednoduché:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Server/Reflection.php';
   $class    = Zend_Server_Reflection::reflectClass('My_Class');
   $function = Zend_Server_Reflection::reflectFunction('my_function');

   // Získanie prototypov
   $prototypes = $reflection->getPrototypes();

   // Cyklus cez všetky prototypy
   foreach ($prototypes as $prototype) {

       // Získanie návratovej hodnoty
       echo "Return type: ", $prototype->getReturnType(), "\n";

       // Získanie parametrov
       $parameters = $prototype->getParameters();

       echo "Parameters: \n";
       foreach ($parameters as $parameter) {
           // Získanie typuparametra
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Získanie menného priestoru triedy, funkcie, alebo metódy
   // Menný priestor môže byť nastavený pri inicializácii (druhy argument) alebo
   // pomocou setNamespace()
   $reflection->getNamespace();

*reflectFunction()* vráti objekt *Zend_Server_Reflection_Function*; *reflectClass* vráti objekt
*Zend_Server_Reflection_Class*. Pre viac informácií o dostupných metódach si pozrite API dokumentáciu.


