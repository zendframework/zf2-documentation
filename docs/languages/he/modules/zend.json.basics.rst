.. EN-Revision: none
.. _zend.json.basics:

שימוש בסיסי
===========

שימוש ב *Zend_Json* נעשה על ידי קריאה לשני מתודות סטטיות שהם:
*Zend\Json\Json::encode()* ו *Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   // Retrieve a value:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Encode it to return to the client:
   $json = Zend\Json\Json::encode($phpNative);



