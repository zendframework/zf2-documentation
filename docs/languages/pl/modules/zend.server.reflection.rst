.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

Wprowadzenie
------------

Klasa Zend\Server\Reflection zapewnia standardowy mechanizm dla przeprowadzania introspekcji funkcji i klas dla
potrzeb klas serwerów. Jest oparta na API Reflection PHP5 i rozszerza je aby zapewnić metody pobierania typów
parametrów jakie przyjmuje funkcja, typów zwracanych wartości oraz opisów, pełnej listy prototypów funkcji i
metod (np. wszystkie możliwe poprawne kombinacje wywołania), oraz opisów funkcji/metod.

Typowo ta funkcjonalność będzie używana przez programistów klas serwerów dla frameworka.

.. _zend.server.reflection.usage:

Użycie
------

Podstawowe użycie jest proste:

.. code-block:: php
   :linenos:

   $class    = Zend\Server\Reflection::reflectClass('My_Class');
   $function = Zend\Server\Reflection::reflectFunction('my_function');

   // Pobierz prototypy
   $prototypes = $reflection->getPrototypes();

   // Przechodzimy pętlą przez wszystkie prototypy funkcji
   foreach ($prototypes as $prototype) {

       // Pobierz typ zwracanej wartości prototypu
       echo "Zwracany typ: ", $prototype->getReturnType(), "\n";

       // Pobierz parametry prototypu
       $parameters = $prototype->getParameters();

       echo "Parametry: \n";
       foreach ($parameters as $parameter) {
           // Pobierz typ prototypu
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Pobierz przestrzeń nazw dla klasy, funkcji lub metody
   // Przestrzenie nazw mogą być ustawione podczas tworzenia instancji
   // lub przez użycie metody setNamespace()
   $reflection->getNamespace();


*reflectFunction()* zwraca obiekt *Zend\Server_Reflection\Function*; *reflectClass* zwraca obiekt
*Zend\Server_Reflection\Class*. Proszę sprawdź dokumentację API aby dowiedzieć się jakie metody ma każdy z
nich.


