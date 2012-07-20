.. _zend.server.reflection:

Zend_Server_Reflection
======================

.. _zend.server.reflection.introduction:

简介
------

Zend_Server_Reflection
提供了一个标准机制，在这个机制下，和服务器类一起执行函数和类自定义（
introspection ），它基于 PHP 5 的 Reflection
API，并且集成它来提供方法来获取参数和返回值类型和描述、函数和方法原型的全部列表（例如，所有可能的有效调用组合）和函数/方法描述。

典型地，这个函数将只给框架服务器类的开发者使用。

.. _zend.server.reflection.usage:

用法
------

基本用法很简单：

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Server/Reflection.php';
   $class    = Zend_Server_Reflection::reflectClass('My_Class');
   $function = Zend_Server_Reflection::reflectFunction('my_function');

   // Get prototypes
   $prototypes = $reflection->getPrototypes();

   // Loop through each prototype for the function
   foreach ($prototypes as $prototype) {

       // Get prototype return type
       echo "Return type: ", $prototype->getReturnType(), "\n";

       // Get prototype parameters
       $parameters = $prototype->getParameters();

       echo "Parameters: \n";
       foreach ($parameters as $parameter) {
           // Get parameter type
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Get namespace for a class, function, or method.
   // Namespaces may be set at instantiation time (second argument), or using
   // setNamespace()
   $reflection->getNamespace();

*reflectFunction()* 返回一个 *Zend_Server_Reflection_Function* 对象； *reflectClass* 返回一个
*Zend_Server_Reflection_Class* 对象。请参考 API 文档来获知那些方法有用。


