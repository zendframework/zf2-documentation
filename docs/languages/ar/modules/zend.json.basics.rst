.. EN-Revision: none
.. _zend.json.basics:

إستخدامات بسيطة
===============

إستخدام *Zend_Json* يتطلب إستخدام إثنان من الـ public static methods المتوفرة
: *()Zend\Json\Json::encode* و *()Zend\Json\Json::decode*.

.. code-block:: php
   :linenos:

   <?php
   // Retrieve a value:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Encode it to return to the client:
   $json = Zend\Json\Json::encode($phpNative);
   ?>

