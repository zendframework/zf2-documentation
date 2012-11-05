.. EN-Revision: none
.. _zend.json.basics:

Основы применения
=================

Использование *Zend_Json* включает в себя применение двух
публичных статических (public static) методов: *Zend\Json\Json::encode()* и
*Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   <?php
   // Получение значения:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Преобразование для возвращения клиенту:
   $json = Zend\Json\Json::encode($phpNative);
   ?>

