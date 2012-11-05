.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

Introdução
----------

``Zend\Server\Reflection`` fornece um mecanismo padrão para executar introspecção de função e classe para uso
com as classes de servidor. É baseado na *API* Reflection do *PHP* 5, acrescentado com métodos para recuperar
parâmetros e retornar tipos de valor e descrições, uma lista completa dos protótipos de funções e métodos
(ex.: todas as possíveis combinações de chamada válidas), e as descrições de funções ou métodos.

Normalmente, esta funcionalidade só será usada por desenvolvedores de classes de servidor para o framework.

.. _zend.server.reflection.usage:

Utilização
----------

O uso básico é simples:

.. code-block:: php
   :linenos:

   $class    = Zend\Server\Reflection::reflectClass('My_Class');
   $function = Zend\Server\Reflection::reflectFunction('my_function');

   // Obter protótipos
   $prototypes = $reflection->getPrototypes();

   // Repetir o laço através de cada protótipo da função
   foreach ($prototypes as $prototype) {

       // Obter o tipo de retorno do protótipo
       echo "Tipo de retorno: ", $prototype->getReturnType(), "\n";

       // Get prototype parameters
       $parameters = $prototype->getParameters();

       echo "Parâmetros: \n";
       foreach ($parameters as $parameter) {
           // Obter tipo do parâmetro
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Obter namespace para uma classe, função ou método.
   // Namespaces podem ser definidos em tempo de instanciação
   // (segundo argumento), ou usando setNamespace()
   $reflection->getNamespace();

``reflectFunction()`` retorna um objeto ``Zend\Server_Reflection\Function``; ``reflectClass()`` retorna um objeto
``Zend\Server_Reflection\Class``. Consulte a documentação da *API* para ver quais métodos estão disponíveis
para cada um.


