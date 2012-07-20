.. _zend.json.basics:

Základní použití
================

Použití *Zend_Json* zahrnuje dvě public static metody: *Zend_Json::encode()* a *Zend_Json::decode()*.

.. code-block::
   :linenos:
   <?php
   // Získání hodnoty:
   $phpNative = Zend_Json::decode($encodedValue);

   // Zakódování hodnoty pro vrácení klientovi:
   $json = Zend_Json::encode($phpNative);


