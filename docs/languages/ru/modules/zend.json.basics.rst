.. _zend.json.basics:

Основы применения
=================

Использование *Zend_Json* включает в себя применение двух
публичных статических (public static) методов: *Zend_Json::encode()* и
*Zend_Json::decode()*.

.. code-block:: php
   :linenos:

   <?php
   // Получение значения:
   $phpNative = Zend_Json::decode($encodedValue);

   // Преобразование для возвращения клиенту:
   $json = Zend_Json::encode($phpNative);
   ?>

