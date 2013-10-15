.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

Введение
--------

*Zend\Server\Reflection* предоставляет стандарный механизм для
выполнения интроспекции функций и классов для использования с
серверными классами. Он основан на Reflection API в PHP 5 и расширяет
его для предоставления методов получения типов и описаний
параметров и возвращаемых значений, полного списка прототипов
функций и методов (т.е. комбинации всех возможных валидных
вызовов), описаний функций/методов.

Обычно этот функционал будет использоваться только
разработчиками серверных классов для данного фреймворка.

.. _zend.server.reflection.usage:

Использование
-------------

Основное использование простое:

.. code-block:: php
   :linenos:

   <?php
   $class    = Zend\Server\Reflection::reflectClass('My_Class');
   $function = Zend\Server\Reflection::reflectFunction('my_function');

   // Получение прототипов
   $prototypes = $reflection->getPrototypes();

   // Обход полученных прототипов
   foreach ($prototypes as $prototype) {

       // Получение типа возращаемого прототипом значения
       echo "Return type: ", $prototype->getReturnType(), "\n";

       // Получение параметров прототипа
       $parameters = $prototype->getParameters();

       echo "Parameters: \n";
       foreach ($parameters as $parameter) {
           // Получение типа параметра
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Получение пространства имен для класса, функции или метода
   // Пространства имен могут быть установлены во время инстанцирования (второй аргумент),
   // или с помощью метода setNamespace()
   $reflection->getNamespace();

*reflectFunction()* возвращает объект *Zend\Server\Reflection\Function*, *reflectClass*
возвращает объект *Zend\Server\Reflection\Class*. Обратитесь к документации
API чтобы узнать, какие методы доступны в этих объектах.


