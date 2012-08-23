.. EN-Revision: none
.. _zend.json.basics:

שימוש בסיסי
===========

שימוש ב *Zend_Json* נעשה על ידי קריאה לשני מתודות סטטיות שהם:
*Zend_Json::encode()* ו *Zend_Json::decode()*.

.. code-block:: php
   :linenos:

   // Retrieve a value:
   $phpNative = Zend_Json::decode($encodedValue);

   // Encode it to return to the client:
   $json = Zend_Json::encode($phpNative);



