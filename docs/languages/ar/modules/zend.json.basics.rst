.. _zend.json.basics:

إستخدامات بسيطة
===============

إستخدام *Zend_Json* يتطلب إستخدام إثنان من الـ public static methods المتوفرة
: *()Zend_Json::encode* و *()Zend_Json::decode*.

.. code-block::
   :linenos:
   <?php
   // Retrieve a value:
   $phpNative = Zend_Json::decode($encodedValue);

   // Encode it to return to the client:
   $json = Zend_Json::encode($phpNative);
   ?>

